class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  serialize :followed_by_user_ids, JSON
  serialize :followed_user_ids, JSON
  
  def followed_by_user_ids=(value)
    super(value.is_a?(String) ? JSON.parse(value) : value)
  end

  def followed_by_user_ids
    super || []
  end

  def followed_user_ids=(value)
    super(value.is_a?(String) ? JSON.parse(value) : value)
  end

  def followed_user_ids
    super || []
  end
end
