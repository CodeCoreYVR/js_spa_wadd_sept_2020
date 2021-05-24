class WelcomeController < ApplicationController
  # instance methods inside controllers are called actions
  # "index" is an "action"
  
  def index
    # Use the "render" method to render a template. By default, it looks in the 
    # app/views directory. There's no need to append the extension because Rails 
    # knows to use erb as our templating engine. 

    # The line below is not needed because by default Rails will render a template
    # inside the views directory. It will look for a directory named after the
    # controller (welcome), and renders a file that's named after the 
    # action name (index) e.g. views/<name-of-controller>/<action-name>.html.erb
    render "welcome/index"
  end
end
