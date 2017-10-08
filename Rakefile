# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new(:rubocop)

Rake::Task["default"].clear if Rake::Task.task_defined?("default")
task :default => %i[ rubocop ]
