class UserMailer < ActionMailer::Base
  default from: "supptort@somesite.com"

  def support_question(ticket)
    @ticket = ticket
    mail(to: @ticket.email, subject: 'Support Ticket')
  end
end
