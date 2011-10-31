class ApplicationController < ActionController::Base

  include Karenandrew::ActionController::Redis
  include UrlHelper

  protect_from_forgery
end
