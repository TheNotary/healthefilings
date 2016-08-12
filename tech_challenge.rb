# lib/sherlock_and_valid_string/string_corrector.rb

# This module contains methods related to making invalid strings valid
# (with regard to the solving (S) for a given string as documented in the
# hypothetical README.md that would exist for an important production grade
# codebase)
module StringCorrector

  # Raises an exception if the string does not meet the minimum criteria to be
  # solved, e.g.
  #   - if the string is less than or equal to 1 character, or
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

  # Returns a hash depicting the frequencey of occurance for each distinct
  # character in the string
  def construct_frequency_analysis_hash(string)
    string.split("").each_with_object(Hash.new(0)) do |letter, hash|
      hash[letter] += 1 # increment frequency count for this letter
    end
  end

  # Returns the count of characters that need to be removed from the string
  # to make it valid with regard to (S).
  def deduce_number_of_removals_required_to_correct_a_string(string)
    # reduction_by_greatest_frequenters(string)
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
    # e.g { a: 3, b: 2, c: 2, x: 1 }
    character_by_frequency_hash = construct_frequency_analysis_hash(string)

    n_removals_per_potential_match_target = character_by_frequency_hash.map do |k_v|
      this_letter = LetterOfS.new(k_v) # this_letter, this_count = k_v

      determine_number_of_removes_given_match_target(this_letter, character_by_frequency_hash)
    end.compact.sort

    minimal_number_of_removals = n_removals_per_potential_match_target.first
  end

  # Returns the number of removals required to eliminate all letters with a
  # smaller frequency than match_letter, plus the cost to reduce all letters
  # with a greater frequency than that of match_letter to be equal to the
  # match_letter's frequency
  def determine_number_of_removes_given_match_target(match_letter, character_by_frequency_hash)
    # for each of it's neighboring letters
    character_by_frequency_hash.map do |other_letter_pair|
      # FIXME: ask if there's a cooler way to do this... I bet there is...
      other_letter = LetterOfS.new(other_letter_pair)
      next if other_letter.char == match_letter.char # skip over itself

      # If the other letter's frequency is greater than the match_letter's
      # count, then we need to count it downwards to the match_letter's count
      if other_letter.count >= match_letter.count
        other_letter.count - match_letter.count
      # Otherwise we count the other letter's frequency down to zero ><
      else
        other_letter.count
      end

    end.compact.inject(&:+)
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

  # Sherlock will want the result of this method to determine how 'easy'
    # it is to solve the (S) for a string given to him by Watson.
  def validate_string_for_sherlock(string)
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
    # which so the top-most algo looks absolutely crystal clear.
    def solvable_in_one_removal?(string)
      if deduce_number_of_removals_required_to_correct_a_string(string) <= 1
        true
      else
        false
      end
    end
end


# gets the first line from stdin
watsons_string = ARGF.read # .lines.first.chomp
if watsons_string.nil? or watsons_string.lines.nil? or watsons_string.lines.first.nil?
  watsons_string = ""
else
  watsons_string = watsons_string.lines.first.chomp
end

#
# Given a frequency analysis, we'll see that...
f = {
      a: 203,
      b: 202,
      c: 201,
      x: 2,
      y: 2,
      z: 1
    }
# because a is so massive, all the other letters are flakes.
# To determine flakeyness, iterate over each number (especially the largest)
# and count the difference between:
# x and y and
# y and 0,
# where x is the large number, and y is the other number


ben = ContractorToSherlock.new

puts ben.validate_string_for_sherlock(watsons_string)
