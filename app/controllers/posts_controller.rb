class PostsController < ApplicationController
	#before_action :authenticate_user!
	 
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :owned_post, only: [:edit, :update, :destroy]
	def vote
	  value = params[:type] == "up" ? 1 : 0
	  @post = Post.find(params[:id])
	  if @post.add_or_update_evaluation(:votes, value, current_user)
	  	create_notification @post
	  	redirect_to :back, notice: "Thank you for voting"
	  end
	end


	def index  
		#@posts = Post.search(params[:search]).page params[:page]
	end 
	def new  
  		@post = current_user.posts.build
	end
	def create  
 		@post = current_user.posts.build(post_params)
	    if @post.save
	      redirect_to post_path(@post)
	    else
	      flash[:alert] = "Your new post couldn't be created!  Please check the form."
	      render :new
	    end
	end
	def show 
		@posts = Post.all.order('created_at DESC') 
	end
	def edit
	end

	def update
		 @post.created_at = Time.now
		if @post.update(post_params)
	      #flash[:success] = "Post updated."

	      redirect_to post_path(@post)
	    else
	      flash.now[:alert] = "Update failed.  Please check the form."
	      render :edit
	    end  
	end
	def destroy  
	  @post.destroy
      redirect_to profile_path(current_user.user_name)
	end 

	private

	def create_notification(post)  
	    return if post.user.id == current_user.id 
	    Notification.create(user_id: post.user.id,
	                        notified_by_id: current_user.id,
	                        post_id: post.id,
	                        identifier: post.id,
	                        notice_type: 'vot')
	end
	def post_params
	    params.require(:post).permit(:image, :caption,:tag_list)
	  end

	def set_post
	  @post = Post.find(params[:id])
	end

	def owned_post  
	  unless current_user == @post.user
	    flash[:alert] = "That post doesn't belong to you!"
	    redirect_to root_path
	  end
	end
	

end
