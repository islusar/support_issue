class SupportTicketController < ApplicationController
  def index
  end

  def create
    ticket = SupportTicket.new(ticket_params)
    flash[:notice] = ticket.save ? t(:created_successfully) : ticket.errors.full_messages.first
    redirect_to support_ticket_index_path
  end

  def show
    @ticket = SupportTicket.find_by_code(params[:id])
  end

  private

  def ticket_params
    params.require(:support_ticket).permit(:user_name, :email, :question, :subject)
  end
end