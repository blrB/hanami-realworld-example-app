class UserRepository < Hanami::Repository
  # associations do
  #   has_many :articles
  #   has_many :comments
  #   has_many :articles, as: :favorites, through: :article_favorites
  # end
  # associations do
  #   has_many :active_relationships, as: :following
  # end

  def find_by_email(email)
    users.where(email: email).first
  end

  def find_by_username(username)
    users.where(username: username).first
  end

  def following(user)
    users.select(:id, :email, :username, :bio, :image).join(:active_relationships, followed_id: :id).where(follower_id: user.id).to_a
  end

  # def find_by_id_with_user_relationship(id, relationship_user)
  #   aggregate(:following).where(id: id).map_to(User).one
  # end
  #
  # def find_by_name_with_user_relationship(username, relationship_user)
  #   aggregate(:following).where(username: username).map_to(User).one
  # end

  # def find_with_comments(id)
  #   aggregate(:comments).where(id: id).map_to(User).one
  # end
  #
  # def find_with_articles(id)
  #   aggregate(:articles).where(id: id).map_to(User).one
  # end
  #
  # def articles_for(user)
  #   assoc(:articles, user).to_a
  # end
  #
  # def find_with_favorites(id)
  #   aggregate(:favorites).where(id: id).map_to(User).one
  # end
  #
  # def favorites_for(user)
  #   assoc(:favorites, user).to_a
  # end
  #
  # def followers_for(user)
  #   users
  #     .join(:user_followers, follower_id: :id)
  #     .where(user_id: user.id)
  #     .to_a
  # end
  #
  # def following_for(user)
  #   users
  #     .join(:user_followers, user_id: :id)
  #     .where(follower_id: user.id)
  #     .to_a
  # end

end
