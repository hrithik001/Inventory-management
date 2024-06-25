class Api::V1::Inventory < Grape::API 
    helpers AuthHelpers
    resources :inventory do
        before do
            # authenticate_retailer!
            authenticate!
        end

        desc "get Inventory"
        get do
            inventories = Inventory.all

          present inventories, with: Entities::Inventory
        end

        desc "get all Transitions"

        params do
            optional :page, type: Integer, default: 1, desc: "Page number"
            optional :per_page, type: Integer, default: 5, desc: "Transistions per page"
            optional :type, type: String, desc: "transistion type [ IN , OUT ]"
        end
        get "transistions" do

            page = params[:page] || 1
            per_page = params[:per_page] || Kaminari.config.default_per_page
            transition_type = params[:type]
            transistions = InventoryTransition.search(transition_type).page(page).per(per_page)

            {  transistions: transistions,
            type: transition_type,
                pagination: {
                current_page: transistions.current_page,
                total_pages: transistions.total_pages,
                total_items: transistions.total_count,
                per_page: transistions.limit_value
                }
        }
        end
    end

    

end