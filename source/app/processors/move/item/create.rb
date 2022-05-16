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
        items.create(attributes)
      end

      private

      attr_reader :params, :items

      def attributes
        params
          .permit(:name)
          .merge(category: category)
      end

      def category
        return Category.find(category_id)
      end

      def category_id
        params['category_id'] || params['category']['id']
      end
    end
  end
end
