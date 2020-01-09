# frozen_string_literal: true

RSpec.describe '`poc_youtube search` command', type: :cli do
  it 'executes `poc_youtube help search` command successfully' do
    output = `poc_youtube help search`
    expected_output = <<~OUT
      Usage:
        poc_youtube search SUBCOMMAND

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Youtube Search Command
    OUT

    expect(output).to eq(expected_output)
  end
end
