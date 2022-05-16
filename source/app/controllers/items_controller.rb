# frozen_string_literal: true

class ItemsController < ApplicationController
  include OnePageApplication
  include LoggedUser

  protect_from_forgery except: %i[create update]

  resource_for Move::Item,
               except: :delete,
               paginated: true,
               per_page: Settings.pagination,
               build_with: :build_item

  private

  def build_item
    Move::Item::Create.process(
      item_params, items
    )
  end

  def moves
    logged_user.moves
  end

  def move
    moves.find(move_id)
  end

  def items
    move.items
  end

  def move_id
    params.require(:move_id)
  end
end
