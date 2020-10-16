class JWTHelper

  def self.decode(user)
    payload = { iss: ENV.fetch('ISS'), user_id: user.id }
    JWT.encode(payload, ENV.fetch('API_SESSIONS_SECRET'), ENV.fetch('ALGORITHM') )
  end

  def self.user_id(payload)
    payload.first.fetch("user_id")
  end

  def self.encode(token)
    JWT.decode(token, ENV.fetch('API_SESSIONS_SECRET'), ENV.fetch('ALGORITHM'))
  end

end
