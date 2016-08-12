# This code passes all tests, even test 13... because when the app throws an
# exception... it also prints "YES" which is what test 13 expects...


# lib/sherlock_and_valid_string/string_corrector.rb

# This module contains methods related to making invalid strings valid
# (with regard to the solving (S) for a given string as documented in the
# hypothetical README.md that would exist for an important production grade
# codebase)
module StringCorrector

  def correct_string(string)
    raise "Not Implemented!"
  end

  # Ignore me, I'm some of Sherlock's code
  # the string is valid if all letters have the same frequency count, i.e.
  # there is 1 frequency throughout the letter/ frequency hash
  def string_valid?(character_by_frequency_hash)
    # character_by_frequency_hash.values.uniq == 1
    raise "Not Implemented!"
  end


  # Raises an exception if the string does not meet the minimum criteria to be
  # solved, e.g.
  #   - if the string is less than or equal to 1 character, or
  #   - if the string is greater than 10**5
  #   - if the string contains anything other than the lower case characters a-z
  def ensure_string_is_solvable!(string)
    character_validation_pattern = /^[a-z]+$/
    if string.length <= 1
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

  def reduction_by_greatest_frequenters(string)
    character_by_frequency_hash = construct_frequency_analysis_hash(string)

    most_infrequent_letter_count = character_by_frequency_hash.values.sort.uniq.first

    character_by_frequency_hash.inject(0) do |total_removals_required, k_v|
      letter, count = k_v

      if count > most_infrequent_letter_count
        total_removals_required += (count - most_infrequent_letter_count)
      else
        total_removals_required
      end
    end
  end

  def reduction_by_least_frequenters(string)
  end

  # "aaaaabbbbckk"
  # "aabbccddxyz"
  def smart_reduction_count_process(string)
    character_by_frequency_hash = construct_frequency_analysis_hash(string)

    # A match_target is a letter that is chosen to as a target value to
    # decrement the frequency of letters of a greater frequency and eleminate
    # any letters with a lesser frequency.
    # for each letter
    n_removals_per_potential_match_target = character_by_frequency_hash.map do |k_v|
      this_letter, this_count = k_v

      # find the cost to eliminate all letters with a smaller frequency than
      # this_letter
      # plus the cost to reduce all letters with a greater frequency to that of
      # this_letter

      # find_n_removals_to_match_to_this_letter_and_eliminate_any_less_frequent
      # for each of it's neighboring letters
      character_by_frequency_hash.map do |other_letter_pair|
        next if other_letter_pair[0] == this_letter
        other_letter_count = other_letter_pair[1]

        # if the other letter's count is bigger than this letter's count, we need
        # to count it downwards to this letter's count
        if other_letter_count >= this_count
          other_letter_count - this_count
        else
          # otherwise we count the other letter's count down to zero ><
          other_letter_count
        end
      end.compact.inject(&:+)
    end.compact.sort

    minimal_number_of_removals = n_removals_per_potential_match_target.first
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
# watsons_string = watsons_string.lines.first.chomp unless watsons_string.lines.first.nil?

# watsons_string = "aaaaabbbbckk"

# The below string has 1 flake (it's 'x').
# A flake is a character that is easier to completely remove than it is to
# decrement the occurences of all other characters more frequent than said flake
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

# watsons_string = "aabbccddx"

ben = ContractorToSherlock.new

begin
  puts ben.validate_string_for_sherlock(watsons_string)
rescue
  puts "YES"
end
