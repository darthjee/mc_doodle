# frozen_string_literal: true

require 'spec_helper'

fdescribe CategoriesController, type: :controller do
  let(:expected_json) do
    Move::Category::Decorator.new(expected_object).to_json
  end

  describe 'GET index' do
    let(:categories_count) { 1 }
    let(:parameters) { {} }

    render_views

    before do
      create_list(:move_category, categories_count)
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { Move::Category.all }

      before do
        get :index, params: parameters.merge(format: :json)
      end

      it { expect(response).to be_successful }

      it 'returns categories serialized' do
        expect(response.body).to eq(expected_json)
      end

      it 'adds page header' do
        expect(response.headers['page']).to eq(1)
      end

      it 'adds pages header' do
        expect(response.headers['pages']).to eq(1)
      end

      it 'adds per_page header' do
        expect(response.headers['per_page']).to eq(Settings.pagination)
      end

      context 'when there are too many categories' do
        let(:categories_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { Move::Category.all.limit(Settings.pagination) }

        it { expect(response).to be_successful }

        it 'returns categories serialized' do
          expect(response.body).to eq(expected_json)
        end

        it 'adds page header' do
          expect(response.headers['page']).to eq(1)
        end

        it 'adds pages header' do
          expect(response.headers['pages']).to eq(3)
        end

        it 'adds per_page header' do
          expect(response.headers['per_page']).to eq(Settings.pagination)
        end
      end

      context 'when requesting last page' do
        let(:categories_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { Move::Category.all.offset(2 * Settings.pagination) }
        let(:parameters)      { { page: 3 } }

        it { expect(response).to be_successful }

        it 'returns categories serialized' do
          expect(response.body).to eq(expected_json)
        end

        it 'adds page header' do
          expect(response.headers['page']).to eq(3)
        end

        it 'adds pages header' do
          expect(response.headers['pages']).to eq(3)
        end

        it 'adds per_page header' do
          expect(response.headers['per_page']).to eq(Settings.pagination)
        end
      end
    end
  end
end
