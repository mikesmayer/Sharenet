Rails.application.routes.draw do
  devise_for :admins, :skip => [:registrations]

  as :admin do
    get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
    get 'admins', :to => 'devise/registrations#edit'
  end

  as :categories do
    get   'categories' => 'categories#index',  :as => 'categories'
    get   'categories/all' => 'categories#all',   :as => 'all_categories'
    get   'categories/:id' => 'categories#index',  :as => 'category'
    post  'categories/subcategories/:id' => 'categories#subcategories',  :as => 'subcategories_json'
    post  'categories/subcategories' => 'categories#subcategories',  :as => 'all_categories_json'

    get   'categories/new/:parent_id' => 'categories#new', :as => 'new_category'
    post  'categories' => 'categories#create'

    get   'categories/:id/edit' => 'categories#edit', :as => 'edit_category'
    post  'categories/:id' => 'categories#update'

    post  'categories/:id/delete' => 'categories#delete', :as => 'delete_category'

    post  'categories/:id/status/:field' => 'categories#update_status', :as => 'update_category_status'
  end

  as :post_types do
    get   'post_types'                  => 'post_types#index',    :as => 'post_types'
    post  'post_types/all'              => 'post_types#json_all', :as => 'post_types_json'

    get   'post_types/new'              => 'post_types#new',      :as => 'new_post_type'
    post  'post_types'                  => 'post_types#create'

    get   'post_types/:id'              => 'post_types#edit',     :as => 'post_type'
    get   'post_types/:id/edit'         => 'post_types#edit',     :as => 'edit_post_type'
    post  'post_types/:id'              => 'post_types#update'
    post  'post_types/:id/status/:field'=> 'post_types#update_status', :as => 'update_post_type_status'
  end

  #devise_for :users
  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
