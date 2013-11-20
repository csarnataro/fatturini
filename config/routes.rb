Fatturini::Application.routes.draw do

  resources :memos
  get "/m" => "memos#new"


  # oauth
  get "/signin" => "services#signin"
  delete "/signout" => "services#signout"

  get '/auth/:service/callback' => 'services#create' 
  get '/auth/failure' => 'services#failure'

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end


  get '/dashboard' => 'application#dashboard'

  # render json defaults in invoice creation
  resources :clients do
    member do
      get 'defaults', :action => :defaults
    end
  end

  # invoices by client
  get 'invoices/client/:client_id' => 'invoices#by_client', :as => 'invoice_by_client'

  get 'invoices/:id/archive/latest' => 'invoices#download_latest_file', :as => :invoice_history_latest_file

  get 'invoices/:id/archive/:file_id' => 'invoices#download_file', :as => 'invoice_history_file'
  delete 'invoices/:id/archive/:file_id' => 'invoices#delete_history_file' #, :as => 'invoice_history_file'



  resources :invoices do

    member do
      get 'print'
      # get 'archive', :action => :history
      get 'archive', :action => 'history', :as => 'history'
      
      # get 'register/:participant_type_id', :action => 'register'
    end

    resources :items
  end


  resources :footers do
    resources :footer_items
  end

  resources :companies

  resources :users

  


#  controller :users do
#    get "sign_up", :action => :sign_up, :as => :sign_up
#    post "sign_up", :action => :public_create, :as => :public_user_create
#  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

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
