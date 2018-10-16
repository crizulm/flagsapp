class FlagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :index]

  def new
    @flag = Flag.new
  end

  def index
    @flags = Flag.where(organization_id: current_user.organization_id, is_deleted: false).includes(:organization)
  end

  def show
    @external_id = request.headers['client-id']
    @flag = Flag.where(auth_token: params[:id])

    @result = case @flag.style_function
              when '2'
                evaluate_percentage_flag(@external_id, @flag)
              when '3'
                evaluate_list_flag(@external_id, @flag)
              else
                evaluate_boolean_flag(@external_id, @flag)
              end

    render json: { data: @result }, status: :ok
  end

  def create
    @flag = set_flag
    @flag.report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0)
    @flag.is_deleted = false
    @flag.last_update = DateTime.current
    if @flag.save
      redirect_to flags_path
    else
      render :new
    end
  end

  def change
    @flag = Flag.find(params[:id])

    @flag.active = !@flag.active
    @flag.last_update = DateTime.current
    @flag.save

    redirect_to flags_path
  end

  def destroy
    @flag = Flag.find(params[:id])
    @flag.is_deleted = true
    @flag.save

    redirect_to flags_path
  end

  private

  def evaluate_boolean_flag(external_id, flag)
    set_report(flag)
  end

  def evaluate_percentage_flag(external_id, flag)
    set_report(flag)
  end

  def evaluate_list_flag(external_id, flag)
    set_report(flag)
  end

  def set_report(flag); end

  def set_flag
    @organization = Organization.find(current_user.organization_id)
    @flag = case params[:flag][:style_function]
            when '2'
              @organization.flags.new flag_params_percentage_type
            when '3'
              @organization.flags.new flag_params_list_type
            else
              @organization.flags.new flag_params_boolean_type
            end
    @flag
  end

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
