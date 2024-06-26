class Product < ApplicationRecord
    has_many :product_categories
    has_many :categories, through: :product_categories
    has_many :variant

   
    def self.create_product(params)
puts "creating a product %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      product_name = params[:name]
      product_description = params[:description]
      categories = params[:categories]
      product = self.new(
        name: product_name,
        description: product_description
      )

      if product.save
        categories.each do |category_name|
          category = Category.find_or_create_by(name: category_name)
          product.categories << category unless product.categories.include?(category)
        end
      end
      product
    end

end
  