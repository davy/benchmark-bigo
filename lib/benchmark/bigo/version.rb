module Benchmark
  module BigO
    class Version
      MAJOR = 1
      MINOR = 0
      PATCH = 0

      def self.to_s
        [MAJOR, MINOR, PATCH].compact.join('.')
      end
    end

    VERSION = Version.to_s
  end
end
