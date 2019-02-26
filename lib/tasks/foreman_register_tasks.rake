# frozen_string_literal: true

require 'rake/testtask'

# Tests
namespace :test do
  desc 'Test ForemanRegister'
  Rake::TestTask.new(:foreman_register) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_register do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_register) do |task|
        task.patterns = ["#{ForemanRegister::Engine.root}/app/**/*.rb",
                         "#{ForemanRegister::Engine.root}/lib/**/*.rb",
                         "#{ForemanRegister::Engine.root}/test/**/*.rb"]
      end
    rescue StandardError
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_register'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_register']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_register', 'foreman_register:rubocop']
end
