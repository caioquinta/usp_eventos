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

    it 'sends a suggestion', js: true do
      visit '/'
      expect(page).to have_text 'Sugestões?'

      fill_in 'suggestion_user_name', with: 'Bruce Wayne'
      fill_in 'suggestion_email', with: 'bruce@waynecorp.com'
      fill_in 'suggestion_description', with: 'Sugestão'
      click_button 'Enviar'
      expect(page).to have_text 'Sugestão enviada com sucesso'
      suggestion = Suggestion.last
      expect(suggestion.user_name).to eql 'Bruce Wayne'
      expect(suggestion.email).to eql 'bruce@waynecorp.com'
      expect(suggestion.description).to eql 'Sugestão'
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

      click_button 'Entrar'
      expect(page).to have_text 'E-mail ou senha inválidos.'

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '12345678'
      click_button 'Entrar'
      expect(page).to have_link 'Novo Evento', count: 2
      expect(page).to have_css '.next_event_' + Event.last.id.to_s
      expect(page).to have_text 'De ' + Event.last.begin_date.strftime('%d/%m/%Y')
      expect(page).to have_text 'Até ' + Event.last.end_date.strftime('%d/%m/%Y')

      within('.navbar') { click_link 'Novo Evento' }
      expect(page).to have_text 'Novo Evento!'

      click_button 'Enviar'
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
      click_button 'Enviar'

      created_event = Event.last
      expect(page).to have_text 'Próximos Eventos'
      expect(page).to have_css '.next_event_' + created_event.id.to_s, count: 2
      expect(page).to have_css '.ion-edit', count: 2
      within(first('.next_event_' + created_event.id.to_s)) do
        expect(page).to have_text 'Back to the future date!'
        expect(page).to have_text '21/10/2017'
        expect(page).to have_text '21/10/2017'
        expect(page).to have_link '+Info'
      end
      expect(page).to have_link 'Me interessa!', count: 3

      first(:link, 'Me interessa!').click
      expect(page).to have_link 'Desistir', count: 2

      first(:link, 'Desistir').click
      expect(page).to have_text 'Me interessa!', count: 3

      first(:css, '.ion-edit').click
      expect(page).to have_text 'Editar Evento'

      fill_in 'event_name', with: 'Evento editado'
      fill_in 'event_description', with: 'descricao'
      fill_in 'event_location', with: 'local'
      select '1', from: 'event_begin_date_3i'
      select 'Janeiro', from: 'event_begin_date_2i'
      select (Time.now.year + 2).to_s, from: 'event_begin_date_1i'
      select '15', from: 'event_end_date_3i'
      select 'Fevereiro', from: 'event_end_date_2i'
      select (Time.now.year + 2).to_s, from: 'event_end_date_1i'
      click_button 'Enviar'

      expect(page).to have_text 'Meus Eventos'
      event_edited = created_event.reload
      expect(event_edited.name).to eql 'Evento editado'
      expect(event_edited.description).to eql 'descricao'
      expect(event_edited.location).to eql 'local'
      expect(event_edited.begin_date.strftime('%d/%m/%Y')).to eql '01/01/2018'
      expect(event_edited.end_date.strftime('%d/%m/%Y')).to eql '15/02/2018'

      within(first('.next_event_' + created_event.id.to_s)) { click_link '+Info' }
      expect(page).to have_text created_event.name
      expect(page).to have_text created_event.location
      expect(page).to have_text created_event.description
      expect(page).to have_text created_event.participants.count
      expect(page).to have_text created_event.price
    end
  end
end
