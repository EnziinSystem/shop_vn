class PagesController < ApplicationController
  require 'will_paginate/array'

  def home
    @products = Product.all.order('id desc')
    @products = @products.paginate(page: params[:page], per_page: 9)
  end

  def about
  end
end
