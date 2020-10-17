Hanami::Model.migration do
  change do
    create_table :active_relationships do
      foreign_key :follower_id, :users, null: false, on_delete: :cascade
      foreign_key :followed_id, :users, null: false, on_delete: :cascade

      index :follower_id
      index :followed_id
    end
  end
end
