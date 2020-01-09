# frozen_string_literal: true

require_relative '../command'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class ChannelMine < PocYoutube::Command
      def initialize(options)
        @options = options
      end

      # Execute ChannelMine subcommand taking input from 
      # a input stream and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        :gui
      end
    end
  end
end
