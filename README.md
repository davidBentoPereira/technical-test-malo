# Technical Test for Malo

## Description

Malo is heavily driven by its content. A large part of our content is based on articles.

Build a page to search for articles. It should include a form to search through free text entry and display the matching articles' images with their titles.

The sea*rch should apply to both the content of the articles, its title and their tagging.*

*Only save the tags which are *not* starting with a hash ("#").*

The list of articles and its data is joined to this email. We expect you to load them into a database.

We do not require more fields than the searchable fields at the time.

The goal of this exercise is to test your ability to code and to achieve a result in a limited time span.

You'll be questioned on code quality and trade-offs done during the exercise.

We welcome tests but they are not mandatory.

We welcome a decent UI, but it does not have to look great or be responsive.

The goal is to have something thought off and working.

We expect you to spend ~3 hours on the test. We would recommend Rails as a tech stack to be inline with our own stack and knowledge

[Download the file with the articles](lib/data/articles_simplified.json)

## Setup

```bash
# Clone the repository
git clone git@github.com:davidBentoPereira/technical-test-malo.git
cd technical-test-malo

# Install dependencies
bundle install

# Install the DB
rails db:setup

# Run the rake task to import the artists from the file "lib/data/articles_simplified.json"
rails import_articles:import

# Start the Rails server
rails server
```