Sonicraph::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  get 'error' => 'error#index'
  post 'error' => 'error#index'
  post 'api/user/register' => 'user#register'
  get 'api/user/validate' => 'user#validate'
  get "api/user/check_is_token_valid" => 'user#check_is_token_valid'
  get 'api/user/login' => 'user#login'
  get 'api/authentication/get_token' => 'authentication#get_token'
  get 'api/user/followers' => 'user#followers'
  get 'api/user/followings' => 'user#followings'
  get 'api/user/follow' => 'user#follow'
  get 'api/user/unfollow' => 'user#unfollow'
  get 'api/user/search' => 'user#search'

  post 'api/sonic/create_sonic' => 'sonic#create_sonic'
  get 'api/sonic/like_sonic' => 'sonic#like_sonic'
  get 'api/sonic/dislike_sonic' => 'sonic#dislike_sonic'
  get 'api/sonic/get_sonics' => 'sonic#get_sonics'
  get 'api/sonic/delete_sonic' => 'sonic#delete_sonic'
  get 'api/sonic/likes' => 'sonic#likes'
  post 'api/sonic/write_comment' => 'sonic#write_comment'
  get 'api/sonic/comments' => 'sonic#comments'
  get 'api/sonic/resonic' => 'sonic#resonic'
  get 'api/sonic/resonics' => 'sonic#resonics'
  get 'api/sonic/delete_resonic' => 'sonic#delete_resonic'
  get 'api/sonic/delete_comment' => 'sonic#delete_comment'
  get 'api/sonic/search' => 'sonic#search'

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
