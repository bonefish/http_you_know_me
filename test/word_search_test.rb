require './lib/word_search.rb'
require 'minitest/autorun'
require 'minitest/pride'

class WordSearchTest < MiniTest::Test

  attr_reader :word_search

  def setup
    @word_search = WordSearch.new
  end

  def test_it_populates_full_dictionary
    assert_equal 235886, word_search.dictionary.length
  end

  def test_it_valididate_good_word
    assert word_search.valid_word?('pizza')
  end

  def test_it_invalidates_bad_word
    refute word_search.valid_word?('piz')
  end

  def test_it_validates_good_upper_case_word
    assert word_search.valid_word?('PIZZA')
  end

  def test_it_invalidates_empty_word
    refute word_search.valid_word?('')
    refute word_search.valid_word?(nil)
  end

end
