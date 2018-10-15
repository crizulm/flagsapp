class FlagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :index]

  def new
    @flag = Flag.new
  end

  def index
   @flags = Flag.where(organization_id: current_user.organization_id).includes(:organization)
  end

  def create
    @organization = Organization.find(current_user.organization_id)
    @flag = @organization.flags.new flag_params
    @flag.token = Base64.encode64(SecureRandom.uuid)
    @report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0)

    if @flag.style_function == 2
      @flag.percentage = params[:flag][:percentage]
    end

    @flag.report = @report
    @flag.save
  end

  def update
    @flag = Flag.find(params[:id])

    @flag.active = !@flag.active
    @flag.save

    redirect_to flags_path
  end

  private

  def flag_params
    params.require(:flag).permit(:name, :active, :style_function, external_users_attributes: [:id, :user_id, :active])
  end

end
