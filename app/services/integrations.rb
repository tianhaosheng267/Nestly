module Integrations
  class Error < StandardError; end
  class NotConfigured < Error; end
  class Unavailable < Error; end
  class Unauthorized < Error; end
end
