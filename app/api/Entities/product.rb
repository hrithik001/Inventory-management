module Entities
  class Product < Grape::Entity
    expose :id
    expose :name
    expose :description
    expose :variant, using: Entities::Variant
  end
  end