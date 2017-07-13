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

  controller do
    def create
      # begin
        user_id = params['user_broadband']['user_id']
        arr = []
        params['broadband_ids'].each do |broadband_id|
          arr << { user_id: user_id, broadband_id: broadband_id } unless broadband_id == ''
        end
        UserBroadband.create!(arr)
        return redirect_to admin_user_broadbands_path
      # rescue => e
      #   return render text: e.message
      # end
    end

    def update
      begin
        update! do
          return render json: { url: admin_broadbands_path }
        end
      rescue => e
        return render text: e.message
      end
    end
  end

  form do |f|
    f.inputs 'New Broadband-User mapping' do
      f.input :user, placeholder: 'Select user here...'
      # f.input :broadband_id, placeholder: 'Write Broadband Id here...'
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }
      f.input :broadband_id, input_html: { name: 'broadband_ids[]' }

      # f.input :password
      # f.input :password_confirmation
      # f.input :roles, as: :check_boxes, collection: [Role::SUPER_USER_ROLE]
      # f.collection_select :roles, [Role::SUPER_USER_ROLE, Role::USER_ROLE],:id, :name, include_blank: true
    end
    f.button :Submit
  end
end
