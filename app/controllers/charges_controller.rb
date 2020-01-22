class ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product

  def new_card
    begin
      stripe_card_id = CreditCardService.new(current_user.id, card_params).create_credit_card
      current_user.credit_cards.where(stripe_id: stripe_card_id).first_or_create(card_params)
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to :back
    end

    respond_to do |format|
      format.js { render 'products/new_card' }
    end
  end

  def create
    begin
      stripe_card_id = charge_params[:card_id]
      qty = @product.qty

      Stripe::Charge.create(
        customer: current_user.customer_id,
        source: stripe_card_id,
        amount: @product.price_in_cents,
        currency: 'usd'
      )

      if qty == "unlimited"
        current_user.update(sub_type: "unlimited")
      else
        current_user.update(posts: current_user.posts.to_i + qty.to_i)
      end
      redirect_to @product
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to @product
    end
  end

  private

  def card_params
    params.require(:credit_card).permit(:number, :month, :year, :cvc)
  end

  def charge_params
    params.require(:charge).permit(:card_id)
  end

  def find_product
    begin
      if params[:product_id]
        @product = Product.find(params[:product_id])
      end
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = 'Product not found!'
      redirect_to root_path
    end
  end
end