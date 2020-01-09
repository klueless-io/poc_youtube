# frozen_string_literal: true

require 'poc_youtube/commands/oauth'

RSpec.describe PocYoutube::Commands::Oauth do

  let(:subcommand) { nil }
  let(:options) { {} }
  subject { PocYoutube::Commands::Oauth.new(subcommand, options) }

  describe 'initialize' do
    it 'executes `oauth` command successfully' do
      output = StringIO.new
      subject.execute(output: output)

      expect(output.string).to eq('')
    end
  end

  describe 'execute' do
    before { subject.execute }

    context 'with XYZ' do
    end
  end
end
