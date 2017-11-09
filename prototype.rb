require 'pry'
require 'json'
require 'awesome_print'

class Board
  attr_reader :board, :render

  def initialize
    @board = {}
    open_file
    generate_board
  end

  def open_file
    @f = File.new('trivia-questions.txt', 'r')
    @category_separators = %w[0 4 8 12 16 20 24 28 32 36]
  end

  def generate_board
    5.times do
      category_line = @category_separators.shuffle!.pop.to_i
      question_set = JSON.parse(@f.readlines[category_line])['results']

      category = Category.new(question_set[0]['category'])

      clue_200 = question_set.shuffle.pop
      category.questions << Question.new(200, clue_200['question'], clue_200['correct_answer'])

      clue_400 = question_set.shuffle.pop
      category.questions << Question.new(400, clue_400['question'], clue_400['correct_answer'])

      ###############

      category_line += 1
      @f.rewind
      question_set = JSON.parse(@f.readlines[category_line])['results']

      clue_600 = question_set.shuffle.pop
      category.questions.push(Question.new(600, clue_600['question'], clue_600['correct_answer']))

      clue_800 = question_set.shuffle.pop
      category.questions.push(Question.new(800, clue_800['question'], clue_800['correct_answer']))

      ###############

      category_line += 1
      @f.rewind
      question_set = JSON.parse(@f.readlines[category_line])['results']

      clue_1000 = question_set.shuffle.pop
      category.questions.push(Question.new(1000, clue_1000['question'], clue_1000['correct_answer']))

      category_line += 1
      @f.rewind
      @board[category.title] = category.questions
    end
  end

  def render # use leftpad or center for this!!
    <<-heredoc
   #{@board.keys[0]}   || #{@board.keys[1]}   || #{@board.keys[2]}   || #{@board.keys[3]}   || #{@board.keys[4]}
     200         ||   200         ||   200         ||   200         ||   200
     400         ||   400         ||   400         ||   400         ||   400
     600         ||   600         ||   600         ||   600         ||   600
     800         ||   800         ||   800         ||   800         ||   800
     1000        ||   1000        ||   1000        ||   1000        ||   1000
    heredoc
  end
end

class Category
  attr_reader :title
  attr_accessor :questions

  def initialize(title, questions=[])
    @title = title
    @questions = questions
  end
end

class Question
  attr_accessor :value, :clue, :answer, :asked

  def initialize(value, clue, answer)
    @value = value
    @clue = clue
    @answer = answer
    @asked = false
  end
end

board = Board.new
puts board.render

# 10 Categories
# 3 Difficulties
# 10 Questions per difficulty

# 200 - 400 EASY
# 600 - 800 MEDIUM
# 1000      HARD