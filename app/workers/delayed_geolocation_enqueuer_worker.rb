class DelayedGeolocationEnqueuerWorker
  include Sidekiq::Worker

  def perform()
    @geolocs = GeoLocation.delayed.all
  
    @geolocs.each do |geoloc|
      GeolocationResolverWorker.perform_async(geoloc.key)
    end
  end
end
