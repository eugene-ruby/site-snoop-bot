require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'])

DB.create_table? :snapshots do
  primary_key :id
  String :url
  String :attribute_query
  String :content_hash
  DateTime :last_checked_at
  Bignum :chat_id
  index :chat_id
end
