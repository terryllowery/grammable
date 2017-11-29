class GramsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]
	def index
	end

	def show
		@grams = Gram.find_by_id(params[:id])
		if @grams.blank?
			render :new, status: :not_found
		end
	end

	def new
		@gram = Gram.new
	end

	def create
		@gram = current_user.grams.create(grams_params)
		if @gram.valid?
			redirect_to root_path
		else
			render :new, status: :unprocessable_entity
		end

	end

	private
	def grams_params
		params.require(:gram).permit(:message)
	end

end
