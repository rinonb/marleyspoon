require_relative '../spec_helper'

RSpec.describe Recipe, type: :model do
  describe '#build_from_entry' do
    context 'given we have fetched an entry' do
      let(:entry) do
        OpenStruct.new(
          id: '1001',
          fields: {
            title: 'some title',
            photo: 'https://picsum.photos/200/300',
            tags: %w[meat cake],
            description: 'some description',
            chef: 'Monica Geller'
          }
        )
      end

      subject { described_class.build_from_entry(entry) }

      it %(
        should
        - build recipe from entry
        - match built recipe with the given entry
      ) do
        expect(subject).to be_a(Recipe)
        expect(subject.id).to eq(entry.id)
      end
    end
  end

  describe '#find_in_cache' do
    context 'given we have build an entry' do
      let(:entry) do
        OpenStruct.new(
          id: '1002',
          fields: {
            title: 'some title',
            photo: 'https://picsum.photos/200/300',
            tags: %w[meat cake],
            description: 'some description',
            chef: 'Monica Geller'
          }
        )
      end

      before { described_class.build_from_entry(entry, cache: true) }
      subject { described_class.find_in_cache(entry.id) }
      it %(
        should
        - find from cache
        - match found entry
      ) do
        expect(subject).not_to be_nil
        expect(subject.id).to eq(entry.id)
        expect(subject.title).to eq(entry.fields[:title])
      end
    end
  end
end
