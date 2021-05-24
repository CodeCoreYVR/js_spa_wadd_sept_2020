# frozen_string_literal: true
# Generate this file using:
# rails g cancan:ability

class Ability
  include CanCan::Ability

  # cancancan assumes that you have a method called "current_user" in our
  # ApplicationController. It gets initialized with "current_user" passed
  # to the "initialize"  method.

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
  
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end

    # Here we define a rule about who is able to "edit" a question. We are checking
    # if the current_user's id is the same as the user_id of the question that 
    # we're allowing to edit. To enforce this rule, we'd use the "can?" method 
    # inside of our controllers and views.
    # can :edit, Question, user_id: user.id

    alias_action :create, :read, :update, :destroy, to: :crud

    can :crud, Question, user_id: user.id

    can :crud, Answer do |answer|
      # answer is the instance that we're checking
      # If the current_user is the author of either the answer or the question that 
      # the answer is associated to, we'll allow cruding the answer
      answer.user == user || answer.question.user == user
    end

    can :crud, JobPost do |job_post|
      user == job_post.user
    end

    can :like, Question do |question|
      # This unsures that you cannot like your own question
      user.persisted? && question.user != user

      # If the current_user is not logged in we set "user" to
      # be a new user (guest) from line 15:
      # user ||= User.new # (guest user) not logged in
      # If "user" is a guest user, then"
      # question.user != user
      # will also be true. Therefore we'll also check if the user
      # is in the database as well (logged in) because we don't 
      # guests to be able to like.
    end

    can :destroy, Like do |like|
      like.user == user
    end

    if user.is_admin?
      # :manage means they can do everything (not just CRUD)
      # :all means all resources or classes
      can :manage, :all 
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
