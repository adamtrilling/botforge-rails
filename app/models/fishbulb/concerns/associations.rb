module Fishbulb::Concerns::Associations
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    def has_many(target, options = {})
    end

    def belongs_to(target, options = {})
    end
    alias_method :has_one, :belongs_to
  end
end