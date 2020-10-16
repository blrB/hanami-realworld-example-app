Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :email, String,  null: false, unique: true
      column :password, String,  null: false

      column :username, String,  null: false, unique: true

      column :bio, String, size: 512
      column :image, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :email, unique: true
      index :username, unique: true
    end
  end
end
