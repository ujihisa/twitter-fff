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

  # follow_candidates :: [ScreenName]
  def follow_candidates
    @your_followings.inject([]) {|memo, s|
      memo += followings(s)
      memo.uniq
    } - @your_followings
  end
end
