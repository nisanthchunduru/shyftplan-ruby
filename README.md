# shyftplan-ruby

Ruby gem for Shyftplan's REST & GraphQL APIs https://github.com/shyftplan/api-documentation

Try the gem on repl.it https://replit.com/@nisanth074/tryshyftplanruby#main.rb If you run into a problem or have ideas for improvement, do open a GitHub issue or PR

## Installation

Add the gem to your Rails app's Gemfile

```ruby
gem "shyftplan", git: "https://github.com/nisanthchunduru/shyftplan-ruby", branch: "main"
```

and bundle install

Alternatively, if you're say, writing a script and don't have a Gemfile or have bundler installed, clone the repo and add the lib/ directory to Ruby's load path

```bash
mkdir ~/repos/
git clone https://github.com/nisanthchunduru/shyftplan-ruby ~/repos/shyftplan-ruby
```

and add the lib/ directory to Ruby's load path

```ruby
$LOAD_PATH << "/Users/nisanth/repos/shyftplan-ruby/lib"

require "shyftplan"

shyftplan = Shyftplan.new("john@acme.com", "dummy_api_token")

# ...
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

Perform a GraphQL query

```ruby
graphql = shyftplan.GraphQL
query = <<-QUERY
query FetchStaffShifts($shiftplanIds: [Int!] = null) {
  staffShifts(shiftplanIds: $shiftplanIds) {
    items {
      id
      shift {
        startsAt
        endsAt
      }
    }
  }
}
QUERY
response = graphql.query("FetchStaffShifts", query, "shiftplan_ids" => [8])
staff_shifts = response["data"]["staffShifts"]["items"]
```
