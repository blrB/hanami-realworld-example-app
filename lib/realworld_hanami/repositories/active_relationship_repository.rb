class ActiveRelationshipRepository < Hanami::Repository
  # associations do
  #   belongs_to :user
  #   belongs_to :user
  # end

  def user_is_following?(follower_id:, followed_id:)
    active_relationships.where(follower_id: follower_id, followed_id: followed_id).exist?
  end

  def find_or_create(follower_id:, followed_id:)
    result = active_relationships.where(follower_id: follower_id, followed_id: followed_id).first
    result ? result : create(follower_id: follower_id, followed_id: followed_id)
  end

  def delete_by_ids(follower_id:, followed_id:)
    active_relationships.where(follower_id: follower_id, followed_id: followed_id).delete
  end

end