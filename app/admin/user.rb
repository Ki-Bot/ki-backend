ActiveAdmin.register User do
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

  menu priority: 3

  permit_params :provider, :uid, :name, roles: []

  index do
    id_column

    column :provider
    column :uid
    column :name
    column :roles
    # column :oauth_expires_at
    # column :oauth_token
    # column :created_at
    # column :updated_at

    actions
  end

  filter :id
  filter :provider
  filter :uid
  filter :name
  filter :roles, as: :check_boxes, collection: [Role::SUPER_USER_ROLE, Role::USER_ROLE]

  form do |f|
    f.inputs 'New User' do
      f.input :provider
      f.input :uid
      f.input :name
      f.input :roles, as: :check_boxes, collection: [Role::SUPER_USER_ROLE]
      # f.collection_select :roles, [Role::SUPER_USER_ROLE, Role::USER_ROLE],:id, :name, include_blank: true
    end
    f.button :Submit
  end

  controller do
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path
      end
      # super
    end

    def update
      update! do |format|
        return render json: { url: admin_users_path }
      end
    end

    def destroy
      destroy! do |format|
        return render json: { url: admin_users_path }
      end
    end

    private
    def user_params
      params.require(:user).permit(:provider, :uid, :name, roles: [])
    end
  end
end