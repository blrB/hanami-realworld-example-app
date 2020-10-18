module Api
  module Controllers
    module Articles
      module Comments
        class Destroy
          include Api::Action

          def initialize(repository: CommentRepository.new)
            @repository = repository
          end

          def call(params)
            article = ArticleRepository.new.find_by_slug(params.get(:slug))
            halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article

            comment = @repository.find_by_id_and_article_id(id: params.get(:id), article_id: article.id)
            halt 404, ErrorMessageTemplate.errors(['Comment not exist']) unless comment
            halt 403, ErrorMessageTemplate.errors(['Only author can delete comment']) if comment.author_id != current_user.id

            @repository.delete(comment.id)
            status 200, {}.to_json
          end
        end
      end
    end
  end
end
