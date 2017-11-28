require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#index" do
		it "Should open page successfully" do
			get :index
			expect(response).to have_http_status(:success)
		end

	end

end
