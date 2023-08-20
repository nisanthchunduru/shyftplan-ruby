FactoryBot.define do
  sequence(:evaluation_item_id) { |n| n }

  factory :evaluation_item, class: Hash do |evaluation_item|
    id { generate(:evaluation_item_id) }

    # Borrowed from https://lortza.github.io/2020/10/28/factory-bot-hashes.html
    skip_create
    initialize_with { attributes.stringify_keys }
  end
end
