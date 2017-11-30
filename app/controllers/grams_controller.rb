class GramsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :edit]
	def index
		@grams = Gram.all
	end

	def show
		@gram = Gram.find_by_id(params[:id])
		return render_not_found if @gram.blank?
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

	def edit
		@gram = Gram.find_by_id(params[:id])
		return render_not_found if @gram.blank?
		return render_forbidden if (@gram.user != current_user)
	end

	def update
		@gram = Gram.find_by_id(params[:id])
		return render_not_found if @gram.blank?

		return render_forbidden if (@gram.user != current_user)

		@gram.update_attributes(grams_params)

		if @gram.valid?
			redirect_to root_path
		else
			return render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		@gram = Gram.find_by_id(params[:id])
		return render_not_found if @gram.nil?
		return render_forbidden if (@gram.user != current_user)
		@gram.destroy
		redirect_to root_path
	end

	private
	def grams_params
		params.require(:gram).permit(:message)
	end

	def render_not_found
		render plain: 'Not Found:(', status: :not_found
	end

	def render_forbidden
		render plain: 'Forbidden:(', status: :forbidden
	end

end
