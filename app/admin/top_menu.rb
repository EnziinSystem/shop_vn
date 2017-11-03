ActiveAdmin.register TopMenu do
  permit_params :title, :icon, :link, :tag, :published

  config.sort_order = 'tag_asc'
  sortable tree: false, sorting_attribute: :tag

  index :as => :sortable do
    label :title
    actions
  end

  show do |t|
    attributes_table do
      row :id
      row :title
      row :icon
      row :link
      row :tag
      row :published
    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs do
      f.input :title
      f.input :icon
      f.input :link
      f.input :tag
      f.input :published
    end
    f.actions
  end

end
