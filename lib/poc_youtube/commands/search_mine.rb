# frozen_string_literal: true

require_relative '../command'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class SearchMine < PocYoutube::Command
      def initialize(options)
        @options = options
      end

      # Execute SearchMine subcommand taking input from 
      # a input stream and writing to output stream
      #
      # sample: output.puts 'OK'
      def execute(input: $stdin, output: $stdout)
        data = list_searches_by(type: 'video', for_mine: true, max_results: 50)

        pretty_table('videos',
                     %w[video_id title published_at],
                     data.map { |d| [d[:video_id], d[:title], d[:published_at]] })

        pretty_table('videos thumbnails',
                     %w[video_id title thumbnail],
                     data.map { |d| [d[:video_id], d[:title], d[:thumbnail_high]] })
      end

      # invalidSearchFilter: The request contains an invalid combination of search filters and/or restrictions.
      #Note that you must set the <code>type</code> parameter to <code>video</code> if you set either the <code>forContentOwner</code> or <code>forMine</code> parameters to <code>true</code>. You must also set the <code>type</code> parameter to <code>video</code> if you set a value for the <code>eventType</code>, <code>videoCaption</code>, <code>videoCategoryId</code>, <code>videoDefinition</code>, <code>videoDimension</code>, <code>videoDuration</code>, <code>videoEmbeddable</code>, <code>videoLicense</code>, <code>videoSyndicated</code>, or <code>videoType</code>)

      def list_searches_by(part = 'snippet', **params)
        response = youtube.list_searches(part, params).to_json
        data = JSON.parse(response)

        data.fetch('items').map { |i| mapper(i) }
      end

      def mapper(item)
        {
          etag: item.dig('etag'),
          kind: item.dig('id', 'kind'),
          video_id: item.dig('id', 'videoId'),
          title: item.dig('snippet', 'title'),
          description: item.dig('snippet', 'description'),
          published_at: item.dig('snippet', 'publishedAt'),
          thumbnail_default: item.dig('snippet', 'thumbnails', 'default', 'url'),
          thumbnail_high: item.dig('snippet', 'thumbnails', 'high', 'url'),
          thumbnail_medium: item.dig('snippet', 'thumbnails', 'medium', 'url'),
          channel_id: item.dig('snippet', 'channelId'),
          channel_title: item.dig('snippet', 'channelTitle')
        }
      end
    end
  end
end
