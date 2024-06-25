module Entities
    class OrderVariant < Grape::Entity
      expose :ordered_quantity
      expose :supplied_quantity
      expose :variant ,using: Entities::Variant
    end
  end