module TestModels
  class Attribute < BaseModel
    attribute :first_name
    attribute :last_name
  end

  class All < BaseModel
    attribute :first_name
    attribute :last_name
  end

  class Index < BaseModel
    attribute :identifier, index: :unique
    attribute :category, index: true
    attribute :age, index: true
  end

  # association examples
  class Blog < BaseModel
    attribute :name

    has_many :posts, sorted: true
    has_many :authors
  end

  class Author <  BaseModel
    attribute :name

    belongs_to :blog
    has_many :posts
  end

  class Post < BaseModel
    attribute :title
    attribute :body

    belongs_to :blog
    belongs_to :author
  end
end