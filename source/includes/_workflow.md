# Workflow

<aside class="notice">
Please note that the `workflow` gem and its process engine can only be used by subscribing to a PRO or ENTE plan. ADD LINK haha
</aside>

## Events

In Trailblazer, triggering a throwing event via the process engine always implies resuming a process that was stopped earlier. It resumes at the resume event, which is a _catching event_.


### Explicit Event

```ruby
{
  uuid: "66f1f0b1-7fe0-46b9-85dd-37dcea3fde51",
  resume_path: [:ready_for_sign_in, :user_resume],
  data: {
    user_id: 1,
    group_id: 2
  }
}
```

> Example of an explicit event that gets persisted to be triggered at a later point in time.

You can let Trailblazer maintain all open (or triggerable) events instead of managing state yourself. Every throwing event is persisted (Mysql, Postgres, Redis, etc), those who know the event UUID can trigger this event and continue the session, potentially avoiding permission checks and authentication.

Per default, the process engine will assume it's "ok" to continue from the throwing event.


A setup with explicit events emulates a persistent environment, where a process runs in a "real" state machine from beginning to end. This is found in many Java BPMN implementations. In Trailblazer, whatsoever, until we implement a persistend process engine, we decided this semi-persistent setup is extremely flexible, quite fast and a good trade-off.

An explicit event is always an instance of `Event::Throwing`.


### Implicit Event

```ruby
Trailblazer::Workflow::Event.implicit(
  [:ready_for_signin],
  { user_id: user.id }
)
```

> Example for creating an ad-hoc event instance.


In case you're migrating from a legacy app, or simply don't want to maintain another table for sessions, events can also be inferred ad-hoc, for example in a controller action. The event data and state can be computed from arbitrary (persisted) data. This is called an _implicit event_.

Every implicit event is an instance of `Event::Throwing`.
