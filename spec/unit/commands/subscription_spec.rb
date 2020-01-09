# frozen_string_literal: true

require 'poc_youtube/commands/subscription'

RSpec.describe PocYoutube::Commands::Subscription do

  let(:subcommand) { nil }
  let(:options) { {} }
  subject { PocYoutube::Commands::Subscription.new(subcommand, options) }

  describe 'initialize' do
    it 'executes `subscription` command successfully' do
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
