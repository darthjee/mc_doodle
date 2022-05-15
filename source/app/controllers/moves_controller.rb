# frozen_string_literal: true

class MovesController < ApplicationController
  include OnePageApplication
  include LoggedUser

  protect_from_forgery except: %i[create update]

  resource_for :move,
               except: :delete,
               paginated: true,
               per_page: Settings.pagination

  private

  def moves
    logged_user.moves
  end
end
