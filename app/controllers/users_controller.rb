class UsersController < ApplicationController
  before_action :set_review, :only => [:destroy_review]

  def edit
    @credit_cards = current_user.credit_cards
  end

  def update
    # update for general items
    if params['gen-submit']
      respond_to do |format|
        if current_user.update(user_params)
          format.html { redirect_to edit_registration_path(resource), :notice => "User updated successfully!" }
        else
          format.html { redirect_to :back, :alert => current_user.errors}
        end
      end
    end
  end

  def users
    sp = user_search_params['q'] || {}
    @q = User.ransack(sp)
    @users = @q.result.order(:email).page params[:page]
    render 'users/users'
  end

  def reviews
    @user = User.find_by("LOWER(username)= ?", params['username'].downcase)
    render 'users/reviews'
  end

  def new_review
    @review = UserReview.where(by_user_id: current_user.id, for_user_id: params['user_id'], role: params['role']).first_or_create
    @role = params['role']
    @user = User.find(params['user_id'])
  end

  def edit_review
    @review = UserReview.where(by_user_id: current_user.id, for_user_id: params['user_id'], role: params['role']).first_or_create
    @role = params['role']
    @user = User.find(params['user_id'])
  end

  def buy_posts
  end

  def create_review
    @review = UserReview.where(review_params).first_or_create
    @review.for_user_id = params[:user_id]
    @review.by_user_id = current_user.id
    @users = User.all

    respond_to do |format|
      if @review.save
        format.html { redirect_to reviews_path(params[:user_id]), notice: "Review successfully submitted" }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { @user = User.find(params[:user_id]); render new_review_path({:user_id => params[:id], :role => params[:role]}), :alert => @review.errors }
        format.json { render :json => @review.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_review
    @review = UserReview.find_by(for_user_id: params[:user_id], by_user_id: current_user.id, role: review_params[:role])
    @review.content = review_params[:content]
    @review.stars = review_params[:stars]
    @users = User.all

    respond_to do |format|
      if @review.save
        format.html { redirect_to reviews_path(params[:user_id]), notice: "Review successfully submitted" }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { @user = User.find(params[:user_id]); render new_review_path({:user_id => params[:id], :role => params[:role]}), :alert => @review.errors }
        format.json { render :json => @review.errors, :status => :unprocessable_entity }
      end
    end

  end

  def destroy_review
    if @review.by_user.id != current_user.id
      redirect_to reviews_path, :alert => "You cannot delete another user's review"
    end

    @review.destroy
    respond_to do |format|
      format.html { redirect_to users_path, :notice => 'Review was successfully removed' }
      format.json { head :no_content }
    end
  end

  private

  def set_review
    @review = UserReview.find(params[:id])
  end

  def user_search_params
    params.except(:button).permit(:button, :q => [:username_cont, :profile_cont])
  end

  def review_params
    params.require(:user_review).permit(:content, :stars, :for_user_id, :by_user_id, :role)
  end

  def user_params
    params.require(:user).permit(:show_phone_request, :show_email_request, :show_phone_service, :show_email_service, :profile)
  end
end
