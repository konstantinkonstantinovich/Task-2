# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Problem.create(name: "Stress")
Problem.create(name: "Anxiety")
Problem.create(name: "Depression")
Problem.create(name: "Irritability")

Technique.create(
  title: "Cognitive - Behavioral Therapy",
  description: "Elimination of the dependence of emotions and human behavior on his thoughts.",
  age: "25-35",
  gender: 0,
  total_steps: 6,
  duration: "6-7 hours"
)


Technique.create(
  title: "Lifestyle changes",
  description: "Eliminating the lack of control that makes people feel worse.",
  age: "30-40",
  gender: 1,
  total_steps: 4,
  duration: "5 hours"
)

Technique.create(
  title: "Inflammation and mood",
  description: "Does a dysfunctional immune system cause inflammation in the body, leading to mood swings?",
  age: "30-45",
  gender: 0,
  total_steps: 4,
  duration: "5 hours"
)

Technique.create(
  title: "Cognitive elaboration of the predicted future",
  description: "It is necessary to complete the unfinished in the past and live in the present.",
  age: "30-45",
  gender: 0,
  total_steps: 8,
  duration: "10 hours"
)
