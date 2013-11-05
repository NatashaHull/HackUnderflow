HackUnderflow::Application.routes.draw do
  get "questions/index"

  get "questions/show"

  get "questions/new"

  get "questions/edit"

  resources :users, :except => [:index, :destroy]
  resource :session, :only => [:new, :create, :destroy]

  resources :questions
end
