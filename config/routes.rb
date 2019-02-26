# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :foreman_register do
    resources :hosts, only: [] do
      collection do
        get :register
      end
    end
  end
end
