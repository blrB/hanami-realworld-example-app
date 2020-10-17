Hanami::Model.migration do
  up do
    drop_table :user_followers
  end

  down do
    drop_table :user_followers
  end
end
