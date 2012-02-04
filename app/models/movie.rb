class Movie
  include Mongoid::Document

  ## extensions ##
  include Mongoid::Timestamps

  ## fields ##
  field :title
  field :url
  field :position,     type: ::Integer
  field :premiered_at, type: ::Date
  field :released_at,  type: ::Date
  field :watched,      type: ::Boolean

  ## validations ##
  validates :title, presence: true
  validates :url, format: URI::regexp(%w(http https)), allow_nil: true
  validates :position, uniqueness: true

  ## callbacks ##
  before_create :add_to_list_bottom

  protected

  def add_to_list_bottom
    self.position ||= (self.class.where(:_id.ne => self._id).max(:position) || 0) + 1
  end

end