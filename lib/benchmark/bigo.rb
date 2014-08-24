# encoding: utf-8
require 'erb'
require 'chartkick'
require 'csv'
require 'benchmark/ips'
require 'benchmark/bigo/report'
require 'benchmark/bigo/job'

module Benchmark

  module BigO
    def bigo
      suite = nil

      sync, $stdout.sync = $stdout.sync, true

      if defined? Benchmark::Suite and Suite.current
        suite = Benchmark::Suite.current
      end

      quiet = suite && !suite.quiet?

      job = Job.new({:suite => suite,
                     :quiet => quiet
      })

      yield job

      $stdout.puts "Calculating -------------------------------------" unless quiet

      job.run_warmup

      $stdout.puts "-------------------------------------------------" unless quiet

      job.run
      job.generate_output

      $stdout.sync = sync

      return job.full_report
    end
  end

  extend Benchmark::BigO
end
