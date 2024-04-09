require 'feature'

repo = Feature::Repository::SimpleRepository.new

# configure features here
unless ActiveRecord::Type::Boolean.new.cast(ENV.fetch('DISABLE_ACCOUNT_CREATION', 'false'))
  repo.add_active_feature :account_creation
end
unless(ENV['RECAPTCHA_SITE_KEY'].blank? || ENV['RECAPTCHA_SECRET_KEY'].blank?)
  repo.add_active_feature :recaptcha
end

Feature.set_repository repo
