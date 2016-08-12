require 'pry'

# lib/sherlock_and_valid_string/string_corrector.rb

# The StringCorrector module contains methods related to making invalid strings
# valid (with regard to the solving (S) for a given string as documented in the
# hypothetical README.md that would exist for an important production grade
# codebase).
module StringCorrector

  # Raises an exception if the string does not meet the minimum criteria to be
  # solved, e.g.
  #   - if the string is less than 1 character, or
  #   - if the string is greater than 10**5
  #   - if the string contains anything other than the lower case characters a-z
  def ensure_string_is_solvable!(string)
    character_validation_pattern = /^[a-z]+$/
    if string.length < 1
      raise "ERROR: the string is less than or equal to 1 character"
    elsif string.length > 100_000 # 10**5
      raise "ERROR: the string is too large"
    elsif (string =~ character_validation_pattern).nil?
      raise "ERROR: the string contained characters other than those [a-z]"
    end
  end

  # Returns an array of LetterOfS objects which depict the frequencey of
  # occurance for each distinct character in the string.
  # Consider this function to return
  #
  #         [ LetterOfS(["a", 3]),
  #           LetterOfS(["b", 2]),
  #           LetterOfS(["c", 2]),
  #           LetterOfS(["x", 1]) ]
  #
  # when given a string of "aaabbccx".
  def construct_frequency_analysis_array(string)
    string.split("").each_with_object(Hash.new(0)) do |letter, hash|
      hash[letter] += 1 # increment frequency count for this letter
    end.map {|h| LetterOfS.new(h) }
  end

  # Returns the count of characters that need to be removed from the string
  # to make it valid with regard to (S).
  def deduce_number_of_removals_required_to_correct_a_string(string)
    smart_reduction_count_process(string)
  end

  # Terminology:
  #
  # Given the string "aabbccddx", there exists 1 *flake* (it's 'x').
  # A flake is a character that is easier to completely remove than it is to
  # decrement the occurences of all other characters more frequent than said flake
  # (it flakes off easily).
  #
  # Given the string "aabbccddx", if the letter 'a' were chosen to be the
  # *match_target*, letters b, c, and d would not need to be decremented at all
  # because they already match the frequency of letter 'a'.  However the number
  # of occurences of 'x' would need to be removed to completely eliminate
  # it from the string.  That is to say that if 'a' were selected as a
  # match_target only one removal step would be required to eliminate the flake
  # 'x'.
  #
  # smart_reduction_count_process will accept a string, say "aaabbccddx" and
  # return the integer 2 as that the optimal number of steps required to make
  # the string valid are 2; *one* step to remove an 'a' such that the letter 'a'
  # is as frequent as the match_target of b (c, or d could also be chosen as
  # match targets).  Additionally *one* step would be required to remove the
  # letter 'x' from the string entirely.
  def smart_reduction_count_process(string)
    @character_by_frequency_array = construct_frequency_analysis_array(string)

    n_removals_of_each_potential_match_target =
      @character_by_frequency_array.map do |match_target|
        determine_number_of_removals_given_match_target(match_target)
      end.compact

    # pick that of the least number of removals
    minimal_number_of_removals = n_removals_of_each_potential_match_target.sort.first
  end

  # Returns the number of removals required to eliminate all letters with a
  # smaller frequency than match_target, plus the cost to reduce all letters
  # with a greater frequency than that of match_target to be equal to the
  # match_target's frequency.
  def determine_number_of_removals_given_match_target(match_target)

    # for each neighboring letter of match_target
    @character_by_frequency_array.map do |other_letter|
      next if other_letter.char == match_target.char # skip over itself

      # If the other letter's frequency is greater than the match_letter's
      # count, then we need to count it downwards to the match_target's count
      if other_letter.count >= match_target.count
        other_letter.count - match_target.count
      # Otherwise we count the other letter's frequency down to zero ><
      else
        other_letter.count
      end

    end.compact.reduce(:+)
  end

end

# This simple class is for working with Letters in strings to make them valid
# (S) strings.
class LetterOfS
  attr_reader :char, :count

  def initialize(k_v)
    @char, @count = k_v
  end
end



# lib/sherlock_and_valid_string/contractor_to_sherlock.rb

# Sherlock needs a 3rd party contractor to answer some questions
# about a strings that watson gives to him.
class ContractorToSherlock
  include StringCorrector

  # Sherlock will want the result of this method to determine how many steps are
  # required to reach a string of (S) given a string from Watson.
  def check_string_for_sherlock(string)
    ensure_string_is_solvable!(string)
    return "YES" if string.length == 1

    if solvable_in_one_removal?(string)
      "YES"
    else
      "NO"
    end
  end


  private
    # meta-notes: I gave this it's own function to hide the conditional check
    # so that the top-most algo looks absolutely crystal clear.
    def solvable_in_one_removal?(string)
      if deduce_number_of_removals_required_to_correct_a_string(string) <= 1
        true
      else
        false
      end
    end
end



# gets the first line from stdin
watsons_string = ARGF.read.lines.first.chomp

ben = ContractorToSherlock.new

puts ben.check_string_for_sherlock(watsons_string)
