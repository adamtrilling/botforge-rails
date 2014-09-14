class BaseModel
  extend ActiveModel::Naming
  include ActiveModel::Model

  def persisted?
    false
  end
end