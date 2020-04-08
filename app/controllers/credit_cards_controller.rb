class CreditCardsController < ApplicationController
  before_action :set_credit_card, only: [:show, :edit, :update, :destroy]

  # GET /credit_cards
  # GET /credit_cards.json
  def index
    @credit_cards = CreditCard.all
  end

  # GET /credit_cards/1
  # GET /credit_cards/1.json
  def show
  end

  # GET /credit_cards/new
  def new
    @credit_card = CreditCard.new
  end

  # GET /credit_cards/1/edit
  def edit
  end

  def new_card_from_acct
    begin
      flash[:success] = "Credit card was successfully created."
      stripe_card_id = CreditCardService.new(current_user.id, credit_card_params).create_credit_card
      current_user.credit_cards.where(stripe_id: stripe_card_id).first_or_create(credit_card_params)
    rescue Stripe::CardError => e
      flash.delete(:success)
      flash[:alert] = e.message

      # redirect_to :back
    end

    respond_to do |format|
      format.js { render 'devise/registrations/new_card_from_acct' }
    end
  end

  # POST /credit_cards
  # POST /credit_cards.json
  def create
    @credit_card = CreditCard.new(credit_card_params)

    respond_to do |format|
      if @credit_card.save
        flash[:success] = "Credit card was successfully created."
        format.html { redirect_to @credit_card, notice: 'Credit card was successfully created.' }
        format.json { render :show, status: :created, location: @credit_card }
      else
        flash[:alert] = "Credit card information was invalid"
        format.html { render :new }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credit_cards/1
  # PATCH/PUT /credit_cards/1.json
  def update
    respond_to do |format|
      if @credit_card.update(credit_card_params)
        format.html { redirect_to @credit_card, notice: 'Credit card was successfully updated.' }
        format.json { render :show, status: :ok, location: @credit_card }
      else
        format.html { render :edit }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_cards/1
  # DELETE /credit_cards/1.json
  def destroy
    @credit_card.destroy
    respond_to do |format|
      flash[:success] = "Credit card was successfully removed"
      format.html { redirect_to :back, notice: 'Credit card was successfully destroyed.' }
      format.js { render 'devise/registrations/destroy' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_card_params
      params.require(:credit_card).permit(:number, :month, :year, :cvc, :stripe_id)
    end
end
