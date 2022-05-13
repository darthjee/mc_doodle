# frozen_string_literal: true

class DevicesController < ApplicationController
  include OnePageApplication

  protect_from_forgery except: %i[create]

  resource_for :move,
    except: :delete,
    paginated: true,
    per_page: Settings.pagination
end
