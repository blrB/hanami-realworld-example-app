module Api
  module Controllers
    module Articles
      class Index
        include Api::Action

        params do
          optional(:tag) { str? }
          optional(:author) { str? }
          optional(:favorited) { str? }
          optional(:limit) { int? & lteq?(1024) }
          optional(:offset) { int? }
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          articles = ArticleRepository.new.find_all_with_tags_favorites_author_info(
            current_user_id: current_user&.id,
            tag: params.get(:tag),
            author: params.get(:author),
            favorited: params.get(:favorited),
            limit: params.get(:limit),
            offset: params.get(:offset)
          )
          status 200, ArticleTemplate.list(articles)
        end

        private

        def authenticate!
        end

      end
    end
  end
end
