class Todo < ApplicationRecord

  broadcasts_refreshes

  def self.ransackable_attributes(auth_object = nil)
    ["completed", "created_at", "id", "id_value", "title", "updated_at"]
  end

  # Scope for filtering completed todos
  scope :completed, -> { where(completed: true) }

  # Method to count total todos
  def self.total_count
    count
  end

  # Method to count completed todos using the scope
  def self.completed_count
    completed.count
  end

end
