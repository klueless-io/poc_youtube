# frozen_string_literal: true

RSpec.describe '`poc_youtube oauth` command', type: :cli do
  it 'executes `poc_youtube help oauth` command successfully' do
    output = `poc_youtube help oauth`
    expected_output = <<~OUT
      Usage:
        poc_youtube oauth SUBCOMMAND

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Oauth description
    OUT

    expect(output).to eq(expected_output)
  end
end
