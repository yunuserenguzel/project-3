Sonicraph::Application.routes.draw do
  get "user_controller/new_password"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  get 'sonic' => 'sonic#index'

  get "about/company"
  get "about/terms"
  get "about/privacy"
  get "about/contact"
  get "about/team"
  get 'about' => 'about#company'
  get 'legal' => 'about#terms'
  get 'terms' => 'about#terms'

  get 'new_password' => 'user#new_password'
  post 'set_new_password' => 'user#set_new_password'

  get '/' => redirect('/home')
  post '/' => redirect('/home')
  #post '/' => 'application#index'

  post 'email' => 'email#save_email'
  get 'email/list/741285' => 'email#list'

  namespace 'api' do
    post 'user/register' => 'user#register'
    get 'user/validate' => 'user#validate'
    get "user/check_is_token_valid" => 'user#check_is_token_valid'
    get 'user/login' => 'user#login'
    get 'authentication/get_token' => 'authentication#get_token'
    get 'user/followers' => 'user#followers'
    get 'user/followings' => 'user#followings'
    get 'user/follow' => 'user#follow'
    get 'user/unfollow' => 'user#unfollow'
    get 'user/search' => 'user#search'
    post 'user/edit' => 'user#edit'
    post 'user/register_device_token' => 'user#register_device_token'
    get 'user/destroy_authentication' => 'user#destroy_authentication'
    get 'user/reset_password'

    post 'sonic/create_sonic' => 'sonic#create_sonic'
    get 'sonic/like_sonic' => 'sonic#like_sonic'
    get 'sonic/dislike_sonic' => 'sonic#dislike_sonic'
    get 'sonic/get_sonics' => 'sonic#get_sonics'
    get 'sonic/delete_sonic' => 'sonic#delete_sonic'
    get 'sonic/likes' => 'sonic#likes'
    post 'sonic/write_comment' => 'sonic#write_comment'
    get 'sonic/comments' => 'sonic#comments'
    get 'sonic/resonic' => 'sonic#resonic'
    get 'sonic/resonics' => 'sonic#resonics'
    get 'sonic/delete_resonic' => 'sonic#delete_resonic'
    get 'sonic/delete_comment' => 'sonic#delete_comment'
    get 'sonic/search' => 'sonic#search'
    get 'sonic/get_sonic' => 'sonic#get_sonic'

    get 'noitifications/get_last_notifications' => 'notification#get_last_notifications'
    post 'noitifications/mark_as_read' => 'notification#mark_as_read'

    get 'error' => 'error#index'
    post 'error' => 'error#index'
  end


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
