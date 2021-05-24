class ContactController < ApplicationController
  def new
  end

  def create
    # We can pass values to a template using instance variables
    @name = params["name"]
    @message = params["message"]
  end
end
