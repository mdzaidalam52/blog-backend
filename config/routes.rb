Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "signup", to: "users#signup"
  post "signin", to: "users#signin"
  post "logout", to: "users#logout"
  get "profile", to: "users#profile"
  post "profiles", to: "users#profiles"
end
