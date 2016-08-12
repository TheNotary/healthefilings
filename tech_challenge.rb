# Notes:
#   - be functional
#   - treat submitted code as though it has production value
require 'pry'



module StringCorrector

  # Ignore me, I'm some of Sherlock's code
  # takes in a string an corrects it such that each distinct
  # character occurs exactly as often as each other, eg "aabbc"
  # becomes
  def correct_string(string)
    raise "Not Implemented!"

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
      most_frequent_char = character_by_frequency_hash.values.last
    end
  end

  # Ignore me, I'm some of Sherlock's code
  # the string is valid if all letters have the same frequency count, i.e.
  # there is 1 frequency throughout the letter/ frequency hash
  def string_valid?(character_by_frequency_hash)
    character_by_frequency_hash.values.uniq == 1
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
    elsif (string =~ character_validation_pattern).nil?
      raise "ERROR: the string contained characters other than those [a-z]"
    end
  end

  # outputs a hash depicting the frequencey of occurance for each distinct
  # character in the string
  def construct_frequency_analysis_hash(string)
    string.split("").each_with_object(Hash.new(0)) do |letter, hash|
      hash[letter] += 1 # increment frequency count for this letter
    end
  end

  # Returns the count of the number of characters that need to be removed
  # from the string to make it valid.
  def deduce_number_of_removals_required_to_correct_a_string(string)
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

end


# meta-notes:
# I'm chose to use an instantiable class because the problem described in the
# paragraph already contained discrete entities and creating the seperate
# contractor class made a lot of logical sense though it does mean I have overal
# more lines of code than I would have had I used a straight forward, procedural
# approach to the problem.
class ContractorToSherlock

  # meta-notes: There's shared functionality between what the contractor to
  # sherlock does and what sherlock himself does :)
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
watsons_string = ARGF.read.lines.first.chomp

binding.pry

# Sherlock needs a 3rd party contractor to answer some questions
# about a strings that watson gives to him.
ben = ContractorToSherlock.new

puts ben.validate_string_for_sherlock(watsons_string)


puts ben.validate_string_for_sherlock("abc")
puts ben.validate_string_for_sherlock("abzzc")

# puts ben.validate_string_for_sherlock("")

# puts ben.validate_string_for_sherlock("a" + "a" * 10**5)
# puts ben.validate_string_for_sherlock("abzzC")
