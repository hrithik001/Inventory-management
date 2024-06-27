module Entities
  class Variant < Grape::Entity
    expose :id
    expose :price do |variant, options|
              if Current.user.role == 'CUSTOMER'
                variant.current_selling_price
              else
                variant.base_price
              end
            end
     expose :selling_price, if: ->(variant, options) { Current.user.role == 'RETAILER' } do |variant, options|
                                variant.current_selling_price
                              end

    expose :properties, using: Entities::Property
    
   
  end
end

