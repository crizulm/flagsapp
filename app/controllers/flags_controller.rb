class FlagsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  before_action :authenticate_admin!, only: [:new, :create, :change, :destroy]

  def new
    @flag = Flag.new
  end

  def index
    @flags = Flag.where(organization_id: current_user.organization_id, is_deleted: false).includes(:organization)
  end

  def show
    @flag = Flag.includes(:organization).find(params[:id])
    @external_users = ExternalUser.where(flag_id: params[:id])
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
    @flag.report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0, new_request: 0, new_true_answer: 0)
    @flag.is_deleted = false
    @flag.last_update = DateTime.current
    @flag_record = @flag.flag_records.new date_start: Date.current, active: @flag.active, date_end: Date.parse('1900-01-01')
    @flag_record.save
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
    @max_id = FlagRecord.where(flag_id: @flag.id).maximum(:id)
    @flag_record = FlagRecord.find(@max_id)
    @flag_record.date_end = Date.current
    @flag_record.save
    @flag_record_new = @flag.flag_records.new date_start: Date.current, active: @flag.active, date_end: Date.parse('1900-01-01')
    @flag_record_new.save
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

  def start_evaluate(flag, external_id)
    result = case flag.style_flag
             when 2
               evaluate_percentage_flag(external_id, flag)
             when 3
               evaluate_list_flag(external_id, flag)
             else
               evaluate_boolean_flag(flag)
             end
    result
  end

  def evaluate_boolean_flag(flag)
    method_return = true
    unless flag.is_deleted
      method_return = flag.active
      set_report(flag, method_return)
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
        set_report(flag, method_return)
      end
    end
    method_return
  end

  def evaluate_new_user(external_id, flag)
    report = Report.where(flag_id: flag.id).first
    percentage = report.new_request.positive? ? (report.new_true_answer * 100) / report.new_request : 0
    report.new_request = report.new_request + 1
    method_return = set_new_external_user(external_id, flag, flag.percentage > percentage, report)
    report.save
    method_return
  end

  def set_new_external_user(external_id, flag, value, report)
    report.new_true_answer = report.new_true_answer + 1 if value
    external_new_user = flag.external_users.new user_id: external_id, active: value
    external_new_user.save
    value
  end

  def evaluate_list_flag(external_id, flag)
    method_return = true
    unless flag.is_deleted
      method_return = false
      if flag.active
        external_user = ExternalUser.where(flag_id: flag.id, user_id: external_id).first
        method_return = !external_user.nil?
        set_report(flag, method_return)
      end
    end
    method_return
  end

  def set_report(flag, result)
    report = Report.where(flag_id: flag.id).first
    report.total_request = report.total_request + 1
    if result
      report.true_answer = report.true_answer + 1
    else
      report.false_answer = report.false_answer + 1
    end

    report.save
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

  def set_time(flag, time)
    report = Report.where(flag_id: flag.id).first
    report.total_time = report.total_time + time
    report.save
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
    date_sql = date == '' ? '1900-01-01' : date
    result = "SELECT f.*
       FROM flags f, flag_records fr
       where fr.flag_id = f.id and
       f.organization_id = " + current_user.organization_id.to_s + " and
       fr.active = " + state_date + " and fr.date_start <= '" + date_sql + "'
       and (fr.date_end >= '" + date_sql + "' or fr.date_end = '1900-01-01')
       GROUP BY f.id"
    result
  end
end
