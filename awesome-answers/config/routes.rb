Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  post("/contact", { to: "contact#create" })
  get("/contact/new", { to: "contact#new" })

  # This defines a route definition that says when a GET request to "/" is made, handle it in the 
  # WelcomeController with the "index" (instance method) action inside the controller. The "as"
  # option names a helper url/path method. By default, Rails will automatically generate the helper
  # for you, but we can rename it using the "as" option. All similar HTTP verbs have an associated
  # method named after the verb.
  get("/", { to: "welcome#index", as: "root" })

  # Renders a form to create a new question
  # get("/questions/new", to: "questions#new", as: "new_question")

  # Create a question (submitting the new question form)
  # post("/questions", to: "questions#create")

  # Render a question show page
  # Helper method would use the id or instance as an argument
  # question_path(<id>) or question_path(instance)
  # get("/questions/:id", to: "questions#show", as: "question")

  # Render a list of all questions
  # get("/questions", to: "questions#index")

  # Render a form to edit an existing question
  # Helper method would use the id or instance as an argument
  # edit_question_path(<id>) or edit_question_path(instance)
  # get("/questions/:id/edit", to: "questions#edit", as: "edit_question")

  # Update a question in the database (submission of the edit form)
  # patch("/questions/:id", to: "questions#update")

  # Delete a question
  # delete("questions/:id", to: "questions#destroy")

  # The "resources" method will generate all the CRUD routes above
  # following RESTful conventions for a resource. It will assume that
  # there is a controller named after the first argument pluralized and
  # PascalCased e.g. (:questions => QuestionsController)
  resources :questions do 
    # Routes written inside of a block passed to the "resources" will
    # be prefixed by a path corresponding to the passed in symbol.
    # In this case, all routes will be prefixed with "questions/:question_id"
    # "only" creates the routes that we need and "except" will create 
    # all the routes with the exception of the routes in the array.
    
    # Passing shallow: true will remove the prefix if it doesn't need it:

    # The create action stays the same because we need the :question_id
    # when creating an answer 
    # POST /questions/:question_id/answers

    # The prefix is removed for :destroy because we only need the id of 
    # the answer we're destroying.
    # DELETE /questions/:question_id/answers/:id
    # becomes
    # DELETE answers/:id

    resources :answers, only: [:create, :destroy], shallow: true
    
    resources :likes, only: [:create, :destroy]
    # POST /questions/:question_id/likes
    # DELETE /likes/:id
  end

  resources :users, only: [:new, :create]

  # resource is singular if we perform CRUD actions on a single
  # thing and not a collection of resources. There's no index 
  # nor routes that have an :id wildcard. Even though the resource 
  # is singular, the controller is still plural. The url will look 
  # like this: 
  # GET /session/new
  # POST /session
  # DELETE /session
  resource :session, only: [:new, :create, :destroy]

  resources :job_posts

  # api/v1/questions
  # api/questions
  # The namespace method will use the controller found in a directory
  # called api and then in a nested directory for v1
  # 'defaults: {format: :json}' will set the default format to be JSON
  # in all routes contained within the block.
  # Use this command to test json format 'curl -H “Accept: application/json” http://localhost:3000/questions'


  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :questions
      resource :session, only: [:create, :destroy] 
      resources :users, only: [:create] do
        # get :current -> /api/v1/users/:user_id/current
        get :current, on: :collection # -> /api/v1/users/current
      end
    end
  end

end
