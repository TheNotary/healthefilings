require './tech_challenge.rb'
require 'pry'
require 'rspec'


describe "tech_challenge tests" do

  describe "ContractorToSherlock" do

    it "test 13, 1 character input returns YES" do
      test_string = "h"
      ben = ContractorToSherlock.new

      expect(ben.check_string_for_sherlock(test_string)).to eq "YES"
    end

    it "should raise an exception if no input passed" do
      test_string = ""
      ben = ContractorToSherlock.new

      expect {
        ben.check_string_for_sherlock(test_string)
      }.to raise_exception(InvalidInputs)
    end

    it "should raise an exception if too large an input is passed in" do
      test_string = "a" + "a" * 10**5
      ben = ContractorToSherlock.new

      expect {
        ben.check_string_for_sherlock(test_string)
      }.to raise_exception(InvalidInputs)
    end

    it "should raise an exception if the input contains unexpected characters" do
      test_string = "hi^"
      ben = ContractorToSherlock.new

      expect {
        ben.check_string_for_sherlock(test_string)
      }.to raise_exception(InvalidInputs)
    end

    it "should report yes for the already solved case 'hi'" do
      test_string = "hi"
      ben = ContractorToSherlock.new

      expect(ben.check_string_for_sherlock(test_string)).to eq "YES"
    end

    it "should report yes for the elimination solvable case 'hhhhhiiiiiz'" do
      test_string = "hhhhhiiiiiz"
      ben = ContractorToSherlock.new

      expect(ben.check_string_for_sherlock(test_string)).to eq "YES"
    end

    it "should report yes for the reduction solvable case 'hhhhhhiiiii'" do
      test_string = "hhhhhhiiiii"
      ben = ContractorToSherlock.new

      expect(ben.check_string_for_sherlock(test_string)).to eq "YES"
    end

    it "should report NO for the reduction solvable case 'aaaaaahhhhhhiiiii' where n is 2" do
      test_string = "aaaaaahhhhhhiiiii"
      ben = ContractorToSherlock.new

      expect(ben.check_string_for_sherlock(test_string)).to eq "NO"
    end

    it "should report NO for the elimination solvable case 'aaaaaahhhhhhii' where n is 2" do
      test_string = "aaaaaahhhhhhii"
      ben = ContractorToSherlock.new

      expect(ben.check_string_for_sherlock(test_string)).to eq "NO"
    end

  end



  describe "StringCorrector" do
    it "can produce a frequency analysis array with the expected length given a known input" do
      extend StringCorrector

      test_string = "aaabbccddx"
      freq_analysis_array = construct_frequency_analysis_array(test_string)

      expect(freq_analysis_array.length).to eq test_string.split("").uniq.length
    end

    it "can produce a frequency analysis array with the expected characters given a known input" do
      extend StringCorrector

      test_string = "aaabbccddx"
      freq_analysis_array = construct_frequency_analysis_array(test_string)

      actual_characters = freq_analysis_array.collect { |l| l.char }
      expect(actual_characters.sort.join).to eq test_string.split("").uniq.sort.join
    end

    it "can produce a frequency analysis array with the expected counts given a known input" do
      extend StringCorrector

      test_string = "aaabbccddx"
      expected_counts = [3, 2, 2, 2, 1]
      freq_analysis_array = construct_frequency_analysis_array(test_string)

      actual_counts = freq_analysis_array.collect { |l| l.count }
      expect(actual_counts.sort.reverse.join).to eq expected_counts.join
    end

  end

  describe "LetterOfS" do

    it "can be instantiated given a character and a count" do
      character = "s"
      count = 1
      los = LetterOfS.new(character, count)

      expect(los.char).to eq character
      expect(los.count).to eq count
    end

    describe "methods" do

      before :each do
        @character = "s"
        @count = 1
        @los = LetterOfS.new(@character, @count)
      end

      it "can be incremented" do
        @los.increment
        expect(@los.count).to eq @count + 1
      end
    end

  end

end
