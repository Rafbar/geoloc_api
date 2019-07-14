require 'rails_helper'

RSpec.describe GeoLocation, type: :model do
  describe "#key_processable" do
    context "valid key" do
      let(:key_ip) { '192.168.0.1' }
      let(:key_url) { 'www.google.com' }
      
      it "validates ip" do 
        expect(GeoLocation.new(key: key_ip).valid?).to be_truthy
      end

      it "validates url" do 
        expect(GeoLocation.new(key: key_url).valid?).to be_truthy
      end
    end

    context "invalid key" do
      let(:key_ip) { '192.168.256.1' }
      let(:key_url) { 'www.google.com::::2313' }
      
      it "invalidates malformed ip" do 
        expect(GeoLocation.new(key: key_ip).valid?).to be_falsey
      end

      it "invalidates malformed url" do 
        expect(GeoLocation.new(key: key_url).valid?).to be_falsey
      end
    end
  end

  describe "#ip_address_valid" do
    let(:valid_ip) { '192.168.0.1' }
    let(:invalid_ip) { '192.168.256.1' }
    let(:proper_key) { 'www.google.com' }
  
    it 'validates proper ip' do
      expect(GeoLocation.new(key: proper_key, ip: valid_ip).valid?).to be_truthy
    end

    it 'invalidates malformed ip' do
      expect(GeoLocation.new(key: proper_key, ip: invalid_ip).valid?).to be_falsey
    end
  end

  describe "#stripped_key" do
    let(:http_key) { 'http://www.google.com' }
    let(:https_key) { 'https://www.google.com' }
    let(:stripped_key) { 'www.google.com' }

    it "strips http" do
      expect(GeoLocation.new(key: http_key).stripped_key).to eq(stripped_key)
    end

    it "strips https" do
      expect(GeoLocation.new(key: https_key).stripped_key).to eq(stripped_key)
    end

    it "returns key if http/https is not present" do
      expect(GeoLocation.new(key: stripped_key).stripped_key).to eq(stripped_key)
    end
  end

  describe "#enqueue_ip_resolver" do
    before do
      Sidekiq::Testing.fake!
      GeolocationResolverWorker.clear
    end

    it "enqueues ip resolver on create" do
      GeoLocation.create(key: 'www.google.es')
      expect(GeolocationResolverWorker.jobs.size).to eq(1)
    end
  end
end
