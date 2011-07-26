ActionController::Routing::Routes.draw do |map|
  map.resources :notifications

  map.resources :personal_notifications

  map.resources :general_notifications

  map.resources :contacts

  map.resources :visits

  map.resources :individual_posts
  map.resources :accommodations
  map.resources :individual_post_preferred_countries
  map.resources :organisation_post_spoken_languages
  map.resources :user_spoken_languages
  map.resources :languages
  map.resources :organisation_posts
  #
  map.resources :invitations
  #

  map.resources :organisations

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  # attenzione: le seguenti sono necessarie, e devono stare PRIMA di 'map.resources :users'
  map.connect 'users/select_org',       :controller => 'users', :action => 'select_org'
  map.connect 'users/:id/edit_profile',     :controller => 'users', :action => 'edit_profile'
  map.connect 'users/:id/edit_preferences', :controller => 'users', :action => 'edit_preferences'
  map.connect 'users/:id/edit_notification_preferences', :controller => 'users', :action => 'edit_notification_preferences'
  map.connect 'users/:id/edit_permissions', :controller => 'users', :action => 'edit_permissions'

  map.resources :users
  # la seguente mi serve per mettere una chiamata nelle notification che porti ciascuno al suo profilo
  map.edit_profile("edit_profile",          :controller => "users", :action => 'edit_profile')
  map.edit_preferences("edit_preferences",  :controller => "users", :action => 'edit_preferences')
  map.edit_notification_preferences("edit_notification_preferences", :controller => "users", :action => 'edit_notification_preferences')
  map.edit_permissions("edit_permissions",  :controller => "users", :action => 'edit_permissions')

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  #
  map.root :controller => "login", :action => "welcome", :conditions => { :canvas => true }
  map.root :controller => "login", :action => "redirect_to_facebook_welcome", :conditions => { :canvas => false }
  #
  # the following to avoid errors when facebook search for http://changingroom.archenet.it/changingroom {:method=>:get, :canvas=>false}
  #  NO NON SI PUO FARE
  #map.matchmaker("matchmaker", :controller => "login", :action => "redirect_to_facebook_welcome", :conditions => { :canvas => false })

  # See how all your routes lay out with "rake routes"
  #
  # le seguenti sono da utilizzare per creare link personalizzati
  #map.nome_url_in_codice("url_breve_dopo_barra", :controller => "nome controller", :action => "nome azione")

  # la seguente... serve? SI (ed es. per edit_permissions)
  map.home("index", :controller => "main", :action => "index")
  # aggiunta da me dato ke senza il redirect pesca una pagina vuota
  #map.index("index", :controller => "main", :action => "index")
  #
#  map.iframe_users_map("iframe_users_map", :controller => "iframe", :action => "iframe_users_map", :conditions => { :canvas => false } )
#  map.iframe_user_map("iframe_user_map", :controller => "iframe", :action => "iframe_user_map", :conditions => { :canvas => false } )

  # questa e' OK
  map.search("search", :controller => "main", :action => "search", :conditions => { :canvas => true })
  #map.search("search", :controller => "main", :action => "search", :conditions => { :canvas => false })
  map.wanted("wanted", :controller => "main", :action => "wanted", :conditions => { :canvas => true })
  map.search_organisations("search_organisations", :controller => "main", :action => "search_organisations", :conditions => { :canvas => true })
  # voglio che /search/reset
  # vada a :controller => "main", :action => "search", e che assegni :option => 'reset'
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  #map.search 'search/:option', :controller => 'main', :action => 'search', :conditions => { :canvas => true }

  # This route can be invoked with purchase_url(:id => product.id)
  #map.search_list(':type/search_list', :controller => "main", :action => "search_list")

#  #map.search_full_list("search_full_list", :controller => "main", :action => "search_full_list")
#  map.wanted_list("wanted_list", :controller => "main", :action => "wanted_list")
#  map.wanted_full_list("wanted_full_list", :controller => "main", :action => "wanted_full_list")
#  map.wanted_map("wanted_map", :controller => "main", :action => "wanted_map")
#  # DA TOGLIERE
#  map.expertise_list("expertise_list", :controller => "main", :action => "expertise_list")
#  map.go_map("go_map", :controller => "main", :action => "go_map")
#  map.go_list("go_list", :controller => "main", :action => "go_list")
#  map.go_full_list("go_full_list", :controller => "main", :action => "go_full_list")
#  map.community("community", :controller => "main", :action => "community")
#  #
  map.settings("settings", :controller => "main", :action => "settings")
  map.my_notifications("my_notifications/:id", :controller => "main", :action => "my_notifications")

#  map.admin("admin", :controller => "admin", :action => "index")
#  map.message_board("message_board", :controller => "main", :action => "message_board")
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect 'iframe/:action',          :controller => 'iframe', :conditions => { :canvas => false }
  map.connect 'cron/:action',            :controller => 'cron',   :conditions => { :canvas => false }
  map.connect ':controller/:action/:id', :conditions => { :canvas => true }
  map.connect ':controller/:action/:id.:format', :conditions => { :canvas => true }

end
