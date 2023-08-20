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

  # @todo Add rspecs
  def post(path, options = {})
    url = base_url + path
    query = options.fetch(:query, {})
    query.merge!(authentication_params)
    HTTParty.post(url, options.merge(query:))
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

  private

  def authentication_params
    {
      user_email:,
      authentication_token:
    }
  end
end
