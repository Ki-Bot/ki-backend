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

  permit_params :id, :anchorname, :address, :bldgnbr, :predir, :streetname, :streettype, :suffdir, :city, :state_code, :zip5, :latitude, :longitude, :publicwifi, :url, :detail, :broadband_type_id, :banner, :logo, :opening_hours_attributes => [:id, :day, :from, :to, :closed]

  index do
    id_column
    column :anchorname
    column :address
    # column :bldgnbr
    # column :predir
    column :streetname
    column :streettype
    # column :suffdir
    column :city
    column :state_code
    column :zip5
    column :latitude
    column :longitude
    column :publicwifi
    column :url
    column :broadband_type
    column 'Logo' do |broadband|
      broadband.logo_file_name
    end
    column 'Banner' do |broadband|
      broadband.banner_file_name
    end
    column 'Opening Days Count' do |broadband|
      broadband.opening_hours.count
    end
    # column 'Logo' do |event|
    #   link_to(image_tag(event.logo.url(:thumb), :height => '100'), admin_broadband_path(event))
    # end

    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :anchorname
      f.input :address
      f.input :bldgnbr
      f.input :predir
      f.input :streetname
      f.input :streettype
      f.input :suffdir
      f.input :city
      f.input :state_code
      f.input :zip5
      f.input :latitude
      f.input :longitude
      f.input :publicwifi
      f.input :url
      f.input :detail
      f.input :broadband_type
      f.input :logo, as: :file
      f.input :banner, as: :file
      f.has_many :opening_hours do |item|
        item.input :day
        item.input :from, :as => :time_picker
        item.input :to, :as => :time_picker
        item.input :closed
      end
    end
    f.actions
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
  filter :broadband_type

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
