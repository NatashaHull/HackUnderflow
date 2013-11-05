HackUnderflow::Application.routes.draw do
  resources :users, :except => [:index, :destroy]
  resource :session, :only => [:new, :create, :destroy]

  resources :questions do
    resources :answers, :only => [:create]
  end

  resources :answers, :only => [:edit, :update, :destroy]
end