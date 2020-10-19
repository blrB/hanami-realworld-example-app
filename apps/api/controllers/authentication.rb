module Api
  module Controllers
    module Authentication
      def self.included(action)
        action.class_eval do
          before :authenticate!
          expose :current_user
        end
      end

      private

      def authenticate!
        halt 401, ErrorMessageTemplate.errors(['Unauthorized requests']) unless authenticated?
      end

      def authenticated?
        !!current_user
      end

      def current_user
        @current_user ||= token ? UserRepository.new.find(user_id) : nil
      end

      def token
        @token ||= params.env['HTTP_AUTHORIZATION'][/Token \K.*/] rescue nil
      end

      def user_id
        JWTHelper.user_id(JWTHelper.encode(token))
      end
    end
  end
end
