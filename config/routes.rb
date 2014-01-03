Sfjourney::Application.routes.draw do
  get "donations/donate"
  get "donations/donated"
  get "donations/cancelled"
  get "/donate" => "donations#donate"
  get "/donated" => "donations#donated"
  get "/canceled_donation" => "donations#canceled"

  get "registrations/full" => 'registrations#full'
  resources :registrations, :only => [:index, :create, :destroy, :show, :new]

  get "tos" => 'tos#show'
  get "privacy" => 'privacy#show'
  get "export" => 'registrations#export'
  get "waiver" => 'registrations#blank_waiver'

  # Omniauth pure
  match "/signin" => "services#signin", via: [:get, :post]
  match "/signout" => "services#signout", via: [:get, :post]

  match '/auth/:service/callback' => 'services#create', via: [:get, :post]
  match '/auth/failure' => 'services#failure', via: [:get, :post]

  match '/r/:id' => 'registrations#verify', via: [:get, :post]

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  #root "registrations#landing"
  root "donations#donate"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
