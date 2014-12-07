class CreateSupportTickets < ActiveRecord::Migration
  def change
    create_table(:support_tickets) do |t|
      t.string :user_name,  null: false
      t.string :email, null: false
      t.string :subject, null: false
      t.string :question, null: false
      t.string :code, null: false
      t.string :answer
      t.integer :admin_id
      t.integer :status, default: 1
      t.timestamps
    end

    add_index :support_tickets, :code
  end
end
