class Api::V1::Variant < Grape::API 
    helpers AuthHelpers

    resources :product do
        route_param :product_id do
            resources :variant do
              before do
                  authenticate!
              end

              desc "Get all variants of a product"
              get do
                  product = Product.find(params[:product_id])
                  variants = product.variant
                  present variants, with: Entities::Variant
              end

              desc "Create a variants for an product along with properties"
              params do
                  
                  requires :properties_attributes, type: Array, desc: "Array of properties for the variant" do
                    requires :name, type: String, desc: "Name of the property"
                    requires :value, type: String, desc: "Value of the property"
                  end
              end
                  
              post do
                authenticate_retailer!
                  product = Product.find(params[:product_id])
                  
                  
                  variant_params = declared(params, include_missing: false).except(:properties_attributes)
                  variant = product.variant.create!(
                    price: 0.0
                  )
          
                    if params[:properties_attributes].present?
                      params[:properties_attributes].each do |prop|
                        variant.properties.create!(name: prop[:name], value: prop[:value])
                      end
                    end
                  
          
                  present variant, with: Entities::Variant
              end


                
              desc "Get particular variant"
              get ":id" do
                  product = Product.find(params[:product_id])
                  variant = product.variants.find(params[:id])
                  present variant, with: Entities::Variant
              end

              desc "update a variant"
              params do
                  optional :price, type: Integer, desc: "New price of the variant"
                  
              end
                
              patch ":id" do
                product = Product.find(params[:product_id])
                variant = product.variants.find(params[:id])
                variant.update!(declared(params, include_missing: false))
                present variant, with: Entities::Variant
              end

              desc "Delete a variant"
              params do
                requires :id, type: Integer, desc: "Variant ID"
              end
              delete ":id" do
                authenticate_retailer!
                variant = Variant.find_by(id: params[:id])

                if variant
                  result = variant.delete_if_allowed
                  if result[:status] == 'deleted'
                    { status: 'deleted' }
                  else
                    error!(result, 422)
                  end
                else
                  error!({ error: 'Variant not found' }, 404)
                end
              end

                  
                  
                  
                  

            end
        end
    end
end