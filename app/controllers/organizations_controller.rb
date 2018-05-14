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
      render :template => "organizations/error"
    end
  end

end