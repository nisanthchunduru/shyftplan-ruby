# shyftplan-ruby

Ruby gem for Shyftplan's REST & GraphQL APIs https://github.com/shyftplan/api-documentation

Try the gem on repl.it https://replit.com/@nisanth074/tryshyftplanruby#main.rb If you run into a problem or have ideas for improvement, do open a GitHub issue or PR

## Installation

Add the gem to your Rails app's Gemfile

```ruby
gem "shyftplan", git: "https://github.com/nisanthchunduru/shyftplan-ruby", branch: "main"
```

and bundle install


### Alternate installation

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

If you've many evaluations in your Shyftplan account, retrieving all pages can take a while. If you'd like to perform an action after each page retrieval, you can provide a block

```ruby
shyftplan.each_page("/evaluations") do |page|
  puts "Page retrieved..."

  evaluations = page["items"]
  EvaluationsCSVExport.add(evaluations)
end
```

Create an evaluation

```ruby
staff_shift_id = 1
evaluation_starts_at = "2023-07-01T09:00:00+02:00"
evaluation_ends_at = "2023-07-01T17:00:00+02:00"
evaluation_params = {
  "evaluation_starts_at" => evaluation_starts_at,
  "evaluation_ends_at" => evaluation_ends_at,
  "untimed_breaks" => 0
}
shyftplan.post("/api/v1/evaluations/#{staff_shift_id}", body: evaluation_params)
```

### GraphQL Usage

Perform a GraphQL query

```ruby
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
response = shyftplan.graphql_query("FetchStaffShifts", query, "shiftplan_ids" => [8])
staff_shifts = response["data"]["staffShifts"]["items"]
```
