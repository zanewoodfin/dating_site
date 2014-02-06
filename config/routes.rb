DatingSite::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root to: 'static_pages#home'

  # polling
  get '/poll' => 'application#poll', defaults: { format: 'js' }

  # blocked_users
  resources :blocked_users

  # images
  get 'images_new' => 'image#new'
  post 'images' => 'images#create'

  # likes
  get 'likes' => 'likes#index'
  post 'likes(.:format)' => 'likes#create', defaults: { format: 'js' }
  delete 'likes/:id' => 'likes#destroy', as: 'like', defaults: { format: 'js' }

  # messages
  post 'messages/mass_destroy' => 'messages#mass_destroy'
  get 'messages/poll' => 'messages#poll', defaults: { format: 'js' }
  resources :messages

  # users
  resources :users do
    # pics
    resources :pics
  end

end
