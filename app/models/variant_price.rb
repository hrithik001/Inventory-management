class VariantPrice < ApplicationRecord
    belongs_to :variant
  
    validates :base_price, :selling_price, presence: true
  end
  