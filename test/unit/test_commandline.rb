# frozen_string_literal: true

require 'test_helper'

class TestCommandLine < TaskWarrior::Test::Integration::Test
  def test_plain
    assert_equal('task foo', build_line('foo'))
  end

  def test_args
    assert_equal('task foo=bar something', build_line('something', 'foo' => 'bar'))
  end

  def test_args_empty
    assert_equal('task something', build_line('something', {}))
  end

  def test_args_with_blanks
    assert_equal('task foo=bar something', build_line('something', ' foo ' => ' bar '))
  end

  def test_command_with_blanks
    assert_equal('task something', build_line(' something '))
  end
end
