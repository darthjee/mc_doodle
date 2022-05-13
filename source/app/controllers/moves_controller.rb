# frozen_string_literal: true

class MovesController < ApplicationController
  include OnePageApplication

  protect_from_forgery except: %i[create]

  resource_for :move,
    except: :delete,
    paginated: true,
    per_page: Settings.pagination

  private

  def moves
    user.moves
  end

  def user
    User.last
  end
end
