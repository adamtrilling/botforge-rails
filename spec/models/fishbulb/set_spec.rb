require 'rails_helper'

require 'test_models'

describe Fishbulb::Set do
  let(:elements) {
    [
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
    ]
  }

  subject {
    Fishbulb::Set.new(elements)
  }

  it 'implements Enumberable' do
    Enumerable.instance_methods.each do |m|
      expect(subject).to respond_to(m)
    end
  end

  describe '#each' do
    it 'iterates over the elements of the underlying array' do
      subject.each do |elt|
        expect(elements.collect(&:id)).to include elt.id
      end
    end
  end

  describe '#initialize' do
    it 'verifies that all items are the same type'
  end

  describe '#add' do
    it 'verifies that the added element matches the set type'
    it 'adds the item to the set in a permanent manner'
  end
end