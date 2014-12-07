require 'spec_helper'
include Devise::TestHelpers

describe 'admin support tickets' do
  before do
    @admin = FactoryGirl.create(:admin)
    real_sign_in @admin
    @ticket = FactoryGirl.create(:support_ticket, question: 'testtest', subject: 'subject', user_name: 'user_name', email: 'fdf@ddd.dd')
  end

  describe 'list tickets' do

    describe 'new tickets' do
      before do
        visit '/admins'
      end

      it 'should have user name' do
        print page.html
        expect(page).to have_content(@ticket.user_name)
      end

      it 'should have user question' do
        expect(page).to have_content(@ticket.question)
      end

      it 'should have subject' do
        expect(page).to have_content(@ticket.subject)
      end

      it 'should have filters' do
        expect(page).to have_selector('.filters')
      end

    end

  end

  describe 'ticket edit' do
    before do
      visit '/admins'
      click_on(t('admin.support.tickets.edit'))
    end

    it 'should have user question' do
      expect(page).to have_content(@ticket.question)
    end

    describe 'change ticket' do
      before do
        fill_in 'support_ticket[answer]', with: 'answer'
      end

      it 'should change answer' do
        expect{click_and_wait(t('admin.support.edit.update'))}.to change{@ticket.reload.answer}
      end
    end
  end

end