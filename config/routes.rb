HackUnderflow::Application.routes.draw do
  get "edit_suggestions/show"

  resources :users, :except => [:index, :destroy]
  resource :session, :only => [:new, :create, :destroy]

  resources :questions, :except => [:show] do
    post 'upvote' => 'votes#up'
    post 'downvote' => 'votes#down'
    resources :answers, :only => [:create]
    resources :comments, :only => [:new, :create]
  end

  resources :questions, :only => [:show]

  resources :answers, :only => [:edit, :update, :destroy] do
    resources :comments, :only => [:new, :create]
    post 'upvote' => 'votes#up'
    post 'downvote' => 'votes#down'
  end
end