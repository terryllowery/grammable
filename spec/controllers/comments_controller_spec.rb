require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

	describe 'comments#Create Action' do
		it "should allow users to create comments on grams" do
			# A gram needs to exist in our database.
			# As a user who is logged into the site.
			# When they trigger an HTTP POST request to a URL that looks like /grams/:gram_id/comments, with the message "awesome gram"
			# Our server's response should be to redirect the user to the root path.
			# And there should be a comment created in the database with the message "awesome gram".
			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: { gram_id: gram.id, comment: { message: "Awesome Gram!" } }
			expect(response).to redirect_to root_path

			expect(gram.comments.length).to eq 1
			expect(gram.comments.first.message).to eq("Awesome Gram!")

		end

		it "should require a user to be logged in to comment on a gram" do
			# A gram needs to exist in our database.
			# When someone who is not logged in triggers an HTTP POST request to a URL that looks like /grams/:gram_id/comments, with the message "awesome gram".
			# Our server will redirect the user to login.
			gram = FactoryBot.create(:gram)

			post :create, params: { gram_id: gram.id, comment: { message: "Awesome Gram!" } }
			expect(response).to redirect_to new_user_session_path

		end

		it "should show a 404 error if a user tries to crate a comment for a gram with an invalid id" do

			# As a user who is logged into the site.
			# When when they trigger an HTTP POST request to a URL that looks like /grams/YOLOSWAG/comments, with the message "awesome gram"
			# Our server should respond with the HTTP Response of 404 Not Found

			user = FactoryBot.create(:user)
			sign_in user
			post :create, params: { gram_id: "YOLLOG", comment: { message: "Awesome Gram!" } }
			expect(response).to have_http_status(:not_found)
		end
	end
end
