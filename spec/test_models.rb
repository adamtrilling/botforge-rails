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
end