require 'resolv'

class EmailValidatorService
  PERSONAL_EMAIL_DOMAINS = %w[
    gmail.com yahoo.com hotmail.com outlook.com aol.com icloud.com
    mail.com yandex.com protonmail.com zoho.com
  ].freeze

  TEMPORARY_EMAIL_DOMAINS = %w[
    mailinator.com tempmail.com 10minutemail.com disposablemail.com
    guerrillamail.com
  ].freeze

  def initialize(email)
    @email = email
    @domain = email.split('@').last.downcase
  end

  def valid_work_email?
    !personal_email? && !temporary_email? && valid_mx_record?
  end

  private

  def personal_email?
    PERSONAL_EMAIL_DOMAINS.include?(@domain)
  end

  def temporary_email?
    TEMPORARY_EMAIL_DOMAINS.include?(@domain)
  end

  def valid_mx_record?
    Resolv::DNS.open do |dns|
      mx_records = dns.getresources(@domain, Resolv::DNS::Resource::IN::MX)
      mx_records.any?
    end
  rescue Resolv::ResolvError
    false
  end
end
