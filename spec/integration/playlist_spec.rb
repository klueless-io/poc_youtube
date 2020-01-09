# frozen_string_literal: true

RSpec.describe '`poc_youtube playlist` command', type: :cli do
  it 'executes `poc_youtube help playlist` command successfully' do
    output = `poc_youtube help playlist`
    expected_output = <<~OUT
      Usage:
        poc_youtube playlist SUBCOMMAND

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Youtube Playlist Lister
    OUT

    expect(output).to eq(expected_output)
  end
end
