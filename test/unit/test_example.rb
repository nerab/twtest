require 'twtest'

class ExampleTest < TaskWarrior::Test::Integration::TestCase
  GTD = "get things done"

  def test_empty
    task("add #{GTD}")
    tasks = export_tasks
    assert_equal(1, tasks.size)
    assert_equal(GTD, tasks.first['description'])
    assert_equal('pending', tasks.first['status'])
  end
end
