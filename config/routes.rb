Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "signup", to: "users#signup"
  post "signin", to: "users#signin"
  post "logout", to: "users#logout"
  get "profile", to: "users#profile"
  post "profiles", to: "users#profiles"

  post "follow", to: "follows#follow"
  post "unfollow", to: "follows#unfollow"

  post "post/create", to: "posts#create"
  get "post/latest", to: "posts#get_all_posts"
  put "post/edit", to: "posts#edit"
  delete 'post/delete', to: 'posts#delete'
  get "post/search/author", to: "posts#search_by_author"
end
