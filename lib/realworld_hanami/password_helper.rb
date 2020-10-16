class PasswordHelper

  def self.create_password(raw_password)
    BCrypt::Password.create(raw_password)
  end

  def self.valid_password?(raw_password, user)
    BCrypt::Password.new(user.password) == raw_password
  end

end