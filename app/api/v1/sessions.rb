class Api::V1::Sessions < Grape::API 

    helpers AuthHelpers
    resource :sessions do
     desc "Login a user"
     params do
       requires :email, type: String
       requires :password, type: String
     end
     post "/login" do
      
       user = User.find_by(email: params[:email])
       
       puts "params -------- #{params[:email]}  #{params[:role]}"
       if user&.authenticate(params[:password]) 
        
         payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
         token = JWT.encode(payload, "123456789", 'HS256')
        
          present({ token: token, user: user }, with: Entities::Login)
       else
         error!('Invalid email or password', 401)
       end
     end

     desc "Logout a user"
     delete "/logout" do
       token = request.headers['authorization']&.split(' ')&.last
       if token  
         JwtBlacklist.create!(token: token)

         
         { message: 'Logged out successfully' }
       else
         error!('Unauthorized - No token provided',401)
       end
     end

     desc "Get current user"
     get "/current_user" do
       authenticate!
       present :user, Current.user, with: Entities::User
     end

   end
   
end