require 'rails_helper'

describe 'User', type: :feature do
  context 'with a unsigned user' do
    it 'signs up successfully' do
      visit '/'
      expect(page).to have_link 'Cadastrar'
      expect(page).to_not have_link 'Sair'

      click_link 'Cadastrar'

      click_button 'Cadastrar'
      expect(page).to have_text 'não pode ficar em branco', count: 2

      fill_in 'user_name', with: 'Bruce Wayne'
      fill_in 'user_email', with: 'bruce@waynecorp.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
      click_button 'Cadastrar'
      expect(page).to have_text 'Meus Eventos'
      expect(page).to have_link 'Sair'
      user = User.last
      expect(user.name).to eql 'Bruce Wayne'
      expect(user.email).to eql 'bruce@waynecorp.com'

      click_link 'Sair'
      expect(page).to have_text 'Bem Vindo'
    end
  end

  context 'with a signed user' do
    it 'create new event' do
      user = create :user
      visit '/'
      expect(page).to have_link 'Entrar'

      click_link 'Entrar'
      expect(page).to have_text 'Login'

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '12345678'
      click_button 'Entrar'
      expect(page).to have_text 'Meus Eventos'
      expect(page).to have_link 'Criar Evento', count: 2
      expect(page).to have_link 'Sair'

      within('.my_events') do
        click_link 'Criar Evento'
      end
      expect(page).to have_text 'Cadastrar Evento'

      fill_in 'event_name', with: 'Back to the future date!'
      fill_in 'event_description', with: 'Back to the future description'
      fill_in 'event_begin_date', with: '21/10/2016'
      fill_in 'event_end_date', with: '25/10/2016'
      click_button 'Cadastrar'
      expect(page).to have_text 'Meus Eventos'
      event = Event.last
      expect(event.name).to eql 'Back to the future date!'
      expect(event.description).to eql 'Back to the future description'
      expect(event.begin_date.strftime('%d/%m/%Y')).to eql '21/10/2016'
      expect(event.end_date.strftime('%d/%m/%Y')).to eql '25/10/2016'
    end
  end
end
