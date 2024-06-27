class Customer < ApplicationRecord
  belongs_to :user
  has_many :customer_orders, foreign_key: 'customer_id'

  def self.get_details
    Customer.find_by(user_id: Current.user) 
  end
end
