class Shyftplan
  class Graphql
    attr_reader :base_url,
                :user_email,
                :authentication_token

    def initialize(base_url, user_email, authentication_token)
      @base_url, @user_email, @authentication_token = base_url, user_email, authentication_token
    end

    def query(operation_name, query, variables = {})
      body = {
        operationName: operation_name,
        query: query,
        variables: variables
      }.to_json
      graphql_endpoint_url = base_url + "/graphql"
      response = HTTParty.post(
        graphql_endpoint_url,
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }.merge(auth_headers),
        body: body
      )
      raise Shyftplan::Errors::UnsuccessfulResponse.new(response) unless response.success?
      response
    end

    private

    def auth_headers
      {
        "Authemail" => user_email,
        "Authtoken" => authentication_token
      }
    end
  end
end
