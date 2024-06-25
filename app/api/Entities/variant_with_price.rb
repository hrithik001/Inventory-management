module Entities
   
    class VariantWithPrice < Grape::Entity
      expose :id
      expose :price do |variant, _|
                    variant.current_selling_price
              end
  
      expose :properties, using: Entities::Property
    end


  end
  