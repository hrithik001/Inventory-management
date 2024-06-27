module Entities
    class OrderDetails < Grape::Entity
        expose :id
        expose :delivery_date
        expose :order_date
        expose :expected_delivery_date
        expose :retailer_id 
        expose :status
        expose :total_amount
       expose :order_variant, using: Entities::OrderVariant
      end
end