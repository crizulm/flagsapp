class FlagsController < ApplicationController
  def new
    @flags = Flag.new
  end

  def create
    @organization = Organization.find(current_user.organization_id)
    @flag = @organization.flags.new flag_params
    @report = Report.new(total_request: 0, true_answer: 0, false_answer: 0, total_time: 0)
    @flag.report = @report
    @flag.save
  end

  private

  def flag_params
    params.require(:flag).permit(:name)
  end

end
