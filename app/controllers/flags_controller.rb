require 'reports_service'

class FlagsController < ApplicationController
  include ReportsService
  before_action :authenticate_user!, only: [:index, :show]
  before_action :authenticate_admin!, only: [:new, :create, :change, :destroy]

  def new
    healthcheck = healthcheck_report
    if !healthcheck
      render :healthcheck_report_fail
    else
      @flag = Flag.new
    end
  end

  def index
    @flags = Flag.where(organization_id: current_user.organization_id, is_deleted: false).includes(:organization)
  end

  def show
    flag_token = params[:id]
    if validate_is_organization_user(flag_token)
      @flag = Flag.includes(:organization).find(flag_token)
      @external_users = ExternalUser.where(flag_id: flag_token)
      @flag_state = FlagRecord.where(flag_id: flag_token)
      @evaluate_history = EvaluateHistory.where(flag_id: flag_token)
    else
      redirect_to flags_path
    end
  end

  def evaluate
    flag = Flag.where(auth_token: params[:id]).first
    return render json: { data: 'Error flag not found' }, status: 400 if flag.nil?

    start_time = Time.now
    result = start_evaluate(flag, request.headers['client-id'])
    end_time = Time.now
    render json: { data: result }, status: :ok
    set_time(flag, (end_time - start_time))
  end

  def filter
    @flags = evaluate_filter
    render :index
  end

  def create
    @flag = set_flag
    @flag.is_deleted = false
    @flag.flag_request = FlagRequest.new(new_request: 0, new_true_answer: 0)
    @flag.last_update = DateTime.current
    @flag_record = @flag.flag_records.new date_start: DateTime.current, active: @flag.active, date_end: Date.parse('1900-01-01')
    @flag_record.save
    if @flag.save
      create_report(@flag.auth_token)
      redirect_to flags_path
    else
      render :new
    end
  end

  def change
    flag_token = params[:id]
    if validate_is_organization_user(flag_token)
      @flag = Flag.find(flag_token)

      date_current = DateTime.current
      @flag.active = !@flag.active
      @flag.last_update = date_current
      @max_id = FlagRecord.where(flag_id: @flag.id).maximum(:id)
      @flag_record = FlagRecord.find(@max_id)
      @flag_record.date_end = date_current
      @flag_record.save
      @flag_record_new = @flag.flag_records.new date_start: date_current, active: @flag.active, date_end: Date.parse('1900-01-01')
      @flag_record_new.save
      @flag.save

      redirect_to flags_path
    else
      redirect_to flags_path
    end
  end

  def destroy
    flag_token = params[:id]
    if validate_is_organization_user(flag_token)
      @flag = Flag.find(flag_token)
      @flag.is_deleted = true
      @flag.save

      redirect_to flags_path
    else
      redirect_to flags_path
    end
  end

  private

  def validate_is_organization_user(flag_token)
    flag = Flag.includes(:organization).find(flag_token)
    current_user.organization.id == flag.organization.id
  end

  def start_evaluate(flag, external_id)
    result = case flag.style_flag
             when 2
               evaluate_percentage_flag(external_id, flag)
             when 3
               evaluate_list_flag(external_id, flag)
             else
               evaluate_boolean_flag(flag, external_id)
             end
    result
  end

  def evaluate_boolean_flag(flag, external_id)
    method_return = true
    unless flag.is_deleted
      method_return = flag.active
      set_result(flag, method_return)
      set_evaluate(external_id, flag, method_return)
    end
    method_return
  end

  def evaluate_percentage_flag(external_id, flag)
    method_return = true
    unless flag.is_deleted
      method_return = false
      if flag.active
        external_user = ExternalUser.where(flag_id: flag.id, user_id: external_id).first
        method_return = !external_user.nil? ? external_user.active : evaluate_new_user(external_id, flag)
        set_result(flag, method_return)
      end
      set_evaluate(external_id, flag, method_return)
    end
    method_return
  end

  def evaluate_new_user(external_id, flag)
    flag_request = FlagRequest.where(flag_id: flag.id).first
    percentage = flag_request.new_request.positive? ? (flag_request.new_true_answer * 100) / flag_request.new_request : 0
    flag_request.new_request = flag_request.new_request + 1
    method_return = set_new_external_user(external_id, flag, flag.percentage > percentage, flag_request)
    flag_request.save
    method_return
  end

  def set_new_external_user(external_id, flag, value, flag_request)
    flag_request.new_true_answer = flag_request.new_true_answer + 1 if value
    external_new_user = flag.external_users.new user_id: external_id, active: value
    external_new_user.save
    value
  end

  def set_evaluate(external_id, flag, value)
    evaluate = flag.evaluate_histories.new user_id: external_id, active: value, date: DateTime.current
    evaluate.save
  end

  def evaluate_list_flag(external_id, flag)
    method_return = true
    unless flag.is_deleted
      method_return = false
      if flag.active
        external_user = ExternalUser.where(flag_id: flag.id, user_id: external_id).first
        method_return = !external_user.nil?
        set_result(flag, method_return)
      end
      set_evaluate(external_id, flag, method_return)
    end
    method_return
  end

  def set_result(flag, result)
    healthcheck = healthcheck_report
    update_report_result(flag.auth_token, result) if healthcheck
  end

  def set_time(flag, time)
    healthcheck = healthcheck_report
    update_report_time(flag.auth_token, time)  if healthcheck
  end

  def set_flag
    organization = Organization.find(current_user.organization_id)
    flag = obtain_flag(organization)
    flag
  end

  def obtain_flag(organization)
    flag = case params[:flag][:style_flag]
           when '2'
             organization.flags.new flag_params_percentage_type
           when '3'
             organization.flags.new flag_params_list_type
           else
             organization.flags.new flag_params_boolean_type
           end
    flag
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

  def evaluate_filter
    case params[:style_filter]
    when '2'
      filter_name(params[:name])
    when '3'
      filter_state(params[:state])
    when '4'
      filter_date(params[:date], params[:state_date])
    else
      filter_type(params[:style_flag].to_i)
    end
  end

  def filter_type(selected_type)
    Flag.where(organization_id: current_user.organization_id, is_deleted: false, style_flag: selected_type).includes(:organization)
  end

  def filter_name(name)
    Flag.where(organization_id: current_user.organization_id, is_deleted: false, name: name).includes(:organization)
  end

  def filter_state(state)
    Flag.where(organization_id: current_user.organization_id, is_deleted: false, active: state).includes(:organization)
  end

  def filter_date(date, state_date)
    results = ActiveRecord::Base.connection.execute(cast_consult(date, state_date))
    cast_json(results)
  end

  def cast_json(list)
    result = []
    list.each do |i|
      new_flag = Flag.new
      result.push(new_flag.from_json(i.to_json))
    end
    result
  end

  def cast_consult(date, state_date)
    date_sql_start = date == '' ? '1900-01-01' : (date + ' 23:59:59.504718')
    date_sql_end = date == '' ? '1900-01-01' : (date + ' 00:00:00.504718')
    result = "SELECT f.*
       FROM flags f, flag_records fr
       where fr.flag_id = f.id and f.is_deleted = false and
       f.organization_id = " + current_user.organization_id.to_s + " and
       fr.active = " + state_date + " and fr.date_start <= '" + date_sql_start + "'
       and (fr.date_end >= '" + date_sql_end + "' or fr.date_end = '1900-01-01')
       GROUP BY f.id"
    result
  end
end