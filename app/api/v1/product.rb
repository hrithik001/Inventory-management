class Api::V1::Product < Grape::API 
    helpers AuthHelpers

    resources :product do 
        before do
            authenticate!
        end

        desc "get all product"
        params do 
            optional :page, type: Integer, default: 1, desc: "Page number"
            optional :per_page, type: Integer, default: 5, desc: "Product per page"
            optional :query, type: String, desc: "Search query"
        end
        get do
            search_conditions = {
                id_eq: params[:query],
                name_cont: params[:query],
                description_cont: params[:query]
            }
            page = params[:page]
            per_page = params[:per_page]

            product = Product.ransack(search_conditions.merge(m: 'or')).result
            product = paginate(product) 

            if Current.user&.role == "RETAILER"
                present product,  with: Entities::Product
            else
                present product, with: Entities::ProductWithPrice
            end

            # ?query=1
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

        desc "delete product only if not having dependency"
        delete ":id" do
            authenticate_retailer!

            product = Product.find_by(id: params[:id])
  
            if product
              ActiveRecord::Base.transaction do
              
                if product.variant.exists?
                  error!({ error: 'Delete variants first' }, 422)
                end
                
                
                product.categories.destroy_all
                
                
                if product.destroy
                  { status: 'deleted' }
                else
                  error!({ error: 'Unable to delete product' }, 422)
                end
              end
            else
              error!({ error: 'Product not found' }, 404)
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
            
            if product.nil?
                error!({ error: 'Product not found' }, 404)
            end
    
            if product.update_product(declared(params, include_missing: false))
                present :product, product, with: Entities::Product
            else
                error!({ error: 'Failed to update product', details: product.errors.full_messages }, 422)
            end
        end

       

        
          


    end
end
