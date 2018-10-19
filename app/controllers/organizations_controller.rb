class OrganizationsController < ApplicationController
  layout 'organization', only: [:profile]

  skip_before_action :verify_authenticity_token, :only => [:create_faq, :destroy_faq, :update_faq  ]
  before_action :get_broadband, only: [:profile]
  before_action :set_env_vars, only: [:profile]

  def activate
    @broadband = Broadband.find(params[:id])
  end

  def approved
    @broadband = Broadband.find(params[:id])
    if params["chars"].join == @broadband.access_code
      @broadband.is_approved = true
      @broadband.save
      user = @broadband.user
      user.confirm
      user.send_reset_password_instructions
    else
      render :json => { bool: false }
    end
  end

  def notfound
  
  end

  def show 
    @faq = Faq.new
    @broadband = Broadband.find(params[:id])
    if @broadband.banner.exists?
      @banner = @broadband.banner.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com'
    else
      @banner = '../assets/top-md.jpg'
    end
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
    if @broadband.banner.exists?
      @banner = @broadband.banner.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com'
    else
      @banner = '/assets/top-md.jpg'
    end
    @reviews = @broadband.reviews
    @user = User.find(@broadband.user_id)
  end

  def profile

  end

  def ongoing_chat
    @sender          = User.find_by(id: params["sender_id"])
    @message         = params["message_obj"]["message"]
    @organization_id = params["id"]

    render partial: 'ongoing_chat'
  end

  def single_chat
    @sender          = User.find_by(id: params["sender_id"])
    @message         = params["message_obj"]["message"]
    @organization_id = params["id"]
    # @broadband_name  = Broadband.find_by(id: @organization_id).try(:broadband_type).try(:name)
    render partial: 'single_chat', locals: {message: @message, sender: @sender } # , organization_name: @broadband_name }
  end

  def chat
    @sender          = User.find_by(id: params["sender_id"])
    @chat_messages   = params["chat_messages"].values
    @organization_id = params["id"]
    @broadband       = Broadband.find_by(id: @organization_id) #.try(:broadband_type).try(:name)
    @broadband_name  = @broadband.try(:broadband_type).try(:name)
    
      
    if @broadband.banner.exists?
      @banner = @broadband.banner.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com'
    else
      @banner = '../../assets/top-md.jpg'
    end

    render partial: 'chat'
  end

  private
    def get_broadband
      @broadband = Broadband.find_by(id: params[:id])
      # @user = User.find_by(id: @broadband.user_id)
      @user      = current_user
      
      if @broadband.banner.exists?
        @banner = @broadband.banner.url.gsub '//s3.amazonaws.com', 'https://s3.us-east-2.amazonaws.com'
      else
        @banner = '../../assets/top-md.jpg'
      end
    end

    def set_env_vars
        gon.FIREBASE = {
          "API_KEY"               => ENV["FIREBASE_API_KEY"],
          "AUTH_DOMAIN"           => ENV["FIREBASE_AUTH_DOMAIN"],
          "DATABASE_URL"          => ENV["FIREBASE_DATABASE_URL"],
          "PROJECT_ID"            => ENV["FIREBASE_PROJECT_ID"],
          "STORAGE_BUCKET"        => ENV["FIREBASE_STORAGE_BUCKET"],
          "MESSAGING_SENDER_ID"   => ENV["FIREBASE_MESSAGING_SENDER_ID"]
        }
    end
    
end