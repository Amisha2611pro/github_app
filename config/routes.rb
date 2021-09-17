Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions]
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      devise_for :users, controllers: { sessions: 'api/v1/sessions', registrations: 'api/v1/registrations' }
      resources :events
      resources :repositories
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
