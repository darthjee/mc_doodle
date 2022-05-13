# frozen_string_literal: true

require 'spec_helper'

describe Move::Decorator do
  subject(:decorator) { described_class.new(object) }

  let(:attributes) { %w[id title] }
  let(:decorator_json) { JSON.parse(decorator.to_json) }

  describe '#to_json' do
    context 'when object is one entity' do
      let(:object) { create(:move) }

      let(:expected_json) do
        object
          .as_json
          .slice(*attributes)
      end

      it 'returns expected json' do
        expect(decorator_json).to eq(expected_json)
      end

      context 'when object is invalid but object has not been validated' do
        let(:object) do
          build(:move, title: 'a' * 500)
        end

        it 'returns expected json without errors' do
          expect(decorator_json).to eq(expected_json)
        end
      end

      context 'when object is invalid and object has been validated' do
        let(:object) do
          build(:move, title: 'a' * 500)
        end

        let(:expected_errors) do
          {
            title: ['is too long (maximum is 255 characters)']
          }
        end

        let(:expected_json) do
          object
            .as_json
            .slice(*attributes)
            .merge(errors: expected_errors)
            .deep_stringify_keys
        end

        before { object.valid? }

        it 'returns expected json with errors' do
          expect(decorator_json).to eq(expected_json)
        end
      end
    end

    context 'when object is a collection' do
      let(:object) { create_list(:move, 3) }

      let(:expected_json) do
        object.map do |move|
          {
            id: move.id,
            title: move.title
          }
        end.as_json
      end

      it 'returns expected json' do
        expect(decorator_json).to eq(expected_json)
      end

      context 'when object is a collection of invalid not validated objects' do
        let(:object) { build_list(:move, 3, title: 'a' * 500) }

        it 'returns expected json without errors' do
          expect(decorator_json).to eq(expected_json)
        end
      end

      context 'when object is a collection with invalid ivalidated objects' do
        before { object.each(&:valid?) }

        let(:expected_errors) do
          {
            title: ['is too long (maximum is 255 characters)']
          }
        end

        let(:object) { build_list(:move, 3, title: 'a' * 500) }

        let(:expected_json) do
          object.map do |move|
            {
              id: move.id,
              title: move.title,
              errors: expected_errors
            }
          end.as_json
        end

        it 'returns expected json' do
          expect(decorator_json).to eq(expected_json)
        end
      end
    end
  end
end
