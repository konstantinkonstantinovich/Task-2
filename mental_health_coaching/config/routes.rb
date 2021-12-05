Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "landing_page#index"

  get '/auth/:provider/callback', to: 'authorization#omniauth'
  # registration user controller
  get '/sign_up', to: 'registrations#new'
  post '/sign_up', to: 'registrations#create'
  get '/sign_up/verification', to: 'registrations#edit'
  delete 'destroy', to: 'registrations#destroy', as: 'destroy'
  patch '/sign_up/verification', to: 'registrations#update'
  get '/sign_up/verification/resend/', to: 'registrations#resend', as: 'resend'

  # registration coach controller
  get '/become_coach', to: 'registration_coaches#new'
  post '/become_coach', to: 'registration_coaches#create'
  delete 'destroy_coach', to: 'registration_coaches#destroy', as: 'back_to_sign_up'
  get '/become_coach/update', to: 'registration_coaches#edit'
  patch '/become_coach/update', to: 'registration_coaches#update'


  # authorization user controller
  get '/sign_in', to: 'authorization#new'
  post '/sign_in', to: 'authorization#create'
  delete 'logout', to: 'authorization#destroy'

  # authorization coach controller
  get '/sign_in/coach', to: 'authorization_coach#new'
  post '/sign_in/coach', to: 'authorization_coach#create'
  delete 'logout_coach', to: 'authorization_coach#destroy', as: 'logout_coach'

  # user contoller
  get '/user/:id', to: 'user#dashboard', as: 'user_page'
  get '/user/:id/update', to: 'user#edit', as: 'update_profile_user'
  patch '/user/:id/update', to: 'user#update'
  get '/user/:id/password_change', to: 'user#password_edit', as: 'password_change_user'
  patch '/user/:id/password_change', to: 'user#password_update'
  get '/user/:id/dashboard', to: 'user#dashboard', as: 'user_dashboard_page'
  get '/user/:id/coaches', to: 'user#coaches_page', as: 'user_coahes_page'
  get '/user/:id/coaches/invitation/:coach_id', to: "user#new", as: 'invitation'
  post 'user/:id/coaches/invitation/:coach_id', to: "user#send_invintation"
  delete 'cancel/:invite_id', to: 'user#cancel_invite', as: 'cancel_coach_invite'
  delete 'end/:invite_id', to: 'user#end_cooperation', as: 'end_cooperation_coach_invite'
  get '/user/:id/dashboard/:technique_id/step/:step_id', to: 'user#user_technique_detail', as: 'user_technique_detail'
  patch '/user/:id/dashboard/:technique_id/step/:step_id', to: 'user#restart', as: 'restart'
  # coach contoller
  get '/coach/:id', to: 'coach#dashboard', as: 'coach_page'
  get '/coach/:id/update', to: 'coach#edit', as: 'update_profile_coach'
  patch '/coach/:id/update', to: 'coach#update'
  get '/coach/:id/password_change', to: 'coach#password_edit', as: 'password_change_coach'
  patch '/coach/:id/password_change', to: 'coach#password_update'
  get '/coach/:id/dashboard', to: 'coach#dashboard', as: 'coach_dashboard_page'
  get '/coach/:id/my_users', to: 'coach#coach_users', as: 'coach_users_page'
  get '/coach/:id/library', to: 'coach#library', as: 'coach_library_page'
  delete 'refuse/:invite_id', to: 'coach#refuse', as: 'refuse_user_invite'
  patch 'confirm/:invite_id', to: 'coach#confirm', as: 'confirm_user_invite'
  get '/coach/:id/library/:technique_id', to: 'coach#technique_detail', as: 'technique_detail_page'
  get '/coach/:id/library/:technique_id/recommendation', to: 'coach#new', as: 'recommend_to_users_page'
  post '/coach/:id/library/:technique_id/recommendation', to: 'coach#create'



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
