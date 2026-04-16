class Account < ApplicationRecord
  # Each account/tenant has many users and properties
  has_many :users
  has_many :properties, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
end
