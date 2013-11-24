GameOn::Application.routes.draw do
  root 'welcome#index'

# In case we want to get fancy
# %w( date station ).each do |how|
#   get "games/#{how}/:#{how}",  to: "games#for_#{how}",  defaults: { format: 'json' }
# end

  get 'games/date/:date',       to: 'games#for_date',     defaults: { format: 'json' }
  get 'games/station/:station', to: 'games#for_station',  defaults: { format: 'json' }

  get 'games/generate', to: 'games#generate'
end
