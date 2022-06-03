# frozen_string_literal: true

require 'spec_helper'

describe Move::Item::Update do
  let!(:item)      { create(:move_item) }
  let!(:category) { create(:move_category) }

  describe '.process' do
    subject(:update) { described_class.process(parameters, item) }

    let(:parameters) { ActionController::Parameters.new(params) }

    let(:new_name) { 'some new name' }

    context 'when only the name is changed' do
      let(:params) do
        {
          name: new_name
        }
      end

      it do
        expect { update }
          .not_to change(Move::Item, :count)
      end

      it 'updates the name' do
        expect { update }
          .to change { item.reload.name }
          .from(item.name)
          .to(new_name)
      end

      it 'does not change the category' do
        expect { update }
          .not_to change { item.reload.category }
      end
    end

    context 'when sending invalid parameters' do
      let(:other_move) { create(:move) }

      let(:params) do
        {
          name: new_name,
          category_id: category.id,
          move_id: other_move.id
        }
      end

      it 'updates the name' do
        expect { update }
          .to change { item.reload.name }
          .from(item.name)
          .to(new_name)
      end

      it 'updates the category' do
        expect { update }
          .to change { item.reload.category }
          .from(item.category)
          .to(category)
      end


      it do
        expect { item }
          .not_to(change { other_move.items.reload.count })
      end

      it do
        expect(item).to be_a(Move::Item)
      end

      it do
        expect { item }
          .not_to change(Move::Category, :count)
      end

      xcontext 'when an existing category object is given' do
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

      xcontext 'when an existing category object is given without the id' do
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

      xcontext 'when a non existing category object is given' do
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

    xcontext 'when there is a validation error' do
      let(:params) do
        {
          name: 'n' * 500,
          category: {
            name: 'some new category'
          }
        }
      end

      it do
        expect { item }
          .not_to(change { items.reload.count })
      end

      it do
        expect(item).to be_a(Move::Item)
      end

      it do
        expect { item }
          .not_to change(Move::Category, :count)
      end

      it do
        expect(item.errors).not_to be_empty
      end
    end

    xcontext 'when there is a validation error on category' do
      let(:params) do
        {
          name: 'some name'
        }
      end

      it do
        expect { item }
          .not_to(change { items.reload.count })
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
