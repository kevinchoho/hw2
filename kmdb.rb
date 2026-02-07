# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!
# - Note rubric explanation for appropriate use of external resources.

# Rubric
#
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)
# - You are welcome to use external resources for help with the assignment (including
#   colleagues, AI, internet search, etc). However, the solution you submit must
#   utilize the skills and strategies covered in class. Alternate solutions which
#   do not demonstrate an understanding of the approaches used in class will receive
#   significant deductions. Any concern should be raised with faculty prior to the due date.

# Submission
#
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======
# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========
# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Represented by agent
# ====================
# Christian Bale

# Delete existing data, so you'll start fresh each time this script is run.
# Use `Model.destroy_all` code.
Role.destroy_all
Actor.destroy_all
Agent.destroy_all
Movie.destroy_all
Studio.destroy_all

# Generate models and tables, according to the domain model.
# rails generate model Studio name:string
# rails generate model Movie title:string year_released:integer rated:string studio:references
# rails generate model Agent name:string
# rails generate model Actor name:string agent:references
# rails generate model Role movie:references actor:references character_name:string
# rails db:migrate


# Insert data into the database that reflects the sample data shown above.

warner = Studio.create!(name: "Warner Bros.")

batman_begins = Movie.create!(title: "Batman Begins", year_released: 2005, rated: "PG-13", studio: warner)
dark_knight = Movie.create!(title: "The Dark Knight", year_released: 2008, rated: "PG-13", studio: warner)
dark_knight_rises = Movie.create!(title: "The Dark Knight Rises", year_released: 2012, rated: "PG-13", studio: warner)

ari = Agent.create!(name: "Ari Emanuel")

christian = Actor.create!(name: "Christian Bale", agent: ari)
michael = Actor.create!(name: "Michael Caine", agent: ari)
liam = Actor.create!(name: "Liam Neeson", agent: ari)
katie = Actor.create!(name: "Katie Holmes", agent: ari)
gary = Actor.create!(name: "Gary Oldman", agent: ari)
heath = Actor.create!(name: "Heath Ledger", agent: ari)
aaron = Actor.create!(name: "Aaron Eckhart", agent: ari)
maggie = Actor.create!(name: "Maggie Gyllenhaal", agent: ari)
tom = Actor.create!(name: "Tom Hardy", agent: ari)
joseph = Actor.create!(name: "Joseph Gordon-Levitt", agent: ari)
anne = Actor.create!(name: "Anne Hathaway", agent: ari)


Role.create!(movie: batman_begins, actor: christian, character_name: "Bruce Wayne")
Role.create!(movie: batman_begins, actor: michael, character_name: "Alfred")
Role.create!(movie: batman_begins, actor: liam, character_name: "Ra's Al Ghul")
Role.create!(movie: batman_begins, actor: katie, character_name: "Rachel Dawes")
Role.create!(movie: batman_begins, actor: gary, character_name: "Commissioner Gordon")


Role.create!(movie: dark_knight, actor: christian, character_name: "Bruce Wayne")
Role.create!(movie: dark_knight, actor: heath, character_name: "Joker")
Role.create!(movie: dark_knight, actor: aaron, character_name: "Harvey Dent")
Role.create!(movie: dark_knight, actor: michael, character_name: "Alfred")
Role.create!(movie: dark_knight, actor: maggie, character_name: "Rachel Dawes")


Role.create!(movie: dark_knight_rises, actor: christian, character_name: "Bruce Wayne")
Role.create!(movie: dark_knight_rises, actor: gary, character_name: "Commissioner Gordon")
Role.create!(movie: dark_knight_rises, actor: tom, character_name: "Bane")
Role.create!(movie: dark_knight_rises, actor: joseph, character_name: "John Blake")
Role.create!(movie: dark_knight_rises, actor: anne, character_name: "Selina Kyle")

# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
Movie.includes(:studio).order(:title).each do |movie|
  # 使用 printf 对齐列
  printf "%-22s %-13s %-6s %s\n", movie.title, movie.year_released, movie.rated, movie.studio.name
end

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""

# Query the cast data and loop through the results to display the cast output for each movie.
Movie.includes(roles: :actor).order(:title).each do |movie|
  # 角色按名字排序
  movie.roles.sort_by { |r| r.actor.name }.each do |role|
    printf "%-22s %-22s %s\n", movie.title, role.actor.name, role.character_name
  end
end

# Prints a header for the agent's list of represented actors output
puts ""
puts "Represented by agent"
puts "===================="
puts ""

# Query the actor data and loop through the results to display the agent's list of represented actors output.
Actor.order(:name).each do |actor|
  puts actor.name
end
