Trunk::Application.routes.draw do
  
  resources :saved_properties

  root :to => "infos#index"
  
  match '/about' => 'infos#about'
  match '/auth/:provider/callback' =>'authentications#create'

  devise_for :users, :controllers => { :registrations => 'registrations'}

  devise_for :users, :controllers => { :registrations => "registrations" } do
    get "users/edit_password", :to => "registrations#edit_password", :as => "edit_password_user_registration"
    put "users/update", :to => "registrations#update_without_password", :as => "update_user_without_password"    
  end
  resources :authentications
  resources :user_infos, :path => 'account_info'
  resources :preferences
  resources :infos
  resources :property_photos
  resources :properties do
    resources :property_photos
  end

#  match 'properties/:property_id/property_photos/:id' => 'property_photos#show'
#  match 'properties/:property_id/property_photos/' => 'property_photos#index'
  
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
