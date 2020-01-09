# frozen_string_literal: true

require_relative '../command'

require 'tty-config'
require 'tty-prompt'

module PocYoutube
  module Commands
    # Command Name goes here
    class SubscriptionMine < PocYoutube::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        data = list_subscription_by(mine: true, max_results: 50)

        pretty data

        pretty_table('subscriptions',
              %w[video_id title published_at],
              data.map { |d| [d[:video_id], d[:title], d[:published_at]] })

        pretty_table('subscription images',
                     %w[video_id title thumbnail],
                     data.map { |d| [d[:video_id], d[:title], d[:thumbnail_high]] })
      end

      def list_subscription_by(part = 'snippet,subscriber_snippet', **params)
        response = youtube.list_subscriptions(part, params).to_json
        data = JSON.parse(response)

        pretty data

        data.fetch('items').map { |i| mapper(i) }
      end

      def mapper(item)
        {
          etag: item.dig('etag'),
          id: item.dig('id'),
          video_id: item.dig('contentDetails', 'upload', 'videoId'),
          kind: item.dig('kind'),
          description: item.dig('snippet', 'description'),
          published_at: item.dig('snippet', 'publishedAt'),
          channel_id: item.dig('snippet', 'channelId'),
          channel_title: item.dig('snippet', 'channelTitle'),
          thumbnail_default: item.dig('snippet', 'thumbnails', 'default', 'url'),
          thumbnail_high: item.dig('snippet', 'thumbnails', 'high', 'url'),
          thumbnail_medium: item.dig('snippet', 'thumbnails', 'medium', 'url'),
          thumbnail_maxres: item.dig('snippet', 'thumbnails', 'maxres', 'url'),
          thumbnail_standard: item.dig('snippet', 'thumbnails', 'standard', 'url'),
          title: item.dig('snippet', 'title'),
          type: item.dig('type')
        }
      end
    end
  end
end
