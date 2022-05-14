# frozen_string_literal: true

require 'spec_helper'

describe Session::Decorator do
  subject(:decorator) { described_class.new(object) }

  let(:object)   { session }
  let!(:session) { create(:session) }
  let(:user)     { session.user }

  describe '#as_json' do
    let(:expected_json) do
      {
        id: user.id,
        name: user.name,
        login: user.login,
        email: user.email,
        token: session.token
      }.stringify_keys
    end

    it 'returns meta data defined json' do
      expect(decorator.as_json).to eq(expected_json)
    end

    context 'when object is an collecton' do
      let(:object) { Session.all }

      let(:expected_json) do
        [
          {
            id: user.id,
            name: user.name,
            login: user.login,
            email: user.email,
            token: session.token
          }
        ].map(&:stringify_keys)
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end
  end
end
