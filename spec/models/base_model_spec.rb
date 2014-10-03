require 'rails_helper'

require 'test_models'

describe BaseModel do
  let(:redis) { BaseModel.redis }

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
    context 'basic attributes' do
      subject { TestModels::Attribute.new(first_name: 'foo', last_name: 'bar')}

      it 'defines a getter' do
        expect(subject).to respond_to(:first_name)
        expect(subject.first_name).to eq 'foo'

        expect(subject).to respond_to(:last_name)
        expect(subject.last_name).to eq 'bar'
      end

      it 'defines a setter' do
        expect(subject).to respond_to(:first_name=)
        expect(subject).to respond_to(:last_name=)
      end

      it 'throws an exception on find_by' do
        expect { subject.class.find_by(first_name: 'foo') }.to raise_error(UnindexedSearch)
        expect { subject.class.find_by(last_name: 'bar') }.to raise_error(UnindexedSearch)
      end
    end

    context 'attributes with an index' do
      subject { TestModels::Index.new(identifier: SecureRandom.hex, category: 'animal') }

      it 'does not throw an exception on find_by' do
        expect { subject.class.find_by(identifier: 'abc') }.to_not raise_error
        expect { subject.class.find_by(category: 'animal') }.to_not raise_error
      end
    end
  end

  describe '#save' do
    subject { TestModels::Attribute.new(first_name: 'foo', last_name: 'bar')}

    before do
      subject.save
    end

    it 'assigns an id' do
      expect(subject.id).to be_a(Fixnum)
    end

    it 'creates an attributes hash in the database' do
      expect(redis.exists("TestModels::Attribute:#{subject.id}")).to eq true
      expect(redis.hget("TestModels::Attribute:#{subject.id}", 'first_name')).to eq 'foo'
      expect(redis.hget("TestModels::Attribute:#{subject.id}", 'last_name')).to eq 'bar'
    end

    it 'causes persisted to be true' do
      expect(subject.persisted?).to eq true
    end
  end

  describe '#save!' do
    pending "like save except it throws an exception on failure"
  end

  describe '#find' do
    context 'with a saved model' do
      subject do
        model = TestModels::Attribute.new(first_name: 'foo', last_name: 'bar')
        model.save
        model
      end

      it 'finds the model' do
        found = TestModels::Attribute.find(subject.id)
        expect(found).to be_a(subject.class)
        expect(found.first_name).to eq 'foo'
        expect(found.last_name).to eq 'bar'
      end
    end

    context 'with a nonexistent model' do
      it 'returns nil' do
        expect(TestModels::Attribute.find(-24)).to be_nil
      end
    end
  end

  describe '#find_by' do
    context 'with no key given' do
      it 'raises an ArgumentError' do
        expect { TestModels::Index.find_by({}) }.to raise_error ArgumentError
      end
    end
  end
end