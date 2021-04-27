Rails.application.routes.draw do
  devise_for :users,
              path: '',
              path_names: { registration: 'signup' },
              controllers: { registrations: 'registrations' }
  namespace :api do
    post :auth, to: 'authentication#create'
    get  '/auth' => 'authentication#fetch'
    resources :notes, except: [:new, :edit], param: :slug
  end
end
