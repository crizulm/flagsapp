class Invite < ApplicationRecord
  before_create :generate_token
  belongs_to :sender, class_name: 'User'
  belongs_to :organization, class_name: 'Organization'
  validates :email, presence: true
  def generate_token
    self.token = Digest::SHA1.hexdigest([self.organization_id, Time.now, rand].join)
  end
end
