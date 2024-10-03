# frozen_string_literal: true

class SignInFormComponent < ViewComponent::Base
  def initialize(resource:, resource_name:, user_type:)
    @resource = resource
    @resource_name = resource_name
    @user_type = user_type
  end

  private

  attr_reader :resource, :resource_name, :user_type

  def new_registration_path
    send("new_#{user_type}_registration_path")
  end

  def session_path
    send("#{user_type}_session_path")
  end

  def title
    case user_type
    when :candidate
      'Sign in to your candidate account'
    when :business
      'Sign in to your business account'
    end
  end

  def another_user_type?
    case user_type
    when :candidate
      { question: 'Are you a business?', path: new_business_session_path }
    when :business
      { question: 'Are you a candidate?', path: new_candidate_session_path }
    end
  end
end
