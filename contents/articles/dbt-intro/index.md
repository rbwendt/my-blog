---
title: An Intro to Data Build Tool (dbt)
author: ben-wendt
template: article.pug
date: 2024-03-13
---

DBT is a tool to simplify populating the relationships
between different tables. With DBT, you can specify the
queries used to create your tables, as well as parameterizing
portions of those queries. You can also add data tests.

<span class="more"></span>

## Introduction: Getting to Know Data Build Tool (dbt)

Ever wished for a smoother way to handle your data without the 
headaches of complex ETL processes? Enter Data Build Tool, or 
as we fondly call it, DBT. It makes data transformations and 
modeling feel like a breeze.

DBT takes a refreshing approach to data pipelines, letting you 
express your data transformations in good old SQL. No need for 
fancy jargon or convoluted workflows—just simple, 
straightforward SQL magic.

In this article, we'll take a relaxed stroll through the world 
of DBT, from setting it up to some cool tricks it can do. So 
grab your favorite drink, kick back, and let's dive into the 
world of DBT together!

## Installation of Project Bootsrapping.

To get started with dbt, the recommended method for 
installation is to use pip.

```bash
pip install dbt-{your adapater}
```

I am using bigquery, but there are adapters for all the major
database engines, including snowflake, postgres, cassandra,
mySQL, SQLServer, SQLite, Oracle, Athena, Redshift and many more.

* [Trusted Adapters](https://docs.getdbt.com/docs/trusted-adapters)
* [Community Adapters](https://docs.getdbt.com/docs/community-adapters)

So for me, the install was done with:

```bash
pip install dbt-bigquery
```

This mat take a while because it has to install some GCS
dependencies, such as grpc. You can then confirm your DBT
installed correctly with:

```bash
dbt --version
```

Now you will be ready to start your own DBT project. I have
been keeping a GCP console open to bigquery to verify my
changes.

First navigate to the parent folder of where you want to store
your DBT project, and then run:

```bash
dbt init
```

This will start a configuration wizard which has fairly 
reasonable defaults. When the configuration is complete, `cd` 
to your new folder and you will be ready to start working with 
DBT.

## DBT Profiles

DBT init will have created a file named `dbt_project.yml` in
your project root. Take a look! This will have all the info
you entered in the setup wizard. It's also where you can
configure connections to external sources of data.

We can add a reference to the public `dbt-tutorial` dataset
in GCP by adding this to `dbt_profile.yml`:

```yml
jaffle_shop:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: dbt-tutorial
      dataset: jaffle_shop
```

Your profile is also the place where you configure your
materialization strategy. The default is view. You can
configure this by:

```yml
models:
  my_dataset:
    # Config indicated by + and applies to all files
    +materialized: table
```

You can override this materialization config on a per-model
basis in your model.

## Database Seeds

DBT supports database [seeds](https://docs.getdbt.com/docs/build/seeds). These are described as:

> Seeds are CSV files in your dbt project (typically in your seeds directory), that dbt can load into your data warehouse using the dbt seed command.
> Seeds are best suited to static data which changes infrequently.

Seeds are not meant as a way of loading database dumps,
but it does seem like it would be pretty easy to abuse
this.

Here are some seeds I will use for my demo.

`seeds/movies.csv`:

```csv
id,title,year 
1,Speed,1994
2,Avatar,2008
3,The Matrix,1998
4,Paul,2012
5,Terminator 2,1992
```

`seeds/actors.csv`:

```csv
id,name
1,Sandra Bullock
2,Keanu Reeves
3,Mickey Rooney
4,Sigourney Weaver
5,Nick Frost
6,Linda Hamilton
```

`seeds/stg_actor_movies.csv`:

```csv
id,movie_id,actor_id
1,1,1
2,1,2
3,2,4
4,3,2
5,4,4
6,5,6
```

Note that this is closer to "loading a dump" than
proper seed loading, but this is for a demo, so that
is fine.

If you now run:

```bash
dbt run
```

And look in your database, you should see these three tables.

## Models

The `models/` folder is where you will put your model files.
You can put a file in here such as:

`flowers.sql`:

```sql
select 1 as id, 'flea bane' as plant
union all
select 2, 'showy tick trefoil'
```

After a DBT run, these will appear in your database. It would 
be more common to do something like this:

`stg_customers.sql`:
```sql
    select
        id as customer_id,
        first_name,
        last_name

    from {{ ref('jaffle_shop', 'customers') }}
```

Note the use of the [ref](https://docs.getdbt.com/reference/dbt-jinja-functions/ref)
function here. DBT will resolve this reference to the table 
you set up in your profile; note how the first parameter
`jaffle_shop` matches the profile name, and `customers` is
the name of the table in that public dataset.

### Macros

In the `macros/` folder, you can define jinja macros that will
be accessible from your models. For example, you could make a
good customers macro called `good_customer.sql`:

```sql
{% macro good_customer(number_of_orders) %}
CASE when {{ number_of_orders }} >= 3 then
    true
    else
    false
end
{% endmacro %}
```

This is needlessly verbose but serves to illustrate how to use
a macro. Assume then that we use this macro in model called
`customers.sql`:

```sql
with customers as (
 select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        {{ good_customer('customer_orders.number_of_orders') }} as is_good_customer
    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

Here you see the reference to the `good_customer` macro. You
can see the generated sql by looking in the `target` folder.
So for this model, you could run
`cat target/compiled/my_proj/models/customers.sql`, where you would see something like this:

```sql
with customers as (
 select * from `my_proj`.`my_dataset`.`stg_customers`

),

orders as (

    select * from `my_proj`.`my_dataset`.`stg_orders`

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        
CASE when customer_orders.number_of_orders >= 3 then
    true
    else
    false
end
 as is_good_customer
    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

Note how the case statement has been inlined from the macro.

## Schemas

In the model folder, there is a file called `schema.yml` that
will contain the schemas of all of your tables in yaml format.
This is not auto-generated. You should be going in here and 
populating any fields you create. So for my customers table, I 
have:

```yml
models:
  - name: customers
    description: One record per customer
    columns:
      - name: customer_id
        description: Primary key
        tests:
          - unique
          - not_null
      - name: first_order_date
        description: NULL when a customer has not yet placed an order.
```

Note the presence of the `tests` key. This is where you will
define your data tests, including the ones I've shown here
for column constraints, but you can do more interesting stuff
as well.

A DBT test passes when the query it represents returns zero
rows. So imagine I made a macro called
`test_does_not_contain.sql` like this:

```sql
{% macro test_does_not_contain(model, column_name, unwanted) %}
select {{column_name}}
from {{model}}
where contains_substr({{column_name}}, '{{unwanted}}')
{% endmacro %}
```

(Note that test macro names must begin with `test_`.)

I can then use this test for my fields by adding it in the 
schema, like so:

```yml
- name: customer_orders_by_name
    description: a report on how many orders come from customers per first name.
    columns:
      - name: first_name
        description: the 1st name.
        tests:
          - unique
          - not_null
          - does_not_contain:
              unwanted: 😂
      - name: total_orders
        tests:
          - dbt_expectations.expect_column_values_to_be_between:
              min_value: 0
              strictly: false
```

This will now throw an error if any first names contain the
laughing smiling emoji '😂'.

Note the second added test. After installing the 
`dbt_expectations` package you can use its tests, and this one
does range checking. You can install the package by running
`dbt deps --add-package dbt_expectations:1.0.0`.

## Data Tests

For larger tests, such as data quality tests, you can add a 
test in the tests folder, like this:

```sql
select 
    order_amount_cents
from
    {{ ref('order_amounts') }}
where order_amount_cents <= 0
```

As before, DBT expects zero rows to be returned from a test 
for it to pass. You can configure the expected number of rows
for a failure or warning. You can run all the tests with
`dbt test`. Tests will likely fail if you haven't first 
populated their underlying tables. Tests also run when you do
`dbt run`.

# Analyses

If you want the goodness of re-usable code to generate SQL
without necessarily using it to populate a table, you can 
put SQL in the analyses folder. For example you could make
`movies_by_year.sql`:

```sql
select year, count(*)
from
    {{ ref('movies') }}
group by year
```

Then run

```bash
dbt compile
```

Then inspect the file:

```bash
cat target/compiled/my_proj/analyses/movies_by_year.sql
```

This will give you something like:

```sql
select year, count(*)
from
    `my_project`.`my_dataset`.`movies`
group by year
```

## Python models

DBT also supports [python models](https://docs.getdbt.com/docs/build/python-models).
 You could make something like `transformed_customers.py`:

```python

def my_transform(name):
    return f"{name} {name[0].lower()}"

def model(dbt, session):
    dbt.config(materialized="table")

    df = dbt.ref("customers")

    pdf = df.to_pandas()

    pdf['name2'] = pdf['first_name'].apply(my_transform)

    return pdf

```

You don't have to use pandas here. In fact, is probably
quite often a bad idea. `df` will be a spark data frame.

This will apply your custom transformation logic to each row
and save that in the new table. Note that the python logic
will be run through whatever flavour of spark is convenient
for your platform. So since I'm using bigquery, that means
dataproc.

## Conclusion

And there you have it -— your crash course in Data Build Tool 
(DBT). It's like the Swiss Army knife of data, simplifying 
your life and making building and managing data projects a 
whole lot easier.

As you venture into the world of DBT, remember that you're 
equipped with a powerful tool that's trusted by data 
professionals worldwide. Whether you're a seasoned analyst or 
a newcomer to the data scene, DBT offers a friendly and 
intuitive platform to work with.

So take a deep breath, relax, and dive into the wonderful 
world of DBT. Experiment, explore, and have fun with it! After 
all, data doesn't have to be daunting -— it can be downright 
delightful with DBT by your side.

Here's to embracing data adventures with a smile—dbt style!