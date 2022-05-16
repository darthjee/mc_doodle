# frozen_string_literal: true

require 'spec_helper'

fdescribe Move::Item::Create do
  let(:items)    { move.items }
  let(:move)     { create(:move) }
  let(:category) { create(:move_category) }

  describe '.process' do
    subject(:item) { described_class.process(params, items) }

    let(:params) do
      {
        name: 'some name',
        category_id: category.id
      }
    end

    it do
      expect { item }
        .to change { items.reload.count }
        .by(1)
    end

    it 'sets the correct category' do
      expect(item.category).to eq(category)
    end
  end
end
