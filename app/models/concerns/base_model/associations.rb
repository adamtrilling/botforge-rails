module Concerns::BaseModel::Associations
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    def has_many(target, options = {})
    end

    def belongs_to(target, options = {})
    end
  end
end