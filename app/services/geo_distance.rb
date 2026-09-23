class GeoDistance
  def self.miles(lat1, lon1, lat2, lon2)
    radians = Math::PI / 180
    delta_lat = (lat2 - lat1) * radians
    delta_lon = (lon2 - lon1) * radians
    h = Math.sin(delta_lat / 2)**2 + Math.cos(lat1 * radians) * Math.cos(lat2 * radians) * Math.sin(delta_lon / 2)**2
    3958.7613 * 2 * Math.asin(Math.sqrt(h.clamp(0, 1)))
  end
end
