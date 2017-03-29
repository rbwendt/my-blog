---
title: 'Adding Database Constraints Using the `rein` Gem'
author: ben-wendt
layout: post
date: 2017-03-28
template: article.jade
categories:
  - 'rails'
tags:
  - database
template: article.jade
---
[rein][1] is a gem for adding database constraints
in rails migrations. It's always been possible to set
these up using execute calls in the migration, but rein
makes it look rails-y.

<span class="more"></span>

Letting your database manage constraints is often a great
idea. I'm not a huge fan of the rails-way of letting the
application layer manage all relationships between data.
My main concerns with this are:

1. A developer cannot look
 at the database and understand the meanings of all the
 data it contains. A prime example of this is using rails
 enumerations to store integers that have a meaning to
 the application. 
2. Letting the application manage this for you locks you
 in to rails, but you really want flexibility in terms of
 what technology you want to implement the application in.
 If you were to need to add another service with access to
 the database, it would need to duplicate the management of
 any information it needs access to. The could be a real
 pain point when using any other technology than rails (and
 even if the other app was in rails). Adding constraints in
 the database eases this issue, as regardless of what 
 technology is used on the application layer, you will have
 guarantees of your data's consistency from the database.

So let's take a look at a sample migration using rein,
and what limitations it puts on the application layer.

```
class CreateBooks < ActiveRecord::Migration
  def up
    create_enum_type :binding, ['hardcover', 'softcover']
    create_table :books
    add_column :books, :name, :string
    add_column :books, :description, :string
    add_column :books, :binding, :binding, :default => 'hardcover'
    add_column :books, :publication_month, :int

    add_numericality_constraint :books, :publication_month,
      greater_than_or_equal_to: 1
  end

  def down
    drop_enum_type :binding
    drop_table :books
  end
end
```

This will set up a new type called `binding`, and a
books table with a numericality constraint on its
publication month field. Let's see what happens when
we try to save some data that the database doesn't
like:

```
irb(main):001:0> b = Book.new
=> #<Book id: nil, name: nil, description: nil, binding: "hardcover", publication_month: nil>
irb(main):002:0> b.publication_month = -1; b.save
ActiveRecord::StatementInvalid: PG::CheckViolation: ERROR:  new row for relation "books" violates check constraint "books_publication_month"
```

And with the enum type, you see something similar:

```
b.binding = 'none'; b.save!
ActiveRecord::StatementInvalid: PG::InvalidTextRepresentation: ERROR:  invalid input value for enum binding: "none"
```

This is great! We can't save this data to the database. Now,
ideally we would set up validations that mirror these
constraints so that we can handle this data gracefully. Further than
this, we can use a rails enum  in the model:

```
enum :binding, {
  'hardcover' => 'hardcover',
  'paperback' => 'paperback'
}
```

This will give us methods like `book.hardcover?`, `book.paperback!`,
scopes like `Book.hardcover` and do all of our validations. It's a
very effective pairing.

 [1]: https://github.com/nullobject/rein

