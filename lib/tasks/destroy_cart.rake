desc 'destroy cart expired'
task destroy_carts: :environment do
  carts = Cart.all
  carts.each do |cart|
    cart.destroy if (Time.now - cart.created_at) >= (2 * 24 * 3600)
  end
end