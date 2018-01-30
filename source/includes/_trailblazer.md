# Trailblazer

[//]: # "FIXME - add a docs"
<aside class="notice">
  Populate me
</aside>

## File Structure

## Loader

> Short-form, needs our loader.

```ruby
class Memo::Create < Trailblazer::Operation
end
```

> Normal, works with Rails autoloader out-of-the-box.

```ruby
module Memo::Operation
  class Create < Trailblazer::Operation
  end
end
```


### Disable Loader

```ruby
Memos::Application.config.trailblazer.use_loader = false
```

In Rails, the `Trailblazer::Loader` is only necessary when you want to use the short-form for operations. You can disable our loader entirely should you follow the [Rails naming conventions](http://guides.rubyonrails.org/autoloading_and_reloading_constants.html).
