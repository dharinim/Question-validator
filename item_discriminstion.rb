require_relative 'answers'

class ItemDescrimination

  def initialize(test_results)
    @test_results = test_results
    @good_qns_rate = 0.3
    @round_decimal = 2
    @cohorts = {
      top_cohort: [],
      middle_cohort: [],
      bottom_cohort: []
    }
  end

  def find_questions
    questions_list = []

    @test_results.each do |result|
      if !questions_list.include?(result[:question])
        questions_list << result[:question]
      end
    end
    questions_list
  end

  def categorizing_test_takers(students_percentage_details)
    students_percentage_details = students_percentage_details.sort_by{|user_id, percentage| percentage}.to_h
    students_count = students_percentage_details.keys.count  
    equal_split = students_count/3   
    count = 0
    students_percentage_details.each do |user_id, percentage|
      if count < equal_split
        @cohorts[:bottom_cohort] << user_id
      elsif count > equal_split && count < (2*(equal_split))
        @cohorts[:middle_cohort] << user_id
      else
        @cohorts[:top_cohort] << user_id
      end
      count += 1
    end
    return @cohorts
  end

  def calculate_percentage
    students = Hash.new(0)
    students_percentage = {}

    @test_results.each do |result|
      if students.keys.include?(result[:user_id])
        if result[:correct] == true
          students[result[:user_id]][:correct] += 1
        else
          students[result[:user_id]][:incorrect] += 1
        end
      else
        students[result[:user_id]] = {
          correct: 0,
          incorrect: 0
        }
      end
    end

    students.each do |user_id, answer|
      correct_ans = answer[:correct].to_f
      incorrect_ans = answer[:incorrect].to_f
      students_percentage[user_id] = (((correct_ans)/(correct_ans+ incorrect_ans))*100).round(@round_decimal)
    end
    return students_percentage
  end

  def evaluate_answers(result, student, question, total_answered, correct_ans)
    if result[:user_id] == student && result[:question] == question 
      if result[:correct] == true
        correct_ans += 1
        total_answered += 1
      elsif result[:correct] == false
        total_answered += 1
      end
    end   
    return correct_ans.to_f, total_answered.to_f
  end

  def check_question_quality(questions)
    question_quality = Hash.new(0)

    questions.each do |question|
      correct_ans_cohort_top = 0
      total_answered_cohort_top = 0
      correct_ans_cohort_bottom = 0
      total_answered_cohort_bottom = 0

      @cohorts[:top_cohort].each do |student|
        @test_results.each do |result|
          correct_ans_cohort_top, total_answered_cohort_top = evaluate_answers(result, student, question, total_answered_cohort_top, correct_ans_cohort_top)
        end
      end

      question_quality[question] = (correct_ans_cohort_top/total_answered_cohort_top).round(@round_decimal)
      @cohorts[:bottom_cohort].each do |student|
        @test_results.each do |result|
          correct_ans_cohort_bottom, total_answered_cohort_bottom = evaluate_answers(result, student, question, total_answered_cohort_bottom, correct_ans_cohort_bottom)
        end
      end

      result = (correct_ans_cohort_bottom/total_answered_cohort_bottom).round(@round_decimal)
      question_quality[question] = (question_quality[question]  - result).round(@round_decimal)
    end 
    return question_quality
  end

  def question_discrimination(question_quality)
    item_discrimination = {}

    question_quality.each do |question, percentage|
      if percentage > @good_qns_rate
        item_discrimination[question] = 2
      elsif percentage > 0 && percentage < @good_qns_rate
        item_discrimination[question] = 1
      else
        item_discrimination[question] = 0
      end
    end
    results =  item_discrimination.sort_by{|question, result| result}.to_h
    results.each do |question, rating|
      if rating == 0
        results[question] = "Error"
      elsif rating == 1
        results[question] = "Mediocre Question"
      else
        results[question] = "Good Question"
      end
    end
    return results
  end

end

question_set_1 = ItemDescrimination.new(Test_results)
questions = question_set_1.find_questions
students_percentage_details = question_set_1.calculate_percentage
# p students_percentage_details
cohorts = question_set_1.categorizing_test_takers(students_percentage_details)
# p cohorts
question_quality = question_set_1.check_question_quality(questions)
# p question_quality
item_discrimination = question_set_1.question_discrimination(question_quality)
p item_discrimination







