ActiveAdmin.register Category do
  permit_params :title, :parent_id, :tag, :icon, :published, :slug

  filter :title
  filter :parent
  filter :tag
  filter :published

  config.sort_order = 'tag_asc'
  sortable tree: false, sorting_attribute: :tag

  index :as => :sortable do
    label :title
    actions
  end

  show do |_|
    attributes_table do
      row :parent
      row :id
      row :title
      row :icon
      row :published
      row :tag
      row :slug
    end
  end

  form do |f|
    f.inputs 'Category Details' do
      f.input :parent
      f.input :title
      f.input :icon
      f.input :published
      f.input :tag
    end
    actions
  end
end
