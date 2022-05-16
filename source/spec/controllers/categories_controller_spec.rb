# frozen_string_literal: true

require 'spec_helper'

describe MovesController, :logged, type: :controller do
  let(:user) { logged_user }

  let(:expected_json) do
    Move::Decorator.new(expected_object).to_json
  end

  describe 'GET index' do
    let(:moves_count) { 1 }
    let(:parameters) { {} }

    render_views

    before do
      create_list(:move, moves_count, user: user)
      create_list(:move, moves_count)
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { user.moves }

      before do
        get :index, params: parameters.merge(format: :json)
      end

      it { expect(response).to be_successful }

      it 'returns moves serialized' do
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

      context 'when there are too many moves' do
        let(:moves_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { user.moves.limit(Settings.pagination) }

        it { expect(response).to be_successful }

        it 'returns moves serialized' do
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
        let(:moves_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { user.moves.offset(2 * Settings.pagination) }
        let(:parameters)      { { page: 3 } }

        it { expect(response).to be_successful }

        it 'returns moves serialized' do
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

    context 'when requesting html and ajax is true', :cached do
      before do
        get :index, params: { format: :html, ajax: true }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('moves/index') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :index
      end

      it { expect(response).to redirect_to('#/moves') }
    end
  end
end
