ActiveAdmin.register User do
  permit_params :id, :name, :email, :password, :password_confirmation, :address, :address2, :phone,
                :state, :city, :zipcode, :country, :language, :created_at, :updated_at,
                :failed_attempts, :unlock_token, :locked_at

  filter :name
  filter :email
  filter :address
  filter :address2
  filter :phone
  filter :state
  filter :city
  filter :zipcode
  filter :country
  filter :language
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :name
    column :email
    column :address
    column :address2
    column :phone
    column :state
    column :city
    column :zipcode
    column :country
    column :language
    column :created_at
    column :updated_at
    actions
  end

  show do |t|
    attributes_table do
      row :name
      row :email
      row :address
      row :address2
      row :phone
      row :state
      row :city
      row :zipcode
      row :country
      row :language
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs 'Customer Details' do
      f.input :name
      f.input :email
#      f.input :password
#      f.input :password_confirmation
      f.input :address
      f.input :address2
      f.input :phone
      f.input :state
      f.input :city
      f.input :zipcode
      f.input :country, as: :string
      f.input :language
    end
    actions
  end

end