module Benchmark
  module BigO
    class Version
      MAJOR = 0
      MINOR = 0
      PATCH = 1
      DATE  = 20140808093808

      def self.to_s
        [MAJOR, MINOR, PATCH, DATE].compact.join('.')
      end
    end

    VERSION = Version.to_s
  end
end
