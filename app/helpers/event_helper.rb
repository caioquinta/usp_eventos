include ActsAsTaggableOn::TagsHelper
module EventHelper
  def tag_list_error?
    'has-error' unless @event.errors[:tag_list].empty?
  end
end
