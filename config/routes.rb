HackUnderflow::Application.routes.draw do
  resources :users, :except => [:index, :destroy]
  resource :session, :only => [:new, :create, :destroy]
end
