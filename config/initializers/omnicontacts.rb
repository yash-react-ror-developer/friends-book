require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, ENV['OMNICONTACTS_ID'], ENV['OMNICONTACTS_KEY']
end