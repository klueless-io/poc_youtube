# frozen_string_literal: true

require_relative '../command'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class Subscription < PocYoutube::Command
      def initialize(subcommand, options)
        @subcommand = (subcommand || '').to_sym

        @options = options
      end

      # Execute Subscription command taking input from a input stream
      # and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        case @subcommand
        when :gui
          gui
        when :mine
          require_relative 'subscription_mine'
          subcmd = PocYoutube::Commands::SubscriptionMine.new({})
        end
        subcmd&.execute(input: input, output: output)
      end

      private

      def gui
        prompt = TTY::Prompt.new

        choices = [
          'mine',
          { name: :gui, disabled: '(:gui disabled, you are already on this menu)' }
        ]

        subcommand = prompt.select('Select your subcommand?', choices, per_page: 15, cycle: true)

        command = PocYoutube::Commands::Subscription.new(subcommand, {})
        command.execute(input: @input, output: @output)
      end
    end
  end
end
