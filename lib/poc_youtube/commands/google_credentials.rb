# frozen_string_literal: true

require 'google/apis/youtube_v3'

module PocYoutube
  # Get authentication credentials from google
  #
  # Learn more:
  #   - https://martinfowler.com/articles/command-line-google.html
  # API Discovery resources
  #   - https://developers.google.com/discovery/v1/using
  #   - https://www.googleapis.com/discovery/v1/apis?parameters
  #   - https://www.googleapis.com/discovery/v1/apis/youtube/v3/rest
  class GoogleCredentials
    def initialize(application_name: nil, refresh_key:, scopes: nil, client_secret: nil, client_id: nil)
      @application_name = application_name
      @refresh_key = refresh_key
      @scopes = scopes
      @client_secret = client_secret
      @client_id = client_id
    end

    def self.for_youtube(credential_file = '/Users/davidcruwys/dev_credentials/poc-youtube-client-id.json')
      file = File.read(credential_file)
      data = JSON.parse(file)

      scopes = [Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY]

      client_id = data['installed']['client_id']
      client_secret = data['installed']['client_secret']

      new(
        application_name: 'Youtube',
        refresh_key: 'yt',
        scopes: scopes,
        client_id: client_id,
        client_secret: client_secret
      )
    end

    def retrieve_oneoff_auth_code
      URI::HTTPS.build(authorization_url)
    end

    def authorization_url
      # The parameters to the URL are:

      # scope:          how much api access we want
      # redirect_uri:   in the usual flow of using this with a web app,
      #                 google redirects the browser to another URL
      #                 (typically a localhost post) and deposits its response there.
      #                 Using this value tells google I want it displayed
      #                 in the browser for me to copy and paste
      # response_type:  I want a one-time authorization code back
      # client_id:      I get this from the earlier interaction with
      #                 the Google Developers Console

      params = {
        scope: @scopes.join(' '),
        redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
        response_type: 'code',
        client_id: @client_id
      }
      {
        host: 'accounts.google.com',
        path: '/o/oauth2/v2/auth',
        query: URI.encode_www_form(params)
      }
    end

    def renew_refresh_token(auth_code, refresh_token_file)
      token = get_new_refresh_token(auth_code)
      # puts "new token: #{token}"
      save_refresh_token(token, refresh_token_file)
    end

    def get_new_refresh_token(auth_code)
      client = Signet::OAuth2::Client.new(
        token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
        code: auth_code,
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
        grant_type: 'authorization_code'
      )
      client.fetch_access_token!
      client.refresh_token
    end

    # Save into Mac Keychain
    def save_refresh_token_mac(arg)
      cmd = "security add-generic-password -a '#{@refresh_key}' -s '#{@refresh_key}' -w '#{arg}'"
      system cmd
    end

    def save_refresh_token(refresh_token, refresh_token_file)
      data = {
        refresh_key: @refresh_key,
        refresh_token: refresh_token
      }
      json = JSON.pretty_generate(data)

      File.write(refresh_token_file, json)
    end

    def load_user_refresh_credentials(refresh_token)
      @credentials = Google::Auth::UserRefreshCredentials.new(
        client_id: @client_id,
        scope: @scopes,
        client_secret: @client_secret,
        refresh_token: refresh_token,
        additional_parameters: { 'access_type' => 'offline' })
      @credentials.fetch_access_token!
      @credentials
    end

    def load_refresh_token_mac_keychain
      @refresh_token = `security find-generic-password -wa #{@refresh_key}`.chomp
    end

    def load_refresh_token_file(refresh_token_file)
      file = File.read(refresh_token_file)
      data = JSON.parse(file)

      @refresh_token = data['refresh_token']
    end
  end
end
