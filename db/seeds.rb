require 'open-uri'
require 'nokogiri'

#Creation Methods
def create_new_user(username, password)
  u = User.new(
    :username => username,
    :password => password,
    :password_confirmation => password
    )

  u.set_session_token
  u.save!
  u
end

def create_question(title, body, answers, comments)
  q = Question.new(:title => title, :body => body)
  q.user_id = rand(100)
  q.save!

  ActiveRecord::Base.transaction do
    build_answers(q, answers).each(&:save!)
    q.answers.first.accept
    build_comments(q, comments).each(&:save!)
    build_random_upvotes(rand(80), q.id, "Question", q.user_id)
  end
end

def build_answers(q, answers)
  user_ids = [q.user_id]
  answers.map do |answer|
    num = find_non_taken_id(user_ids)
    user_ids << num

    a = Answer.new(:body => answer)
    a.user_id = num
    a.question_id = q.id
    a
  end
end

def build_comments(q, comments)
  user_ids = [q.user_id]
  comments.map do |comment|
    num = find_non_taken_id(user_ids)
    user_ids << num

    c = Comment.new(:body => comment)
    c.user_id = num
    c.commentable_id = q.id
    c.commentable_type = "Question"
    c
  end
end

def build_random_upvotes(num, id, type, taken_id)
  used_ids = [taken_id]
  num.times do
    u_id = find_non_taken_id(used_ids)
    used_ids << u_id
    
    Vote.build_vote("up", id, type, u_id)
  end
end

def find_non_taken_id(taken_ids)
  num = rand(1..100)
  while taken_ids.include?(num)
    num = rand(1..100)
  end
  num
end

#Scraping Methods
def get_html_doc(url)
  Nokogiri::HTML(open(url)) do |config|
    config.noerror
  end
end

def get_question_content(ldoc)
  pphs = []
  ldoc.xpath('//div[contains(@class, "question")]//td[contains(@class, "postcell")]//p').each do |pph|
    break if pph.content == "Sign up using Google"
    pphs << pph.content
  end
  pphs.join("\n\n")
end

def get_question_answers(ldoc)
  path = '//div[contains(@class, "answer")]//div[contains(@class, "post-text")]'
  ldoc.xpath(path).map do |answer|
    answer.text
  end
end

def get_question_comments(ldoc)
  path = '//div[contains(@class, "question")]//table/tbody/tr/td/div[contains(@class, "comment-body")]'
  ldoc.xpath(path).map do |comm|
    comm.content
  end
end

#Create Users
users = []
User.transaction do
  100.times do
    users << create_new_user(
      Faker::Name.name,
      SecureRandom.urlsafe_base64(16)
      )
  end
end

User.transaction do
  users.each do |user|
    num = rand(5000)
    user.add_points(num)
  end
end

#Get Questions Pages
docs = []
docs << get_html_doc("http://stackoverflow.com/questions?page=5&sort=votes")
docs << get_html_doc("http://stackoverflow.com/questions?page=4&sort=votes")
docs << get_html_doc("http://stackoverflow.com/questions?page=3&sort=votes")
docs << get_html_doc("http://stackoverflow.com/questions?page=2&sort=votes")
docs << get_html_doc("http://stackoverflow.com/questions?sort=votes")

question_titles = []
question_links = []
questions_answers = []
questions_comments = []

docs.each do |doc|
  doc.xpath('questions', '//h3/a').each do |question|
    question_titles << question.content
    question_links << "http://www.stackoverflow.com#{question["href"]}"
  end
end

question_content = question_links.map do |link|
  begin
    ldoc = get_html_doc(link)
    questions_answers << get_question_answers(ldoc)
    questions_comments << get_question_comments(ldoc)
    get_question_content(ldoc)
  rescue
  end
end

(0...question_titles.length).each do |i|
  title = question_titles[i]
  body = question_content[i]
  answers = questions_answers[i]
  comments = questions_answers[i]
  create_question(title, body, answers, comments)
end