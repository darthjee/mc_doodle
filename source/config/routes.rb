# frozen_string_literal: true

Rails.application.routes.draw do
  get '/' => 'home#show', as: :home

  resources :users, only: [:index] do
    collection do
      resources :login, only: [:create] do
        get '/' => :check, on: :collection
      end
      delete '/logoff' => 'login#logoff'
    end
  end

  resources :categories, only: :index, defaults: { format: :json }

  resources :moves, except: %i[delete] do
    resources :items, except: %i[delete]
  end
end
