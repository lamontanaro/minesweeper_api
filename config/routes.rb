Rails.application.routes.draw do

  resource :game, only: [:create, :update]

end
