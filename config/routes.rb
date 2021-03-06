Openfoodnetwork::Application.routes.draw do
  
  get "stadistics/index", to: "stadistics#index"
  post"stadistics/index", to: "stadistics#create_chart"
  post "stadistics/data", to: "stadistics#generate_stat"
  get "stadistics/index/:id_del", to: "stadistics#destroy"
  
  get "help", to: "help#index"
  get "help/introduction", to: "help#introduction"
  get "help/faq", to: "help#faq"
  get "help/contact", to: "help#contact"
  get "help/userguide", to: "help#userguide"
  get "help/userguide/hub", to: "help#userguide_hub"
  get "help/userguide/producer", to: "help#userguide_producer"
  
  get "help/userguide/hub/:name", to:"help#userguide_hub"
  get "help/userguide/producer/:name", to:"help#userguide_producer"
  
  
  # Download guides
  get "help/userguide/hub/hub-create-account/:file_name", to: "help#download"
  get "help/userguide/hub/hub/hub-create-or-connect-with-supplying-producers/:file_name", to: "help#download"
  get "help/userguide/hub/dashboard/:file_name", to: "help#download"
  get "help/userguide/hub/enterprise-fees/:file_name", to: "help#download"
  get "help/userguide/hub/order-cycles/:file_name", to: "help#download"
  get "help/userguide/hub/payment-methods/:file_name", to: "help#download"
  get "help/userguide/hub/products/:file_name", to: "help#download"
  get "help/userguide/hub/profile-type/:file_name", to: "help#download"
  get "help/userguide/hub/reports/:file_name", to: "help#download"
  get "help/userguide/hub/set-up-guide/:file_name", to: "help#download"
  get "help/userguide/hub/shipping-methods/:file_name", to: "help#download"
  get "help/userguide/hub/view-orders/:file_name", to: "help#download"
  get "help/userguide/hub/your-profile/:file_name", to: "help#download"
  
  get "help/userguide/producer/hub-create-account/:file_name", to: "help#download"
  get "help/userguide/producer/enterprise-fees/:file_name", to: "help#download"
  get "help/userguide/producer/order-cycles/:file_name", to: "help#download"
  get "help/userguide/producer/payment-methods/:file_name", to: "help#download"
  get "help/userguide/producer/products/:file_name", to: "help#download"
  get "help/userguide/producer/profile-type/:file_name", to: "help#download"
  get "help/userguide/producer/report/:file_name", to: "help#download"
  get "help/userguide/producer/shipping-methods/:file_name", to: "help#download"
  get "help/userguide/producer/view-orders/:file_name", to: "help#download"
  get "help/userguide/producer/profile/:file_name", to: "help#download"
  
  root :to => 'home#index'

  # Redirects from old URLs avoid server errors and helps search engines
  get "/enterprises", to: redirect("/")
  get "/products", to: redirect("/")
  get "/products/:id", to: redirect("/")
  get "/t/products/:id", to: redirect("/")
  get "/about_us", to: redirect(ContentConfig.footer_about_url)

  get "/#/login", to: "home#index", as: :spree_login
  get "/login", to: redirect("/#/login")

  get "/discourse/login", to: "discourse_sso#login"
  get "/discourse/sso", to: "discourse_sso#sso"

  get "/map", to: "map#index", as: :map
  get "/sell", to: "home#sell", as: :sell

  get "/register", to: "registration#index", as: :registration
  get "/register/auth", to: "registration#authenticate", as: :registration_auth

  # Redirects to global website
  get "/connect", to: redirect("https://openfoodnetwork.org/#{ENV['DEFAULT_COUNTRY_CODE'].andand.downcase}/connect/")
  get "/learn", to: redirect("https://openfoodnetwork.org/#{ENV['DEFAULT_COUNTRY_CODE'].andand.downcase}/learn/")
  
 # get "/stadistics", to: "stadistics#index"

  resource :shop, controller: "shop" do
    get :products
    post :order_cycle
    get :order_cycle
  end

  resources :producers, only: [:index] do
    collection do
      get :signup
    end
  end

  resources :shops, only: [:index] do
    collection do
      get :signup
    end
  end

  resources :groups, only: [:index, :show] do
    collection do
      get :signup
    end
  end

  get '/checkout', :to => 'checkout#edit' , :as => :checkout
  put '/checkout', :to => 'checkout#update' , :as => :update_checkout
  get '/checkout/paypal_payment/:order_id', to: 'checkout#paypal_payment', as: :paypal_payment

  resources :enterprises do
    collection do
      post :search
      get :check_permalink
    end

    member do
      get :shop
      get :relatives
    end
  end
  get '/:id/shop', to: 'enterprises#shop', as: 'enterprise_shop'
  get "/enterprises/:permalink", to: redirect("/") # Legacy enterprise URL

  devise_for :enterprise, controllers: { confirmations: 'enterprise_confirmations' }

  namespace :admin do
    resources :order_cycles do
      post :bulk_update, on: :collection, as: :bulk_update

      member do
        get :clone
        post :notify_producers
      end
    end
#------------------------------------------------------------
    #resources :stadistics do
     # get :index
    #end
#------------------------------------------------------------
    resources :enterprises do
      collection do
        get :for_order_cycle
        get :for_line_items
        post :bulk_update, as: :bulk_update
      end

      member do
        get :welcome
        put :register
      end

      resources :producer_properties do
        post :update_positions, on: :collection
      end

      resources :tag_rules, only: [:destroy]
    end

    resources :enterprise_relationships
    resources :enterprise_roles

    resources :enterprise_fees do
      collection do
        get :for_order_cycle
        post :bulk_update, :as => :bulk_update
      end
    end

    resources :enterprise_groups do
      get :move_up
      get :move_down
    end

    get '/inventory', to: 'variant_overrides#index'

    resources :variant_overrides do
      post :bulk_update, on: :collection
      post :bulk_reset, on: :collection
    end

    resources :inventory_items, only: [:create, :update]

    resources :customers, only: [:index, :create, :update, :destroy]

    resources :tag_rules, only: [], format: :json do
      get :map_by_tag, on: :collection
    end

    resource :content

    resource :accounts_and_billing_settings, only: [:edit, :update] do
      collection do
        get :show_methods
        get :start_job
      end
    end

    resource :business_model_configuration, only: [:edit, :update], controller: 'business_model_configuration'

    resource :cache_settings

    resource :account, only: [:show], controller: 'account'
    
    resources :column_preferences, only: [], format: :json do
      put :bulk_update, on: :collection
    end
  end

  namespace :api do
    resources :enterprises do
      post :update_image, on: :member
      get :managed, on: :collection
      get :accessible, on: :collection
    end
    resources :order_cycles do
      get :managed, on: :collection
      get :accessible, on: :collection
    end

    resource :status do
      get :job_queue
    end
  end

  namespace :open_food_network do
    resources :cart do
      post :add_variant
    end
  end

  # Mount Spree's routes
  mount Spree::Core::Engine, :at => '/'

end


# Overriding Devise routes to use our own controller
Spree::Core::Engine.routes.draw do
  get "stadistics/index"

  devise_for :spree_user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'user_registrations',
                               :passwords => 'user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' },
             :path_prefix => :user
end



Spree::Core::Engine.routes.prepend do
  match '/admin/reports/orders_and_distributors' => 'admin/reports#orders_and_distributors', :as => "orders_and_distributors_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/order_cycle_management' => 'admin/reports#order_cycle_management', :as => "order_cycle_management_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/packing' => 'admin/reports#packing', :as => "packing_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/group_buys' => 'admin/reports#group_buys', :as => "group_buys_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/bulk_coop' => 'admin/reports#bulk_coop', :as => "bulk_coop_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/payments' => 'admin/reports#payments', :as => "payments_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/orders_and_fulfillment' => 'admin/reports#orders_and_fulfillment', :as => "orders_and_fulfillment_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/users_and_enterprises' => 'admin/reports#users_and_enterprises', :as => "users_and_enterprises_admin_reports",  :via => [:get, :post]
  match '/admin/reports/sales_tax' => 'admin/reports#sales_tax', :as => "sales_tax_admin_reports",  :via  => [:get, :post]
  match '/admin/products/bulk_edit' => 'admin/products#bulk_edit', :as => "bulk_edit_admin_products"
  match '/admin/orders/bulk_management' => 'admin/orders#bulk_management', :as => "admin_bulk_order_management"
  match '/admin/reports/products_and_inventory' => 'admin/reports#products_and_inventory', :as => "products_and_inventory_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/customers' => 'admin/reports#customers', :as => "customers_admin_reports",  :via  => [:get, :post]
  match '/admin/reports/xero_invoices' => 'admin/reports#xero_invoices', :as => "xero_invoices_admin_reports",  :via  => [:get, :post]
  match '/admin', :to => 'admin/overview#index', :as => :admin
  match '/admin/payment_methods/show_provider_preferences' => 'admin/payment_methods#show_provider_preferences', :via => :get
  #
  #match '/stadistics', :to => 'stadistics/#index'

  namespace :api, :defaults => { :format => 'json' } do
    resources :users do
      get :authorise_api, on: :collection
    end

    resources :products do
      collection do
        get :managed
        get :bulk_products
        get :overridable
      end
      delete :soft_delete

      resources :variants do
        delete :soft_delete
      end
    end

    resources :orders do
      get :managed, on: :collection
    end
  end

  namespace :admin do
    get '/search/known_users' => "search#known_users", :as => :search_known_users

    resources :products do
      get :product_distributions, on: :member

      post :bulk_update, :on => :collection, :as => :bulk_update
    end

    resources :orders do
      get :invoice, on: :member
      get :print, on: :member
      get :managed, on: :collection
    end

    resources :line_items, only: [:index], format: :json
  end

  resources :orders do
    get :clear, :on => :collection
    get :order_cycle_expired, :on => :collection
  end

end
