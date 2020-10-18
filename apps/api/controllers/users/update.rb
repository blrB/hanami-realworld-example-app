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

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          if params.get(:user, :username)
            user_by_name = @repository.find_by_username(params.get(:user, :username))
            halt 403, ErrorMessageTemplate.errors(['Username already registered']) if user_by_name && user_by_name.id != current_user.id
          end

          if params.get(:user, :email)
            user_by_email = @repository.find_by_email(params.get(:user, :email))
            halt 403, ErrorMessageTemplate.errors(['Email already registered']) if user_by_email && user_by_email.id != current_user.id
          end

          user_params = params.get(:user)
          user_params.merge!(password: PasswordHelper.create_password(params.get(:user, :password))) if params.get(:user, :password)

          user = @repository.update(current_user.id, user_params)

          status 200, UserTemplate.user(@repository.update(current_user.id, user_params), JWTHelper.decode(user))
        end

      end
    end
  end
end
