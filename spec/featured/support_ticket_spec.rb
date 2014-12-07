require 'spec_helper'

describe 'Support' do
  describe 'content' do
    before do
      visit '/support_ticket'
    end

    it 'should have input field' do
      print page.html
      expect(page).to have_selector('.support_question')
    end

    it 'should have submit button' do
      expect(page).to have_selector('.send')
    end

    it 'should show empty list of support messages' do
      expect(page).to have_selector('.question')
    end
  end

  describe 'show messages' do

    before do
      @support_ticket = FactoryGirl.create(:support_ticket, question: 'testtest', subject: 'subject', user_name: 'user_name', email: 'fdf@ddd.dd')
      visit "/support_ticket/#{@support_ticket['code']}"
    end

    it 'should have question' do
      print page.html
      expect(page).to have_text('testtest')
    end

    it 'should have subject' do
      expect(page).to have_text('subject')
    end

    it 'should have status' do
      expect(page).to have_text(I18n.t("support.support_ticket_status_1"))
    end

  end

  describe 'submit' do
    before do
      visit '/support_ticket'
      fill_in 'support_ticket[question]', with: 'question'
      fill_in 'support_ticket[subject]', with: 'subject'
      fill_in 'support_ticket[user_name]', with: 'user_name'
      fill_in 'support_ticket[email]', with: 'email@fdff.ff'
    end

    describe 'success' do
      it 'should submit new message' do
        expect{click_and_wait(I18n.t('support_ticket.index.send'))}.to change{SupportTicket.count}.from(0).to(1)
      end
    end

    describe 'fail' do
      it 'question empty should now submit create ticket' do
        fill_in 'support_ticket[question]', with: ''
        expect { click_on(I18n.t('support_ticket.index.send')) }.to_not change(SupportTicket, :count)
      end

      it 'broken mail' do
        fill_in 'support_ticket[email]', with: 'mail'
        expect { click_on(I18n.t('support_ticket.index.send')) }.to_not change(SupportTicket, :count)
      end
    end
  end

end