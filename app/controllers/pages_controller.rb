class PagesController < ApplicationController
  require 'will_paginate/array'
  include CurrentCart
  before_action :set_cart

  def introduction
    @product = Product.find(params[:id])
    @landing_page = @product.landing_page

    respond_to do |format|
      format.html {
        render layout: false
      }
    end
  end

  def home
    @products = Product.all.order('id desc')
    @products = @products.paginate(page: params[:page], per_page: 9)

    @slides = Slide.all

    if @cart.tag == 'confirm_auth'
      @cart.tag = 'normal'
      @cart.save
      redirect_to @cart
    end
  end

  def about
  end
end
