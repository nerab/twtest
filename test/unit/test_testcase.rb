# frozen_string_literal: true

require 'test_helper'
require 'json'

class TestTestCase < TaskWarrior::Test::Integration::TestCase
  def test_empty
    # http://taskwarrior.org/issues/1017
    # assert_empty(export_tasks)

    # Use a placeholder as workaround
    task('add placeholder')
    assert_equal(1, export_tasks.size)
  end

  def test_import
    contents = { description: 'foobar' }
    input_file = Tempfile.new('test_simple')

    begin
      input_file.write(JSON.dump(contents))
      input_file.close

      # TODO: Replace temp file with in-process version
      #     task("import <(echo '#{JSON.dump(contents)}')")
      task("import #{input_file.path}")

      tasks = export_tasks
      assert_equal(1, tasks.size)
      assert_equal('foobar', tasks.first['description'])
    ensure
      input_file.unlink
    end
  end
end
