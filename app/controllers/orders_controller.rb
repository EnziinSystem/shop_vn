class OrdersController < ApplicationController
  require 'net/http'
  require 'digest'
  require 'json'
  require 'openssl'

  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :authenticate_user!, only: [:list, :show]
  before_action :ensure_cart_isnt_empty, only: :new
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  #before_action :set_order, only: [:show, :edit, :update, :destroy]

  def history
    email = params[:email].strip
    token_key = params[:token_key].strip
    time = params[:time].strip

    joinMd5 = "#{email}-#{time}-#{ENV['SECRET_CODE_CREATE_ORDER_FROM_EMAIL']}"
    token_key_calculation = Digest::MD5.hexdigest joinMd5
    token_key_calculation = token_key_calculation.upcase

    time_convert = time.to_i

    user = User.find_by_email(email)

    if user.present? && token_key_calculation == token_key && ((Time.now.to_i - time_convert) < (24 * 3600))
      sign_in user
      redirect_to my_orders_path
    else
      flash[:notice] = 'Please login!'
      redirect_to root_path
    end
  end

  def bao_kim_submit_cart
    order_id = params[:order_id]
    unless current_user.nil?
      @user = User.find(current_user.id)
      @order = Order.find(order_id)

      if @order.present? && @order.status == 'Pending' && @order.user.email == @user.email
        description_order = "Thanh toán cho đơn hàng #{@order.order_number}"

        hashCart = {
            merchant_id: ENV['BAO_KIM_MERCHANT_ID'].to_s.strip,
            order_id: @order.order_number.strip,
            business: ENV['BAO_KIM_BUSINESS_ACCOUNT'].to_s.strip,
            total_amount: @order.total_in_vietnamese.to_s.strip,
            shipping_fee: @order.shipping_fee.to_s.strip,
            tax_fee: @order.tax_fee.to_s.strip,
            order_description: description_order.strip,
            url_success: ENV['BAO_KIM_SUCCESS_CART_URL'].to_s.strip,
            url_cancel: ENV['BAO_KIM_CANCEL_CART_URL'].to_s.strip,
            url_detail: ENV['BAO_KIM_DETAIL_CART_URL'].to_s.strip,
            payer_name: @user.name.strip,
            payer_email: @user.email.strip,
            payer_phone_no: @user.phone.strip,
            shipping_address: @user.address.strip,
            money: 'VND'
        }

        array_keys = hashCart.keys.sort
        join_str = ''
        array_keys.each do |key|
          join_str.concat(hashCart[key].to_s.strip)
        end

        secure_code = ENV['BAO_KIM_SECURE_CODE']
        check_sum_cart_bao_kim = OpenSSL::HMAC.hexdigest('sha1', secure_code, join_str)
        hashCart['checksum'] = check_sum_cart_bao_kim

        bao_kim_cart_query = ENV['BAO_KIM_PAYMENT_CART_URL'] + '?' + URI.encode_www_form(hashCart).to_s

        redirect_to bao_kim_cart_query
      else
        flash[:notice] = 'Thanh toán lỗi!'
        redirect_to root_path
      end
    end
  end

  def list
    @user = current_user
    @products = @user.products
  end

  # GET /orders
  # GET /orders.json
  def index
    #@orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    unless current_user.nil?
      @user = User.find(current_user.id)
      begin
        @order = @user.orders.where(status: 'Pending').last
        if @order.present?
          @order.update_total_price
          @order.save
        else
          redirect_to root_path
        end
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = 'Not found the order!'
        redirect_to root_path
      end
    end
  end

  # GET /orders/new
  def new
    #@order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    user_exist = params[:user_check]
    verify_man = false

    if user_exist == 'UpdateUser' && !current_user.nil?
      name = params[:user_name]
      phone = params[:user_phone]
      address = params[:user_address]
      city = params[:user_city]
      zipcode = params[:user_zipcode]
      country = params[:user_country]

      if !name.blank? && !phone.blank? && !address.blank? && !city.blank? && !zipcode.blank? && !country.blank?
        @user = User.find(current_user.id)
        @user.update_attributes(name: name, phone: phone, address: address, address2: address, state: city, city: city, zipcode: zipcode, country: country)
        verify_man = true
      else
        flash[:notice] = 'You must fill information!'
        redirect_to @cart
      end

      if verify_man && !current_user.nil?
        @user = User.find(current_user.id)

        random_number = ''
        loop do
          random_number = 'U' + @user.id.to_s + '-' + rand(10 ** 6).to_s
          exist_order = Order.find_by_order_number(random_number)
          break if !exist_order.present?
        end

        @order = Order.new(user_id: @user.id, order_number: random_number, total: @cart.total_price, payment_type: 'Undefine', status: 'Pending')
        @order.add_order_items_from_cart(@cart)
        @order.token_key = @cart.token_key
        @order.save

        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html {redirect_to @order, notice: 'Order was successfully updated.'}
        format.json {render :show, status: :ok, location: @order}
      else
        format.html {render :edit}
        format.json {render json: @order.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html {redirect_to orders_url, notice: 'Order was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def record_not_found
    flash[:notice] = 'Error, not found the resource!'
    redirect_to root_path
  end

  def ensure_cart_isnt_empty
    if @cart.order_items.empty?
      redirect_to '/', notice: 'Your cart is empty'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:user_id, :order_number, :total, :payment_type, :status, :shipping_fee, :tax_fee, :token_key)
  end
end
