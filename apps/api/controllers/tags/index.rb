module Api
  module Controllers
    module Tags
      class Index
        include Api::Action

        def call(params)
          status 200, TagTemplate.list(TagRepository.new.all)
        end

        private

        def authenticate!
        end

      end
    end
  end
end
