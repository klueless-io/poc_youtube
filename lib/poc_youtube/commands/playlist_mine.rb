# frozen_string_literal: true

require_relative '../command'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class PlaylistMine < PocYoutube::Command
      def initialize(options)
        @options = options
      end

      # Execute PlaylistMine subcommand taking input from 
      # a input stream and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        data = list_playlists_by(mine: true, max_results: 50)

        pretty data

        pretty_table('playlists',
                     %w[title published id channel],
                     data.map { |d| [d[:title], d[:published_at], d[:id], d[:channel_title]] })
      end

      def list_playlists_by(part = 'snippet,contentDetails', **params)
        response = youtube.list_playlists(part, params).to_json
        data = JSON.parse(response)

        data.fetch('items').map { |i| mapper(i) }
      end

      def mapper(item)
        {
          id: item.dig('id'),
          etag: item.dig('etag'),
          kind: item.dig('kind'),
          channel_id: item.dig('snippet', 'channelId'),
          channel_title: item.dig('snippet', 'channelTitle'),
          title: item.dig('snippet', 'title'),
          description: item.dig('snippet', 'description'),
          published_at: item.dig('snippet', 'publishedAt')
        }
      end
    end
  end
end
