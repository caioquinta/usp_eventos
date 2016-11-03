module UserHelper
  def get_correct_name(provider)
    case provider.to_s
    when 'google_oauth2'
      return 'google'
    else
      return 'facebook'
    end
  end
end
