#Hack Underflow

##App
This application is a clone of Stack Overflow. However, it is designed differently, and will be a one page application. Below is basic overview of the features of this site:

* [Users](https://github.com/NatashaHull/HackUndderflow#users)
* [Questions](https://github.com/NatashaHull/HackUndderflow#questions)
* [Answers](https://github.com/NatashaHull/HackUndderflow#answers) (which may or may not be accepted)
* [Comments](https://github.com/NatashaHull/HackUndderflow#comments)
* [Up and Down Voting](https://github.com/NatashaHull/HackUndderflow#voting) (On Questions and Answers By Users)
* [Edit suggestions](https://github.com/NatashaHull/HackUndderflow#edit-suggestions) (By Users with enough points)

Below is a list of advanced features I may add to this site:

* Tags
* Question view counts
* User profile pics
* Facebook, Twitter, and other logins
* The ability to open and close questions
* Moderator privileges

##Construction
I started this application as a Rails app (getting all the models, controllers, views, and routes set up, along with the API layer) and then started turning it into a one page application with backbone. In order to have some sample data on this website, I used Nokogiri to scrape Stack Overflow and seeded my database with that data.

##Users
While I could use Devise or another authentication gem for me, this would complicate the structure of my project later on. My goal of turning this into a single page application using Backbone (including the sign up and sign in pages) lead me to the conclusion that I need more control over the `Users` and `Session` resources than using a pre-built authentication system would give me.

The `users` table has the following schema:

* id
* username
* password_digest
* session_token
* points

I briefly considered splitting the points part of the schema out into another table (such as a `profiles` table that belongs to a `user`). However, it seemed simpler (for the moment) to just add one column to the `users` table.

In addition to the authentication methods necessary for each user, my model has several methods relating to points. See the ["Points"](https://github.com/NatashaHull/HackUndderflow#points) section below for more details.

###Points
Points are the gatekeepers for the ability to do anything other than ask a question, or answer someone else's question. Methods for dealing with points in the `User` model include a basic method for adding points and several methods for checking if user has enough points to do a particular action:

* `add_points` - This takes in a number of points as a parameter.
* `can_vote_up?` (min 15 points)
* `can_comment?` (min 50 points)
* `can_vote_down?` (min 125 points)
* `can_edit?` (min 2000)

Users can get points by their questions and answers being voted up and their `answers` and `edit_suggestions` being accepted. Simply using the `add_points` method in the `accept` methods for `answers` and `edit_suggestions` was enough to get those actions to add points to a user. However, my method for dealing with votes was more complicated. This led to me adding a class method to the `Vote` model called `calculate_user_points` that figures out how many points to add to the object's user based on whether the object is a `Question` or an `Answer`.

If I get around to moderator and more advanced features, more methods will need to be added to correspond to those extra features.

##Questions
The `questions` resource is fairly simple compared to the user's resource (at least for now). The database only stores an id, a title, and a body. That said, from this point on, everything relates back to a question and a user, either directy (to the question itself) or inderection through an answer. Moreover, questions end up having a number of methods to deal with Voting and Edit Suggestions. That are mentioned in those respective section below.

##Answers
The `answers` resource is even simpler than the `questions` resource. It has the following schema:
* id
* body
* user_id
* question_id
* accepted

The `Answer` model also has a method called `accept` that sets the `accepted` attribute to `true` and saves the object. Since each question should only have one accepted answer, this necessitated the private validation method `only_one_accepted_answer` which (if the current object has `accepted` set to `true`) performs a SQL query (using `find_by_sql`) to determine if there is another accepted answer for the current object's question and adds an error if there is another accepted answer for the same question. Lastly, question also has a method `accepted_answer` which finds and returns its accepted answer.

Answers, like questions, can be voted on, commented on, and even edited by other users. Every added method that a question needs to deal with the following resources, an answer needs as well.

##Comments
The `comments`, while storing a polymorhpic association, is very simple. Each row in the `comments` table has the following schema:

* id
* body
* user_id
* commentable_id
* commentable_type

Simply adding the polymorphic association was enough to take care of the model level of this resource.

Handling `routes` and `controllers` for this resource was more complicated. I ended up making a route for new comments and creating new comments under both the question route and the comments route. This led to my splitting up the controller action for creating a new comment into one of two private methods which either built the comment as a `question` or `answer` comment using either `params[:question_id]` or `params[:answer_id]`. This was not particularly difficult and it was fairly easy to adjust the new view accordingly as well.

##Voting
This is where I started having to make more interesting decisions. Instead of splitting this out into two or four tables, I created one table that had a polymorphic association with `questions` and `answers` as well as a column for the `direction` of each vote. This caused the schema to be as follows:
* id
* direction
* user_id
* voteable_type
* voteable_Id

The bigger issue was figuring out how to make sure that a user could unvote if they clicked on the same arrow (voting is through arrows in the view) twice, in addition to being able to reverse their vote by clicking on the opposite arrow. Moreover, I wanted to make sure that the model did all the work. After trying a different method, I created a `parse_vote_request` class method for Votes that the controller calls when a user clicks on an arrow. This method takes in a `direction`, `voteable_type`, `voteable_id` and a `user_id`. It then tries to find any previous vote on the same object by the same user and adds, removes, and updates vote accordingly.

Voting also required two different instance methods on `question` and `answer` objects. Those were:
* `vote_counts`
* `vote_direction_by_user` - This takes in a user_id and sees if and how the user voted on that object.

##Edit Suggestions
Broadly, edit suggestions are simply edits on questions or answer bodies which are not saved directly because they are created by a different user than the one who wrote the respective question or answer. This means that, as a resource, the user only perceives that their edit is not directly saved because the edit button is different. I decided that a user should be able to see what they have suggested edits for, and what other users have suggested they change in their own questions and answers via their profile page. I also added a show page for suggested edits, which shows the original body and the suggested revision side by side. If it is your question or answer that is being edited, then you can see and click on buttons to accept the edit or reject the edit.

The `edit_suggestions` schema is fairly simple. It contains the following:

* id
* body
* user_id
* editable_type
* editable_id
* accepted

The only thing users can access directly is the body. Everything else is set for them using the available information.

The necessary methods for `edit_suggestions` were fairly simple. For the moment I have the following methods:

* `questions` - This figures out which question to which this edit can be traced back.
* `accept_edit` - This changes the associated `editable`'s body to its own body, saves its revised `editable` and changes the `accepted` attribute to `true` and saves everything.

This led to a few associated methods for users. Assuming that I want to show a user all the suggested edits they have for their questions and answers (which I do), I realized that no direct association would give me this list. Moreover, I want users to be able to see whether their edits are pending or accepted on their profile. This led to the following methods:

* `suggested_edits` - This adds together both the `suggested_question_edits` and the `suggested_answer_edits`
* `pending_edit_suggestions` - This finds the `edit_suggestions` that have not been accepted
* `accept_edit_suggestions` - This finds the `edit_suggestions` that have been accepted
 
Additionally, I was able to use this to add a `contributors` instance method to the `Answer` and `Question` models which performas a SQL query (using `find_by_sql`) to find all the users that have accepted edit suggestions for the object in question.

##Credits
Design: I am not a designer. As a result I downloaded [Foundation's](http://foundation.zurb.com/) stylesheets and added them to my own CSS files.

FriendlyId: This website uses the `friendly_id` gem.
