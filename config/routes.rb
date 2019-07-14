Rails.application.routes.draw do

  namespace :api do
    namespace :v1, defaults: {format: :json} do
      resources :users, except: [:index]
      post 'login', to: 'auth#login'
    end
  end

end
