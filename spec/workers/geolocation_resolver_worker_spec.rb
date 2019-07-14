require 'rails_helper'
RSpec.describe GeolocationResolverWorker, type: :worker do
  describe "#perform" do
    let(:geolocation) { GeoLocation.create(key: 'www.google.pl') }
    let(:response_success) { {ip: '192.168.0.1'} }
    let(:response_failed_retriable) { 'failed_retriable' }
    let(:response_failed_permanently) { 'failed_permanently' }
    subject { GeolocationResolverWorker.new }

    context "with valid service response for key" do
      before do
        allow_any_instance_of(FreegeoipService).to receive(:process).and_return(response_success)
      end

      it "updates the record with data from service" do
        subject.perform(geolocation.key)
        geolocation.reload
        expect(geolocation.ip).to eq(response_success[:ip])
        expect(geolocation.resolved?).to be_truthy
      end
    end

    context "with failed_retriable service response for key" do
      before do
        allow_any_instance_of(FreegeoipService).to receive(:process).and_return(response_failed_retriable)
      end

      it "moves the geolocation to delayed state" do
        subject.perform(geolocation.key)
        geolocation.reload
        expect(geolocation.delayed?).to be_truthy
      end
    end

    context "with failed_permanently service response for key" do
      before do
        allow_any_instance_of(FreegeoipService).to receive(:process).and_return(response_failed_permanently)
      end

      it "moves the geolocation to failed_permanently state" do
        subject.perform(geolocation.key)
        geolocation.reload
        expect(geolocation.failed_permanently?).to be_truthy
      end
    end
  end
end
