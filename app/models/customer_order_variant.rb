class CustomerOrderVariant < ApplicationRecord
  belongs_to :customer_order
  belongs_to :variant
end
