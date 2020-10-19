FactoryBot.define do

  factory :user do
    username { "Jacob" }
    email  { "jake@jake.jake" }
    password { PasswordHelper.create_password("jakejake") }
  end

  factory :user2, class: "User" do
    username { "Jacob2" }
    email  { "jake2@jake.jake" }
    password { PasswordHelper.create_password("jakejake2") }
  end

  factory :article do
    slug { "how-to-train-your-dragon" }
    title { "How to train your dragon" }
    description { "Ever wonder how?" }
    body { "It takes a Jacobian" }
    tags { ["dragons", "training"] }
  end

  factory :article2, class: "Article" do
    slug { "how-to-train-your-dragon-2" }
    title { "How to train your dragon 2" }
    description { "Ever wonder how ?(2)" }
    body { "It takes a Jacobian 2" }
    tags { ["dragons2", "training2"] }
  end

  factory :article3, class: "Article" do
    slug { "how-to-train-your-dragon-3" }
    title { "How to train your dragon 3" }
    description { "Ever wonder how?(3)" }
    body { "It takes a Jacobian 3" }
    tags { ["dragons3", "training3"] }
  end

  factory :comment do
    body { "Comment 1." }
  end

  factory :comment2, class: "Comment" do
    body { "Comment 2." }
  end

  factory :comment3, class: "Comment" do
    body { "Comment 3." }
  end

  factory :tag do
    name { "dragons" }
  end

  factory :tag2, class: "Tag" do
    name { "training" }
  end

end
