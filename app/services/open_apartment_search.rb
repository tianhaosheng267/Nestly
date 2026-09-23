class OpenApartmentSearch
  MAX_RESULTS = 200
  CACHE_TTL = 24.hours

  def call(zip_code:, radius_miles:)
    raise Integrations::Error, 'Enter a valid US ZIP code and search radius.' unless /\A\d{5}\z/.match?(zip_code) && ApartmentSearch::RADII.include?(radius_miles)
    # Shared, bounded disk cache avoids repeat calls to the community-run server.
    cache.fetch("open-apartments-v3/#{zip_code}/#{radius_miles}", expires_in: CACHE_TTL) do
      zip = Integrations::Http.json("https://api.zippopotam.us/us/#{zip_code}")
      location = zip.fetch('places').first
      lat = Float(location.fetch('latitude'))
      lon = Float(location.fetch('longitude'))
      # Bound the map query first; apply a precise circular distance below.
      delta_lat = radius_miles / 3958.7613 * 180 / Math::PI
      delta_lon = Math.asin((Math.sin(radius_miles / 3958.7613) / Math.cos(lat * Math::PI / 180)).clamp(-1, 1)) * 180 / Math::PI
      area = "(#{[lat - delta_lat, -90].max},#{(lon - delta_lon + 180) % 360 - 180},#{[lat + delta_lat, 90].min},#{(lon + delta_lon + 180) % 360 - 180})"
      query = <<~QUERY
        [out:json][timeout:60][maxsize:134217728];
        (
          nwr["building"="apartments"]#{area};
          nwr["residential"="apartments"]#{area};
        )->.apartments;
        nwr["landuse"="residential"]#{area}->.residential;
        (
          nwr.apartments["name"];
          nwr.residential["name"~"apartments|apartment homes|apartment community",i];
        );
        out center tags #{MAX_RESULTS + 1};
      QUERY
      endpoint = ENV.fetch('OVERPASS_API_URL', 'https://overpass.private.coffee/api/interpreter')
      data = Integrations::Http.json(endpoint, method: :post, form: { data: query },
        headers: { 'User-Agent' => 'Nestly/1.0 (apartment discovery; cached queries)' }, read_timeout: 75)
      if data['remark'].present?
        Rails.logger.warn("Open map search incomplete: #{data['remark'].to_s.truncate(300)}")
        raise Integrations::Unavailable, 'The open map search is busy. Please try a smaller radius or try again later.'
      end
      elements = data.fetch('elements')
      communities = elements.filter_map { |element| normalize(element, lat, lon, radius_miles) }
      # OSM may map a named community as both a site and individual buildings.
      deduplicated = []
      communities.sort_by { |entry| entry[:distance] }.each do |entry|
        duplicate = deduplicated.any? do |other|
          other[:name].downcase == entry[:name].downcase && GeoDistance.miles(other[:latitude], other[:longitude], entry[:latitude], entry[:longitude]) < 0.3
        end
        deduplicated << entry unless duplicate
      end
      { latitude: lat, longitude: lon, fetched_at: Time.current, truncated: elements.size > MAX_RESULTS, communities: deduplicated.first(MAX_RESULTS) }
    end
  rescue KeyError, ArgumentError, TypeError
    raise Integrations::Unavailable, 'The search provider returned incomplete location data. Please try again later.'
  end

  private

  def cache
    return Rails.cache if Rails.env.test?
    @cache ||= ActiveSupport::Cache::FileStore.new(Rails.root.join('tmp/cache/apartment-search'))
  end

  def normalize(element, lat, lon, radius)
    return unless %w[node way relation].include?(element['type']) && element['id'].is_a?(Integer)
    tags = element.fetch('tags', {})
    center = element['center'] || element
    return if tags['name'].blank? || center['lat'].nil? || center['lon'].nil?
    # Unit/building codes and explicitly institutional housing are not communities.
    return if /\A(?:[A-Z]?\d+[A-Z]?|N\/A|unknown)\z/i.match?(tags['name'].strip)
    return if tags['amenity'].in?(%w[university school nursing_home]) || /\b(?:residence hall|dormitory|condominiums)\b/i.match?(tags['name'])
    return unless tags['building'] == 'apartments' || tags['residential'] == 'apartments' || (tags['landuse'] == 'residential' && /apartments|apartment homes|apartment community/i.match?(tags['name']))
    return if tags['disused'] == 'yes' || tags['abandoned'] == 'yes'
    distance = GeoDistance.miles(lat, lon, center.fetch('lat'), center.fetch('lon'))
    return if distance > radius
    address = [tags['addr:housenumber'], tags['addr:street'], tags['addr:city'], tags['addr:state'], tags['addr:postcode']].compact.join(' ')
    { external_id: "#{element['type']}/#{element['id']}", name: tags['name'].truncate(255), address: address.presence,
      website: tags['contact:website'].presence || tags['website'], contact_email: tags['contact:email'].presence || tags['email'],
      phone: tags['contact:phone'].presence || tags['phone'], latitude: center.fetch('lat'), longitude: center.fetch('lon'), distance: distance }
  end
end
