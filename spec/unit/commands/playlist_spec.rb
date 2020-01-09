# frozen_string_literal: true

require 'poc_youtube/commands/playlist'

RSpec.describe PocYoutube::Commands::Playlist do

  let(:subcommand) { nil }
  let(:options) { {} }
  subject { PocYoutube::Commands::Playlist.new(subcommand, options) }

  describe 'initialize' do
    it 'executes `playlist` command successfully' do
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
