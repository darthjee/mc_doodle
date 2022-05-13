# frozen_string_literal: true

require 'spec_helper'

describe MovesController, type: :controller do
  let!(:user) { create(:user) }

  let(:expected_json) do
    Move::Decorator.new(expected_object).to_json
  end

  describe 'GET new' do
    render_views

    context 'when requesting html and ajax is true', :cached do
      before do
        get :new, params: { format: :html, ajax: true }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('moves/new') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :new
      end

      it do
        expect(response).to redirect_to('#/moves/new')
      end
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { Move.new }

      before do
        get :new, params: { format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns moves serialized' do
        expect(response.body).to eq(expected_json)
      end
    end
  end

  describe 'GET index' do
    let(:moves_count) { 1 }
    let(:parameters) { {} }

    render_views

    before { create_list(:move, moves_count) }

    context 'when requesting json', :not_cached do
      let(:expected_object) { Move.all }

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
        let(:expected_object) { Move.limit(Settings.pagination) }

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
        let(:expected_object) { Move.offset(2 * Settings.pagination) }
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

  describe 'POST create' do
    context 'when requesting json format' do
      let(:move) { Move.last }

      let(:parameters) do
        { format: :json, move: payload }
      end

      let(:payload) do
        {
          title: 'my move'
        }
      end

      let(:expected_object) { move }

      it do
        post :create, params: parameters

        expect(response).to be_successful
      end

      it do
        expect { post :create, params: parameters }
          .to change(Move, :count)
          .by(1)
      end

      context 'when the request is completed' do
        before { post :create, params: parameters }

        let(:move) { Move.last }

        let(:move_attributes) do
          move.attributes.reject do |key, _|
            %w[id created_at updated_at].include? key
          end
        end

        let(:expected_move_attributes) do
          payload.stringify_keys
        end

        it 'returns created move' do
          expect(response.body).to eq(expected_json)
        end

        it 'creates a correct move' do
          expect(move_attributes)
            .to eq(expected_move_attributes)
        end
      end
    end
  end

  describe 'GET show' do
    render_views

    let(:move)    { create(:move) }
    let(:move_id) { move.id }

    context 'when requesting html and ajax is true', :cached do
      before do
        get :show, params: { format: :html, ajax: true, id: move_id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('moves/show') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :show, params: { id: move_id }
      end

      it do
        expect(response).to redirect_to("#/moves/#{move_id}")
      end
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { move }

      before do
        get :show, params: { id: move_id, format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns moves serialized' do
        expect(response.body).to eq(expected_json)
      end
    end
  end

  describe 'GET edit' do
    render_views

    let(:move)    { create(:move) }
    let(:move_id) { move.id }

    context 'when requesting html', :cached do
      before do
        get :edit, params: { format: :html, id: move_id }
      end

      it { expect(response).to redirect_to("#/moves/#{move_id}/edit.html") }
    end

    context 'when requesting html and ajax is true', :cached do
      before do
        get :edit, params: { format: :html, ajax: true, id: move_id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('moves/edit') }
    end
  end

  describe 'PATCH update' do
    context 'when requesting json format' do
      let(:move)    { create(:move) }
      let(:move_id) { move.id }
      let(:expected_json) do
        Move::Decorator.new(expected_object)
          .as_json.merge('offset' => -20.0).to_json
      end

      let(:parameters) do
        { format: :json, id: move_id, move: payload }
      end

      let(:payload) do
        {
          offset: -20
        }
      end

      let(:expected_object) { move }

      it 'does not updates the move' do
        expect { patch :update, params: parameters }
          .not_to(change { move.reload.offset })
      end

      it 'returns move with errors' do
        patch :update, params: parameters

        expect(response.body).to eq(expected_json)
      end
    end
  end
end
