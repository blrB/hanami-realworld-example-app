module Api
  module Controllers
    module Articles
      module Comments
        class Show
          include Api::Action

          def call(params)
            article = ArticleRepository.new.find_by_slug(params.get(:slug))
            halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article

            comments = CommentRepository.new.find_with_author_info(article_id: article.id, current_user_id: current_user.id)
            status 200, CommentTemplate.list(comments)
          end
        end
      end
    end
  end
end
