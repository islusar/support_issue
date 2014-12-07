class SendMail
  include Sidekiq::Worker

  def perform(action, ticket)
    UserMailer.send(action, ticket).deliver
  end
end