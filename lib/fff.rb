require 'yaml'
require 'rubygems'
require 'twitter'

class Fff
  def initialize(u, p)
    @t = Twitter::Base.new(u, p)
    @your_followings = @t.friends.map(&:screen_name)
  end

  # followings :: ScreenName -> [ScreenName]
  def followings(s)
    @t.friends_for(s).map(&:screen_name)
  end

  # followed? :: ScreenName -> Boolean
  def followed?(s)
    @your_followings.include? s
  end
end
