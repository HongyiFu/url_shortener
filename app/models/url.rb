require 'net/http'

class Url < ApplicationRecord
	before_validation :prefix_long_url, on: :create

	validates :long_url, presence: true, uniqueness:true

	validate :proper_url?

	before_create do 
		short_url = shorten
		while !Url.find_by(short_url:short_url).nil?
			short_url = shorten
		end
		self.short_url = short_url
	end

	private

	def shorten
		SecureRandom.hex(6)
	end	

	def prefix_long_url
		self.long_url.gsub!(/\s/,'')
		self.long_url.downcase!
		arr = self.long_url.scan(/\A(?:https:\/\/|http:\/\/)/)
		if arr.empty? 
			self.long_url = "https://" + self.long_url
		end
	end

	def proper_url?
		begin
			res = Net::HTTP.get_response(URI(long_url))
		rescue SocketError => exception
			errors.add(:long_url, "Invalid url given.")
		end
	end

end
