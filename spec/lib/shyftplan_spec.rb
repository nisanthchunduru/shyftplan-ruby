require_relative "../../lib/shyftplan"

describe Shyftplan do
  let(:user_email) { "john@acme.com" }
  let(:authentication_token) { "dummy_api_token" }
  let(:shyftplan) { Shyftplan.new(user_email, authentication_token) }

  describe "#get" do
    it "performs a GET API request" do
      evaluation_items = [(FactoryBot.build :evaluation_item)]
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
          headers: { "Content-Type" => "application/json" },
          body: { "error" => "401 Unauthorized" }.to_json
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

  describe "#each_page" do
    let(:pages) do
      2.times.map do |page_number|
        {
          "items" => [(FactoryBot.build :evaluation_item)],
          "total" => 2
        }
      end
    end
    let(:all_items) { pages.inject([]) { |all_items, page| all_items + page["items"] } }

    before(:each) do
      2.times.each do |page_number|
        response_hash = pages[page_number]
        stub_request(
          :get,
          "https://shyftplan.com/api/v1/evaluations"
        ).with(
          query: {
            user_email:,
            authentication_token:,
            page: page_number + 1
          }
        ).to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: response_hash.to_json
        )
      end
    end

    it "retrieves items across all pages" do
      expect(shyftplan.each_page("/evaluations")).to eq(all_items)
    end

    context "given a block" do
      it "yields each page to the given block" do
        actual = []
        shyftplan.each_page("/evaluations") do |page|
          actual = actual + page["items"]
        end
        expected = all_items
        expect(actual).to eq(expected)
      end
    end
  end
end
