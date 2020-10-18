# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview

namespace 'users' do
  post '/', to: 'users#create'
  post '/login', to: 'users#login'
end

namespace 'user' do
  get '/', to: 'users#show'
  put '/', to: 'users#update'
end

namespace 'profiles' do
  get '/:username', to: 'profiles#show'
  post '/:username/follow', to: 'profiles#follow'
  delete '/:username/follow', to: 'profiles#unfollow'
end

namespace 'articles' do
  get '/feed', to: 'articles#feed'

  get '/', to: 'articles#index'
  post '/', to: 'articles#create'
  get '/:slug', to: 'articles#show'
  put '/:slug', to: 'articles#update'
  delete '/:slug', to: 'articles#destroy'

  post '/:slug/comments', to: 'articles::comments#create'
  get '/:slug/comments', to: 'articles::comments#show'
  delete '/:slug/comments/:id', to: 'articles::comments#destroy'

  post '/:slug/favorite', to: 'articles::favorites#create'
  delete '/:slug/favorite', to: 'articles::favorites#destroy'
end

namespace 'tags' do
  get '/', to: 'tags#index'
end
