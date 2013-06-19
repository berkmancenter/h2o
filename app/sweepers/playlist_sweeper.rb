require 'sweeper_helper'
class PlaylistSweeper < ActionController::Caching::Sweeper
  include SweeperHelper
  observe Playlist

  def playlist_clear(record)
    Rails.cache.delete_matched(%r{playlists-search*})
    Rails.cache.delete_matched(%r{playlists-embedded-search*})

    expire_fragment "playlist-all-tags"
    expire_fragment "playlist-#{record.id}-index"
    expire_fragment "playlist-#{record.id}-tags"
    expire_page :controller => :playlists, :action => :show, :id => record.id
    expire_page :controller => :playlists, :action => :export, :id => record.id
    Rails.cache.delete("playlist-wordcount-#{record.id}")

    record.path_ids.each do |parent_id|
      Rails.cache.delete("playlist-wordcount-#{parent_id}")
      Rails.cache.delete("playlist-barcode-#{parent_id}")
    end
    record.relation_ids.each do |p|
      Rails.cache.delete("playlist-wordcount-#{p}")
      Rails.cache.delete("playlist-barcode-#{p}")
      expire_page :controller => :playlists, :action => :show, :id => p
      expire_page :controller => :playlists, :action => :export, :id => p
    end

    begin
      users = (record.owners + record.creators).uniq.collect { |u| u.id }
      users.each { |u| Rails.cache.delete("user-playlists-#{u}") }
      if record.changed.include?("public")
        users.each { |u| Rails.cache.delete("user-barcode-#{u}") }
      end
    rescue Exception => e
    end
  end

  def playlist_clear_nonsiblings(id)
    record = Playlist.find(params[:id])

    expire_page :controller => :playlists, :action => :show, :id => record.id
    expire_page :controller => :playlists, :action => :export, :id => record.id

    record.relation_ids.each do |p|
      expire_page :controller => :playlists, :action => :show, :id => p
      expire_page :controller => :playlists, :action => :export, :id => p
    end
  end

  def after_save(record)
    playlist_clear(record)
  end

  def before_destroy(record)
    playlist_clear(record)
  end

  def after_playlists_position_update
    playlist_clear_nonsiblings(params[:id])
  end

  def after_playlists_notes
    playlist_clear_nonsiblings(params[:id])
  end
end
