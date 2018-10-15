class ExternalUser < ApplicationRecord
  belongs_to :flag, foreign_key: :flag_id, optional: true
end
