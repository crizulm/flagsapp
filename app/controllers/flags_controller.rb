class FlagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :index, :create, :change]

  def new
    @flag = Flag.new
  end

  def index
    @flags = Flag.where(organization_id: current_user.organization_id, is_deleted: false).includes(:organization)
  end

  def show
    @external_id = request.headers['client-id']
    @flag = Flag.where(auth_token: params[:id]).first
    return render json: { data: 'Error flag not found' }, status: 400 if @flag.nil?
    @result = case @flag.style_flag
              when 2
                evaluate_percentage_flag(@external_id, @flag)
              when 3
                evaluate_list_flag(@external_id, @flag)
              else
                evaluate_boolean_flag(@flag)
              end

    render json: { data: @result }, status: :ok
  end

  def create
    @flag = set_flag
    @flag.report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0, new_request: 0, new_true_answer: 0)
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

  def evaluate_boolean_flag(flag)
    @return = true
    unless flag.is_deleted
      @return = flag.active
      set_report(flag, @return)
    end
    @return
  end

  def evaluate_percentage_flag(external_id, flag)
    @return = true
    unless flag.is_deleted
      @return = false
      if flag.active
        @external_user = ExternalUser.where(flag_id: flag.id, user_id: external_id).first
        @return = !@external_user.nil? ? @external_user.active : evaluate_new_user(external_id, flag)
        set_report(flag, @return)
      end
    end
    @return
  end

  def evaluate_new_user(external_id, flag)
    @report = Report.where(flag_id: flag.id).first
    @percentage = if @report.new_request.positive?
                    (@report.new_true_answer * 100) / @report.new_request
                  else
                    0
                  end
    @report.new_request = @report.new_request + 1
    @return = if flag.percentage > @percentage
                @report.new_true_answer = @report.new_true_answer + 1
                @external_new_user = flag.external_users.new user_id: external_id, active: true
                @external_new_user.save
                true
              else
                @external_new_user = flag.external_users.new user_id: external_id, active: false
                @external_new_user.save
                false
              end
    @report.save
    @return
  end

  def evaluate_list_flag(external_id, flag)
    @return = true
    unless flag.is_deleted
      @return = false
      if flag.active
        @external_user = ExternalUser.where(flag_id: flag.id, user_id: external_id).first
        @return = !@external_user.nil?
        set_report(flag, @return)
      end
    end
    @return
  end

  def set_report(flag, result)
    @report = Report.where(flag_id: flag.id).first
    @report.total_request = @report.total_request + 1
    if result
      @report.true_answer = @report.true_answer + 1
    else
      @report.false_answer = @report.false_answer + 1
    end

    @report.save
  end

  def set_flag
    @organization = Organization.find(current_user.organization_id)
    @flag = case params[:flag][:style_flag]
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
    @params = params.require(:flag).permit(:name, :active, :style_flag)
  end

  def flag_params_percentage_type
    @params = params.require(:flag).permit(:name, :active, :style_flag, :percentage)
  end

  def flag_params_list_type
    @params = params.require(:flag).permit(:name, :active, :style_flag, external_users_attributes: [:id, :user_id, :active])
  end
end
