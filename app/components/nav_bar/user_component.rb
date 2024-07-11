# frozen_string_literal: true

class NavBar::UserComponent < ViewComponent::Base
  include SecondaryRootPath

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def navbar_links
    if user.business
      business_navbar_links
    elsif user.candidate
      candidate_navbar_links
    else
      user_navbar_links
    end
  end

  def dropdown_links
    if user.business
      business_dropdown_links
    elsif user.candidate
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
      { title: 'My assessments', path: customer_assessments_path },
      { title: 'My candidates', path: customer_candidates_path }
    ]
  end

  def candidate_navbar_links
    [{ title: 'My assessments', path: candidate_assessments_path }]
  end

  def user_navbar_links
    []
  end

  def business_dropdown_links
    [
      { title: 'Profile', path: customer_profile_path },
      { title: 'Test Library', path: customer_tests_path }
    ]
  end

  def candidate_dropdown_links
    [{ title: 'Profile', path: candidate_profile_path }]
  end

  def user_dropdown_links
    [{ title: 'Get started', path: new_role_path }]
  end
end
