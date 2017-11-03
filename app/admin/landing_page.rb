ActiveAdmin.register LandingPage do
  permit_params :title, :content, :product_id, :cover_image

  index do
    selectable_column
    column :title
    column :product_id
    actions
  end

  show do |t|
    attributes_table do
      row :title
      row :product_id
      row 'Content' do
        t.content.html_safe
      end
      row :cover_image do
        t.cover_image? ? image_tag(t.cover_image.url, height: '100') : content_tag(:span, 'No photo yet')
      end
    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs do
      f.input :product
      f.input :title
      f.input :content, as: :ckeditor
      f.input :cover_image, as: :file, hint: f.landing_page.cover_image ? image_tag(landing_page.cover_image.url, height: '100') : content_tag(:span, 'Upload JPG/PNG/GIF image')
    end
    f.actions
  end
end
