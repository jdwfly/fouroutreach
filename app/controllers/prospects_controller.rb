class ProspectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prospect, only: [:show, :edit, :update, :destroy]

  def index
    @prospects = current_user.prospects.paginate(page: params[:page], per_page: 10)
  end

  def show
    authorize! :read, @prospect
  end

  def new
    @prospect = current_user.prospects.new
  end

  def create
    @prospect = current_user.prospects.new(prospect_params)
    if @prospect.save
      flash[:success] = "Prospect successfully created!"
      redirect_to @prospect
    else
      render 'new'
    end
  end

  def edit
    authorize! :update, @prospect
  end

  def update
    authorize! :update, @prospect
    if @prospect.update(prospect_params)
      flash[:success] = "Prospect information updated!"
      redirect_to @prospect
    else
      render 'edit'
    end
  end

  def destroy
    Prospect.find(params[:id]).destroy
    flash[:success] = "Prospect deleted!"
    redirect_to prospects_url
  end

  private
    def set_prospect
      @prospect = Prospect.find(params[:id])
    end

    def prospect_params
      params.require(:prospect).permit(:name,
                                       :address,
                                       :city,
                                       :state,
                                       :zip,
                                       :phone,
                                       :email,
                                       :point_of_contact,
                                       :interests,
                                       :comments,
                                       :date_first_contact)
    end
end
