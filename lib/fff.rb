require 'yaml'
require '~/git/twitter/lib/twitter'

class Fff
  def initialize(u, p)
    @t = Twitter::Base.new(u, p)
    # NOTE: Twitter::Base#all_friends is not officialy distributed in the gem twitter library.
    @your_followings = @t.all_friends.map(&:screen_name)
  end

  # followings :: ScreenName -> [ScreenName]
  def followings(s)
    @t.friends_for(s).map(&:screen_name)
  end

  # followed? :: ScreenName -> Boolean
  def followed?(s)
    @your_followings.include? s
  end

  # follow_candidates :: String -> IO ()
  def write_candidates(filename)
    File.open(filename, 'w') do |io|
      @your_followings.each do |s|
        begin
          ff = followings(s) - @your_followings
          io.puts "#{s}: #{ff.inspect}"
          sleep 1
        rescue Twitter::CantConnect => e
          p e
          io.puts "# #{s}: skipped."
          sleep 60
        end
      end
    end
  end
end
