require 'test/unit'

require 'tmpdir'
require 'erb'
require 'json'

module TaskWarrior
  module Test
    module Integration
      class TestCase < ::Test::Unit::TestCase
        def setup
          assert(task_command_available?, "The TaskWarrior binary '#{TASK}' was not found or is not executable.")
          @data_dir = Dir.mktmpdir
          @taskrc_file = build_taskrc(:data_dir => @data_dir)
        end

        def teardown
          FileUtils.rm_r(@data_dir) if @data_dir && Dir.exist?(@data_dir)
          File.delete(@taskrc_file) if @taskrc_file && File.exist?(@taskrc_file)
        end
      
      protected
        def task_command_available?
          !%x[type -t #{TASK}].chomp.empty?
        end

        def export_tasks
          JSON[task('export')]
        end
  
        def task(cmd)
          ENV['TASKRC'] = @taskrc_file
          %x[#{TASK} #{cmd}]
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