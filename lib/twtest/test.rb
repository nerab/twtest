# frozen_string_literal: true

require 'json'

module TaskWarrior
  module Test
    module Integration
      class Test < MiniTest::Test
        def initialize(*args)
          super
          @taskrc_file = nil
          @data_dir = nil
        end

        def setup
          assert(task('--version') =~ /2\.\d\.\d/, "The TaskWarrior binary '#{TASK}' must be available and at least v2.0.")
          @data_dir = Dir.mktmpdir
          @taskrc_file = build_taskrc(data_dir: @data_dir)
        end

        def teardown
          FileUtils.rm_r(@data_dir) if @data_dir && Dir.exist?(@data_dir)
          File.delete(@taskrc_file) if @taskrc_file && File.exist?(@taskrc_file)
        end

        protected

        def export_tasks(args={})
          json = task('export', args)
          raise 'Empty JSON returned by task command' if json.nil? || json.empty?
          JSON.parse(json)
        end

        def task(cmd, args={})
          ENV['TASKRC'] = @taskrc_file
          `#{build_line(cmd, args)}`
        end

        def build_line(cmd, args={})
          [].tap { |line|
            line << TASK
            line << args.map { |k, v| "#{Shellwords.escape(k.strip)}=#{Shellwords.escape(v.strip)}" }.join(' ')
            line << cmd.strip
            line.reject!(&:empty?)
          }.join(' ')
        end

        def build_taskrc(options={})
          taskrc = Tempfile.new('taskrc')
          @data_dir = options[:data_dir]

          begin
            taskrc.write(ERB.new(File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'taskrc.erb')), 0, '%<>').result(binding))
            return taskrc.path
          ensure
            taskrc.close
          end
        end

        TASK = 'task'
      end
    end
  end
end
