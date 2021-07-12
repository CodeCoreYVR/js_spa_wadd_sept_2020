Rails.application.config.middleware.use  OmniAuth::Builder do
    # To get a GITHUB_CLIENT_ID and a GITHUB_CLIENT_SECRET, you must create
    # a Github Developer Application. You can to this in
    # Settings > Developer Settings > OAuth Apps > New OAuth App.
    # This is the same process you will have to do with nearly every provider.
    provider  :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'] , scope:  "read:user, user:email"
end
 