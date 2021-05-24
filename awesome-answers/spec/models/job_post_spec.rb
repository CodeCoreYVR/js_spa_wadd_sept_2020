require 'rails_helper'

# To run tests with details:
# rspec -f d

# Every test rebuilds the database, so our persisted instances will not be
# persisted in the next round of tests.

RSpec.describe JobPost, type: :model do
  # List of expectations and matchers:
  # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

  # The "describe" method groups related tests together. It works same
  # as "context". It provides a level of organization for the tests.
  # "describe" usually wraps a set of tests against one functionality while
  # "context" is to wrap to set of tests against one functionality given the same state
  # "it" groups each individual test
  describe("validates") do
    context("title") do
      it("is required") do 
        # GIVEN 
        # An instance of a JobPost (without a title)
        job_post = FactoryBot.build(:job_post, title: nil)
  
        # WHEN
        # Validations are triggered when we check for validity or
        # when we attempt to save it to the database
        job_post.valid?
  
        # THEN
        
        # There's an error related to title in the errors object of
        # the JobPost. The following will pass the test if the 
        # errors.messages hash has a key named :title
        # This only occurs if a title validation failed.
  
        # Use the "expect" method instead of "assert" to write 
        # expectations. It take a single argument which is the value
        # that we're going to test. We call "to" on the object that 
        # returns with a matcher to performs the verification of the value.
        expect(job_post.errors.messages).to(have_key(:title))
      end
  
      it("requires a unique title") do
        # GIVEN: A job post in the database and an instance of another
        # job post with the same title:
        persisted_job_post = FactoryBot.create(:job_post)
        job_post = FactoryBot.build(:job_post, title: persisted_job_post.title)
  
        # WHEN
        job_post.valid?
  
        # THEN
        expect(job_post.errors.messages).to(have_key(:title))
        expect(job_post.errors.messages[:title]).to(include("has already been taken"))
      end
    end
    context("description") do
      it("is required") do
        job_post = FactoryBot.build(:job_post, description: nil)
        job_post.valid?
        
        expect(job_post.errors.messages).to(have_key(:description))
      end

      it("must be longer than 100 characters") do
        job_post = FactoryBot.build(:job_post, description: "notonehundred")
        job_post.valid?

        expect(job_post.errors.messages).to(have_key(:description))
      end
    end

    context("min_salary") do
      it("is numerical") do
        job_post = FactoryBot.build(:job_post, min_salary: "one hundred")
        job_post.valid?
        
        expect(job_post.errors.messages).to(have_key(:min_salary))
      end
      
      it("must be greater or equal to 30_000") do
        job_post = FactoryBot.build(:job_post, min_salary: 25_000)
        job_post.valid?

        # The error object has a method "details" which returns a hash with keys
        # that are the columns that have errors. The value is an array of error
        # messages, each with an error key whose value is a validation symbol

        # use byebug here to view the array:
        # byebug
        # job_post.errors.details => {:min_salary=>[{:error=>:greater_than_or_equal_to, :value=>25000, :count=>30000}]}
        expect(job_post.errors.details[:min_salary][0][:error]).to(be(:greater_than_or_equal_to))
      end
    end

    context("location") do 
      it("is required") do
        job_post = FactoryBot.build(:job_post, location: nil)
        job_post.valid?

        expect(job_post.errors.messages).to(have_key(:location))
      end
    end
  end

  # According to ruby docs, methods that are described with a "." are class
  # methods. Those that are described with a "#" are instance methods
  describe(".search") do
    it("returns only job posts containing the search term, regardless of case") do
      job_post_1 = FactoryBot.create(:job_post, title: "Software Engineer")
      job_post_2 = FactoryBot.create(:job_post, title: "Programmer")
      job_post_3 = FactoryBot.create(:job_post, title: "Software Architect")
  
      results = JobPost.search("software")
  
      # job_post 1 & 3 returned
      expect(results).to(eq([job_post_1, job_post_3]))
    end
  end
end
