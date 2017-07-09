ActiveAdmin.register Point do
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

  menu priority: 4
  permit_params :id, :broadband_id, :user_id

  actions :all, except: [:edit]

  index do
    id_column
    column :broadband_id
    column :user_id

    actions
  end

  filter :broadband_id
  filter :user_id

  form do |f|
    f.inputs 'New Point' do
      li do
        f.label :user_id
        f.select :user_id, options_for_select(User.all.collect {|u| [ u.name, u.id ] }), include_blank: true
      end
      f.input :broadband_id
    end
    f.button :Submit
  end

  # controller do
  #   def update
  #     begin
  #       update! do
  #         return render json: { url: admin_points_path }
  #       end
  #     rescue => e
  #       return render text: e.message
  #     end
  #   end
  #
  #   def destroy
  #     begin
  #       destroy! do
  #         return render json: { url: admin_points_path }
  #       end
  #     rescue => e
  #       return render text: e.message
  #     end
  #   end
  # end

end
