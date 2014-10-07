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

      it 'does not create an index' do
        expect(TestModels::Attribute.has_index?(:first_name)).to eq false
        expect(TestModels::Attribute.has_unique_index?(:last_name)).to eq false
      end
    end

    context 'attributes with an index' do
      subject { TestModels::Index.new(identifier: SecureRandom.hex, category: 'animal') }

      it 'defines a getter' do
        expect(subject).to respond_to(:identifier)

        expect(subject).to respond_to(:category)
        expect(subject.category).to eq 'animal'
      end

      it 'defines a setter' do
        expect(subject).to respond_to(:identifier=)
        expect(subject).to respond_to(:category=)
      end

      it 'creates an index' do
        expect(TestModels::Index.has_index?(:category)).to eq true
        expect(TestModels::Index.has_unique_index?(:identifier)).to eq true
      end

      it 'does not throw an exception on find_by' do
        expect { subject.class.find_by(identifier: 'abc') }.to_not raise_error
        expect { subject.class.find_by(category: 'animal') }.to_not raise_error
      end
    end
  end

  describe '#save' do
    context 'on a new object' do
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

    context 'on an existing object' do
      let(:obj) { TestModels::Attribute.create(first_name: 'foo', last_name: 'bar') }
      let!(:obj_id) { obj.id }

      before do
        obj.first_name = 'baz'
        obj.save
      end

      it 'does not change the id' do
        expect(obj.id).to eq obj_id
      end

      it 'saves the changed field' do
        expect(TestModels::Attribute.find(obj_id).first_name).to eq 'baz'
      end
    end
  end

  describe '#save!' do
    pending "like save except it throws an exception on failure"
  end

  describe '#create' do
    subject { TestModels::Attribute.create(first_name: 'foo', last_name: 'bar') }

    it 'is persisted' do
      expect(subject.persisted?).to eq true
    end
  end

  describe '#all' do
    context 'with no saved objects' do
      it 'returns an empty array' do
        expect(TestModels::All.all).to eq []
      end
    end

    context 'with saved objects' do
      let!(:objs) do
        [ 
          TestModels::All.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
          TestModels::All.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
          TestModels::All.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
        ]
      end

      it 'returns an array with at least 3 objects' do
        all_objs = TestModels::All.all
        expect(all_objs.count).to be >= 3
      end

      it 'contains each saved object' do
        all_ids = TestModels::All.all.collect(&:id)
        objs.each do |o|
          expect(all_ids).to include(o.id)
        end
      end
    end
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

    context 'with an unindexed field' do
      subject { TestModels::Attribute.create(first_name: 'foo', last_name: 'bar') }

      it 'raises an UnindexedSearch exception' do
        expect { subject.class.find_by(first_name: 'foo') }.to raise_error(UnindexedSearch)
        expect { subject.class.find_by(last_name: 'bar') }.to raise_error(UnindexedSearch)
      end
    end

    context 'with an indexed field' do
      let(:subject_identifier) { SecureRandom.hex }
      let!(:subject) { TestModels::Index.create(identifier: subject_identifier, category: 'plant') }

      it 'returns the model for a correct search (unique)' do
        results = TestModels::Index.find_by(identifier: subject_identifier)
        expect(results.size).to eq 1
        expect(results.first.id).to eq subject.id
      end

      it 'resturns the model for a correct search (non-unique)' do
        non_uniq_subject = TestModels::Index.create(identifier: subject_identifier, category: 'metal')
        results = TestModels::Index.find_by(category: 'metal')
        expect(results.size).to eq 1
        expect(results.first.id).to eq non_uniq_subject.id
      end

      it 'returns an empty array for an incorrect result' do
        results = TestModels::Index.find_by(category: 'mineral')
        expect(results.size).to eq 0
      end
    end
  end
end