module Entities
    class Order < Grape::Entity
      expose :id
     expose :delivery_date
     expose :order_date
     expose :expected_delivery_date
     expose :status
     expose :total_amount
     expose :order_variant, using: Entities::OrderVariant
    end
  end