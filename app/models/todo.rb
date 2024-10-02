class Todo < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["completed", "created_at", "id", "id_value", "title", "updated_at"]
  end
end
