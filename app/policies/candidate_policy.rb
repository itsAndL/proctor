class CandidatePolicy < ApplicationPolicy
  def index?
    user.business?
  end

  def show?
    user.business?
  end

  relation_scope do |relation|
    relation.joins(:assessments).where(assessments: { business: user.business }).distinct
  end
end
