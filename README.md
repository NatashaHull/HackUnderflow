#Hack Underflow

##App
This application is a clone of Stack Overflow. However, it is designed differently, and will be a one page application. Below is basic overview of the features of this site:

* Users
* Questions
* Answers (which may or may not be accepted)
* Points (belonging to a User)
* Comments
* Up and Down Voting (On Questions and Answers By Users)
* Edit suggestions (By Users with enough points)

Below is a list of advanced features I may add to this site:

* Tags
* Question view counts
* The ability to open and close questions
* Moderator privileges

##Construction

I plan on starting the application as a Rails app (getting all the models, controllers, views, and routes set up, along with the API layer) and then (if I have time) trying to turn it into a one page application with backbone once I have finished setting up the main app.

##Users
While I could use Devise or another authentication gem for me, this would complicate the structure of my project later on. My goal of turning this into a single page application using Backbone (including the sign up and sign in pages) lead me to the conclusion that I need more control over the `Users` and `Session` resources than using a pre-built authentication system would give me.

The `users` table has the following schema:

* id
* username
* password_digest
* session_token
* points

I briefly considered splitting the points part of the schema out into another table (such as a `profiles` table that belongs to a `user`). However, it seemed simpler (for the moment) to just add one column to the `users` table.

In addition to the authentication methods necessary for each user, my model has several methods relating to points, including the a basic method for adding points and several methods for checking if user has enough points to do a particular action:

* add_points - This takes in a number of points as a parameter.
* can_vote_up? (min 15 points)
* can_comment? (min 50 points)
* can_vote_down? (min 125 points)
* can_edit? (min 2000)

If I get around to moderator and more advanced features, more methods will need to be added to correspond to those extra features.

##Questions

##Answers

##Points

##Comments

##Up and Down Voting

##Edit suggestions