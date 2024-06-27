module Entities
    class User < Grape::Entity
      expose :id
      expose :name   
      expose :email
      expose :role
    end
  end