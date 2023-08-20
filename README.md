# shyftplan-ruby

Ruby gem for Shyftplan's REST API https://github.com/shyftplan/api-documentation

Try the gem on repl.it https://replit.com/@nisanth074/tryshyftplanruby#main.rb

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

Initialize the Shyftplan client

```ruby
shyftplan = Shyftplan.new("john@acme.com", "dummy_api_token")
```

Retrieve evaluations

```ruby
response = shyftplan.get("/evaluations")
evaluations = response["items"]
```

Retrieve evaluations across all pages

```ruby
evaluations = shyftplan.each_page("/evaluations")
```

Doing the above may take a while. If you'd like to perform any action after each page retrieval, provide a block

```ruby
shyftplan.each_page("/evaluations") do |page|
  puts "Page retrieved..."

  evaluations = page["items"]
  EvaluationsCSVExport.add(evaluations)
end
```

## Todos

- Publish gem to https://rubygems.org
