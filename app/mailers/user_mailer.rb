class UserMailer < ActionMailer::Base
  layout 'user_mail'
  default from: "supptort@somesite.com"

  def support_question(ticket)
    @ticket = ticket
    mail(to: @ticket['email'], subject: 'Support Ticket')
  end

  def support_answer(ticket)
    @ticket = ticket
    mail(to: @ticket['email'], subject: 'Support Answer')
  end
end
