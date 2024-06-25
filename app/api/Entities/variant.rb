module Entities
  class Variant < Grape::Entity
    expose :id
    expose :price
    expose :properties, using: Entities::Property
    
   
  end
end

 # class Variant < Grape::Entity
    #   expose :id
    #   expose :name, as: :product_name do |variant, _|
    #     variant.product.name
    #   end
    #   expose :description, as: :product_description do |variant, _|
    #     variant.product.description
    #   end
    #   expose :current_selling_price
    #   expose :properties, using: Entities::Property
    # end