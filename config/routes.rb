Grammable::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  root "grams#index"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'


  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
end
