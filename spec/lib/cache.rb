require_relative '../spec_helper'

RSpec.describe Cache do
  describe '#fetch' do
    let(:cache) { Cache.new }

    context 'given we have no pre stored value' do
      let(:key) { 'recipe-123' }
      let(:value) do
        {
          id: '123',
          title: 'some title'
        }
      end
      subject { cache.fetch(key, value) }
      it 'should store missing key' do
        expect { subject }.to change { cache.get(key) }.from(nil).to(value.to_json)
      end
    end

    context "given there is a stored value" do
      let(:key) { 'recipe-345' }
      let(:value) do
        {
          id: '345',
          title: 'some title'
        }
      end
      let(:new_value) do
        {
          id: '345',
          title: 'updated title'
        }
      end
      before { cache.store(key, value) }
      subject { cache.fetch(key, new_value) }
      it %(
        should
        - return old value
        - not set a new value
      ) do
        expect { subject }.not_to change { cache.get(key) }
        expect(subject).to eq(value.to_json)
      end
    end
  end
end
