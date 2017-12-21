ActiveAdmin.register Order do
  permit_params :id, :user_id, :order_number, :total, :payment_type,
                :status

  index do
    selectable_column
    column :id
    column :user_id
    column :order_number
    column :total
    column :payment_type
    column :status
    actions
  end

  show do |t|
    attributes_table do
      row :id
      row :user_id
      row :order_number
      row :total
      row :payment_type
      row :status
    end
  end

  form html: {enctype: 'multipart/form-data'} do |f|
    f.inputs do
      f.input :order_number
      f.input :total
      f.input :payment_type
      f.input :status
    end
    f.actions
  end
end
