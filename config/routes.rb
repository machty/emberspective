Emberspector::Application.routes.draw do
  resource :status_snapshot
  root :to => 'status_snapshots#show'
end

