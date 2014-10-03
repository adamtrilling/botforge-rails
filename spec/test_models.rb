module TestModels
  class Attribute < BaseModel
    attribute :first_name
    attribute :last_name
  end

  class Index < BaseModel
    attribute :identifier, unique_index: true
    attribute :category, index: true
  end
end