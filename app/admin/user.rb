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

  # permit_params :provider, :uid, :name, roles: []
  permit_params :id, :name, :email
  
  index do
    id_column

    column :name
    column :email
    column :roles
    # column :provider
    # column :uid
    # column :name
    # column :roles
    # column :oauth_expires_at
    # column :oauth_token
    # column :created_at
    # column :updated_at

    actions
  end

  filter :id
  filter :name
  filter :email
  # filter :roles, as: :check_boxes, collection: [Role::SUPER_USER_ROLE, Role::USER_ROLE]

  # sidebar 'User Favorites', only: [:show, :edit] do
  #   ul do
  #     li link_to 'Favorites', admin_user_points_path(resource)
  #   end
  # end



  form do |f|
    f.inputs 'New User' do
      f.input :name
      f.input :email
      # f.input :password
      # f.input :password_confirmation
      # f.input :roles, as: :check_boxes, collection: [Role::SUPER_USER_ROLE]
      # f.collection_select :roles, [Role::SUPER_USER_ROLE, Role::USER_ROLE],:id, :name, include_blank: true
    end
    f.button :Submit
  end

  controller do
    def create
      begin
        @user = User.new(user_params)
        generated_password = Devise.friendly_token.first(8)
        @user.password = generated_password
        @user.password_confirmation = generated_password
        @user.save!
        Thread.new do
          RegistrationMailer.welcome(@user).deliver
        end
        redirect_to admin_users_path
      rescue => e
        return render text: e.message
      end

      # super
    end

    # def update
    #   begin
    #     @user = User.find(params[:id])
    #     @user.update!(user_params)
    #     return render json: { url: admin_users_path }
    #   rescue => e
    #     return render json: { message: e.message }
    #   end
    # end
    #
    # def destroy
    #   begin
    #     destroy! do
    #       return render json: { url: admin_users_path }
    #     end
    #   rescue => e
    #     return render json: { message: e.message }
    #   end
    # end

    private
    def user_params
      params.require(:user).permit(:name, :email, roles: [])
    end
  end

end
