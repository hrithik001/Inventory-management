class Product < ApplicationRecord
    has_many :product_categories
    has_many :categories, through: :product_categories
    has_many :variant

    validates :name, presence: true, uniqueness: true, length: { minimum: 3 }
    validates :description, presence: true, length: { minimum: 10 }
    # validate :validate_categories

   
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

    def self.get_product(query, min_price = nil, max_price = nil)

      products = all
      if query.present?
        name_description_condition = "products.name LIKE :query OR products.description LIKE :query"
        property_condition = "properties.name LIKE :query OR properties.value LIKE :query"
        category_condition = "categories.name LIKE :query"
  
        products = products.where(name_description_condition, query: "%#{query}%")
      end
  
     
  
      products.distinct
     

    
  end
  def update_product(params)
    update(params)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[categories variant]
  end 

end
  