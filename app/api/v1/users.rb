class Api::V1::Users < Grape::API
     helpers AuthHelpers
    resources :users do


        desc "create a user"
        params do
            requires :name ,type: String
            requires :email ,type: String
            requires :password ,type: String
            requires :password_confirmation, type: String
            requires :role, type: String
            optional :contact, type:String
            optional :address, type: String
        end
        post  do
            
            user = User.create_user(params)
            puts user.inspect
            if user.persisted?
                present :user, user, with: Entities::User
            else
               error!(user.errors.full_messages.to_json, 422)
            end
        
        end
        
        desc "edit the profile"
        params do
            optional :name ,type: String
            optional :contact, type:String
            optional :address, type: String
        end
        put ":id" do
            user = User.find_by(id: params[:id])
            if user
                user.update_profile(params)
                if user.is_a?(User)
                    present user,with: Entities::User
                else
                    error!("user not updated",403)
                end

            else
                error!("user not exists",404)
            end
            
        end

        desc "add a retailer or supplier"
        params do
            requires :name ,type: String
            requires :email ,type: String
            requires :password ,type: String
            requires :password_confirmation, type: String
            requires :role, type: String
            optional :contact, type:String
            optional :address, type: String
        end
        post "add" do

            authenticate!
            authenticate_retailer!
            
            user = User.create_user(params)
            puts user.inspect
            if user.persisted?
                
                if user.role == 'SUPPLIER'

                    supplier = Supplier.find_by(user_id: user.id)
                    present supplier,with: Entities::Supplier

                else
                    present :user, user, with: Entities::User
                end
            else
               error!(user.errors.full_messages.to_json, 422)
            end
        end

        
        
    end
end