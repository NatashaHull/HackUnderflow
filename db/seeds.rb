# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
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

users = []
100.times do
  users << create_new_user(
    Faker::Name.name,
    SecureRandom.urlsafe_base64(16)
    )
end

users.each do |user|
  num = rand(5000)
  user.add_points(num)
end

def create_question(title, body, answers)
  q = Question.new(:title => title, :body => body)
  q.user_id = rand(100)
  q.save!
  build_answers(q.id, answers).each(&:save!)
end

def build_answers(q_id, answers)
  user_ids = []
  answers.map do |answer|
    num = rand(100)
    while num == q.user_id || user_ids.include?(num)
      num = rand(100)
    end

    a = Answer.new(:body => answer)
    a.user_id = num
    a.question_id = q_id
    a
  end
end

answers = ["git commit --amend -m \"New commit message\"\nUsed to amend the tip of the current branch. Prepare the tree object you would want to replace the latest commit as usual (this includes the usual -i/-o and explicit paths), and the commit log editor is seeded with the commit message from the tip of the current branch. The commit you create replaces the current tip -- if it was a merge, it will have the parents of the current tip as parents -- so the current top commit is discarded.\n\nIt is a rough equivalent for:\n\n$ git reset --soft HEAD^\n$ ... do something else to come up with the right tree ...\n$ git commit -c ORIG_HEAD\nbut can be used to amend a merge commit.",
  "git commit --amend -m \"your new message\"",
  "If the commit you want to fix isn’t the most recent one:\n\ngit rebase --interactive $parent_of_flawed_commit\n\nIf you want to fix several flawed commits, pass the parent of the oldest one of them.\n\nAn editor will come up, with a list of all commits since the one you gave.\n\nChange pick to reword (or on old versions of Git, to edit) in front of any commits you want to fix.\nOnce you save, Git will replay the listed commits. \n\nGit will drop back you into your editor for every commit you said you want to reword and into the shell for every commit you wanted to edit. If you’re in the shell:\n\nChange the commit in any way you like.\ngit commit --amend\ngit rebase --continue\nMost of this sequence will be explained to you by the output of the various commands as you go. It’s very easy, you don’t need to memorise it – just remember that git rebase --interactive lets you correct commits no matter how long ago they were.\n\nNote that you will not want to change commits that you have already pushed. Or maybe you do, but in that case you will have to take great care to communicate with everyone who may have pulled your commits and done work on top of them. How do I recover/resynchronise after someone pushes a rebase or a reset to a published branch?",
  "To amend the previous commit, make the changes you want and stage those changes, and then run\n\ngit commit --amend\nThis will open a file in your text editor representing your new commit message. It starts out populated with the text from your old commit message. Change the commit message as you want, then save the file and quit your editor to finish.\n\nTo amend the previous commit and keep the same log message, run\n\ngit commit --amend -C HEAD\nTo fix the previous commit by removing it entirely, run\n\ngit reset --hard HEAD^\nIf you want to edit more than one commit message, run\n\ngit rebase -i HEAD~commit_count\n(Replace commit_count with number of commits that you want to edit.) This command launches your editor. Mark the first commit (the one that you want to change) as “edit” instead of “pick”, then save and exit your editor. Make the change you want to commit and then run\n\ngit commit --amend\ngit rebase --continue",
  "A plain\n\ngit commit --amend\nwill run your editor and load the previous commit message. All you have to do is edit it and save.",
  "As already mentioned, git commit --amend is the way to overwrite the last commit. One note: if you would like to also overwrite the files, the command would be\n\ngit commit -a --amend -m \"My new commit message\"",
  "I prefer this way.\n\ngit commit --amend -c <commit ID>\nOtherwise, there will be a new commit with a new commit ID",
  "You also can use git filter-branch for that.\n\ngit filter-branch -f --msg-filter \"sed 's/errror/error/'\" $flawed_commit..HEAD\n\nIt's not as easy as a trivial \"git commit --amend\", but it's especially useful, if you already have some merges after your erroneous commit message.\n\nNote that this will try to rewrite EVERY commit between HEAD and the flawed commit, so you should choose your msg-filter command very wise ;-)",
  "If you only want to modify your last commit message, then do:\n  \n  $ git commit --amend That will drop you into your text exitor and let you change the last commit message.\n  \n  If you want to change the last 3 commit messages, or any of the commit messages up to that point, supply 'HEAD~3' to the git rebase -i command.\n  \n  $ git rebase -i HEAD~3"
]
create_question("How do I edit an incorrect commit message in Git?", "I stupidly did a Git commit while half asleep, and wrote the totally wrong thing in the commit message. How do I change the commit message?\n\nI have not yet pushed the commit to anyone.", answers)