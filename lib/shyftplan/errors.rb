class Shyftplan
  module Errors
    class UnsuccessfulResponse < StandardError
      attr_reader :response

      def initialize(response)
        @response = response
      end
    end
  end
end
