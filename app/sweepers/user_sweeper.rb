require 'sweeper_helper'
class UserSweeper < ActionController::Caching::Sweeper
  include SweeperHelper
  observe User

  def after_users_delete_bookmark_item
    clear_cached_bookmark_fragments
  end

  def after_users_bookmark_item
    clear_cached_bookmark_fragments
  end

  def clear_cached_bookmark_fragments
    return unless current_user
    Rails.cache.delete("user-bookmarks-#{current_user.id}")
    Rails.cache.delete("user-bookmarks-map-#{current_user.id}")
  end

  def after_update(record)
    if record.changed.include?("attribution")
      record.collages.map(&:clear_cached_pages)
      record.playlists.map(&:clear_cached_pages)

      Sunspot.index record.all_items
      Sunspot.commit
    end

    if record.changed.include?("description")
      record.playlists.each {|playlist| playlist.clear_page_cache}
    end
  end
end
