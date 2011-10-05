class ApplicationController < ActionController::Base

  include Karenandrew::ActionController::Redis

  protect_from_forgery
end
