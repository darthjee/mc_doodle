# frozen_string_literal: true

class Move < ApplicationRecord
  class Item < ApplicationRecord
    class Create
      def self.process(*args)
        new(*args).process
      end

      def initialize(params, items)
        @params = params
        @items  = items
      end

      def process
        items.create(params)
      end

      private

      attr_reader :params, :items
    end
  end
end
