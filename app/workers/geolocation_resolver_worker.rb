class GeolocationResolverWorker
  include Sidekiq::Worker

  def perform(key)
    @geoloc = GeoLocation.find_by_key(key)
    response = FreegeoipService.new(key).process
  
    case response
    when 'failed_retriable'
      @geoloc.delay!
    when 'failed_permanently'
      @geoloc.fail_permanently!
    else
      @geoloc.resolve! if @geoloc.update(response)
    end
  end
end
