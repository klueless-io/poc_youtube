# frozen_string_literal: true

require_relative '../command'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class Oauth < PocYoutube::Command
      def initialize(subcommand, options)
        @subcommand = (subcommand || '').to_sym

        @options = options
      end

      # Execute Oauth command taking input from a input stream
      # and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        case @subcommand
        when :gui
          gui
        when :auth_code
          require_relative 'oauth_auth_code'
          subcmd = PocYoutube::Commands::OauthAuthCode.new({})
        when :refresh_token
          require_relative 'oauth_refresh_token'
          subcmd = PocYoutube::Commands::OauthRefreshToken.new({})
        end
        subcmd&.execute(input: input, output: output)
      end

      private

      def gui
        prompt = TTY::Prompt.new

        choices = [
          'auth_code',
          'refresh_token',
          { name: :gui, disabled: '(:gui disabled, you are already on this menu)' }
        ]

        subcommand = prompt.select('Select your subcommand?', choices, per_page: 15, cycle: true)

        command = PocYoutube::Commands::Oauth.new(subcommand, {})
        command.execute(input: @input, output: @output)
      end
    end
  end
end
