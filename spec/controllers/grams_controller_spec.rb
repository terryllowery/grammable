require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#update action" do

		it "should allow successful updates on gram" do
			gram = FactoryBot.create(:gram, message: "Initial Value" )
			patch :update, params: { id: gram.id, gram: { message: "Changed" } }
			expect(response).to redirect_to root_path
			gram.reload
			expect(gram.message).to eq("Changed")
		end

		it "should show 404 if edit gram does not match" do
			patch :update, params: { id: "BAHA", gram: { message: "Not Changed" } }
			expect(response).to have_http_status(:not_found)
		end

		it "should show new form again on validation errors" do
			gram = FactoryBot.create(:gram, message: "Initial Value")
			patch :update, params: {id: gram.id, gram: { message: '' } }
			expect(response).to have_http_status(:unprocessable_entity)
			gram.reload
			expect(gram.message).to eq("Initial Value")
		end

	end

	describe "grams#edit action" do

		it "should successfully show the edit form if the gram is found" do
			gram = FactoryBot.create(:gram)
			get :edit, params: { id: gram.id }
			expect(response).to have_http_status(:success)
		end

		it "should show a 404 when editing a gram that is not found" do
			get :edit, params: { id: 'TOCAT' }
			expect(response).to have_http_status(:not_found)
		end

	end

	describe "grams#show action" do
		it "should successfully show gram if it matches" do
			gram = FactoryBot.create(:gram)
			get :show, params: { id: gram.id }
			expect(response).to have_http_status(:success)
		end

		it "should show a 404 if the gram isn't found" do
			get :show, params: { id: 'TOCAT' }
			expect(response).to have_http_status(:not_found)
		end
	end

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
