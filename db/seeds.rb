# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

root_category = Category.create(title: 'Information Technology', icon: 'settings', published: true, tag: 0)

for i in 1..5
  category = Category.create(title: 'Category ' + i.to_s, parent_id: root_category.id, icon: 'settings', published: true, tag: i)

  for j in 1..5
    index_product = i * 10 + j
    product = Product.create(name: 'Product ' + index_product.to_s, content: 'Content here.', category_id: category.id)
  end
end

