require 'sweeper_helper'
class CollageSweeper < ActionController::Caching::Sweeper
  include SweeperHelper
  observe Collage

  def collage_clear(record)
    Rails.logger.debug "############ CollageSweeper.collage_clear firing for #{record}"
    begin
      relations = [record.ancestor_ids, record.descendant_ids]

      Rails.logger.debug "BOOP: Ancestor IDS: #{record.ancestor_ids}"
      Rails.logger.debug "BOOP: Descendant IDS: #{record.descendant_ids}"

      relations.push(record.sibling_ids.select { |i| i != record.id }) if record.parent.present?

      related_collages = Collage.where(id: relations.flatten)
      related_collages.update_all(updated_at: Time.now)

      [record, related_collages].flatten.each do |collage|
        collage.clear_cached_pages(:clear_iframes => true)
      end

      if record.changed.include?("public")
        [:playlists, :collages, :cases].each do |type|
          record.user.send(type).each { |i| ActionController::Base.expire_page "/#{type.to_s}/#{i.id}.html" }
        end
        [:playlists, :collages].each do |type|
          record.user.send(type).each do |i|
            ActionController::Base.expire_page "/iframe/load/#{type.to_s}/#{i.id}.html"
            ActionController::Base.expire_page "/iframe/show/#{type.to_s}/#{i.id}.html"
          end
        end
        record.user.collages.update_all(updated_at: Time.now)
      end

      clear_playlists(record.playlist_items)
    rescue Exception => e
      Rails.logger.warn "Collage sweeper error: #{e.inspect}"
    end
  end

  def after_save(record)
    return true if record.changed.empty?

    return true if record.changed.include?("created_at")

    return true if record.changed.include?("readable_state")

    collage_clear(record)
    notify_private(record)
  end

  def before_destroy(record)
    clear_playlists(record.playlist_items)
    collage_clear(record)
  end

  def after_collages_save_readable_state
    collage = Collage.find(params[:id])
    collage.clear_cached_pages(:clear_iframes => true)
    clear_playlists(collage.playlist_items)
  end
end
