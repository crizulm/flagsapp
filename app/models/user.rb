class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  mount_uploader :picture, UserPictureUploader
  belongs_to :organization

  def self.create_from_omniauth(auth)
    auth_credential = where(provider: auth.provider, uid: auth.uid).first
    if !auth_credential.nil?
      user = auth_credential
    else
      user = User.new
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.picture = auth.info.picture
      user.password = Devise.friendly_token[0,20]
      user.is_admin = true
      organization = Organization.new
      organization.name = 'Organization ' + user.email
      organization.save
      user.organization = organization
      user.save!
    end
  end

  def apply_omniauth(auth)
    update_attributes(
        provider: auth.provider,
        uid: auth.uid
    )
  end

end
