require_relative '../item_discrimination'
require 'rspec'


RSpec.describe "item_discrimination" do
  before :each do
    @question_set_1 = ItemDescrimination.new(Test_results)
    @question_set_2 = ItemDescrimination.new(Test_results = {})
  end
  describe "Checking questions" do 
    before :each do 
      @questions = ["Find the center", "Pittsburgh and Philadelphia", "Mets batting average", "Oil in a barrel", "Surface of cube with holes", "Choosing rainy-day outfits", "Televisions per household", "Angie's trip to Kalamazoo", "Divisors of 759325", "Widget sales", "Orchard trees", "Solar panel production", "Climbing Mt. Fuji", "Cats and dogs", "Company revenue"]
    end

    it "returns all the questions provided" do
      expect(@question_set_1.find_questions).to eq(@questions)
    end

    it "returns the number of questions provided" do
      expect(@question_set_1.find_questions.count).to eq(15)
    end

    it "returns the number of questions provided" do
      expect(@question_set_2.find_questions.count).to eq(0)
    end

  end

  describe "Checking students belonging to differnt cohort" do
    let(:students_percentage_details){question_set_1.calculate_percentage}

    it "returns students belonging to top cohort" do
      # p "helloooooo"
        p @question_set_1.calculate_percentage
      # expect(question_set_1.categorizing_test_takers(students_percentage_details)).to eq(0)
    end

    # it "returns students belonging to middle cohort" do
    #   expect(question_set_1.find_questions.count).to eq(15)
    # end

    # it "returns students belonging to bottom cohort" do
    #   expect(question_set_2.find_questions.count).to eq(0)
    # end

  end
end