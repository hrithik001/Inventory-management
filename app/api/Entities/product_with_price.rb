module Entities
    class ProductWithPrice < Grape::Entity
      expose :id
      expose :name
      expose :description
      expose :variant, using: Entities::VariantWithPrice
    end
  
   


  end
  