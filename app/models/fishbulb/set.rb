class Fishbulb::Set
  include Enumerable

  attr_accessor :storage

  def initialize(storage)
    @storage = Set.new(storage)
  end

  delegate :each,
    to: :storage
end