class Customer < ApplicationRecord
  belongs_to :user
  has_many :customer_orders, foreign_key: 'customer_id'
end
