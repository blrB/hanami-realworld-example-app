module Api
  module Controllers
    module Users
      class Update
        include Api::Action

        params do
          required(:user).schema do
            optional(:email) { str? }
            optional(:username) { str? }
            optional(:password) { str? }
            optional(:image) { str? }
            optional(:bio) { str? }
          end
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          user_params = params.get(:user)
          user_params.merge!(password: PasswordHelper.create_password(params.get(:user, :password))) if params.get(:user, :password)
          user = UserRepository.new.update(current_user.id, user_params) rescue nil

          if user
            status 200, UserTemplate.user(user, JWTHelper.decode(user))
          else
            status 422, ErrorMessageTemplate.errors(['User not updated'])
          end
        end

      end
    end
  end
end
