# Notes:
#   - be functional
#   - treat submitted code as though it has production value
require 'pry'

watsons_string = "aabbc"


module StringCorrector

  # takes in a string an corrects it such that each distinct
  # character occurse exactly as often as each other, eg "aabbc"
  # becomes
  def correct_string(string)
    ensure_string_is_solvable!(string)

    return string if string_valid?(character_by_frequency_hash)

    # find which character is most frequent
    # if equally frequent, return that array,
    # else,
    #   remove one occurance
    #   increment count
    # end

    until string_valid?(character_by_frequency_hash) do
      character_by_frequency_hash = construct_frequency_analysis_hash(string)

      # TODO: finish this code just for fun
      most_frequent_char = character_by_frequency_hash.last.key
    end
  end

  # raises an exception if the string does not meet the minimum criteria to be
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
    elsif string =~ character_validation_pattern
      raise "ERROR: the string contained characters other than those [a-z]"
    end
  end

  # the string is valid if all letters have the same frequency count, i.e.
  # there is 1 frequency throughout the letter/ frequency hash
  def string_valid?(character_by_frequency_hash)
    character_by_frequency_hash.values.uniq == 1
  end

  # string = "abcddd"

  def construct_frequency_analysis_hash(string)
    string.split("").each_with_object(Hash.new(0)) do |letter, hash|
      hash[letter] += 1 # increment frequency count for this letter
    end
  end

  # Code for contractor
  def deduce_number_of_removals_required_to_correct_a_string(string)
    character_by_frequency_hash = construct_frequency_analysis_hash(string)

    binding.pry
    most_infrequent_count = character_by_frequency_hash.values.uniq.first

    character_by_frequency_hash.inject(0) do |total_removals_required, k_v|
      letter, count = k_v

      if count > most_infrequent_count
        total_removals_required += (count - most_infrequent_count)
      else
        total_removals_required
      end
    end
  end

end


# meta-notes:
# I'm chose to use an instantiable class because the problem described in the
# paragraph already contained discrete entities and creating the seperate
# contractor class made a lot of logical sense though it does mean I have overal
# more lines of code than I would have had I used a straight forward, procedural
# approach to the problem.
class ContractorToSherlock

  # TODO:  consider mixin of StringCorrector...
  include StringCorrector

  # Sherlock will call this method to determine how 'easy'
  # it the problem (S) which Watson gave to him.
  # Meta-notes:
  # I'm documenting the function from this perspective of 'where this
  # method fits into the grand scheme of thigns' because
  #   1) that's important, and
  #   2) the algorithm is straigh forward enough to readily see via well
  #      thoughtout logic abstraction
  def validate_string_for_sherlock(string)
    if solvable_in_one_removal?(string)
      return "YES"
    else
      return "NO"
    end
  end

  def solvable_in_one_removal?(string)
    if deduce_number_of_removals_required_to_correct_a_string(string) <= 1
      true
    else
      false
    end
  end

end


# Sherlock needs a 3rd party contractor to answer some questions
# about a strings that watson gives to him.
ben = ContractorToSherlock.new

puts ben.validate_string_for_sherlock(watsons_string)
