Hanami::Model.migration do
  change do
    create_table :article_tags do
      foreign_key :article_id, :articles, null: false, on_delete: :cascade
      foreign_key :tag_id, :tags, null: false, on_delete: :cascade

      index :article_id
      index :tag_id
    end
  end
end
