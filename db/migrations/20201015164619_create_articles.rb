Hanami::Model.migration do
  change do
    create_table :articles do
      primary_key :id

      column :slug, String, null: false, unique: true
      column :title, String, null: false
      column :description, String,  null: false, size: 256
      column :body, String, null: false, size: 8192

      foreign_key :author_id, :users, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :slug, unique: true
      index :author_id
    end
  end
end
