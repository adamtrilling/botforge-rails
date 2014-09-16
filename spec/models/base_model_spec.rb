require 'rails_helper'

require 'test_models'

describe BaseModel do
  include ActiveModel::Lint::Tests
 
  # to_s is to support ruby-1.9
  ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
    example m.gsub('_',' ') do
      send m
    end
  end
 
  def model
    subject
  end

  describe '#attribute' do
    subject { TestModels::Attribute.new(first_name: 'foo', last_name: 'bar')}

    it 'defines a getter' do
      expect(subject).to respond_to(:first_name)
      expect(subject).to respond_to(:last_name)
    end

    it 'defines a setter' do
      expect(subject).to respond_to(:first_name=)
      expect(subject).to respond_to(:last_name=)
    end
  end
end