require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#destroy action" do

		it "shouldn't allow a user that didn't create gram to delete" do
			# A gram needs to exist in our database.
			# When a user is logged in as a different user than the user who created the gram performs an HTTP DELETE request to a URL that looks like /grams/:id.
			# Our server should result in the HTTP Status Code of Forbidden.

			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user
			delete :destroy, params: { id: gram.id }
			expect(response).to have_http_status(:forbidden)
		end

		it "shouldn't allow an unauthenticated user to destroy a gram" do
			# A gram needs to exist in our database.
			# When someone who isn't logged in tries to access the edit, update or destroy action.
			# Our server's response should be a redirect to the sign in page.

			gram = FactoryBot.create(:gram)
			delete :destroy, params: { id: gram.id }
			expect(response).to redirect_to new_user_session_path

		end

		it "should allow a user to destroy a gram" do

			# A gram needs to exist in our database.
			# When the user the gram is connected to is signed in.
			# When someone performs a DELETE HTTP request to a URL that looks like /grams/:id.
			# Our server should result in a redirect to the root path.
			# The gram should no longer be inside our database.
			gram = FactoryBot.create(:gram)
			sign_in gram.user
			delete :destroy, params: { id: gram.id }
			expect(response).to redirect_to root_path
			gram = Gram.find_by_id(gram.id)
			expect(gram).to eq(nil)

		end

		it "should return a 404 when user tries to destroy a gram id not in database" do

			# When a user performs a DELETE HTTP request to a URL that looks like /grams/NOTAVALUE.
			# When the user the gram is connected to is signed in.
			# Our server should result in the HTTP response code of 404 Not Found.
			user = FactoryBot.create(:user)
			sign_in user
			delete :destroy, params: {id: "NOTAVALUE"}
			expect(response).to have_http_status(:not_found)
		end

	end

	describe "grams#update action" do

		it "shouldn't allow users that did not create gram to update" do
			# A gram needs to exist in our database.
			# When a user is logged in as a different user than the user who created the gram performs an HTTP PATCH request to a URL that looks like /grams/:id.
			# Our server should result in the HTTP Status Code of Forbidden.

			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user
			patch :update, params: { id: gram.id, gram: { message: "Changed"} }
			expect(response).to have_http_status(:forbidden)
		end



		it "shouldn't allow unauthenticated users to update a gram" do
			# A gram needs to exist in our database
			# When someone who isn't logged in tries to access the edit, update or destroy action.
			# Our server's response should be a redirect to the sign in page.

			gram = FactoryBot.create(:gram, message: "Initial Value")
			patch :update, params: { id: gram.id, gram: { message: "Changed" } }
			expect(response).to redirect_to new_user_session_path

		end
		it "should allow successful updates on gram" do
			gram = FactoryBot.create(:gram, message: "Initial Value" )
			sign_in gram.user
			patch :update, params: { id: gram.id, gram: { message: "Changed" } }
			expect(response).to redirect_to root_path
			gram.reload
			expect(gram.message).to eq("Changed")
		end

		it "should show 404 if edit gram does not match" do
			user = FactoryBot.create(:user)
			sign_in user
			patch :update, params: { id: "BAHA", gram: { message: "Not Changed" } }
			expect(response).to have_http_status(:not_found)
		end

		it "should show new form again on validation errors" do
			gram = FactoryBot.create(:gram, message: "Initial Value")
			sign_in gram.user
			patch :update, params: {id: gram.id, gram: { message: '' } }
			expect(response).to have_http_status(:unprocessable_entity)
			gram.reload
			expect(gram.message).to eq("Initial Value")
		end

	end

	describe "grams#edit action" do

		it "shouldn't let users that did not create gram to edit" do
			# A gram needs to exist in our database.
			# When a user is logged in as a different user than the user who created the gram performs an HTTP GET request to a URL that looks like /grams/:id/edit.
			# Our server should result in the HTTP Status Code of Forbidden.

			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user
			get :edit, params: { id: gram.id }
			expect(response).to have_http_status(:forbidden)

		end

		it "shouldn't let unauthenticated users edit a gram" do

			# A gram needs to exist in our database
			# When someone who isn't logged in tries to access the edit, update or destroy action.
			# Our server's response should be a redirect to the sign in page.

			gram = FactoryBot.create(:gram)
			get :edit, params: { id: gram.id }
			expect(response).to redirect_to new_user_session_path

		end

		it "should successfully show the edit form if the gram is found" do
			gram = FactoryBot.create(:gram)
			sign_in gram.user
			get :edit, params: { id: gram.id }
			expect(response).to have_http_status(:success)
		end

		it "should show a 404 when editing a gram that is not found" do
			user = FactoryBot.create(:user)
			sign_in user
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
			grams = FactoryBot.create(:gram)
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
