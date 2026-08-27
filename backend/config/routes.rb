Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get :health, to: "health#show"

      resources :ebooks, only: %i[index show create destroy] do
        collection do
          get :search
        end

        member do
          get :download
        end
      end
    end
  end
end
