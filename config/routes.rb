Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :marketplace_settings
    resources :shipments
    resources :suppliers
    resources :reports, only: [:index] do
      collection do
        get   :earnings
        post  :earnings
      end
    end

    resources :users do
      member do
        get :wallets
        put :wallets_actions
        put :addcard
      end
    end

    resources :questions, only: %i[index]
  end

  namespace :api, defaults: { format: :json } do
    resources :suppliers, only: :index
    resources :questions do
      resources :answers
    end
  end
end
