class UsersController < ApplicationController
  def users
    sp = user_search_params['q'] || {}
    @q = User.ransack(sp)
    @users = @q.result.order(:email).page params[:page]
    render 'users/users'
  end

  def reviews
    @user = User.find(params['user_id'])
    render 'users/reviews'
  end

  def new_review
    @review = UserReview.new(by_user_id: current_user.id, for_user_id: params['user_id'])
  end

  def edit_review
  end

  def create_review
  end

  def edit_review
  end

  def destroy_review
  end

  private

  def user_search_params
    params.except(:button).permit(:button, :q => [:username_cont, :profile_cont])
  end
end
