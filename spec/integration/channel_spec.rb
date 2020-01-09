# frozen_string_literal: true

RSpec.describe '`poc_youtube channel` command', type: :cli do
  it 'executes `poc_youtube help channel` command successfully' do
    output = `poc_youtube help channel`
    expected_output = <<~OUT
      Usage:
        poc_youtube channel SUBCOMMAND

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Youtube Channel lister
    OUT

    expect(output).to eq(expected_output)
  end
end
