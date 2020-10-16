Hanami::Model.migration do
  change do
    create_table :article_favorites do
      foreign_key :article_id, :articles, null: false, on_delete: :cascade
      foreign_key :favorit_id, :users, null: false, on_delete: :cascade

      index :article_id
      index :favorit_id
    end
  end
end
