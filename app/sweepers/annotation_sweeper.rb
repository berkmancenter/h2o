require 'sweeper_helper'
class AnnotationSweeper < ActionController::Caching::Sweeper
  include SweeperHelper
  observe Annotation

  def collage_clear(record)
    if record.annotated_item_type == 'Collage'
      collage = record.annotated_item
      collage.clear_cached_pages(:clear_iframes => true)
      clear_playlists(collage.playlist_items)
      collage.touch
    end
  end

  def after_save(record)
    collage_clear(record)
  end

  def after_create(record)
    collage_clear(record)
  end

  def before_destroy(record)
    collage_clear(record)
  end
end
