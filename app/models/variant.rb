class Variant < ApplicationRecord
  belongs_to :product
  has_many :properties

  has_many :order_variant
  has_many :orders, through: :order_variant
  has_many :customer_order_variants


  
  has_many :variant_prices

  def current_selling_price
    variant_prices.last&.selling_price || price
  end

  def calculate_average_selling_price
    variant_prices_count = variant_prices.count
    return 0 if variant_prices_count.zero?

    var_sum = variant_prices.sum(:selling_price)
    var_sum / variant_prices_count.to_f
  end

  def calculate_selling_price(average_selling_price)

    profit_margin = 20
    
    average_selling_price * (1 + profit_margin / 100.0)
  end


end
