The current `master` branch represents all documentation for the Trailblazer 2.1 suite.


## Markup

* Use `***this goes into an info box***`.
* Use `***!this goes into a warning box***`.
* Anchors are always 2-level, e.g. `#activity-call` and not `#activity-api-call`. This is for future compat since structuring might change, but headlines never.

## How to contribute to the docs

Below are the instructions for the setup required on your local machine in order to be able compile middleman-based api docs.

### Docs setup

#### On Github
Fork api-docs repo  on github to your account.
Any change you make you should push to your repo first ( into a branch preferably) and then create a pull-request to trailblazer

### Locally

Create a local folder like `~/projects/trailblazer/docs` ( or whatever)
Where you are going to keep local copies of the gems.

cd into the said directory
```shell
cd ~/projects/trailblazer/docs
```

Clone your api-docs  repo locally.
```shell
git clone git@github.com:[YOUR GITHUB ACCOUNT NAME]/api-docs
```

Set upstream to trailblazer api-docs, so that you can keep in sync with any changes

```shell
git remote add upstream git@github.com:trailblazer/api-docs
git pull upstream
```
### Setup local copies of gems
This is needed so that docs can compile.  They need to be cloned into the same parent directory

```shell
git clone git@github.com:trailblazer/cells
git clone git@github.com:trailblazer/formular
git clone git@github.com:trailblazer/reform
git clone git@github.com:trailblazer/representable
git clone git@github.com:trailblazer/roar
git clone git@github.com:trailblazer/roar-jsonapi
git clone git@github.com:trailblazer/trailblazer
git clone git@github.com:trailblazer/trailblazer-activity
git clone git@github.com:trailblazer/trailblazer-args
git clone git@github.com:trailblazer/trailblazer-cells
git clone git@github.com:trailblazer/trailblazer-compat
git clone git@github.com:trailblazer/trailblazer-context
git clone git@github.com:trailblazer/trailblazer-developer
git clone git@github.com:trailblazer/trailblazer-endpoint
git clone git@github.com:trailblazer/trailblazer-generator
git clone git@github.com:trailblazer/trailblazer-loader
git clone git@github.com:trailblazer/trailblazer-operation
git clone git@github.com:trailblazer/trailblazer-rails-basic-setup
git clone git@github.com:trailblazer/trailblazer-test
git clone git@github.com:trailblazer/trailblazer-transform

git clone git@github.com:apotonick/torture
```


### Startup Docs
```shell
cd api-docs
bundle install
bundle exec middleman server
```
### Keeping gems in sync
To pull ALL changed for all gems you can use this little snippet.
You can also alias it to a command in in you **.bash_profile** ( or fish or z config files)

```shell
 alias git_pull_all 'find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull " \;'
```

## Troubleshooting

```
ofile=/proc/sys/fs/inotify/max_user_instances
sudo sh -c "echo 8192 > $ofile"
```

