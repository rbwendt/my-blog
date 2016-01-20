---
title: Restricting post-deployment tasks to certain roles using capistrano
author: ben-wendt
date: 2015-11-10
template: article.jade
---

If you need to only run some tasks on a certain subset of servers in your inventory, first add a role to your inventory file deploy/whatever-environment.rb:

<span class="more"></span>


```ruby
server '1.2.3.4', roles: %w{my_role}
```

Now you can set up your command to run in one of your tasks in `deploy.rb`:

```ruby
on roles(:my_role) do
  within release_path do
    with rails_env: fetch(:rails_env) do
      execute :bundle, :exec, :'script/bend-girders.py', args, :all
    end
  end
end
```

