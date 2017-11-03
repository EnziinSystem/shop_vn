class PaymentsController < ApplicationController
  require 'cgi'
  require 'net/http'
  require 'digest'
  require 'json'
  require 'openssl'

  protect_from_forgery except: :bao_kim_bpn_listener

  before_action :authenticate_user!, except: [:bao_kim_success_cart, :bao_kim_bpn_listener]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def bao_kim_success_cart
    query_str = request.original_url
    query_params = query_str.gsub(ENV['BAO_KIM_SUCCESS_CART_URL'] + '?', '')

    hashParams = Hash[CGI.parse(query_params).map {|key, values| [key.to_sym, values[0]]}]
    hashParams.delete(:checksum)

    array_keys = hashParams.keys.sort
    join_str = ''
    array_keys.each do |key|
      join_str.concat(hashParams[key].to_s)
    end

    secure_code = ENV['BAO_KIM_SECURE_CODE']
    check_sum_calculation = OpenSSL::HMAC.hexdigest('sha1', secure_code, join_str).upcase

    checksum_bao_kim = params[:checksum]
    transaction_status = params[:transaction_status]

    @order = Order.find_by_order_number(params[:order_id])

    if check_sum_calculation == checksum_bao_kim && @order.present? && (transaction_status == '4' || transaction_status == '13')
      @order.payment_type = 'Bảo Kim'
      @order.save
      if transaction_status == '4'
        @order.status = 'Complete'
        @order.save
        flash[:notice] = 'Thanh toán thành công!'
        redirect_to my_orders_path
      end
    end
  end

  def bao_kim_bpn_listener
    bank_fee = params[:bank_fee]
    bank_fee_for = params[:bank_fee_for]
    created_on = params[:created_on]
    customer_account_id = params[:customer_account_id]
    customer_email = params[:customer_email]
    customer_name = params[:customer_name]
    customer_phone = params[:customer_phone]
    fee_amount = params[:fee_amount]
    from_fee = params[:from_fee]
    merchant_email = params[:merchant_email]
    merchant_id = params[:merchant_id]
    merchant_name = params[:merchant_name]
    merchant_phone = params[:merchant_phone]
    net_amount = params[:net_amount]
    order_amount = params[:order_amount]
    order_id = params[:order_id]
    payment_type = params[:payment_type]
    to_fee = params[:to_fee]
    total_amount = params[:total_amount]
    order_number = params[:order_id]
    transaction_id = params[:transaction_id]
    transaction_status = params[:transaction_status]
    usd_vnd_exchange_rate = params[:usd_vnd_exchange_rate]
    verify_sign = params[:verify_sign]
    bpn_id = params[:bpn_id]

    uri = URI("#{ENV['BAO_KIM_BPN_VERIFY']}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'

    request.set_form_data({
                              'bank_fee' => bank_fee,
                              'bank_fee_for' => bank_fee_for,
                              'created_on' => created_on,
                              'customer_account_id' => customer_account_id,
                              'customer_email' => customer_email,
                              'customer_name' => customer_name,
                              'customer_phone' => customer_phone,
                              'fee_amount' => fee_amount,
                              'from_fee' => from_fee,
                              'merchant_email' => merchant_email,
                              'merchant_id' => merchant_id,
                              'merchant_name' => merchant_name,
                              'merchant_phone' => merchant_phone,
                              'net_amount' => net_amount,
                              'order_amount' => order_amount,
                              'order_id' => order_id,
                              'payment_type' => payment_type,
                              'to_fee' => to_fee,
                              'total_amount' => total_amount,
                              'transaction_id' => transaction_id,
                              'transaction_status' => transaction_status,
                              'usd_vnd_exchange_rate' => usd_vnd_exchange_rate,
                              'verify_sign' => verify_sign,
                              'bpn_id' => bpn_id
                          })

    response = http.request(request)
    result_code = response.code.to_s
    @response = response.body
    @result_code = result_code

    if result_code == '200' && @response == 'VERIFIED'
      order = Order.find_by_order_number(order_number)

      if order.present? && merchant_id == ENV['BAO_KIM_MERCHANT_ID'] && order.total_in_vietnamese >= order_amount.to_f && (transaction_status == '4' || transaction_status == '13')
        order.status = 'Complete'
        order.payment_type = 'Bảo Kim'
        order.save
      end
    end

    render body: nil
    head :ok
  end

  def payment_2_checkout
    @order = Order.find(params[:li_0_product_id])
    params[:secret] = ENV['TWO_CHECKOUT_SECRET_WORD']
    @notification = Twocheckout::ValidateResponse.purchase(params)
    total = params[:total].to_f

    if (@notification[:code] == 'PASS') && (total >= @order.total)
      @order.status = 'Complete'
      @order.payment_type = 'CreditCard'
      @order.save
      flash[:notice] = 'Successful payment'
      redirect_to my_orders_path
    else
      flash[:notice] = 'Payment failed'
      redirect_to root_path
    end

  end

  def paypal_express
    @order = Order.find(params[:id])
    response = EXPRESS_GATEWAY.setup_purchase(amount_in_cent(@order.total),
                                              ip: request.remote_ip,
                                              return_url: complete_url(@order),
                                              cancel_return_url: show_order_url,
                                              currency: 'USD',
                                              allow_guest_checkout: true,
                                              items: [{
                                                          name: @order.order_number,
                                                          discription: 'Payment for ' + @order.order_number,
                                                          amount: amount_in_cent(@order.total),
                                                          quantity: '1'
                                                      }])

    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def paypal_complete
    @order = Order.find(params[:id])

    profile = EXPRESS_GATEWAY.purchase(amount_in_cent(@order.total),
                                       :ip => request.remote_ip,
                                       :payer_id => params[:PayerID],
                                       :token => params[:token]
    )

    if profile.success?
      @order.status = 'Complete'
      @order.payment_type = 'Paypal'
      @order.save

      flash[:notice] = 'Successful payment'
      redirect_to my_orders_path

    else
      flash[:notice] = 'Payment failed'
      redirect_to root_path
    end
  end

  private

  def amount_in_cent(amount)
    amount * 100
  end

  def record_not_found
    flash[:notice] = 'Error, not found the resource!'
    redirect_to root_path
  end

end
