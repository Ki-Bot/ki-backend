ActiveAdmin.register Organization do
  actions :index
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  menu priority: 8

  # permit_params :provider, :uid, :name, roles: []
  # permit_params :id, :name, :email

  index do
    id_column

    column :name
    column :email
    column :manager_name
    column :phone_no
    column :address
    column :user_id
    column :access_code
    column :summary
    column :streetname
    column :state_code
    column :zip5
    column :broadband_type
    # column :name
    # column :roles
    # column :oauth_expires_at
    # column :oauth_token
    # column :created_at
    # column :updated_at

  end

  filter :id
end