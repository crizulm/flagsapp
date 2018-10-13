class FlagsController < ApplicationController
  def new
    @flag = Flag.new
  end

  def create
    @organization = Organization.find(current_user.organization_id)
    @flag = @organization.flags.new flag_params
    @flag.token = Base64.encode64(SecureRandom.uuid)
    @report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0)
    @flag.report = @report
    @flag.save
  end

  private

  def flag_params
    params.require(:flag).permit(:name, :active, :style_function, :percentage)
  end

end
