FactoryBot.define do
  factory :snapshot do
    url { "https://example.com" }
    attribute_query { "data-qa=title" }
    content_hash { Digest::SHA256.hexdigest("initial content") }
    last_checked_at { Time.now }
    chat_id { 123456789 }
  end
end
