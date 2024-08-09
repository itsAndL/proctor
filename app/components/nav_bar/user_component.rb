# frozen_string_literal: true

class NavBar::UserComponent < ViewComponent::Base
  include SecondaryRootPath

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def navbar_links
    if user.business&.persisted?
      business_navbar_links
    elsif user.candidate&.persisted?
      candidate_navbar_links
    else
      user_navbar_links
    end
  end

  def dropdown_links
    if user.business&.persisted?
      business_dropdown_links
    elsif user.candidate&.persisted?
      candidate_dropdown_links
    else
      user_dropdown_links
    end
  end

  def mobile_links
    navbar_links.concat(dropdown_links)
  end

  private

  def business_navbar_links
    [
      { title: 'Assessments', path: customer_assessments_path },
      { title: 'Candidates', path: customer_candidates_path }
    ]
  end

  def candidate_navbar_links
    [{ title: 'Assessments', path: candidate_assessments_path }]
  end

  def user_navbar_links
    []
  end

  def business_dropdown_links
    profile_path = user.business.persisted? ? edit_business_path(user.business) : new_business_path

    [
      { title: 'My account', path: edit_user_registration_path },
      { title: 'My business profile', path: profile_path },
      { title: 'Test Library', path: test_library_index_path },
      { title: 'Custom Questions Library', path: custom_question_library_index_path }
    ]
  end

  def candidate_dropdown_links
    profile_path = user.candidate.persisted? ? edit_candidate_path(user.candidate) : new_candidate_path

    [
      { title: 'My account', path: edit_user_registration_path },
      { title: 'My candidate profile', path: profile_path }
    ]
  end

  def user_dropdown_links
    [
      { title: 'My account', path: edit_user_registration_path },
      { title: 'Get started', path: new_role_path }
    ]
  end
end
