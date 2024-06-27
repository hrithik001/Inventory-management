class ProductCategory < ApplicationRecord
    belongs_to :product
    belongs_to :category

    def self.ransackable_attributes(auth_object = nil)
      %w[product_id category_id]
    end
  
    def self.ransackable_associations(auth_object = nil)
      %w[product category]
    end
  end
  