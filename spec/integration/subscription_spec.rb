# frozen_string_literal: true

RSpec.describe '`poc_youtube subscription` command', type: :cli do
  it 'executes `poc_youtube help subscription` command successfully' do
    output = `poc_youtube help subscription`
    expected_output = <<~OUT
      Usage:
        poc_youtube subscription SUBCOMMAND

      Options:
        -h, [--help], [--no-help]  # Display usage information

      YouTube Subscription Lister
    OUT

    expect(output).to eq(expected_output)
  end
end
