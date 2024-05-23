# Technical Test for Malo 🧪

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

## Setup ⬇️

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

# Start the Rails server + Tailwind Watcher
bin/dev
```

## Notes ℹ️

It took me ~2h30 ⌛️ to have :
- A basic rails app
- A functionnal app with a CRUD articles
- A rake task to import the articles from the json file into the DB
- The search form allowing to filter by searching on the `title`, `content` or `tags` (but tags with an "#" were also selected)

And I spent ~1h ⌛️ searching through the advanced documentation of the `ransack` gem and tried to implement a `ransacker` to make a custom search. 
But I got lost and started wasting too much time and decided to go for the most basic solution I could come with.   

Then it took me ~30 minutes ⌛️ to have a first functionnal "plain ruby" solution allowing to search on the `title`, `content` and `tags` but not the ones starting with an "#"

But this solution wasn't optimal. I wanted to be able to perform the search in a single query. So I spent a few more hours with the help of ChatGPT & Perplexity to come up with this SQL query : 

```sql
SELECT id, title, content, tags
FROM articles
WHERE 
  title ILIKE '%8-9%' OR content ILIKE '%8-9%'
  OR id IN (
    SELECT id
    FROM (
      SELECT UNNEST(string_to_array(tags, ', ')) AS tag, id
      FROM articles
    ) AS tag_list
    WHERE 
      tag_list.tag ILIKE '%8-9%'
      AND tag_list.tag !~ '^#'
  );
```
ℹ️  I used the string "8-9" as my search query

- This query select the columns `id`, `title`, `content`, and `tags` from the table articles
- The first part of the WHERE clause checks if the title or the content contains "8-9". If either of these conditions is true, the article is included in the results.
- The second part uses a subquery to check if the article's ID is in a list of IDs obtained from another subquery. This inner subquery splits the tags into an array using string_to_array() and UNNEST(), then selects the IDs associated with those tags that contain "8-9" but exclude those that start with "#".
- In summary, this query selects articles that contain "8-9" in their title or content, or those that have tags containing "8-9" but exclude those that start with "#".


This last part took me about 3 more hours ⌛️

Then I converted the SQL query into an ActiveRecord query and put it in my controller.

Finally, I decided to take a few more hours to :
- add specs on the "search functionnality"
- improve the UI
- remove the ransack gem that was no longer necassary since I has to build the search feature myself