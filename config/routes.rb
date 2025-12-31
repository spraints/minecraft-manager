Rails.application.routes.draw do
  root to: "configurations#index"
  resources :configurations do
    member do
      put "queued" => "configurations#queue"
    end
  end
  resources :minecraft_worlds, path: "worlds" do
    member do
      put "archived" => "minecraft_worlds#archive"
    end
  end

  # Rails's authentication routes.
  resource :session
  resources :passwords, param: :token

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
