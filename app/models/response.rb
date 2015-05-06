class Response < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user

  default_scope { order("created_at DESC") }

  validates_presence_of :user_id, :resource_type, :resource_id

  def display_name
    "Response #{id}"
  end
end
