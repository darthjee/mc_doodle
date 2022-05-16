# frozen_string_literal: true

require 'spec_helper'

describe ItemsController, :logged, type: :controller do
  let(:user) { logged_user }
  let(:move) { create(:move, user: user) }

  let(:expected_json) do
    Move::Item::Decorator.new(expected_object).to_json
  end

  describe 'GET new' do
    render_views

    context 'when requesting html and ajax is true', :cached do
      before do
        get :new, params: { format: :html, ajax: true, move_id: move.id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('items/new') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :new, params: { move_id: move.id }
      end

      it do
        expect(response)
          .to redirect_to("#/moves/#{move.id}/items/new")
      end
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { move.items.build }

      before do
        get :new, params: { format: :json, move_id: move.id }
      end

      it { expect(response).to be_successful }

      it 'returns items serialized' do
        expect(response.body).to eq(expected_json)
      end
    end
  end

  describe 'GET index' do
    let(:items_count) { 1 }
    let(:parameters) { { move_id: move.id } }

    render_views

    before do
      create_list(:move_item, items_count, move: move)
      create_list(:move_item, items_count)
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { move.items }

      before do
        get :index, params: parameters.merge(format: :json)
      end

      it { expect(response).to be_successful }

      it 'returns items serialized' do
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

      context 'when there are too many items' do
        let(:items_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { move.items.limit(Settings.pagination) }

        it { expect(response).to be_successful }

        it 'returns items serialized' do
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
        let(:items_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { move.items.offset(2 * Settings.pagination) }
        let(:parameters)      { { page: 3, move_id: move.id } }

        it { expect(response).to be_successful }

        it 'returns items serialized' do
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
        get :index, params: { format: :html, ajax: true, move_id: move.id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('items/index') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :index, params: { move_id: move.id }
      end

      it { expect(response).to redirect_to("#/moves/#{move.id}/items") }
    end
  end

  describe 'POST create' do
    context 'when requesting json format' do
      let(:item)     { move.items.reload.last }
      let(:category) { create(:move_category) }

      let(:parameters) do
        { format: :json, item: payload, move_id: move.id }
      end

      let(:payload) do
        {
          name: 'my item',
          category_id: category.id
        }
      end

      let(:expected_object) { item }

      it do
        post :create, params: parameters

        expect(response).to be_successful
      end

      it do
        expect { post :create, params: parameters }
          .to change(Move::Item, :count)
          .by(1)
      end

      context 'when the request is completed' do
        before { post :create, params: parameters }

        let(:item) { Move::Item.last }

        let(:item_attributes) do
          item.attributes.reject do |key, _|
            %w[id created_at updated_at].include? key
          end
        end

        let(:expected_item_attributes) do
          payload.merge(move_id: move.id).stringify_keys
        end

        it 'returns created item' do
          expect(response.body).to eq(expected_json)
        end

        it 'creates a correct item' do
          expect(item_attributes)
            .to eq(expected_item_attributes)
        end
      end
    end
  end

  describe 'GET show' do
    render_views

    let(:item)    { create(:move_item, move: move) }
    let(:item_id) { item.id }

    context 'when requesting html and ajax is true', :cached do
      before do
        get :show, params: { format: :html, ajax: true, id: item_id, move_id: move.id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('items/show') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :show, params: { id: item_id, move_id: move.id }
      end

      it do
        expect(response).to redirect_to("#/moves/#{move.id}/items/#{item_id}")
      end
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { item }

      before do
        get :show, params: { id: item_id, format: :json, move_id: move.id }
      end

      it { expect(response).to be_successful }

      it 'returns itemss serialized' do
        expect(response.body).to eq(expected_json)
      end
    end
  end

  describe 'GET edit' do
    render_views

    let(:item)    { create(:move_item, move: move) }
    let(:item_id) { item.id }

    context 'when requesting html', :cached do
      before do
        get :edit, params: { format: :html, id: item_id, move_id: move.id }
      end

      it do
        expect(response)
          .to redirect_to("#/moves/#{move.id}/items/#{item_id}/edit.html")
      end
    end

    context 'when requesting html and ajax is true', :cached do
      before do
        get :edit, params: { format: :html, ajax: true, id: item_id, move_id: move.id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('items/edit') }
    end
  end

  describe 'PATCH update' do
    context 'when requesting json format' do
      let(:item)    { create(:move_item, move: move) }
      let(:item_id) { item.id }
      let(:expected_json) do
        Move::Item::Decorator.new(expected_object.reload).to_json
      end

      let(:parameters) do
        { format: :json, id: item_id, item: payload, move_id: move.id }
      end

      let(:payload) do
        {
          name: 'new item'
        }
      end

      let(:expected_object) { item }

      it 'updates the item' do
        expect { patch :update, params: parameters }
          .to(change { item.reload.name })
      end

      it 'returns item with errors' do
        patch :update, params: parameters

        expect(response.body).to eq(expected_json)
      end
    end
  end
end
