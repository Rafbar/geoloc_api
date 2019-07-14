require 'active_support/concern'

module Controllers
  module JsonHelpers
    def json
      unless @json
        @json = JSON.parse(response.body)
        @json = @json.with_indifferent_access if @json.respond_to?(:with_indifferent_access)
      end
      @json
    end
  end
end
