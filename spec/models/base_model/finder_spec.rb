require 'rails_helper'

require 'test_models'

describe Fishbulb::Base do
  let(:redis) { Fishbulb::Base.redis }
  
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

    context 'with multiple fields' do
      before do
        TestModels::Index.destroy_all

        @objs = [
          TestModels::Index.create(identifier: SecureRandom.hex, category: 'plant', age: 2),
          TestModels::Index.create(identifier: SecureRandom.hex, category: 'plant', age: 2),
          TestModels::Index.create(identifier: SecureRandom.hex, category: 'metal', age: 2),
          TestModels::Index.create(identifier: SecureRandom.hex, category: 'animal', age: 2),
          TestModels::Index.create(identifier: SecureRandom.hex, category: 'plant', age: 3),
          TestModels::Index.create(identifier: SecureRandom.hex, category: 'animal', age: 3)
        ]
      end

      it 'find_by returns the correct results' do
        results = TestModels::Index.find_by(category: 'plant', age: 2).collect(&:id)
        expect(results.size).to eq 2
        expect(results).to include(@objs[0].id)
        expect(results).to include(@objs[1].id)
        expect(results).to_not include(@objs[2].id)
        expect(results).to_not include(@objs[3].id)
        expect(results).to_not include(@objs[4].id)
        expect(results).to_not include(@objs[5].id)
      end

      it 'find_by_any returns the correct results' do
        results = TestModels::Index.find_by_any(category: 'plant', age: 2).collect(&:id)
        expect(results.size).to eq 5
        expect(results).to include(@objs[0].id)
        expect(results).to include(@objs[1].id)
        expect(results).to include(@objs[2].id)
        expect(results).to include(@objs[3].id)
        expect(results).to include(@objs[4].id)
        expect(results).to_not include(@objs[5].id)
      end
    end
  end
end