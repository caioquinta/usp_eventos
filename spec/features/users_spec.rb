require 'rails_helper'

describe 'User', type: :feature do
  context 'unsigned' do
    it 'signs up successfully', js: true do
      visit '/'
      expect(page).to have_link 'Cadastrar', count: 2
      expect(page).to_not have_link 'Sair'

      within('.inner') { click_link 'Cadastrar' }

      click_button 'Cadastrar'
      expect(page).to have_text 'não pode ficar em branco', count: 3
      expect(page).to have_text 'Alguns erros foram encontrados, por favor verifique:
'

      fill_in 'user_name', with: 'Bruce Wayne'
      fill_in 'user_email', with: 'bruce@waynecorp.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
      click_button 'Cadastrar'
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
      expect(page).to have_text 'USP Eventos'
    end
  end

  context 'with a signed user' do
    it 'create new event', js: true do
      user = create :user
      create :next_event
      visit '/'
      expect(page).to have_link 'Entrar', count: 2

      within('.inner') { click_link 'Entrar' }
      expect(page).to have_text 'Login'

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '12345678'
      click_button 'Entrar'
      expect(page).to have_link 'Criar Evento', count: 2
      expect(page).to have_css '#next_event_' + Event.last.id.to_s
      expect(page).to have_text 'De ' + Event.last.begin_date.strftime('%d/%m/%Y')
      expect(page).to have_text 'Até ' + Event.last.end_date.strftime('%d/%m/%Y')

      within('.navbar') { click_link 'Criar Evento' }
      expect(page).to have_text 'Novo Evento!'

      click_button 'Cadastrar'
      expect(page).to have_text 'Alguns erros foram encontrados, por favor verifique:
'
      expect(page).to have_text 'não pode ficar em branco', count: 3

      fill_in 'event_name', with: 'Back to the future date!'
      fill_in 'event_description', with: 'Back to the future bolt accident'
      fill_in 'event_location', with: 'Hill Valley'
      select '21', from: 'event_begin_date_3i'
      select 'Junho', from: 'event_begin_date_2i'
      select (Time.now.year + 1).to_s, from: 'event_begin_date_1i'
      select '21', from: 'event_end_date_3i'
      select 'Outubro', from: 'event_end_date_2i'
      select (Time.now.year + 1).to_s, from: 'event_end_date_1i'
      click_button 'Cadastrar'

      expect(page).to have_text 'Próximos Eventos'
      within('#next_event_' + Event.last.id.to_s) do
        expect(page).to have_text 'Back to the future date!'
        expect(page).to have_text '21/10/2017'
        expect(page).to have_text '21/10/2017'
        expect(page).to have_link '+Info'
        expect(page).to have_link 'Me interessa!'

        click_link 'Me interessa!'
        expect(page).to have_link 'Desistir'

        click_link 'Desistir'
        expect(page).to have_text 'Me interessa!'
      end
    end
  end
end
