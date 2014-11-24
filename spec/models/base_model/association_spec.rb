require 'rails_helper'

require 'test_models'

describe Fishbulb::Base do
  let(:redis) { Fishbulb::Base.redis }

  describe '#has_many' do
    describe 'unsorted' do
      before do
        @blog = TestModels::Blog.create(name: Faker::Lorem.sentence)
        @author1 = TestModels::Author.create(name: Faker::Name.name, blog: @blog)
        @author2 = TestModels::Author.create(name: Faker::Name.name, blog: @blog)
      end

      describe 'getter' do
        it 'is created' do
          expect(@blog).to respond_to :authors
        end

        it 'returns a Set' do
          expect(@blog.authors).to be_a Set
        end
      end

      it 'sets the associated items based on initializer' do
        expect(@blog.authors.size).to eq 2
        expect(@blog.authors.collect(&:id)).to include(@author1.id)
        expect(@blog.authors.collect(&:id)).to include(@author2.id)

        @blog.authors.each do |a|
          expect(a).to be_a TestModels::Author
        end
      end

      it 'creates a set of ids of the associated model' do
        expect(redis.exists("TestModels::Blog:#{@blog.id}:has_many")).to eq true
        expect(redis.type("TestModels::Blog:#{@blog.id}:has_many")).to eq 'set'
      end
    end
  end

  describe '#belongs_to' do
    before do
      @blog = TestModels::Blog.create(name: Faker::Lorem.sentence)
      @author1 = TestModels::Author.create(name: Faker::Name.name, blog: @blog)
      @author2 = TestModels::Author.create(name: Faker::Name.name, blog: @blog)
    end

    describe 'getter' do
      it 'is created' do
        expect(@author1).to respond_to :blog
      end

      it 'returns the associated object' do
        expect(@author1.blog).to be_a TestModels::Blog
      end
    end

    describe 'setter' do
      it 'is created' do
        expect(@author1).to respond_to(:blog=)
      end

      it 'sets the association on the current object' do
        # we've implicitly called this setter using the Author constructor params
        # also, we've tested setting the association the other way in the has_many section
        expect(@author1.blog).to be_a TestModels::Blog
        expect(@author1.blog.id).to eq @blog.id
      end
    end
  end
end

describe Set do
  subject {
    Set.new([
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name),
      TestModels::Attribute.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
    ])
  }

  describe '#size' do
    it 'returns the size of the underlying array' do
      expect(subject.size).to eq 4
    end
  end
end