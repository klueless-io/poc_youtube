# frozen_string_literal: true

require 'thor'

module PocYoutube
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'poc_youtube version'
    def version
      require_relative 'version'
      puts 'v' + PocYoutube::VERSION
    end
    map %w[--version -v] => :version

    #
    # playlist
    #
    desc 'playlist SUBCOMMAND', 'Youtube Playlist Lister'
    method_option :help, aliases: '-h',
                         type: :boolean,
                         desc: 'Display usage information'
    def playlist(subcommand = :gui)
      if options[:help]
        invoke :help, ['playlist']
      else
        require_relative 'commands/playlist'
        PocYoutube::Commands::Playlist.new(subcommand, options).execute
      end
    end
    
    #
    # search
    #
    desc 'search SUBCOMMAND', 'Youtube Search Command'
    method_option :help, aliases: '-h',
                         type: :boolean,
                         desc: 'Display usage information'
    def search(subcommand = :gui)
      if options[:help]
        invoke :help, ['search']
      else
        require_relative 'commands/search'
        PocYoutube::Commands::Search.new(subcommand, options).execute
      end
    end
    
    #
    # subscription
    #
    desc 'subscription SUBCOMMAND', 'YouTube Subscription Lister'
    method_option :help, aliases: '-h',
                         type: :boolean,
                         desc: 'Display usage information'
    def subscription(subcommand = :gui)
      if options[:help]
        invoke :help, ['subscription']
      else
        require_relative 'commands/subscription'
        PocYoutube::Commands::Subscription.new(subcommand, options).execute
      end
    end
    
    #
    # channel
    #
    desc 'channel SUBCOMMAND', 'Youtube Channel lister'
    method_option :help, aliases: '-h',
                         type: :boolean,
                         desc: 'Display usage information'
    def channel(subcommand = :gui)
      if options[:help]
        invoke :help, ['channel']
      else
        require_relative 'commands/channel'
        PocYoutube::Commands::Channel.new(subcommand, options).execute
      end
    end
    
    #
    # oauth
    #
    desc 'oauth SUBCOMMAND', 'Oauth description'
    method_option :help, aliases: '-h',
                         type: :boolean,
                         desc: 'Display usage information'
    def oauth(subcommand = :gui)
      if options[:help]
        invoke :help, ['oauth']
      else
        require_relative 'commands/oauth'
        PocYoutube::Commands::Oauth.new(subcommand, options).execute
      end
    end
  end
end
