Spree::Core::Engine.add_routes do
  devise_for :spree_user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' },
             :path_prefix => :user

  scope(:path_names => { :new => "criar", :edit => "editar" }) do
    resources :users, :only => [:edit, :update], path: "usuarios"
  end

  devise_scope :spree_user do
    get '/login' => 'user_sessions#new', :as => :login
    post '/login' => 'user_sessions#create', :as => :create_new_session
    get '/sair' => 'user_sessions#destroy', :as => :logout
    get '/criar-conta' => 'user_registrations#new', :as => :signup
    post '/criar-conta' => 'user_registrations#create', :as => :registration
    get '/senha/recuperar' => 'user_passwords#new', :as => :recover_password
    post '/senha/recuperar' => 'user_passwords#create', :as => :reset_password
    get '/senha/alterar' => 'user_passwords#edit', :as => :edit_password
    put '/senha/alterar' => 'user_passwords#update', :as => :update_password
  end

  get '/finalizar-pedido/registro' => 'checkout#registration', :as => :checkout_registration
  put '/finalizar-pedido/registro' => 'checkout#update_registration', :as => :update_checkout_registration

  resource :session do
    member do
      get :nav_bar
    end
  end

  scope(:path_names => { :new => "criar", :edit => "editar" }) do
    resource :account, :controller => 'users', path: "conta"
  end

  namespace :admin do
    devise_for :spree_user,
               :class_name => 'Spree::User',
               :controllers => { :sessions => 'spree/admin/user_sessions',
                                 :passwords => 'spree/admin/user_passwords' },
               :skip => [:unlocks, :omniauth_callbacks, :registrations],
               :path_names => { :sign_out => 'logout' },
               :path_prefix => :user
    devise_scope :spree_user do
      get '/falha-autorizacao', :to => 'user_sessions#authorization_failure', :as => :unauthorized
      get '/login' => 'user_sessions#new', :as => :login
      post '/login' => 'user_sessions#create', :as => :create_new_session
      get '/sair' => 'user_sessions#destroy', :as => :logout
    end

  end
end
