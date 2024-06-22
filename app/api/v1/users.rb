class Api::V1::Users < Grape::API
    resources :users do


        desc "create a user"
        params do
            requires :name ,type: String
            requires :email ,type: String
            requires :password ,type: String
            requires :password_confirmation, type: String
            requires :role, type: String
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

        
        
    end
end