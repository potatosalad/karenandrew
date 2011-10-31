module ApplicationHelper

  CONTENT = {
    topics: %q{"The Lord has given us prophets to guide and direct us. We have been promised that if we follow the counsels of the prophets and apostles we will avoid unnecessary pain and eventually gain eternal happiness." I definitely believe it. This blog will be a compilation of quotes from the prophets, on specific topics, that will help govern a life.}
  }

  def karenandrew_url(name)
    "http://#{name}.karenandrew.info"
  end

  def description(name)
    CONTENT[name]
  end
end
