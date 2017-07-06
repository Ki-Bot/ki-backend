ActiveAdmin.register UserBroadband do
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
  menu priority: 5
  permit_params :id, :broadband_id, :user_id

  actions :all, except: [:edit]

  index do
    id_column
    column :user
    column :broadband

    actions
  end

  filter :user
  filter :broadband_id

  form do |f|
    f.inputs 'New Broadband-User mapping' do
      f.input :user, placeholder: 'Select user here...'
      f.input :broadband_id, placeholder: 'Write Broadband Id here...'
      # f.input :password
      # f.input :password_confirmation
      # f.input :roles, as: :check_boxes, collection: [Role::SUPER_USER_ROLE]
      # f.collection_select :roles, [Role::SUPER_USER_ROLE, Role::USER_ROLE],:id, :name, include_blank: true
    end
    f.button :Submit
  end
end
