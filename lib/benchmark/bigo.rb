# encoding: utf-8
require 'erb'
require 'chartkick'
require 'benchmark/bigo_report'
require 'benchmark/bigo_job'

module Benchmark

  module BigO
    VERSION = "0.9.0"

    def bigo
      suite = nil

      sync, $stdout.sync = $stdout.sync, true

      if defined? Benchmark::Suite and Suite.current
        suite = Benchmark::Suite.current
      end

      quiet = suite && !suite.quiet?

      job = BigOJob.new({:suite => suite,
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

      return job.reports
    end
  end

  extend Benchmark::BigO
end
