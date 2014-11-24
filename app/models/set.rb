class Set
  attr_accessor :storage

  def initialize(storage)
    @storage = storage
  end

  delegate :size,
    to: :storage
end