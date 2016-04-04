class PostsController < ApplicationController
	#before_action :authenticate_user!
	 
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :owned_post, only: [:edit, :update, :destroy]
	def vote
	  value = params[:type] == "up" ? 1 : -1
	  @post = Post.find(params[:id])
	  @post.add_or_update_evaluation(:votes, value, current_user)
	  redirect_to :back, notice: "Thank you for voting"
	end


	def index  
	  @posts = Post.all.order('created_at DESC').page params[:page]
	end 
	def new  
  		@post = current_user.posts.build
	end
	def create  
 		@post = current_user.posts.build(post_params)
	    if @post.save
	      redirect_to posts_path
	    else
	      flash[:alert] = "Your new post couldn't be created!  Please check the form."
	      render :new
	    end
	end
	def show  
	end
	def edit
	end

	def update
		 @post.created_at = Time.now
		if @post.update(post_params)
	      flash[:success] = "Post updated."

	      redirect_to posts_path
	    else
	      flash.now[:alert] = "Update failed.  Please check the form."
	      render :edit
	    end  
	end
	def destroy  
	  @post.destroy
      redirect_to root_path
	end 

	private

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
