# frozen_string_literal: true

require_relative 'google_credentials'

require 'forwardable'

require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'tty-table'

module PocYoutube
  # Base command class
  class Command
    extend Forwardable

    def_delegators :command, :run

    # Execute this command
    #
    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # The external commands runner
    #
    # @see http://www.rubydoc.info/gems/tty-command
    #
    # @api public
    def command(**options)
      require 'tty-command'
      TTY::Command.new(options)
    end

    # The cursor movement
    #
    # @see http://www.rubydoc.info/gems/tty-cursor
    #
    # @api public
    def cursor
      require 'tty-cursor'
      TTY::Cursor
    end

    # Open a file or text in the user's preferred editor
    #
    # @see http://www.rubydoc.info/gems/tty-editor
    #
    # @api public
    def editor
      require 'tty-editor'
      TTY::Editor
    end

    # File manipulation utility methods
    #
    # @see http://www.rubydoc.info/gems/tty-file
    #
    # @api public
    def generator
      require 'tty-file'
      TTY::File
    end

    # Terminal output paging
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def pager(**options)
      require 'tty-pager'
      TTY::Pager.new(options)
    end

    # Terminal platform and OS properties
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def platform
      require 'tty-platform'
      TTY::Platform.new
    end

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # @api public
    def prompt(**options)
      require 'tty-prompt'
      TTY::Prompt.new(options)
    end

    # Get terminal screen properties
    #
    # @see http://www.rubydoc.info/gems/tty-screen
    #
    # @api public
    def screen
      require 'tty-screen'
      TTY::Screen
    end

    # The unix which utility
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def which(*args)
      require 'tty-which'
      TTY::Which.which(*args)
    end

    # Check if executable exists
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def exec_exist?(*args)
      require 'tty-which'
      TTY::Which.exist?(*args)
    end

    # Helpers for Google Auth and API calls
        def google_credentials
      return @google_credentials if defined? @google_credentials

      @google_credentials = begin
        auth = PocYoutube::GoogleCredentials.for_youtube

        refresh_token_file = '/Users/davidcruwys/dev_credentials/poc-youtube-refresh-token.json'

        refresh_token = auth.load_refresh_token_file(refresh_token_file)
        auth.load_user_refresh_credentials(refresh_token)
      end
    end

    def youtube
      return @youtube if defined? @youtube

      @youtube = begin
        youtube = Google::Apis::YoutubeV3::YouTubeService.new
        youtube.authorization = google_credentials
        youtube
      end
    end

    # Helpers for printing out some data
    def pretty(data)
      heading(JSON.pretty_generate(data))
    end

    def heading(heading)
      puts '-' * 70
      puts heading
      puts '-' * 70
    end
    
    def print_all(data)
      keys = data.first.keys
      data.each do |row|
        keys.each do |key|
          puts "#{key.to_s.rjust(20)}: #{row[key].to_s.delete("\n")[1..100]}"
        end
        puts '-'*120
      end
    end

    def pretty_table(heading, column_headings, column_values)
      heading heading

      table = TTY::Table.new column_headings, column_values
      puts table.render(:unicode, multiline: true, resize: true)
    end


  end
end
