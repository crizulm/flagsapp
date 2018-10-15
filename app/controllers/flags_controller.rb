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

    @flag = case params[:flag][:style_function]
            when '2'
              @organization.flags.new flag_params_percentage_type
            when '3'
              @organization.flags.new flag_params_list_type
            else
              @organization.flags.new flag_params_boolean_type
            end
    @flag.token = Base64.encode64(SecureRandom.uuid)
    @flag.last_update = DateTime.current
    @report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0)
    @flag.report = @report
    if @flag.save
      return redirect_to flags_path
    end
  end

  def change
    @flag = Flag.find(params[:id])

    @flag.active = !@flag.active
    @flag.last_update = DateTime.current
    @flag.save

    redirect_to flags_path
  end

  private

  def flag_params_boolean_type
    @params = params.require(:flag).permit(:name, :active, :style_function)
  end

  def flag_params_percentage_type
    @params = params.require(:flag).permit(:name, :active, :style_function, :percentage)
  end

  def flag_params_list_type
    @params = params.require(:flag).permit(:name, :active, :style_function, external_users_attributes: [:id, :user_id, :active])
  end
end
