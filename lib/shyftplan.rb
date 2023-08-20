require "httparty"
require_relative "./shyftplan/errors"

class Shyftplan
  attr_reader :site,
              :user_email,
              :authentication_token

  def initialize(*args)
    if args.size == 3
      @site, @user_email, @authentication_token = args
    else
      @site = "https://shyftplan.com"
      @user_email, @authentication_token = args
    end
  end

  def base_url
    site + "/api/v1"
  end

  def get(path, options = {})
    url = base_url + path
    query = authentication_params
    query.merge!(options[:query]) if options[:query]
    response = HTTParty.get(url, query: query)
    raise Shyftplan::Errors::UnsuccessfulResponse.new(response) unless response.success?
    response
  end

  def post(path, options = {})
    url = base_url + path
    query = authentication_params
    query.merge!(options[:query]) if options[:query]
    HTTParty.post(url, query: query)
  end

  # Retrieve items across all pages
  # @example
  #   Shyftplan.each_page("/shifts")
  #
  # @example Perform an action after each page retrieval
  #   Shyftplan.each_page("/shifts") { |page| puts "Page retrieved..." }
  def each_page(path, options = {})
    per_page = 100
    page = 1
    items = []
    loop do
      options[:query] = if options[:query]
        options[:query].merge(page:, per_page:)
      else
        {
          page:,
          per_page:
        }
      end
      response = get(path, options)
      yield response
      page = page + 1
      items << response["items"]
      break if items.size >= response["total"]
    end

    items
  end

  private

  def authentication_params
    {
      user_email:,
      authentication_token:
    }
  end
end
