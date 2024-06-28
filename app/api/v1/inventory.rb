class Api::V1::Inventory < Grape::API 
    helpers AuthHelpers

    resources :inventory do
        before do
            authenticate!
            authenticate_retailer!
           
        end

        desc "get Inventory"
       
        get do
            inventories = Inventory.get_inventory

            present inventories, with: Entities::Inventory
        end

        desc "get all Transitions"

        params do
            optional :page, type: Integer, default: 1, desc: "Page number"
            optional :per_page, type: Integer, default: 5, desc: "Transistions per page"
            optional :filter, type: String, desc: "transistion type [ IN , OUT ]"
        end
        get "transistions" do

            page = params[:page] || 1
            per_page = params[:per_page] || Kaminari.config.default_per_page
            transition_type = params[:filter]
            transistions = InventoryTransition.search(transition_type)
            transitions = paginate(transistions)
            present transitions, with: Api::Entities::Transistion
            
        
        end
    end

    

end