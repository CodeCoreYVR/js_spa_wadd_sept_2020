class DonationsController < ApplicationController
    def new 
        @donation = Donation.new
    end

    def create
        @donation = Donation.new(donation_params)

        @answer = Answer.find params[:answer_id]

        @donation.giver = current_user
        @donation.status = "pending"
        @donation.security_key = SecureRandom.hex(20)
        @donation.receiver = @answer.user
        @donation.answer = @answer

        if @donation.save

            shared_path = "http://127.0.0.1:3000/answers/#{@answer.id}/donations/complete?donation_id=#{@donation.id}&security_key=#{@donation.security_key}"

            session = Stripe::Checkout::Session.create({
                success_url: shared_path + "&status=completed",
                cancel_url:  shared_path +"&status=canceled",
                payment_method_types: ['card'],
                line_items: [
                    {
                        amount: @donation.amount * 100,
                        currency: "usd",
                        name: "Donation for good answer",
                        quantity: 1,
                        images: [
                            "https://www.reedpublicrelations.com/wp-content/uploads/2019/11/Reed-blog-post-image.jpg"
                        ]
                    }
                ],
                mode: "payment"
            })

            redirect_to session.url
        else 
            render :new
        end
    end

    def complete 
        @donation = Donation.find params[:donation_id]

        if @donation.security_key != params[:security_key]
            flash[:danger] = "Invaild security key"
            redirect_to root_path
        else 
            @donation.status = params[:status]
            @donation.save

            if params[:status] == "completed"
                flash[:success] = "Donation was completed"
            else 
                flash[:danger] = "Donation was not completed"
            end

            redirect_to root_path
        end        
    end


    private
    def donation_params
        params.require(:donation).permit(:amount)
    end


end