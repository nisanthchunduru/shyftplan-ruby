# shyftplan-ruby

Ruby gem for Shyftplan's REST API https://github.com/shyftplan/api-documentation

## Installation

Add the gem to your Rails app's Gemfile

```ruby
gem "shyftplan", git: "https://github.com/nisanth074/shyftplan-ruby", branch: "main"
```

and bundle install

```bash
bundle install
```

## Usage

```ruby
shyftplan = Shyftplan.new("john@acme.com", "dummy_api_token")
response = shyftplan.get("/shifts")
shifts = response["items"]
```
