require_relative 'answers'

def find_questions(test_results)
  questions_list = []
  test_results.each do |result|
    if !questions_list.include?(result[:question])
      questions_list << result[:question]
    end
  end
  p questions_list.count
end


def categorizing_test_takers(test_results)
  top_cohort = []
  middle_cohort = []
  bottom_cohort = []


end

def calculate_percentage()
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

questions_count = find_questions(Test_results)
students_percentage = calculate_percentage(Test_results)
categorizing_test_takers(students_percentage)





