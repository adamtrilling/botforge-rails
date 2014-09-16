class BaseModel
  extend ActiveModel::Naming
  include ActiveModel::Model

  class << self
    def attribute(name, params = {})
      define_method :"#{name}" do
        instance_variable_get(:"@#{name}")
      end

      define_method :"#{name}=" do |new_val|
        instance_variable_set(:"@#{name}", new_val)
      end
    end
  end

  def persisted?
    false
  end
end