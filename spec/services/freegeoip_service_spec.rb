describe FreegeoipService do
  let(:code) { 'www.google.pl' }
  let(:response_body) { {:ip=>"52.219.72.82", :country_code=>"DE", :city=>"Frankfurt am Main", :zip=>"60313", :latitude=>50.1155, :longitude=>8.6842} }
  let(:response) { Struct.new('TestResponse',:body).new(response_body.to_json) }
  subject { described_class.new(code) }

  describe "process" do
    context "valid call" do
      before do
        allow(subject.client).to receive(:get).and_return(response)
      end

      it "calls the service" do
        expect(subject.client).to receive(:get)
        expect(subject.process).to eq(response_body)
      end
    end
  end

end
