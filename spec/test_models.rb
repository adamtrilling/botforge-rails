module TestModels
  class Attribute < Fishbulb::Base
    attribute :first_name
    attribute :last_name
  end

  class All < Fishbulb::Base
    attribute :first_name
    attribute :last_name
  end

  class Index < Fishbulb::Base
    attribute :identifier, index: :unique
    attribute :category, index: true
    attribute :age, index: true
  end

  # association examples
  class Blog < Fishbulb::Base
    attribute :name

    has_many :posts, sorted: true
    has_many :authors
  end

  class Author <  Fishbulb::Base
    attribute :name

    belongs_to :blog
    has_many :posts
  end

  class Post < Fishbulb::Base
    attribute :title
    attribute :body

    belongs_to :blog
    belongs_to :author
  end
end