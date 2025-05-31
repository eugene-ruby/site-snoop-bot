
require 'sequel'

class Snapshot < Sequel::Model(:snapshots)
  def save!
    save
  end

  def attribute_query
    self[:attribute_query]
  end

  def chat_id
    self[:chat_id]
  end
end
