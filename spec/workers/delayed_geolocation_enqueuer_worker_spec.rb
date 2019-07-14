require 'rails_helper'
RSpec.describe DelayedGeolocationEnqueuerWorker, type: :worker do
  describe "#perform" do
    let!(:geolocation) { GeoLocation.create(key: 'www.google.pl') }
    let!(:geolocation_2) { GeoLocation.create(key: 'www.google.com') }
    let!(:geolocation_3) { GeoLocation.create(key: 'www.google.es') }
    subject { DelayedGeolocationEnqueuerWorker.new }

    context "with existing delayed geolocations" do
      before do
        Sidekiq::Testing.fake!
        GeolocationResolverWorker.clear
        geolocation_2.delay!
        geolocation_3.delay!
      end

      it "updates the record with data from service" do
        subject.perform()
        expect(GeolocationResolverWorker.jobs.size).to eq(2)
      end
    end
  end
end
