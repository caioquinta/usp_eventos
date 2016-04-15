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
      expect(page).to have_link 'Meus Dados'
      expect(page).to have_link 'Sair'
      user = User.last
      expect(user.name).to eql 'Bruce Wayne'
      expect(user.email).to eql 'bruce@waynecorp.com'

      click_link 'Meus Dados'
      expect(page).to have_text 'Meus Dados'

      fill_in 'user_name', with: 'Robin'
      click_button 'Atualizar'
      expect(page).to have_text 'Digite sua senha atual para confirmar as mudanças'

      fill_in 'user_name', with: 'Robin'
      fill_in 'user_current_password', with: '12345678'
      click_button 'Atualizar'
      expect(page).to have_text 'Próximos Eventos'
      user.reload
      expect(user.name).to eql 'Robin'

      click_link 'Sair'
      expect(page).to have_text 'Bem Vindo'
    end
  end

  context 'with a signed user' do
    it 'create new event', js: true do
      user = create :user
      create :next_event
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
      expect(page).to have_css '#next_event_' + Event.last.id.to_s
      expect(page).to have_text 'de ' + Event.last.begin_date.strftime('%d/%m/%Y')
      expect(page).to_not have_text 'até '

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
      within('#next_event_' + Event.last.id.to_s) do
        expect(page).to have_text 'Back to the future date!'
        expect(page).to have_text '21/10/2016'
        expect(page).to have_text '25/10/2016'
        expect(page).to have_link 'Ver'
        expect(page).to have_link 'Participar'

        click_link 'Participar'
        expect(page).to have_text 'Confirmado'
        expect(page).to have_link 'Desistir'

        click_link 'Desistir'
        expect(page).to have_text 'Participar'
      end
    end
  end
end
