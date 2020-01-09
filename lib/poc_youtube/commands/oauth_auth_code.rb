# frozen_string_literal: true

require_relative '../command'
require_relative '../google_credentials'

require 'pastel'
require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class OauthAuthCode < PocYoutube::Command
      def initialize(options)
        @options = options
      end

      # Execute OauthAuthCode subcommand taking input from 
      # a input stream and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        auth = PocYoutube::GoogleCredentials.for_youtube

        prompt.say("Using your credentials to access a #{Pastel.new.magenta('one off')} access code")
        sleep(3)
        prompt.ok('Open the URL below to get a new access token and then')
        prompt.ok('Run exe/poc_youtube oauth --> refresh token')

        url = auth.retrieve_oneoff_auth_code

        prompt.warn(url)
        # heading url

        :gui
      end
    end
  end
end
