ActiveAdmin.register Broadband do
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

  menu priority: 2
  config.per_page = 10

  permit_params :id, :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :latitude, :longitude, :publicwifi, :url

  index do
    id_column
    column :anchorname
    column :address
    column :bldgnbr
    column :predir
    column :streetname
    column :streettype
    column :suffdir
    column :city
    column :state_code
    column :zip5
    column :latitude
    column :longitude
    column :publicwifi
    column :url

    actions
  end

  filter :anchorname
  filter :address
  filter :bldgnbr
  filter :predir
  filter :streetname
  filter :streettype
  filter :suffdir
  filter :city
  filter :state_code
  filter :zip5
  filter :latitude
  filter :longitude
  filter :publicwifi
  filter :url

  # controller do
  #   def update
  #     begin
  #       update! do
  #         return render json: { url: admin_broadbands_path }
  #       end
  #     rescue => e
  #       return render text: e.message
  #     end
  #   end
  #
  #   def destroy
  #     begin
  #       destroy! do
  #         return render json: { url: admin_broadbands_path }
  #       end
  #     rescue => e
  #       return render text: e.message
  #     end
  #   end
  # end

end
