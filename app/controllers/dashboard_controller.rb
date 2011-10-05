class DashboardController < ApplicationController

  redis_caches_page :index

  def index
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
