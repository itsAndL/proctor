class AssessmentParticipationPolicy < ApplicationPolicy
  def index?
    participant? || user.business?
  end

  def create?
    user.business?
  end

  def show?
    user.business? || participant?
  end

  def update?
    user.business?
  end

  def start?
    participant?
  end

  def checkout?
    participant?
  end

  def delete_confirmation?
    owner?
  end

  def destroy?
    owner?
  end

  def send_reminder?
    owner?
  end

  def report?
    owner?
  end

  def rate?
    owner?
  end

  def share?
    owner?
  end

  def activate_public_link?
    owner?
  end

  def deactivate_public_link?
    owner?
  end

  def public_link?
    owner?
  end

  def invite_me?
    owner?
  end

  def invite?
    owner?
  end

  def check_candidate?
    owner?
  end

  def post_invite?
    owner?
  end

  def bulk_invite?
    owner?
  end

  def bulk_invite_upload?
    owner?
  end

  def bulk_invite_template?
    owner?
  end

  relation_scope do |relation|
    next relation if user.business?

    relation.where(candidate: user.candidate)
  end

  private

  def participant?
    user.candidate? && record.candidate == user.candidate
  end

  def owner?
    user.business? && record.business == user.business
  end
end
