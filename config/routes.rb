Rails.application.routes.draw do
  devise_for :admins
  root 'support_tickets#index'

  resource :support_tickets, only: [:create] do
    get :index, on: :collection
  end
end

