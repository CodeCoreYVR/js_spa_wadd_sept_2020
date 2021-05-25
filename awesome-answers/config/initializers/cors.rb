# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'localhost:5500', '127.0.0.1:5500'
      resource(
          "/api/*", # This olnly allowed CORS requests to a path that looks like /api/ 
          headers: :any, # Allow requests to contain any headers
          credentials: true, #Allow us to send cookies through CORS requests
          methods: [:get, :post, :delete, :patch, :put, :options]
      )
    end
  end
  