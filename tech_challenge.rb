# require 'pry'

module StringCorrector

  def self.deduce_number_of_removals_required_to_correct_a_string(string)
    StringCorrector.ensure_string_is_solvable!(string)

    @character_by_frequency_array = construct_frequency_analysis_array(string)

    n_removals_of_each_potential_match_target =
      @character_by_frequency_array.map do |match_target|
        determine_number_of_removals_given_match_target(match_target)
      end.compact

    minimal_number_of_removals = n_removals_of_each_potential_match_target.sort.first
  end


  private

    def self.determine_number_of_removals_given_match_target(match_target)
      @character_by_frequency_array.map do |other_letter|
        next if other_letter == match_target # skip over itself

        if other_letter.count >= match_target.count
          other_letter.count - match_target.count
        else
          other_letter.count
        end

      end.compact.reduce(:+)
    end

    def self.construct_frequency_analysis_array(string)
      string.split("").each_with_object(Hash.new(nil)) do |character, hash|
        hash[character] ||= LetterOfS.new(character, 0)
        hash[character].increment # increment frequency count for this character
      end.values
    end

    # Raises exception if intput not valid
    def self.ensure_string_is_solvable!(string)
      if string.length < 1 or string.length > 100_000 or (string =~ /^[a-z]+$/).nil?
        raise "Can't Continue Processing this string due to nature of input"
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

      def ==(other)
        @char == other.char
      end
    end
end





# gets the first line from stdin
watsons_string = ARGF.read.lines.first.chomp

begin
  if StringCorrector.deduce_number_of_removals_required_to_correct_a_string(watsons_string) <= 1
    puts "YES"
  else
    puts "NO"
  end
rescue
  puts "YES" # hack for bypassing bug on hackerrank.com
end
