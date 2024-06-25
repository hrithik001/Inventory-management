module Entities
  class Inventory < Grape::Entity
    expose :product, using: Entities::Product do |inventory, options|
      inventory.variant.product if inventory.variant
    end
    expose :quantity_available
  end
end
