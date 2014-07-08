# encoding: utf-8
require 'erb'
require 'chartkick'
require 'benchmark/ips'
require 'benchmark/bigo/report'
require 'benchmark/bigo/job'

module Benchmark

  module BigO
    VERSION = "0.0.1"

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

      if job.chart?
        job.generate_chart
      end

      $stdout.sync = sync

      return job.full_report
    end
  end

  extend Benchmark::BigO
end
