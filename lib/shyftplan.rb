require "httparty"
require_relative "./shyftplan/version"
require_relative "./shyftplan/errors"
require_relative "./shyftplan/graphql"

class Shyftplan
  attr_reader :base_url,
              :user_email,
              :authentication_token

  def initialize(*args)
    if args.size == 3
      @base_url, @user_email, @authentication_token = args
    else
      @base_url = "https://shyftplan.com"
      @user_email, @authentication_token = args
    end
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |*args|
      request(http_method, *args)
    end
  end

  # Retrieve items across all pages
  # @example
  #   Shyftplan.each_page("/shifts")
  #
  # @example Perform an action after each page retrieval
  #   Shyftplan.each_page("/shifts") { |page| puts "Page retrieved..." }
  def each_page(path, options = {})
    page = 1
    items = []
    loop do
      options[:query] = if options[:query]
        options[:query].merge(page:)
      else
        {
          page:,
        }
      end
      response = get(path, options)
      yield response if block_given?
      page = page + 1
      items = items + response["items"]
      break if items.size >= response["total"]
    end

    items
  end

  def graphql(base_url = self.base_url)
    Graphql.new(base_url, user_email, authentication_token)
  end

  private

  def request(http_method, path, options = {})
    url = base_url + path
    httparty_options = default_httparty_options
    httparty_options[:query].merge!(options[:query]) if options[:query]
    if options[:body]
      httparty_options[:body] = if options[:body].is_a?(String)
        options[:body]
      else
        options[:body].to_json
      end
      httparty_options[:headers]["Content-Type"] = "application/json"
    end
    response = HTTParty.public_send(http_method, url, httparty_options)
    raise Shyftplan::Errors::UnsuccessfulResponse.new(response) unless response.success?
    response
  end

  def default_httparty_options
    {
      headers: default_headers,
      query: auth_params
    }
  end

  def auth_params
    {
      user_email:,
      authentication_token:
    }
  end

  def default_headers
    { "Accept" => "application/json" }
  end
end
