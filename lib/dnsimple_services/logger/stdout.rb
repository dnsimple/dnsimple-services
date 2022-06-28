# frozen_string_literal: true

module DnsimpleServices
  module Logger
    # A logger that writes the output messages to STDOUT.
    class Stdout
      def write(message)
        puts message
      end
      alias << write
    end
  end
end
