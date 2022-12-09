# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::RequireOrder, :config do
  context 'when `require` is sorted' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'a'
        require 'b'
      RUBY
    end
  end

  context 'when `require` is not sorted in different sections' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'b'
        require 'd'

        require 'a'
        require 'c'
      RUBY
    end
  end

  context 'when `require` is not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        require 'b'
        require 'a'
        ^^^^^^^^^^^ Sort `require` in alphabetical order.
      RUBY

      expect_correction(<<~RUBY)
        require 'a'
        require 'b'
      RUBY
    end
  end

  context 'when unsorted `require` has some inline comments' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        require 'b' # comment
        require 'a'
        ^^^^^^^^^^^ Sort `require` in alphabetical order.
      RUBY

      expect_correction(<<~RUBY)
        require 'a'
        require 'b' # comment
      RUBY
    end
  end

  context 'when unsorted `require` has some full-line comments' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        require 'b'
        # comment
        require 'a'
        ^^^^^^^^^^^ Sort `require` in alphabetical order.
      RUBY

      expect_correction(<<~RUBY)
        # comment
        require 'a'
        require 'b'
      RUBY
    end
  end

  context 'when `require_relative` is not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        require_relative 'b'
        require_relative 'a'
        ^^^^^^^^^^^^^^^^^^^^ Sort `require_relative` in alphabetical order.
      RUBY

      expect_correction(<<~RUBY)
        require_relative 'a'
        require_relative 'b'
      RUBY
    end
  end

  context 'when both `require` and `require_relative` are in same section' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'b'
        require_relative 'a'
      RUBY
    end
  end

  context 'when `require_relative` is put between unsorted `require`' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'c'
        require_relative 'b'
        require 'a'
      RUBY
    end
  end

  context 'when `require` is a method argument' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        do_something(require)
      RUBY
    end
  end

  context 'when `Bundler.require` is put between unsorted `require`' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'e'
        Bundler.require(:default)
        require 'c'
      RUBY
    end
  end

  context 'when `Bundler.require` with no arguments is put between `require`' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'c'
        Bundler.require
        require 'a'
      RUBY
    end
  end

  context 'when something other than a method call is used between `require`' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        require 'a'
        begin
        end
        require 'b'
      RUBY
    end
  end
end
