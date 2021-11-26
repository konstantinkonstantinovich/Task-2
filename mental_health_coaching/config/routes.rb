Rails.application.routes.draw do
  get 'reset_password/new'
  get 'reset_password/create'
  get 'reset_password/edit'
  get 'reset_password/update'
  root "landing_page#index"

  # registration user controller
  get '/sign_up', to: 'registrations#new'
  post '/sign_up', to: 'registrations#create'
  get '/sign_up/verification', to: 'registrations#edit', as: 'send_mail'
  patch '/sign_up/verification', to: 'registrations#update'
  get '/sign_up/verification/resend/', to: 'registrations#resend', as: 'resend'

  # authorization user controller
  get '/sign_in', to: 'authorization#new'
  post '/sign_in', to: 'authorization#create'
  delete 'logout', to: 'authorization#destroy'

  # user contoller
  get '/user/:id', to: 'user#show', as: 'user_page'

  # reset password contoller
  get '/reset_password/new', to: 'reset_password#new'
  post '/reset_password/new', to: 'reset_password#create'
  get '/reset_password/edit', to: 'reset_password#edit'
  patch '/reset_password/edit', to: 'reset_password#update'
end
