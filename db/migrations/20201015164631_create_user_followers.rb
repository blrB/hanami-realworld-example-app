Hanami::Model.migration do
  change do
    create_table :user_followers do
      foreign_key :user_id, :users, null: false, on_delete: :cascade
      foreign_key :follower_id, :users, null: false, on_delete: :cascade

      index :user_id
      index :follower_id
    end
  end
end
