require_relative "../../lib/shyftplan"

describe Shyftplan do
  let(:user_email) { "john@acme.com" }
  let(:authentication_token) { "dummy_api_token" }
  let(:shyftplan) { Shyftplan.new(user_email, authentication_token) }

  describe "#get" do
    it "performs a GET API request" do
      evaluation_items = [
        {
          "id" => 1
        }
      ]
      stub_request(
        :get,
        "https://shyftplan.com/api/v1/evaluations"
      ).with(
        query: {
          user_email:,
          authentication_token:
        }
      ).to_return(
        status: 200,
        body: { "items" => evaluation_items, "total": 1 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      response = shyftplan.get("/evaluations")
      expect(response["items"]).to eq(evaluation_items)
      expect(response["total"]).to eq(1)
    end

    context "response is not a HTTP 2xx response" do
      it "raises an exception" do
        stub_request(
          :get,
          "https://shyftplan.com/api/v1/evaluations"
        ).with(
          query: {
            user_email:,
            authentication_token:
          }
        ).to_return(
          status: 401,
          body: { "error" => "401 Unauthorized" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        begin
          response = shyftplan.get("/evaluations")
          expect(false).to eq(true)
        rescue Shyftplan::Errors::UnsuccessfulResponse => e
          response = e.response
          expect(response.success?).to eq(false)
          expect(response["error"]).to eq("401 Unauthorized")
        end
      end
    end
  end
end
