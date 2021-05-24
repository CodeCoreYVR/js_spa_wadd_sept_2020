class JobPostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def new
    @job_post = JobPost.new
  end

  def create
    job_post_params = params.require(:job_post).permit(
      :title,
      :description,
      :location,
      :min_salary,
      :max_salary,
    )

    @job_post = JobPost.new job_post_params
    @job_post.user = current_user

    if @job_post.save
      redirect_to job_post_path(@job_post)
    else
      render :new 
    end
  end

  def show
    @job_post = JobPost.find(params[:id])
  end

  def index
  end

  def destroy
    job_post = JobPost.find(params[:id]) 

    if can?(:destroy, job_post)
      job_post.destroy
      flash[:danger] = "#{job_post.title} deleted"
      redirect_to job_posts_path
    else
      flash[:danger] = "Access Denied"
      redirect_to job_post_path(job_post)
    end
  end
end
