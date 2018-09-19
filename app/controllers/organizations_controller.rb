class OrganizationsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:create_faq, :destroy_faq, :update_faq  ]


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
    @faq = Faq.new
    @broadband = Broadband.find(params[:id])
    @faqs = @broadband.faqs
    @user = User.find(@broadband.user_id)
  end

  def create_faq
    @faq = Faq.create(question: params[:que], answer: params[:ans], broadband_id: params[:broadband_id])
    @faq.save!
    respond_to do |format|
      format.html { redirect_to organization_path(@faq.broadband_id), notice: 'Faq was successfully created.' }
    end
  end

  def destroy_faq
    @faq = Faq.where(id: params[:id], broadband_id: params[:broadband_id])
    if @faq.first
      @faq.first.destroy
      render :json => { bool: @faq.first.id }
    end
  end

  def update_faq
    @faq = Faq.where(id: params[:id], broadband_id: params[:broadband_id])
    @faq.first.update(question: params[:que], answer: params[:ans])
    respond_to do |format|
      format.html { redirect_to organization_path(@faq.first.broadband_id), notice: 'Faq was successfully updated.'}
    end
  end

  def rating_review
    @broadband = Broadband.find(params[:id])
    @reviews = @broadband.reviews
    @user = User.find(@broadband.user_id)
  end
end