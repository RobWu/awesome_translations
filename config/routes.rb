AwesomeTranslations::Engine.routes.draw do
  resources :caches

  resources :handlers, only: [:index, :show] do
    resources :groups, only: [:show, :update]
  end

  root to: "handlers#index"
end
