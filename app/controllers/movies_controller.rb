class MoviesController < InheritedResources::Base

  protected

  def collection
    @movies ||= super.order_by(:position.asc)
  end

end