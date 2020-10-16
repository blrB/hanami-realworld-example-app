module Api
  module Controllers
    module Profiles
      class Unfollow
        include Api::Action

        def call(params)
          self.body = 'OK'
        end
      end
    end
  end
end
