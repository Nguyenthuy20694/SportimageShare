class Post < ActiveRecord::Base
	
	
	belongs_to :user

	has_many :comments, dependent: :destroy
	has_many :notifications, dependent: :destroy
	
	validates :user_id, presence: true
	validates :image, presence: true
	has_attached_file :image, styles: { :medium => "640x" }
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/



	acts_as_taggable
	has_reputation :votes, source: :user, aggregated_by: :sum
	
	def self.search(search)
	  if search
	    find(:all, :conditions => ['caption LIKE ?', "%#{search}%"])
	  else
	    find(:all)
	  end
	end
end
