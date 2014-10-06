RailsAdminImport.config do |config|
  config.model Default do
    label :name
    excluded_fields do
      [:tag, :tagging, :base_tag, :tag_tagging, :karma, :pushed_from_id, :content_type, :ancestry, :playlist_item]
    end
  end
end
