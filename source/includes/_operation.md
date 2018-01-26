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

In Trailblazer 1.x and 2.0, the `Operation` was the central notion, all was build around it. In Trailblazer 2.1, operations still exist, but they're just one piece in a huge clockwork of activities. In fact, an operation is not more than a extended API around an activity. Internally, it creates, maintains and runs an activity.

You could build a Trailblazer application without using `Trailblazer::Operation`. This makes especially sense when using the `workflow` process engine. However, until all applications are run using this, we will keep the operation.

The following is different from an activity.

* **INHERITANCE** An operation is a class, not a module. That means, you can use inheritance to derive subclasses. These will inherit step methods and activity wirings.
* **STEP DEFINITIONS** Operations provide the `step :some_method` syntax, which in turn allows to define the activity wiring _before_ implementing the methods.
* **CALL API** When invoking an operation using `Create.()`, you have the "convenient" interface: pass in `:params` and other variables, and the operation will automatically create a `Context` object. This is handy when calling an operation in a controller, or a test, but gets into your way when using an operation in a compound of other activities.
* **RESULT** Also, the operation `call` will return a `Result` object, whereas an activity simply returns following the _circuit interface_.
* **EXTENDED RAILWAY** Whereas activities can choose their DSL strategy, an operation will always be a `FastTrack` railway with four tracks. This has been established in versions before 2.1.

Let's discuss those differences a bit more.
