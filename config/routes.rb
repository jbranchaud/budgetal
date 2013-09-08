Budgets::Application.routes.draw do
  root :to => 'welcome#index'
  get "/monthly-statistics" => "monthly_statistics#index", as: 'monthly_statistics' 
  get "monthly-statistics/:year(/:month)" => "monthly_statistics#show", as: 'monthly_statistic'

  resources :budgets
  resources :budget_categories
  resources :budget_items
  resources :budget_item_expenses
  resources :sessions
  resources :users, path: 'sign-up'

  get '/edit-my-account' => 'users#edit', as: 'edit_user'
  get '/admin' => 'users#index', as: 'admin'
  match 'sign-up' => 'users#new', as: 'sign_up'
  match '/my-budgets/:year/:month' => 'home#index', as: 'my_budgets'  
  resources :home, path: 'my-budgets'
  
  get '/contact' => 'welcome#contact', as: "contact"
  get "/tos" => 'welcome#tos', as: "tos"
  get "/about" => 'welcome#about', as: "about"

  get 'sign-out' => 'sessions#destroy', :as => 'logout'
  get 'sign-in' => 'sessions#create', :as => 'login'
  get 'my-account' => 'users#my_account', :as => 'my_account'
  
  resources :password_resets, path: 'password-resets'
  get "/send-password-reset" => "password_resets#new", :as => "new_password_reset"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
