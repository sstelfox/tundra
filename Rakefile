require 'bundler/gem_tasks'

desc 'Run a console with the application loaded'
task console: [:environment] do
  require 'pry'
  pry
end

task :default do
  tasks = {
    docs: 'Document Generation',
    flay: 'Flay Report',
    flog: 'Flog Report',
    rubocop: 'RuboCop Report',
    spec: 'RSpec Tests'
  }

  tasks.each do |task, title|
    next unless Rake::Task.task_defined?(task)

    puts format("%s:\n", title)
    Rake::Task[task].invoke
    puts
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:docs)
rescue LoadError
  puts 'Yardoc isn\'t available to the rake environment'
end

task :environment do
  require 'tundra'
end

begin
  require 'flay'

  task :flay do
    files = Flay.filter_files(Flay.expand_dirs_to_files('lib/'))

    flay = Flay.new
    flay.process(*files)
    flay.report
  end
rescue LoadError
  puts 'Flay isn\'t available'
end

begin
  require 'flog_cli'

  task :flog do
    flog = FlogCLI.new(quiet: false, continue: false, parser: RubyParser,
                       score: true)
    flog.flog(['lib/'])
    flog.report
  end
rescue LoadError
  puts 'Flog isn\'t available'
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.formatters = %w(simple offenses)
    task.fail_on_error = false
    task.options = %w(--format html --out doc/rubocop.html)
  end
rescue LoadError
  puts 'Rubocop isn\'t available to the rake environment'
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts 'RSpec isn\'t available to the rake environment'
end
