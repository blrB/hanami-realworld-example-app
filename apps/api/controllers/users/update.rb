module Api
  module Controllers
    module Users
      class Update
        include Api::Action

        params do
          required(:user).schema do
            required(:email).maybe(:str?)
            required(:username).maybe(:str?)
            required(:password).maybe(:str?)
            required(:image).maybe(:str?)
            required(:bio).maybe(:str?)
          end
        end

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          user_params = params.get(:user)
          user_params.merge!(password: PasswordHelper.create_password(params.get(:user, :password))) if params.get(:user, :password)
          user = @repository.update(current_user.id, user_params) rescue nil

          if user
            status 201, UserTemplate.user(user, JWTHelper.decode(user))
          else
            status 403, ErrorMessageTemplate.errors(['Forbidden requests'])
          end
        end

      end
    end
  end
end
