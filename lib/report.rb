class Report
  include ActiveModel::Serializers::JSON
  attr_accessor :total_request, :true_answer, :false_answer, :total_time
end
