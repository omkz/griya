class EnableEssentials < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'postgis'
    enable_extension 'vector'
    enable_extension 'pgcrypto'
  end
end
