class AddFeaturedAndViewsCountToProperties < ActiveRecord::Migration[8.1]
  def change
    add_column :properties, :featured, :boolean, default: false
    add_column :properties, :views_count, :integer, default: 0
  end
end
