# Operation

> Example for an operation that doesn't use any TRB macros. It creates a fresh `Memo` instance.

```ruby
class Memo::Operation < Trailblazer::Operation
  step :create_model
  step :validate
  step :save
  step :notify

  def create_model(ctx, **)
    ctx[:model] = Memo.new
  end

  def validate(ctx, params:, **)
    if params[:body].size < 10
      ctx[:errors] = "something wrong with :body"
      return false
    end
  end

  def save(ctx, params:, model:, **)
    model.body = params[:body]
    model.save
  end

  def notify(ctx, model:, **)
    Notifier.(model)
  end
end
```

An operation is the essential element that was introduced with the first Trailblazer book. It indeed is the most popular concept from the TRB architectural style and since has found its way into many other frameworks.

The goal of an operation is to encapsulate all business logic of one feature in an application. Since features (or functions) in web applications are often, very often, mapped to controller actions, sometimes operations are compared to controller actions, orchestrating all logic related to business except for HTTP-related code.

<img src="/images/action-operation.png" >

In particular, this means that neither HTTP code nor rendering is part of an operation.

### Single Entry Point

> The public `Operation.call` method makes invoking operations really straight-forward.

```ruby
result = Memo::Create.( params: { body: "too short!" } )

result.success?      #=> false
result[:model].body  #=> nil
```

> Usually, operations are called from a controller. For example, in Rails, this could look as follows.

```ruby
class MemosController < ApplicationController
  def create
    result = Memo::Create.( params: params, current_user: current_user )

    return redirect_to "/dashboard" if result.success?
  end
end
```


You can imagine an operation being the single entry point to invoke a function of your application such as creating a memo, viewing a comment, or generating a PDF report. The great thing about this encapsulated asset is that you can use it for different layers of your application.

* Operations are the single entry point in controllers.
* They can also be used in Rake files or CLI tools, and do exactly the same as they'd do in a controller.
* Instead of factories that always create leaky test states, chains of operations are called to produce solid test scenarios that are identical to production environments.

## Operation vs. Activity
