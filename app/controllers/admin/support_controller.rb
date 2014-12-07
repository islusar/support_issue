class Admin::SupportController < Admin::AdminController
  before_action only: ['take_ownership', 'edit', 'update'] do
    @ticket = SupportTicket.find(params[:id])
  end

  def index
    @filters = ['new_ticket', 'opened', 'on_hold', 'closed']
    @filter = params[:filter] || @filters.first
    @tickets = SupportTicket.send(@filter).paginate(:page => params[:page])
  end

  def take_ownership
    @ticket.change_ownership!(current_admin)
    redirect_to admin_support_index_path(filter: 'opened')
  end

  def edit
  end

  def update
    @ticket.update!(ticket_params)
    redirect_to admin_support_index_path
  end

  def search
    @tickets = SupportTicket.search(params[:search_word]).paginate(:page => params[:page])
    redirect_to edit_admin_support_path(@tickets[0].id) if @tickets.count == 1
  end

  private
  def ticket_params
    params.require(:support_ticket).permit(:answer, :status, :admin_id)
  end
end