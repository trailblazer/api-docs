---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - RUBY

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Activity

The activity gem provides the DSL to define workflows, and the runtime objects to execute the latter.

## Overview


```ruby
module Memo::Update
  extend Trailblazer::Activity::Railway()
  module_function

  # here goes your business logic
  #
  def find_model(ctx, id:, **)
    ctx[:model] = Memo.find_by(id: id)
  end

  def validate(ctx, params:, **)
    return true if params[:body].is_a?(String) && params[:body].size > 10
    ctx[:errors] = "body not long enough"
    false
  end

  def save(ctx, model:, params:, **)
    model.update_attributes(params)
  end

  def log_error(ctx, params:, **)
    ctx[:log] = "Some idiot wrote #{params.inspect}"
  end

  # here comes the DSL describing the layout of the activity
  #
  step method(:find_model)
  step method(:validate), Output(:failure) => End(:validation_error)
  step method(:save)
  fail method(:log_error)
end
```

An activity defines a workflow for a specific business process. This can be any level of granularity, from the entire lifecycle of a user object, or validating and persisting input from a form, down to parsing and coercing a specific fragment from a document. In Trailblazer, activities are the major building block for logic.

Per convention, activities are `module`s and not classes. A module in Ruby is just a namespace and not automatically supposed to be used as a mixin, which we refrain from. Instead, think of an activity module as a `module` in Elixir, which is simply a collection of stateless functions. Modules have two major benefits.

* You can not subclass actitivies. This might sound counter-intuitive, but activity gives you the much more sustainable tool of compositions.
* Modules provide `module_function` to declare every method as a class method. This makes the module more readable and allows to use `method` to attach a module method to a step.

### Example

In the exemplary `Memo::Update` activity, the first line extends your module and imports the DSL. Activity ships with three built-in strategies to build workflows: `Path` is designed for more linear flows, `Railway` is the [railway-oriented](https://fsharpforfunandprofit.com/rop/) two tracks flow, and `FastTrack` is the extended railway with two more "fast" tracks which was tried and tested in Trailblazer for two years and more.

In the upper part sits the implementation of the actual steps. Note that these don't have to be located in the same module or class as the activity definition - this is just convenient in many cases. All methods expose the _step API_, which is the default.

In the lower part, the actual DSL defines the activity's flow. Check out the rendered diagram, it helps to understand the DSL.

<img src="/images/activity-overview.png" >

# Introduction

Welcome to the Kittn API! You can use our API to access Kittn API endpoints, which can get information on various cats, kittens, and breeds in our database.

We have language bindings in Shell, Ruby, and Python! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

This example API documentation page was created with [Slate](https://github.com/lord/slate). Feel free to edit it and use it as a base for your own API's documentation.

The DSL methods `step`, `pass` and `fail` conveniently allow to put steps on one of the tracks. Using the more advanced `Output` function, you can create additional connections.

# Authentication

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# Kittens

## Get All Kittens

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

## Delete a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -X DELETE
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "deleted" : ":("
}
```

This endpoint deletes a specific kitten.

### HTTP Request

`DELETE http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to delete
