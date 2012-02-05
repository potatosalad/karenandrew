class DashboardController < ApplicationController

  redis_caches_page :index

  respond_to :json, only: :images

  def index
  end

  def images
    require 'open-uri'
    @document = open('https://picasaweb.google.com/data/feed/base/user/potatosaladx/albumid/5705509541418756769?alt=rss&kind=photo&hl=en_US')
    @xml      = Nokogiri::XML.parse(@document) { |config| config.strict.noblanks }
    @images   = @xml.css('enclosure').map do |node|
      begin
        url       = URI.parse(node[:url])
        base_name = File.basename(url.path)
        base_path = File.dirname(url.path)
        url.path  = "#{base_path}/s800/#{base_name}"
        #{ src: url.to_s }
        url.to_s
      rescue
        nil
      end
    end.compact
    render json: { images: @images }
  end

  def clearcache
    if not perform_caching
      redirect_to :back, alert: 'Caching is currently disabled'
    else
      redis = ::Rails.cache.instance_variable_get(:@data)
      self.redis_expire_pages
      redis.flushdb

      redirect_to :back, notice: 'Successfully cleared cache.'
    end
  end

end
