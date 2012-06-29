require 'tempfile'
require 'tmpdir'
require 'erb'
require 'json'

module TaskWarrior
  module Test
    module Integration
      class TestCase < Test::Unit::TestCase
        def setup
          @data_dir = Dir.mktmpdir
          @taskrc_file = build_taskrc(:data_dir => @data_dir)
        end

        def teardown
          FileUtils.rm_r(@data_dir)
          File.delete(@taskrc_file)
        end
      
      protected
        def export_tasks
          JSON[exec('export')]
        end
  
        def exec(cmd)
          ENV['TASKRC'] = @taskrc_file
          %x[task #{cmd}]
        end
  
        def build_taskrc(options = {})
          taskrc_file = Tempfile.new('taskrc')
          data_dir = options[:data_dir]
    
          begin
            taskrc_file.write(ERB.new(File.read(File.join(File.dirname(__FILE__), '..', 'templates', 'taskrc.erb')), 0, "%<>").result(binding))
            return taskrc_file.path
          ensure
            taskrc_file.close
          end
        end
        
      end
    end
  end
end