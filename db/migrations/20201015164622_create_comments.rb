Hanami::Model.migration do
  change do
    create_table :comments do
      primary_key :id

      column :body, String, null: false, size: 1025
      foreign_key :author_id, :users, on_delete: :cascade, null: false
      foreign_key :article_id, :articles, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :article_id
    end
  end
end
