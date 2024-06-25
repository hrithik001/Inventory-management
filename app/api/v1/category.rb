class Api::V1::Category < Grape::API 
    resources :category do
        desc "all categories"
        get do
            categories = Category.all
            present categories, with: Entities::Category
        end
        
        desc "add new category"
        params do
            requires :name
        end
        post do
            category = Category.find_or_create_by(name: params[:name])

            if category.save
                present category ,with: Entities::Category
            else
                error!('category not created',401)
            end

        end
        
    end
end