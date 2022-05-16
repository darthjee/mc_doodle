# frozen_string_literal: true

class MovesController < ApplicationController
  resource_for :category,
               only: :index,
               paginated: true,
               per_page: Settings.pagination

end
