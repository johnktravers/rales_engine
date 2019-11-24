Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find',                  to: 'search#show'
        get '/find_all',              to: 'search#index'
        get '/random',                to: 'random#show'
        get '/:id/items',             to: 'items#index'
        get '/:id/invoices',          to: 'invoices#index'
        get '/most_revenue',          to: 'revenue#index'
        get '/revenue',               to: 'revenue#show'
        get '/:id/favorite_customer', to: 'customers#show'
      end

      namespace :invoices do
        get '/find',              to: 'search#show'
        get '/find_all',          to: 'search#index'
        get '/random',            to: 'random#show'
        get '/:id/transactions',  to: 'transactions#index'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/items',         to: 'items#index'
        get '/:id/merchant',      to: 'merchants#show'
        get '/:id/customer',      to: 'customers#show'
      end

      namespace :invoice_items do
        get '/find',        to: 'search#show'
        get '/find_all',    to: 'search#index'
        get '/random',      to: 'random#show'
        get '/:id/item',    to: 'items#show'
        get '/:id/invoice', to: 'invoices#show'
      end

      namespace :items do
        get '/find',              to: 'search#show'
        get '/find_all',          to: 'search#index'
        get '/random',            to: 'random#show'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/merchant',      to: 'merchants#show'
        get '/most_revenue',      to: 'revenue#index'
        get '/:id/best_day',      to: 'dates#show'
      end

      namespace :transactions do
        get '/find',        to: 'search#show'
        get '/find_all',    to: 'search#index'
        get '/random',      to: 'random#show'
        get '/:id/invoice', to: 'invoices#show'
      end

      resources :merchants,     only: [:index, :show]
      resources :invoices,      only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :items,         only: [:index, :show]
      resources :transactions,  only: [:index, :show]
    end
  end

end
