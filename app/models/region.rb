class Region < ApplicationRecord
  # Self-referencing relationship for hierarchy (Province -> City -> District)
  belongs_to :parent, class_name: "Region", optional: true
  has_many :children, class_name: "Region", foreign_key: "parent_id"

  has_many :properties

  validates :name, presence: true
end
