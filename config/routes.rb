Rails.application.routes.draw do
  devise_for :admins
  root 'support_ticket#index' #for test

  resources :support_ticket do
  end

  namespace :admin do
    resources :support do
      collection do
        get :search
      end
      member do
        get :take_ownership
        get :show
      end
    end
  end


  get 'admins', to: 'admin/support#index', as: :admins  #for test

end

