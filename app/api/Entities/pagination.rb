module Entities
    class Pagination < Grape::Entity
      expose :current_page
      expose :per_page
   
    end
  end
  