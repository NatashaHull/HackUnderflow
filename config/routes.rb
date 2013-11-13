HackUnderflow::Application.routes.draw do
  get "about" => "static_pages#about"

  resources :users, :except => [:destroy]
  resource :session, :only => [:new, :create, :destroy] do
    post 'guest'
  end

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
    put 'accept'
  end

  resources :edit_suggestions, :only => [:show] do
    put 'accept'
    delete 'reject'
  end

  root :to => 'static_pages#root'
end