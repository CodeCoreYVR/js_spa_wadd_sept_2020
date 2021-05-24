require 'rails_helper'

RSpec.describe JobPostsController, type: :controller do
  def current_user
    @current_user ||= FactoryBot.create(:user)
  end
  describe("#new") do
    context("without a signed in user") do 
      it("redirects the user to the sign in page") do
        get(:new)
  
        expect(response).to(redirect_to(new_session_path))
      end

      it("sets a danger flash message") do
        get(:new)

        expect(flash[:danger]).to(be)
      end
    end
    context("with signed in user") do
      # Use "before" to run a block of code before all tests inside of this context. 
      before do
        session[:user_id] = current_user.id
      end
      it("renders a new template") do
        # GIVEN
        # defaults
  
        # WHEN
        # Make GET request to the new action
        # When testing controllers, use methods named after HTTP verbs (e.g. get, post,
        # patch, put, delete) to simulate HTTP requests to your controller actions.
        get(:new)
  
        # THEN
        # The "response" object is available inside any controller test and it also has
        # the rendered template. We also have "flash" and "session" objects available to test.
  
        # We expect the response to render "new.html.erb". For this we'll use a method
        # called "render_template" which comes with a gem: "rails-controller-testing"
        expect(response).to(render_template(:new))
      end
  
      it("sets an instance variable of a new job post") do
        get(:new)
  
        # assigns(:job_post) returns the value of the instance variable named
        # after the symbol argument (e.g. :job_post -> @job_post)
        # Only available with the gem "rails-controller-testing"
  
        # This will verify that the expected value is a new instance
        # of the JobPost model
        expect(assigns(:job_post)).to(be_a_new(JobPost))
      end
    end
  end

  describe("#create") do
    def valid_request
      post(:create, params: { job_post: FactoryBot.attributes_for(:job_post) })
    end
    context("without a signed in user") do
      it("redirects the user to the sign in page") do
        valid_request
        expect(response).to(redirect_to(new_session_path))
      end

      it("sets a danger flash message") do
        valid_request
        expect(flash[:danger]).to(be)
      end
    end
    context("with signed in user") do
      before do
        session[:user_id] = current_user.id
      end
      context("with valid parameters") do
        it("creates a new job post") do
          # GIVEN
          count_before = JobPost.count 
  
          # WHEN
          # Returns a plain hash of the parameters required to create a JobPost
          # This hash simulates the body of a form, which is nested under params[:job_post]
          valid_request
  
          # THEN
          count_after = JobPost.count
          expect(count_after).to(eq(count_before + 1))
        end
  
        it("redirects to the show page of that job post") do
          valid_request
          
          job_post = JobPost.last
          
          expect(response).to(redirect_to(job_post_path(job_post)))
        end
      end
  
      context("with invalid parameters") do
        def invalid_request
          post(:create, params: { job_post: FactoryBot.attributes_for(:job_post, title: nil )})
        end
  
        it("doesn't create a new job post") do
          count_before = JobPost.count
  
          invalid_request
  
          count_after = JobPost.count
          expect(count_after).to(eq(count_before))
        end
  
        it("renders the new template") do
          invalid_request
          expect(response).to(render_template(:new))
        end
  
        it("assigns an invalid job post as an instance variable") do
          invalid_request
  
          # "be_a" checks that the expected value is an instance of the 
          # given class
          expect(assigns(:job_post)).to(be_a(JobPost))
          expect(!assigns(:job_post).valid?)
        end
      end
    end
    

    describe("#show") do
      it("renders the show template") do
        # GIVEN
        # A job post in the database
        job_post = FactoryBot.create(:job_post)

        # WHEN
        # A GET to /posts/:id
        get(:show, params: { id: job_post.id })

        # THEN
        # The response contains the rendered show template
        expect(response).to(render_template(:show))
      end

      it("assigns an instance variable for the shown job post") do
        job_post = FactoryBot.create(:job_post)

        get(:show, params: { id: job_post.id })

        expect(assigns(:job_post)).to(eq(job_post))
      end
    end

    describe("#destroy") do
      context("without signed in user") do
        it("redirects to the sign in page") do
          job_post = FactoryBot.create(:job_post)

          # We need the "id" in the params because our request looks like this:
          # It needs the id of the job post to delete
          # DELETE job_posts/:id
          delete(:destroy, params: { id: job_post.id })
          expect(response).to(redirect_to(new_session_path))
        end

        it("sets a danger flash message") do
          job_post = FactoryBot.create(:job_post)
          delete(:destroy, params: { id: job_post.id })
          expect(flash[:danger]).to(be)
        end
      end

      context("with a signed in user") do
        before do
          session[:user_id] = current_user.id
        end

        def delete_request(job_post)
          delete(:destroy, params: { id: job_post.id })
        end

        context("as job post owner") do
          it("deletes a job post") do
            # We override the user in this test so that the logged in user 
            # is the owner of this job post
            job_post = FactoryBot.create(:job_post, user: current_user)
            delete_request(job_post)

            # If you use "find" instead of "find_by", ActiveRecord will throw an
            # error if the id wasn't
            # expect(JobPost.find(job_post.id)).not_to(be)
            expect(JobPost.find_by(id: job_post.id)).not_to(be)
          end

          it("sets a danger flash message") do
            job_post = FactoryBot.create(:job_post, user: current_user)
            delete_request(job_post)
            expect(flash[:danger]).to(be)
          end

          it("redirects to the job posts index page") do
            job_post = FactoryBot.create(:job_post, user: current_user)
            delete_request(job_post)
            expect(response).to(redirect_to(job_posts_path))
          end
        end

        context("as non job post owner") do
          it("doesn't delete the job post") do
            job_post = FactoryBot.create(:job_post)
            delete_request(job_post)
            expect(JobPost.find_by(id: job_post.id)).to(eq(job_post))
          end

          it("sets a danger flash message") do
            job_post = FactoryBot.create(:job_post)
            delete_request(job_post)
            expect(flash[:danger]).to(be)
          end

          it("redirects to the job post show page") do 
            job_post = FactoryBot.create(:job_post)
            delete_request(job_post)
            expect(response).to(redirect_to(job_post_path(job_post)))
          end
        end

      end
    end
  end
end
