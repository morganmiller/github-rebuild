Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, "d963a08c56351ac128bb", "275e1e27773dfca01150ee9006d78f36a989fcf0"
end
