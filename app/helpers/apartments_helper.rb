module ApartmentsHelper
  def safe_external_url(value)
    uri = URI.parse(value.to_s)
    uri.to_s if %w[http https].include?(uri.scheme) && uri.host.present? && uri.userinfo.nil?
  rescue URI::InvalidURIError
    nil
  end

  def community_maps_url(community)
    "https://www.google.com/maps/search/?#{URI.encode_www_form(api: 1, query: [community.name, community.address.presence || "#{community.latitude},#{community.longitude}"].join(' '))}"
  end
end
