Rails.application.routes.draw do


  # ---
  # Feeds, properties and floorplans
  # ---


  resources :feed_sources, only: [:index, :show]
  resources :feed_xpaths, only: [:index]

  get "property_xpaths/autocomplete" => "property_xpaths#autocomplete"
  resources :properties
  resources :property_xpaths, only: [:index]

  resources :floorplans


  # ---
  # Pages
  # ---


  get "github_search" => "static_pages#github_search"


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
