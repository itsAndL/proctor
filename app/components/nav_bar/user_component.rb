# frozen_string_literal: true

class NavBar::UserComponent < ViewComponent::Base
  include SecondaryRootPath

  attr_reader :user

  def initialize(user)
    super
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
      { title: t('.assessments'), path: assessments_path },
      { title: t('.candidates'), path: customer_candidates_path }
    ]
  end

  def candidate_navbar_links
    [{ title: t('.my_assessments'), path: candidate_assessment_participations_path }]
  end

  def user_navbar_links
    []
  end

  def business_dropdown_links
    profile_path = user.business.persisted? ? edit_business_path(user.business) : new_business_path

    [
      { title: t('.settings'), path: profile_path },
      { title: t('.test_library'), path: test_library_index_path },
      { title: t('.custom_questions_library'), path: custom_question_library_index_path }
    ]
  end

  def candidate_dropdown_links
    profile_path = user.candidate.persisted? ? edit_candidate_path(hashid: user.candidate) : new_candidate_path

    [
      { title: t('.settings'), path: profile_path }
    ]
  end

  def user_dropdown_links
    [
      { title: t('.settings'), path: edit_user_registration_path },
      { title: t('.get_started'), path: new_role_path }
    ]
  end
end
