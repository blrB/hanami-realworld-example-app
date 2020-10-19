class CommentRepository < Hanami::Repository
  associations do
    belongs_to :user, as: :author
  end

  def find_by_id_and_article_id(id:, article_id:)
    comments.where(id: id, article_id: article_id).one
  end

  def find_with_author_info(id: nil, article_id: nil, current_user_id: nil)
    dataset = comments
    dataset = dataset.where(id: id) if id
    dataset = dataset.where(article_id: article_id) if article_id

    ids = dataset.to_a.map(&:id)
    comment_array = aggregate(:author).qualified.where(id: ids).order { created_at }.map_to(Comment).to_a

    following_comments = comment_ids_with_author_following_by_ids(ids: ids, current_user_id: current_user_id)

    comment_array.map do |comment|
      author_with_info = comment.author.to_h.merge(following: following_comments.include?(comment.id))
      comment_with_info = comment.to_h.merge( author: UserWithInfo.new(author_with_info))
      CommentWithInfo.new(comment_with_info)
    end
  end

  private

  def comment_ids_with_author_following_by_ids(ids:, current_user_id: nil)
    comments.
      select(:id).
      left_join(:active_relationships, follower_id: current_user_id, followed_id: :author_id).
      where(id: ids).
      exclude(follower_id: nil).
      to_a.
      map(&:id)
  end

end
