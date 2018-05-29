class OrganizationsController < ApplicationController
  
  def activate
    @organization = Organization.find(params[:id])
  end

  def approved
    @organization = Organization.find(params[:id])
    if params["chars"].join == @organization.access_code
      @organization.is_approved = true
      @organization.save
    else
      render :json => { bool: false }
    end
  end

  def notfound
  
  end

  def show 
    @broadband = Broadband.find(params[:id])
    @user = User.find(@broadband.user_id)
  end

end