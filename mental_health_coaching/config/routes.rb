Rails.application.routes.draw do

  root "landing_page#index"

  # registration user controller
  get '/sign_up', to: 'registrations#new'
  post '/sign_up', to: 'registrations#create'
  get '/sign_up/verification', to: 'registrations#edit', as: 'send_mail'
  delete 'destroy', to: 'registrations#destroy', as: 'destroy'
  patch '/sign_up/verification', to: 'registrations#update'
  get '/sign_up/verification/resend/', to: 'registrations#resend', as: 'resend'

  # registration coach controller
  get '/become_coach', to: 'registration_coaches#new'
  post '/become_coach', to: 'registration_coaches#create'


  # authorization user controller
  get '/sign_in', to: 'authorization#new'
  post '/sign_in', to: 'authorization#create'
  delete 'logout', to: 'authorization#destroy'

  # authorization coach controller
  get '/sign_in/coach', to: 'authorization_coach#new'
  post '/sign_in/coach', to: 'authorization_coach#create'
  delete 'logout', to: 'authorization_coach#destroy', as: 'logout_coach'

  # user contoller
  get '/user/:id', to: 'user#show', as: 'user_page'
  get '/coach/:id', to: 'coach#show', as: 'coach_page'

  # reset password contoller
  get '/reset_password/new', to: 'reset_password#new'
  post '/reset_password/new', to: 'reset_password#create'
  get '/reset_password/edit', to: 'reset_password#edit'
  patch '/reset_password/edit', to: 'reset_password#update'

  # reset password coach controller
  get '/reset_password_coach/new', to: "reset_password_coach#new"
  post '/reset_password_coach/new', to: "reset_password_coach#create"
  get '/reset_password_coach/edit', to: "reset_password_coach#edit"
  patch '/reset_password_coach/edit', to: "reset_password_coach#update"
end
