class UrlsController < ApplicationController
	def index
		@urls = Url.all
	end

	def show
		# byebug
		@url = Url.find(params[:id])
	end

	def new
		@url = Url.new
	end	

	def create
		# byebug
		@url = Url.new(url_params)
		if @url.save
			redirect_to @url
		else 
			render 'index'
		end
	end

	def destroy
		@url = Url.find(params[:id])
		@url.destroy
		redirect_to urls_path
	end

	def short 
		url = Url.find(params[:id])
		redirect_to url.long_url
	end

	private
	def url_params
		params.require(:url).permit(:long_url)
	end

end
