class Api::V1::Product < Grape::API 
    helpers AuthHelpers
    resources :product do 
        before do
            authenticate!
        end

        desc "get all product"
        get do
            products = Product.all

            if Current.user&.role == "RETAILER"
                present products,  with: Entities::Product
            else
                present products, with: Entities::ProductWithPrice
            end
        end

        desc "get a product"
        get ":id" do
            product = Product.find_by(id: params[:id])
            present product,with: Entities::Product
        end

        desc "add new product"
        params do
            requires :name, type: String
            requires :description,type: String
            requires :categories, type: Array[String]

        end

        post do
            authenticate_retailer!

            product =  Product.create_product(params)

            

            if product.persisted?
                present product, with: Entities::Product
            else
                error!("product not created",401)
            end

        end

        desc "Edit a product"
        params do
            optional :name, type: String
            optional :description, type: String
        end
        put ":id" do

            authenticate_retailer!
            
            product = Product.find_by(id: params[:id])

            product.update(params)
            present :product, with: Entities::Product
        end

        private 

        
          


    end
end
