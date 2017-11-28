require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#index" do
		it "Should open page successfully" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do

		it "Should require users to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		it "Should successfully show new form" do

			user = FactoryBot.create(:user)
			sign_in user

			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do

		it "should require users to be authenticated to post to grams" do
			post :create, params: { gram: { message: "Hello!" } }
			expect(response).to redirect_to new_user_session_path
		end

		it "should create a gram successfully in the database" do
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: { gram: { message: "Hello!" } }
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram.message).to eq("Hello!")
			expect(gram.user).to eq(user)
		end

		it "Should deal with validation errors" do
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: { gram: { message: '' } }
			expect(response).to have_http_status(:unprocessable_entity)
			expect(Gram.count).to eq(0)
		end
	end

end
