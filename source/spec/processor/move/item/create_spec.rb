# frozen_string_literal: true

require 'spec_helper'

fdescribe Move::Item::Create do
  let(:items)     { move.items }
  let(:move)      { create(:move) }

  let!(:category) { create(:move_category) }

  describe '.process' do
    subject(:item) { described_class.process(parameters, items) }

    let(:parameters) { ActionController::Parameters.new(params) }

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

    it do
      expect(item).to be_a(Move::Item)
    end

    it do
      expect { item }
        .not_to change(Move::Category, :count)
    end

    it 'sets the correct category' do
      expect(item.category).to eq(category)
    end

    context 'when sending invalid parameters' do
      let(:other_move) { create(:move) }

      let(:params) do
        {
          name: 'some name',
          category_id: category.id,
          move_id: other_move.id
        }
      end

      it do
        expect { item }
          .to change { items.reload.count }
          .by(1)
      end

      it do
        expect { item }
          .not_to change { other_move.items.reload.count }
      end

      it do
        expect(item).to be_a(Move::Item)
      end

      it do
        expect { item }
          .not_to change(Move::Category, :count)
      end

      context 'when an existing category object is given' do
        let(:params) do
          {
            name: 'some name',
            category: {
              id: category.id,
              name: category.name
            }
          }
        end

        it do
          expect { item }
            .to change { items.reload.count }
            .by(1)
        end

        it do
          expect(item).to be_a(Move::Item)
        end

        it do
          expect { item }
            .not_to change(Move::Category, :count)
        end

        it 'sets the correct category' do
          expect(item.category).to eq(category)
        end
      end

      context 'when an existing category object is given without the id' do
        let(:params) do
          {
            name: 'some name',
            category: {
              name: category.name
            }
          }
        end

        it do
          expect { item }
            .to change { items.reload.count }
            .by(1)
        end

        it do
          expect(item).to be_a(Move::Item)
        end

        it do
          expect { item }
            .not_to change(Move::Category, :count)
        end

        it 'sets the correct category' do
          expect(item.category).to eq(category)
        end
      end

      context 'when a non existing category object is given' do
        let(:new_category_name) { 'some name' }

        let(:params) do
          {
            name: 'some name',
            category: {
              name: new_category_name
            }
          }
        end

        it do
          expect { item }
            .to change { items.reload.count }
            .by(1)
        end

        it do
          expect(item).to be_a(Move::Item)
        end

        it do
          expect { item }
            .to change(Move::Category, :count)
            .by(1)
        end

        it 'sets the correct category' do
          expect(item.category.name).to eq(new_category_name)
        end
      end
    end

    context 'when there is a validation error' do
      let(:params) do
        {
          name: 'some name',
        }
      end

      it do
        expect { item }
          .not_to change { items.reload.count }
      end

      it do
        expect(item).to be_a(Move::Item)
      end

      it do
        expect(item.errors).not_to be_empty
      end
    end
  end
end
