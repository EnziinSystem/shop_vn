ActiveAdmin.register Slide do
  permit_params :align, :content, :image

  index do
    selectable_column
    column :id
    column :align
    column :content
    actions
  end

  show do |t|
    attributes_table do
      row :id
      row :align
      row 'Content' do
        t.content.html_safe
      end
      row :image do
        t.image? ? image_tag(t.image.url, height: '100') : content_tag(:span, 'No photo yet')
      end
    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs do
      f.input :align
      f.input :content, as: :ckeditor
      f.input :image, as: :file, hint: f.slide.image? ? image_tag(slide.image.url, height: '100') : content_tag(:span, 'Upload JPG/PNG/GIF image')
    end
    f.actions
  end

end
