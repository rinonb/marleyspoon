require_relative '../../spec_helper'

RSpec.describe Contentful::Recipes do
  before do
    allow_any_instance_of(Contentful::Recipes)
      .to(
        receive(:entries)
          .with('recipe')
          .and_return(entries)
      )
  end

  describe '#all' do
    let(:entries) do
      [
        OpenStruct.new(
          id: '1001',
          fields: {
            title: 'some title',
            photo: 'https://picsum.photos/200/300',
            tags: %w[meat cake],
            description: 'some description',
            chef: 'Monica Geller'
          }
        ),
        OpenStruct.new(
          id: '1002',
          fields: {
            title: 'second title',
            photo: 'https://picsum.photos/200/300',
            description: 'second description'
          }
        ),
        OpenStruct.new(
          id: '1003',
          fields: {
            title: 'third title',
            photo: 'https://picsum.photos/200/300',
            description: 'second description',
            chef: 'Some Chef'
          }
        )
      ]
    end

    subject { described_class.new.all }

    context 'given we have received 3 entries from contentful' do
      it %(
        should
        - return equal number of recipes
        - return entries as recipes
        - match entry with returned recipe
      ) do
        expect(subject.count).to eq(entries.count)
        expect(subject.first).to be_a(Recipe)
        expect(subject.first.id).to eq(entries.first.id)
        expect(subject.first.tags).to eq(entries.first.fields[:tags])
      end
    end
  end
end
