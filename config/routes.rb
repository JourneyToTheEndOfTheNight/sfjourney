Sfjourney::Application.routes.draw do
  get "donations/donate"
  get "donations/donated"
  get "donations/cancelled"
  get "/donate" => "donations#donate"
  get "/donated" => "donations#donated"
  get "/canceled_donation" => "donations#canceled"

  get "/graph" => "registrations#graph"

  get "registrations/full" => 'registrations#full'
  resources :registrations, :only => [:index, :create, :destroy, :show, :new, :edit]

  get "tos" => 'tos#show'
  get "privacy" => 'privacy#show'
  get "export" => 'registrations#export'
  get "waiver" => 'registrations#blank_waiver'

  # Omniauth pure
  match "/signin" => "services#signin", via: [:get, :post]
  match "/signout" => "services#signout", via: [:get, :post]

  match '/auth/:service/callback' => 'services#create', via: [:get, :post]
  match '/auth/failure' => 'services#failure', via: [:get, :post]

  match '/r/:game_id/:registration_token' => 'registrations#verify', via: [:get, :post]

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  if Rails.env == 'production'
#    root "registrations#landing"
    root "donations#donate"
  else
    root "registrations#landing"
  end
end
