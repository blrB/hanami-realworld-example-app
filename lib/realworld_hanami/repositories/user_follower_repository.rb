class UserFollowerRepository < Hanami::Repository
  associations do
    belongs_to :user
    belongs_to :user, as: :follower
  end

  def user_is_following?(user_id, user_id_for_check)
    user_followers.where(user_id: user_id_for_check, follower_id: user_id).exist?
  end
end
