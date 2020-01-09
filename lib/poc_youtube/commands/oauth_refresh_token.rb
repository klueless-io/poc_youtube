# frozen_string_literal: true

require_relative '../command'
require_relative '../google_credentials'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class OauthRefreshToken < PocYoutube::Command
      def initialize(options)
        @options = options
      end

      # Execute OauthRefreshToken subcommand taking input from 
      # a input stream and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        prompt = TTY::Prompt.new

        refresh_token_file = '/Users/davidcruwys/dev_credentials/poc-youtube-refresh-token.json'
        refresh_token_file = prompt.ask('Where do you want your refresh token to be saved?', default: refresh_token_file)

        authentication_token = prompt.mask('What is your google access code?') do |q|
          q.required true
        end

        prompt.ok 'refresh token written to'
        prompt.ok refresh_token_file

        auth = PocYoutube::GoogleCredentials.for_youtube
        auth.renew_refresh_token(authentication_token, refresh_token_file)

        :gui
      end
    end
  end
end
