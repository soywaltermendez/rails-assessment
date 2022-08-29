# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users

  # Comment out to use React
  root to: 'invoices#index'

  resources :invoices do
    member do
      get :qr
    end

    collection do
      get :import, to: 'invoices#import'
      post :import, to: 'invoices#upload'
    end
  end
  resources :people, only: :show
end
