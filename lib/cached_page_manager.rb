require 'active_support/concern'

module CachedPageManager
  extend ActiveSupport::Concern

  def clear_cached_pages(options = {})
    self.class.clear_cached_pages_for(self.id, options)
  end

  module ClassMethods

    def clear_cached_pages_for(id, options = {})
      # NOTE: This is a partial refactoring of all the explicit expire_page calls
      #   sprinkled through the codebase.
      return unless id

      dir = self.name.underscore.pluralize
      # Rails.logger.debug "Cached pages base directory: #{dir}"

      pages = [
        "/#{dir}/#{id}.html",
        "/#{dir}/#{id}/export.html",
        "/#{dir}/#{id}/export_all.html",
      ]

      if options[:clear_iframes]
        pages << [
          "/iframe/load/#{dir}/#{id}.html",
          "/iframe/show/#{dir}/#{id}.html",
        ]
      end

      pages.flatten.each do |page|
        ActionController::Base.expire_page page
      end
    end

  end

end
