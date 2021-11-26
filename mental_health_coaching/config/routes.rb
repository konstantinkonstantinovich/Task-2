Rails.application.routes.draw do
  root "landing_page#index"
  get '/sign_up', to: 'registrations#new'
  post '/sign_up', to: 'registrations#create'
  get '/sign_up/varify', to: 'registrations#edit', as: 'send_mail'
  patch '/sign_up/varify', to: 'registrations#update'
end
