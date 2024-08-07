module AuthHelpers
   
    def authenticate!
      puts request.headers, "++++++++++++++++++++++++"
      token = request.headers['authorization']&.split(' ')&.last
  
      puts "data of headers #{header['Authorization']}"
      puts "Token from Authorization header: #{token}"
  
      if token
        if JwtBlacklist.exists?(token: token)
          error!("Token expired",401)
        else
          begin
            puts "Decoding token..."
            payload = JWT.decode(token, '123456789', true, { algorithm: 'HS256' }).first
            puts "Payload data: #{payload.inspect}"
            user_id = payload['user_id']
            Current.user = User.find(user_id)
            puts "current user --> #{Current.user.inspect}"
  
            if Current.user.nil?
              error!('Unauthorized - - User account is inactive', 401)
            end
          rescue JWT::DecodeError
            error!('Unauthorized - Invalid token', 401)
          end
        end
      else
        error!('Unauthorized - No token provided', 401)
      end
    end 
  
    def current_user
      Current.user
    end
  
    def authenticate_admin!
      
      error!('403 Forbidden', 403) unless Current.user.role == 'RETAILER'
    end

    def authenticate_supplier!
      error!('Forbidden', 403) unless Current.user.role == 'SUPPLIER'
    end

    def authenticate_retailer!
      
      error!('403 Forbidden , role is not allowed for this action', 403) unless Current.user.role == 'RETAILER'
    end
    def authenticate_customer!
      
      error!('403 Forbidden , role is not allowed for this action', 403) unless Current.user.role == 'CUSTOMER'
    end
  end
  