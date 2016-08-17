require 'pry'

module StringCorrector

  def ensure_string_is_solvable!(string)
    character_validation_pattern = /^[a-z]+$/
    if string.length < 1
      raise InvalidInputs, "The input string is less than or equal to 1 character.  Input: #{string}"
    elsif string.length > 100_000 # 10**5
      raise InvalidInputs, "The input string is too large.  Input: #{string}"
    elsif (string =~ character_validation_pattern).nil?
      raise InvalidInputs, "The input string contained characters other than those [a-z].  Input: #{string}"
    end
  end

  def construct_frequency_analysis_array(string)
    string.split("").each_with_object(Hash.new(nil)) do |character, hash|
      hash[character] ||= LetterOfS.new(character, 0)
      hash[character].increment # increment frequency count for this character
    end.values
  end

  def deduce_number_of_removals_required_to_correct_a_string(string)
    @character_by_frequency_array = construct_frequency_analysis_array(string)

    n_removals_of_each_potential_match_target =
      @character_by_frequency_array.map do |match_target|
        determine_number_of_removals_given_match_target(match_target)
      end.compact

    minimal_number_of_removals = n_removals_of_each_potential_match_target.sort.first
  end

  def determine_number_of_removals_given_match_target(match_target)
    @character_by_frequency_array.map do |other_letter|
      next if other_letter.char == match_target.char # skip over itself

      if other_letter.count >= match_target.count
        other_letter.count - match_target.count
      else
        other_letter.count
      end

    end.compact.reduce(:+)
  end

end

class LetterOfS
  attr_reader :char, :count

  def initialize(*args)
    @char, @count = args
  end

  def increment
    @count += 1
  end
end

class InvalidInputs < RuntimeError; end



class ContractorToSherlock
  include StringCorrector

  def check_string_for_sherlock(string)
    ensure_string_is_solvable!(string)
    return "YES" if string.length == 1

    solvable_in_one_removal?(string)
  end


  private
    def solvable_in_one_removal?(string)
      if deduce_number_of_removals_required_to_correct_a_string(string) <= 1
        'YES'
      else
        'NO'
      end
    end
end



# gets the first line from stdin
# watsons_string = ARGF.read.lines.first.chomp
#
# ben = ContractorToSherlock.new
#
# puts ben.check_string_for_sherlock(watsons_string)
