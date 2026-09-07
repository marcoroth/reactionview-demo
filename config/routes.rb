Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#show"

  get "/chat", to: "chat#show"
  post "/chat/messages", to: "chat#create"
  patch "/chat/messages/:id", to: "chat#update"
  delete "/chat/messages/:id", to: "chat#destroy"
  post "/chat/refuse", to: "chat#refuse"

  get "/status", to: "status#show"
  get "/activity", to: "activity#show"
  get "/cascade", to: "cascade#show"
  get "/tooltips", to: "tooltips#show"
  get "/overlays", to: "overlays#show"
  get "/deferred", to: "deferred#show"
  get "/dashboard", to: "dashboard#show"
  get "/music", to: "music#show"
  get "/components", to: "components#show"
end
