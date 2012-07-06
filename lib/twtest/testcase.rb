require 'test/unit'

require 'tmpdir'
require 'erb'
require 'json'
require 'shellwords'

module TaskWarrior
  module Test
    module Integration
      class TestCase < ::Test::Unit::TestCase
        def setup
#          assert(task_command_available?, "The TaskWarrior binary '#{TASK}' was not found or is not executable.")
          @data_dir = Dir.mktmpdir
          @taskrc_file = build_taskrc(:data_dir => @data_dir)
        end

        def teardown
          FileUtils.rm_r(@data_dir) if @data_dir && Dir.exist?(@data_dir)
          File.delete(@taskrc_file) if @taskrc_file && File.exist?(@taskrc_file)
        end
      
      protected
        def task_command_available?
          result = %x[type -t #{TASK}]
          result.nil? ? false : !result.chomp.empty?
        end

        def export_tasks(args = {})
          json = task('export', args)
          raise "Empty JSON returned by task command" if json.nil? || json.empty?
          JSON[json]
        end
  
        def task(cmd, args = {})
          ENV['TASKRC'] = @taskrc_file
          %x[#{build_line(cmd, args)}]
        end

        def build_line(cmd, args = {})
          [].tap{|line|
            line << TASK
            line << args.map{|k,v| "#{Shellwords.escape(k.strip)}=#{Shellwords.escape(v.strip)}"}.join(' ')
            line << cmd.strip
            line.reject!{|part| part.empty?}
          }.join(' ')
        end
  
        def build_taskrc(options = {})
          taskrc_file = Tempfile.new('taskrc')
          data_dir = options[:data_dir]
    
          begin
            taskrc_file.write(ERB.new(File.read(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'taskrc.erb')), 0, "%<>").result(binding))
            return taskrc_file.path
          ensure
            taskrc_file.close
          end
        end

      private
        TASK = 'task'
      end
    end
  end
end