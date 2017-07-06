require_relative 'answers'

def find_questions(test_results)
  questions_list = []
  test_results.each do |result|
    if !questions_list.include?(result[:question])
      questions_list << result[:question]
    end
  end
  questions_list
end


def categorizing_test_takers(students_percentage_details)
  cohorts = {
    top_cohort: [],
    middle_cohort: [],
    bottom_cohort: []
  }
  
  students_percentage_details.each do |student_details|
    user_id = student_details[0]
    percentage = student_details[1]
    if percentage >= 75
      cohorts[:top_cohort] << user_id
    elsif percentage >= 50 && percentage < 75
      cohorts[:middle_cohort] << user_id
    else
      cohorts[:bottom_cohort] << user_id
    end
  end
  return cohorts
end

def calculate_percentage(test_results)
  students = Hash.new(0)
  students_percentage = {}
  test_results.each do |result|
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

  students.each do |student|
    user_id = student[0]
    correct_ans = student[1][:correct]
    incorrect_ans = student[1][:incorrect]
    students_percentage[user_id] = (((correct_ans.to_f)/(correct_ans.to_f + incorrect_ans.to_f))*100).round(2)
  end
  return students_percentage
end

def check_question_quality(questions, test_results, cohorts)
  question_quality = Hash.new(0)
  correct_ans = 0
  total_answered = 0
  correct_ans_cohort3 = 0
  total_answered_cohort3 = 0
  questions.each do |question|
    cohorts[:top_cohort].each do |student|
      test_results.each do |result|
        if result[:user_id] == student && result[:question] == question 
          if result[:correct] == true
          # question_quality[question] += 1
            correct_ans += 1
            total_answered += 1
          elsif result[:correct] == false
            total_answered += 1
          end
        end 
      end

    end
    p correct_ans, total_answered
    question_quality[question] = (correct_ans.to_f/total_answered.to_f).round(2)

    cohorts[:bottom_cohort].each do |student|
      test_results.each do |result|
        if result[:user_id] == student && result[:question] == question 
          if result[:correct] == true
          # question_quality[question] += 1
            correct_ans_cohort3 += 1
            total_answered_cohort3 += 1
          elsif result[:correct] == false
            total_answered_cohort3 += 1
          end
        end
      end
    end
    result = (correct_ans_cohort3.to_f/total_answered_cohort3.to_f).round(2)
    question_quality[question] = (question_quality[question]  - result).round(2)
  end 
  return question_quality
end

def question_discrimination(question_quality)
  item_discrimination = {}
  question_quality.each do |question, percentage|
    if percentage > 0.3
      item_discrimination[question] = "Good question"
    elsif percentage > 0 && percentage < 0.3
      item_discrimination[question] = "Mediocre question"
    else
      item_discrimination[question] = "Error"
    end
  end
  return item_discrimination
end

questions = find_questions(Test_results)
students_percentage_details = calculate_percentage(Test_results)
cohorts = categorizing_test_takers(students_percentage_details)
question_quality = check_question_quality(questions, Test_results, cohorts)
p question_quality
item_discrimination = question_discrimination(question_quality)
p item_discrimination







