module Karenandrew
  module ActionController
    module Redis

      extend ActiveSupport::Concern

      module ClassMethods

        def redis_cache_page(content, path, extension = nil)
          return unless perform_caching
          redis_cache.sadd("#{redis_namespace}__pages", "#{path}")
          cache_page(content, path, extension = nil)
        end

        def redis_caches_page(*actions)
          return unless perform_caching
          options = actions.extract_options!
          after_filter({:only => actions}.merge(options)) { |c| c.redis_cache_page }
        end

        def redis_expire_page(path)
          return unless perform_caching
          redis_cache.srem("#{redis_namespace}__pages", "#{path}")
          expire_page(path)
        end

        def redis_expire_pages(filter = nil)
          return unless perform_caching
          pages = redis_cache.smembers("#{redis_namespace}__pages")
          (filter.blank? ? pages : pages.keep_if { |page| page =~ filter }).each do |path|
            self.redis_expire_page(path)
          end
        end

        def redis_cache
          return unless perform_caching
          ::Rails.cache.instance_variable_get(:@data)
        end

        def redis_namespace
          return unless perform_caching
          (n = ::Rails.cache.options[:namespace]).present? ? "#{n}:" : ''
        end

      end

      module InstanceMethods

        def redis_cache_key(*args)
          options = args.extract_options!
          options.reverse_merge!(query_string: false)

          object = args.first unless args.first.kind_of?(Hash)

          query_string = (options[:query_string] == true) ? Rack::Utils.parse_nested_query(request.query_string).to_query : nil

          "action/#{object.present? ? object.id : nil}#{request.path}?#{query_string}"
        end

        def redis_cache_page(content = nil, options = nil)
          return unless self.class.perform_caching && caching_allowed?

          path = case options
            when Hash
              url_for(options.merge(:only_path => true, :format => params[:format]))
            when String
              options
            else
              request.path
          end

          if (type = Mime::LOOKUP[self.content_type]) && (type_symbol = type.symbol).present?
            extension = ".#{type_symbol}"
          end

          self.class.redis_cache_page(content || response.body, path, extension)
        end

        def redis_expire_page(options = {})
          return unless self.class.perform_caching

          if options.is_a?(Hash)
            if options[:action].is_a?(Array)
              options[:action].dup.each do |action|
                self.class.redis_expire_page(url_for(options.merge(:only_path => true, :action => action)))
              end
            else
              self.class.redis_expire_page(url_for(options.merge(:only_path => true)))
            end
          else
            self.class.redis_expire_page(options)
          end
        end

        def redis_expire_pages(filter = nil)
          self.class.redis_expire_pages(filter)
        end

        def redis_expire_fragment(key, options = nil)
          return unless cache_configured?
          key = fragment_cache_key(key) unless key.is_a?(Regexp)
          message = nil

          instrument_fragment_cache :expire_fragment, key do
            if key.is_a?(Regexp)
              self.class.redis_cache.keys("#{self.class.redis_namespace}*").keep_if { |k| k =~ key }.each do |k|
                cache_store.delete(k, options)
              end
            else
              cache_store.delete(key, options)
            end
          end
        end

      end

    end
  end
end
