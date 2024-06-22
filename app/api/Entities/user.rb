module Entities
    class User < Grape::Entity
      expose :name   
      expose :email
      expose :role
    end
  end