require 'rails_helper'

describe 'User', type: :feature do
  before :each do
    @next_event = create :next_event
  end

  context 'unsigned' do
    it 'signs up successfully', js: true do
      visit '/'
      expect(page).to have_link 'Cadastrar', count: 2
      expect(page).to_not have_link 'Sair'
      expect(page).to have_link 'USP Eventos'

      within('.inner') { click_link 'Cadastrar' }

      click_button 'Cadastrar'
      expect(page).to have_text 'não pode ficar em branco', count: 3
      expect(page).to have_text 'Alguns erros foram encontrados, por favor verifique:
'

      fill_in 'user_name', with: 'Bruce Wayne'
      fill_in 'user_email', with: 'bruce@waynecorp.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
      page.find('#user_preferences_humanas').trigger('click')
      page.find('#user_preferences_exatas').trigger('click')
      click_button 'Cadastrar'
      expect(page).to have_text 'Cadastro efetuado com sucesso.'
      expect(page).to have_link 'Meus Dados'
      expect(page).to have_link 'Sair'
      expect(page).to have_css '.filter.toogle-sliderbar-1.btn.btn-primary.btn-filters'
      user = User.last
      expect(user.name).to eql 'Bruce Wayne'
      expect(user.email).to eql 'bruce@waynecorp.com'
      expect(user.preferences).to include 'Exatas'
      expect(user.preferences).to include 'Humanas'
      expect(page).to have_text 'Principais Escolhas para ' + user.name.split(' ').first
      within('#principal_choices') { expect(page).to have_text @next_event.name }

      click_link 'Meus Dados'
      expect(page).to have_text 'Meus Dados'

      fill_in 'user_name', with: 'Robin'
      page.find('#user_preferences_humanas').trigger('click')
      page.find('#user_preferences_exatas').trigger('click')
      click_button 'Atualizar'
      expect(page).to have_text 'Sua conta foi atualizada com sucesso.'
      user.reload
      expect(user.name).to eql 'Robin'
      expect(user.preferences).to_not include 'Humanas'
      expect(user.preferences).to_not include 'Exatas'
      expect(page).to_not have_text 'Principais Escolhas para ' + user.name.split(' ').first

      click_link 'Sair'
      expect(page).to have_text 'USP Eventos'
    end

    it 'signs up with facebook', js: true do
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123545',
        info: {
          name: 'Tony Stark',
          email: 'test@facebook.com'
        },
        credentials: {
          token: '123456',
          expires_at: 10.day.from_now
        }
      )

      visit '/'
      expect(page).to have_link 'Cadastrar', count: 2

      within('.inner') { click_link 'Cadastrar' }
      expect(page).to have_link 'Entrar com Facebook'

      click_link 'Entrar com Facebook'
      expect(page).to have_text 'Autenticado com sucesso com uma conta de Facebook.'
      expect(page).to have_text 'Nos diga do que você gosta!'
      facebook_user = User.last
      expect(facebook_user.name).to eql 'Tony Stark'
      expect(facebook_user.email).to eql 'test@facebook.com'

      click_link 'Sair'
      expect(page).to have_text 'USP Eventos'
    end

    it 'sends a suggestion', js: true do
      visit '/'
      expect(page).to have_button 'Enviar'

      click_button 'Enviar'
      expect(page).to have_text 'Preencha seu nome, email e a sugestão que deseja enviar'

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

    it 'visits users home and selects an event', js: true do
      visit '/home'
      expect(page).to have_css '.thumbnail_event_' + @next_event.id.to_s
      expect(page).to have_link 'Salvar!'
      expect(page).to have_css '.filter.toogle-sliderbar-1.btn.btn-primary.btn-filters'

      page.find('.btn.btn-participants.participants').trigger(:click)
      expect(page).to have_link 'Faça login primeiro'

      click_link @next_event.name
      expect(page).to have_text @next_event.name
      expect(page).to have_text @next_event.location
      expect(page).to have_text @next_event.description
      expect(page).to have_text @next_event.participants.count
      expect(page).to have_text @next_event.begin_date.strftime('%d/%m/%Y às %H:%M')
      expect(page).to have_text @next_event.end_date.strftime('%d/%m/%Y às %H:%M')
    end
  end

  context 'with a signed user' do
    it 'create new event', js: true do
      user = create :user
      ActsAsTaggableOn::Tag.create(name: 'Festa')
      visit '/'
      expect(page).to have_link 'Entrar', count: 2

      within('.inner') { click_link 'Entrar' }
      expect(page).to have_text 'Login'

      click_button 'Entrar'
      expect(page).to have_text 'E-mail ou senha inválidos.'

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '12345678'
      click_button 'Entrar'
      expect(page).to have_link 'Novo Evento'
      expect(page).to have_css '.event-floater-btn.ion-plus'
      expect(page).to have_css '.thumbnail_event_' + Event.last.id.to_s
      expect(page).to have_text 'De ' + Event.last.begin_date.strftime('%d/%m/%Y')
      expect(page).to have_text 'Até ' + Event.last.end_date.strftime('%d/%m/%Y')
      within('.navbar') { click_link 'Novo Evento' }
      expect(page).to have_text 'Novo Evento!'

      page.find('#event_tag_list_humanas').trigger('click')
      page.find('#event_tag_list_exatas').trigger('click')
      page.find('#event_tag_list_biolgicas').trigger('click')
      page.find('#event_tag_list_festa').trigger('click')
      find('.btn.btn-default').trigger('click')
      expect(page).to have_text 'Alguns erros foram encontrados, por favor verifique:
'
      expect(page).to have_text 'não pode ficar em branco', count: 3
      expect(page).to have_text 'Selecionar no máximo 3 tags'

      fill_in 'event_name', with: 'Back to the future date!'
      fill_in 'event_description', with: 'Back to the future bolt accident'
      fill_in 'event_location', with: 'Hill Valley'
      select (Time.now.day + 1), from: 'event_begin_date_3i'
      select I18n.t('date.month_names')[Time.now.month], from: 'event_begin_date_2i'
      select Time.now.year.to_s, from: 'event_begin_date_1i'
      select (Time.now.day + 2), from: 'event_end_date_3i'
      select I18n.t('date.month_names')[Time.now.month + 1], from: 'event_end_date_2i'
      select Time.now.year.to_s, from: 'event_end_date_1i'
      page.find('#event_tag_list_exatas').trigger('click')
      page.find('#event_tag_list_biolgicas').trigger('click')
      page.find('#event_tag_list_festa').trigger('click')
      find('.btn.btn-default').trigger('click')

      expect(page).to have_text 'Evento Criado com sucesso!'
      expect(page).to have_link 'Home'
      click_link 'Home'

      created_event = Event.last
      expect(page).to have_text 'Próximos Eventos'
      expect(page).to have_css '.thumbnail_event_' + created_event.id.to_s
      expect(page).to have_css '.ion-edit'
      within(first('.thumbnail_event_' + created_event.id.to_s)) do
        expect(page).to have_text 'Back to the future date!'
        expect(page).to have_text created_event.begin_date.strftime('%d/%m/%Y')
        expect(page).to have_text created_event.end_date.strftime('%d/%m/%Y')
        expect(page).to have_css '.thumbnail-tags.humanas'
      end
      expect(page).to have_link 'Salvar!', count: 3

      within(first('.thumbnail_event_' + created_event.id.to_s)) { page.find('.btn.btn-participants.participants').trigger(:click) }
      expect(page).to have_link 'Remover', count: 2
      expect(page).to have_text 'Meus Eventos'
      expect(page).to have_css '.thumbnail_event_' + created_event.id.to_s, count: 2

      within(first('.thumbnail_event_' + created_event.id.to_s)) { page.find('.btn.btn-danger.ion-android-cancel').trigger(:click) }
      expect(page).to have_text 'Salvar!', count: 3
      expect(page).to have_css '.thumbnail_event_' + created_event.id.to_s, count: 1

      first(:css, '.ion-edit').click
      expect(page).to have_text 'Editar Evento'

      fill_in 'event_name', with: 'Evento editado'
      fill_in 'event_description', with: 'descricao'
      fill_in 'event_location', with: 'local'
      select Time.now.day + 5, from: 'event_begin_date_3i'
      select Time.now.day + 6, from: 'event_end_date_3i'
      click_button 'Enviar'

      expect(page).to have_text 'Próximos Eventos'
      event_edited = created_event.reload
      expect(event_edited.name).to eql 'Evento editado'
      expect(event_edited.description).to eql 'descricao'
      expect(event_edited.location).to eql 'local'
      expect(page).to have_text (Time.now.day + 5).to_s + created_event.begin_date.strftime('/%m/%Y')
      expect(page).to have_text (Time.now.day + 6).to_s + created_event.end_date.strftime('/%m/%Y')

      within(first('.thumbnail_event_' + created_event.id.to_s)) { click_link created_event.name }
      expect(page).to have_text created_event.name
      expect(page).to have_text created_event.location
      expect(page).to have_text created_event.description
      expect(page).to have_text created_event.participants.count
      expect(page).to have_text created_event.price
      expect(page).to have_text created_event.begin_date.strftime('%d/%m/%Y às %H:%M')
      expect(page).to have_text created_event.end_date.strftime('%d/%m/%Y às %H:%M')

      current_event = create :current_event
      click_link 'Voltar'
      expect(page).to have_text 'Acontecendo Agora!'
      expect(page).to have_css '.thumbnail_event_' + current_event.id.to_s

      # find('.filter.toogle-sliderbar-1.btn.btn-primary.btn-filters').trigger(:click)
      # sleep 50
      # expect(page).to have_css '.check-box[value=Humanas]'

      # find('#exatas').trigger(:click)
      # expect(page).to have_css '.thumbnail-tags.humanas', count:3
      # expect(page).to_not have_text 'Back to the future date!'

      # find('.filter.toogle-sliderbar-1.btn.btn-primary.btn-filters').trigger('click')
      # expect(page).to have_css '.check-box[value=Humanas]'

      # find('#humanas').trigger(:click)
      # expect(page).to have_css '.thumbnail-tags.humanas', count:4
      # expect(page).to have_text 'Back to the future date!'

      # find('.thumbnail-tags.exatas').trigger(:click)
      # => expect(page).to have_css '.thumbnail-tags.humanas', count:3
    end
  end
end
