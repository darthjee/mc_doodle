# frozen_string_literal: true

class CategoriesController < ApplicationController
  resource_for Move::Category,
               only: :index,
               paginated: true,
               per_page: Settings.pagination

end
