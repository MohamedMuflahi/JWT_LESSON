class ApplicationController < ActionController::API
  def secret
    'my$dsjhfbsdhfdshjfjksdfjkndskjdsfskjfn'
  end
 
  # IN JSON
  def encode(payload)
    JWT.encode(payload, secret, 'HS256')
  end
  #  JWT STRING

  # IN  STRING
  def decode(token)
    JWT.decode(token, secret, true, { algorithm: 'HS256' })
  end
  # OUT  JSON

  #   POST BODY: {username, password}
  def login
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      payload = {
        "user_id": user.id
      }
       token = encode(payload)
       render json: {token:token}
    end
  end
  # POST token
  def profile
    payload = decode(params[:token])[0]
    user = User.find(payload["user_id"])
    if user
      render json: user
    else
      render json: {error: "NOT FOUND"}, status: 404
    end
  end
end
