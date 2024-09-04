class Candidate < ApplicationRecord
  include Avatarable
  include Hashid::Rails
  include PgSearch::Model

  belongs_to :user

  has_many :assessment_participations, dependent: :destroy
  has_many :assessments, through: :assessment_participations

  validates :name, presence: true

  delegate :email, to: :user

  scope :with_email, lambda { |email|
    joins(:user).where("LOWER(users.email) = LOWER(?)", email)
  }

  pg_search_scope :filter_by_search_query,
                  against: :name,
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.find_by_email(email)
    with_email(email).first
  end

  def last_activity
    assessment_participations.map(&:last_activity).max
  end
end
