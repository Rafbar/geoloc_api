require 'yaml'
require 'recursive-open-struct'

class FreegeoipService
  RESPONSE_FIELDS = "ip,country_code,city,zip,latitude,longitude"
  attr_accessor :client, :key

  def initialize(key)
    @key = key
    load_config
    init_client
  end

  def process
    begin
      request = @client.get(build_url)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed
      return 'failed_retriable'
    rescue Faraday::ClientError, Faraday::ParsingError
      return 'failed_permanently'
    end
    stringify_values(JSON.load(request.body).deep_symbolize_keys)
  end

  private

  def stringify_values(obj)
    obj.deep_merge(obj) {|_,_,v| v.to_s}
  end

  def init_client
    @client = Faraday::Connection.new(nil, request: { timeout: @config.timeout })
  end

  def build_url
    "#{@config.url}#{key}?access_key=#{@config.api_key}&fields=#{RESPONSE_FIELDS}"
  end

  def load_config
    @config = RecursiveOpenStruct.new(YAML.load(ERB.new(File.read(File.join(Rails.root, 'config/freegeoip.yml'))).result))
  end
end
