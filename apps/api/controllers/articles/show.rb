module Api
  module Controllers
    module Articles
      class Show
        include Api::Action

        def call(params)
          article = ArticleRepository.new.find_all_with_tags_favorites_author_info(
            current_user_id: current_user&.id,
            slug: params.get(:slug)
          ).first
          halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article

          status 200, ArticleTemplate.article(article)
        end

        private

        def authenticate!
        end

      end
    end
  end
end
