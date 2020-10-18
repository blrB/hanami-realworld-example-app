module Api
  module Controllers
    module Articles
      module Comments
        class Create
          include Api::Action

          params do
            required(:comment).schema do
              required(:body).filled
            end
            required(:slug) { str? }
          end

          def initialize(repository: CommentRepository.new)
            @repository = repository
          end

          def call(params)
            halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

            article = ArticleRepository.new.find_by_slug(params.get(:slug))
            halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article

            comment = @repository.find_with_author_info(
              current_user_id: current_user.id,
              id: @repository.create(
                body: params.get(:comment, :body),
                article_id: article.id,
                author_id: current_user.id
              ).id
            ).first
            status 200, CommentTemplate.comment(comment)
          end
        end
      end
    end
  end
end
