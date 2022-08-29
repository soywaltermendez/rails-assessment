# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users

  # Comment out to use React
  root to: 'invoices#index'

  resources :invoices
  resources :people, only: :show
end
