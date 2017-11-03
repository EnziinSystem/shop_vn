class CartsController < ApplicationController
  require 'securerandom'
  require 'digest'

  include CurrentCart

  before_action :set_cart, only: [:confirm_auth, :send_confirm_order, :index, :show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  #http://shop.com/carts/confirm-email?email=oceandemy@gmail.com&product=7&token_key=1C35AA362BC46AB90D2612476BEFD91D&language=English&time=1509338864

  def confirm_email
    email = params[:email].strip
    product = Product.find(params[:product].strip)
    language = params[:language].strip
    token_key = params[:token_key].strip
    time = params[:time].strip

    joinMd5 = "#{email}-Product-#{product.id.to_s}-#{ENV['SECRET_CODE_CREATE_ORDER_FROM_EMAIL']}-#{time}-#{language}"
    token_calculation = Digest::MD5.hexdigest joinMd5
    token_calculation = token_calculation.upcase

    time_convert = time.to_i

    if token_calculation == token_key && ((Time.now.to_i - time_convert) < (24 * 3600))
      @cart = Cart.find_by_token_key(token_key)
      if @cart.present?

        session[:cart_id] = @cart.id

        if email == @cart.email
          @user = User.find_by_email(email)
          if !@user.present?
            @user = User.new(email: email, password: token_key, password_confirmation: token_key)

            @user.name = 'Customer'
            @user.address = 'Address'
            @user.city = 'City'
            @user.state = 'State'
            @user.country = 'Country'
            @user.zipcode = '100000'
            @user.language = 'English'

            @user.skip_confirmation!
            @user.skip_confirmation_notification!
            @user.save
          end
          sign_in @user
          flash[:notice] = 'Confirm the order success!'
          redirect_to @cart
        else
          flash[:notice] = 'Error confirm the order!'
          redirect_to root_path
        end
      else
        order = Order.find_by_token_key(token_key)
        user = User.find_by_email(email)
        if order.present?
          if user.present? && email == order.user.email && order.status == 'Pending'
            sign_in user
            redirect_to show_order_url
          else
            flash[:notice] = 'Error confirm the order!'
            redirect_to root_path
          end
        else
          if user.present? && product.present?
            set_cart
            @order_item = @cart.add_item(product.id)
            @cart.updated_at = Time.now
            @cart.token_key = token_key
            @cart.email = email
            @cart.save
            sign_in user
            redirect_to @cart
          else
            flash[:notice] = 'Error confirm the order!'
            redirect_to root_path
          end
        end
      end
    else
      flash[:notice] = 'Error confirm the order!'
      redirect_to root_path
    end
  end

  def send_confirm_order
    @email = params[:user_email].strip

    product = @cart.order_items.first.product

    language = 'English'
    @guide_message_after_sent_email = '✓ Please check email to confirm the order (Inbox or Spam folder), you can close the page when the email arrives.'

    time = Time.now.to_i

    joinMd5 = "#{@email}-Product-#{product.id.to_s}-#{ENV['SECRET_CODE_CREATE_ORDER_FROM_EMAIL']}-#{time}-#{language}"
    token_key = Digest::MD5.hexdigest joinMd5
    token_key = token_key.upcase

    @cart.token_key = token_key
    @cart.email = @email
    @cart.save

    user = User.find_by_email(@email)
    new_user = true
    if user.present?
      new_user = false
    end

    confirm_cart = @cart

    ShopMailer.confirm_order(@email, new_user, token_key, time, confirm_cart, language).deliver_later(wait: 1.second)

    respond_to do |format|
      format.html {}
      format.json {head :no_content}
      format.js {render layout: false}
    end
  end

  def confirm_auth
    auth = params[:auth].strip
    if auth == 'google'
      @cart.tag = 'confirm_auth'
      @cart.save
      redirect_to user_google_oauth2_omniauth_authorize_path
    elsif auth == 'facebook'
      @cart.tag = 'confirm_auth'
      @cart.save
      redirect_to user_facebook_omniauth_authorize_path
    elsif auth == 'twitter'
      @cart.tag = 'confirm_auth'
      @cart.save
      redirect_to user_twitter_omniauth_authorize_path
    else
      redirect_to carts_path
    end
  end

  # GET /carts
  # GET /carts.json
  def index

  end

  # GET /carts/1
  # GET /carts/1.json
  def show

    respond_to do |format|
      format.html {}
      format.json {head :no_content}
      format.js {render layout: false}
    end
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html {redirect_to @cart, notice: 'Cart was successfully created.'}
        format.json {render :show, status: :created, location: @cart}
      else
        format.html {render :new}
        format.json {render json: @cart.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html {redirect_to @cart, notice: 'Cart was successfully updated.'}
        format.json {render :show, status: :ok, location: @cart}
      else
        format.html {render :edit}
        format.json {render json: @cart.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    if @cart.id == session[:cart_id]
      @cart.destroy
      session[:cart_id] = nil
    end

    respond_to do |format|
      format.html {redirect_to '/', notice: 'Cart was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def invalid_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to '/', notice: 'Invalid cart'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_params
    params.require(:cart).permit(:token_key, :email, :tag)
  end
end
