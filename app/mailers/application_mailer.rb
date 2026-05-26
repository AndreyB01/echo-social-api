class ApplicationMailer < ActionMailer::Base
  default from: "noreply@echoapp.local"

  layout "mailer"
end