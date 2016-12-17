Rails.application.routes.draw do


  # ---
  # Feeds, properties and floorplans
  # ---


  resources :feed_sources, only: [:index, :show]
  resources :feed_xpaths, only: [:index]

  resources :properties
  resources :floorplans


  # ---
  # Root
  # ---


  root to: "static_pages#home"


  # ---
  # Developement
  # ---


  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
