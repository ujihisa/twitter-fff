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
    @t.all_friends_for(s).map(&:screen_name)
  end

  # followed? :: ScreenName -> Boolean
  def followed?(s)
    @your_followings.include? s
  end

  # follow :: ScreenName -> IO ()
  def follow(s)
    loop do
      begin
        @t.create_friendship(s)
        break
      rescue Twitter::AlreadyFollowing => e
        p e
        break
      rescue Twitter::CantFollowUser => e
        p e
        break
      rescue => e
        p e
        puts 'hmm...'
        sleep 1000#3600
      end
    end
  end

  # follow_candidates :: String -> IO ()
  def write_candidates(filename)
    File.open(filename, 'w') do |io|
      @your_followings.each do |s|
        ff = nil
        loop do
          begin
            ff = followings(s) - @your_followings
            break
          rescue
            puts 'hmm...'
            sleep 1000#3600
          end
        end
        io.puts "#{s}: #{ff.inspect}"
        sleep 1
      end
    end
  end
end
