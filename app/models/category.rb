class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories
  
  def self.ransackable_attributes(auth_object = nil)
    %w[id name]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
  
end
