module Api
  module Controllers
    module Articles
      class Show
        include Api::Action

        def call(params)
          article = ArticleRepository.new.find_all_with_tags_favorites_author(
            current_user_id: current_user&.id,
            slug: params.get(:slug)
          ).first
          status 200, ArticleTemplate.article(article)
        end

        private

        def authenticate!
        end

      end
    end
  end
end
