# frozen_string_literal: true

class Move < ApplicationRecord
  class Item < ApplicationRecord
    class Update
      def self.process(*args)
        new(*args).process
      end

      def initialize(params, item)
        @params = params
        @item  = item
      end

      def process
        item.update(attributes)
      end

      private

      attr_reader :params, :item

      def attributes
        params
          .permit(:name)
          .merge(category: category)
      end

      def category
        return Category.find(category_id) if category_id
        return item.category unless params['category'].present?
        return item.category unless params['category']['name']

        Category.find_or_initialize_by(
          name: params['category']['name']
        )
      end

      def category_id
        return params['category_id'] if params['category_id'].present?
        return params['category']['id'] if params['category'].present?

        nil
      end
    end
  end
end
