module Entities
    class CustomerOrderDetails < Grape::Entity
     expose :id
     expose :delivery_date
     expose :order_date
     expose :expected_delivery_date
     expose :retailer_id 
     expose :status
     expose :total_amount
     expose :customer_order_variants, using: Entities::OrderVariant
    end
    
  end