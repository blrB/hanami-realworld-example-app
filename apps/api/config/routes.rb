# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview

namespace 'users' do
  post '/login', to: 'users#login'
  post '/', to: 'users#create'
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
  get '/', to: 'articles#index'
  get '/feed', to: 'articles#feed'
  get '/:slug', to: 'articles#show'
  post '/', to: 'articles#create'
  put '/:slug', to: 'articles#update'
  delete '/:slug', to: 'articles#destroy'
  post '/:slug/comments', to: 'articles#comments_create'
  get '/:slug/comments', to: 'articles#comments_show'
  delete '/:slug/comments/:id', to: 'articles#comments_destroy'
  post '/:slug/favorite', to: 'articles#make_favorite'
  delete '/:slug/favorite', to: 'articles#destroy_favorite'
end

namespace 'tags' do
  get '/', to: 'tags#index'
end
