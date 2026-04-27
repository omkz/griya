class PropertyImageJob < ApplicationJob
  queue_as :default

  # Process all predefined variants for property images in the background
  def perform(property)
    property.images.each do |image|
      # Trigger processing for each named variant
      [ :large, :card, :thumbnail ].each do |variant_name|
        image.variant(variant_name).processed
      end
    end
  end
end
