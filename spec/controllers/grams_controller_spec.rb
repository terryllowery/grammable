require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#index" do
		it "Should open page successfully" do
			get :index
			expect(response).to have_http_status(:success)
		end

	end

	describe "grams#new action" do
		it "Should successfully show new form" do
			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do
		it "should create a gram successfully in the database" do
			post :create, params: { gram: { message: "Hello!" } }
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram.message).to eq("Hello!")
		end
	end

end
