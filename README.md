# Rspec::ActionCheck

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rspec/actioncheck`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-action-check'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-action-check

## Usage

### How to use your projects

#### Rails

Please add spec/rails_helper.rb

```ruby
require 'rspec/actioncheck'
```

#### Other

Please add spec/spec_helper.rb

```ruby
require 'rspec/actioncheck'
```

### Simple case

You can write that code in spec.

```ruby
RSpec.describe 'First Example' do
  before do
    @some_state1 = nil
    @some_state2 = nil
  end

  actions 'some actions like a scenario test story' do
    action 'set some_state1 = 100' do
      @some_state1 = 100
    end

    check 'some_state1 = 100' do
      expect(@some_state1).to eq 100
    end

    action 'set some_state2 = 200' do
      @some_state2 = 200
    end

    check 'some_state2 = 200' do
      expect(@some_state2).to eq 200
    end
  end
end
```

It output that when It run

```rspec
First Example
  some actions like a scenario test story
    action:set some_state1 = 100
      check:some_state1 = 100
      action:set some_state2 = 200
        check:some_state2 = 200
```

It is same as

```ruby
RSpec.describe SomeTest do
  before do
    @some_state1 = nil
    @some_state2 = nil
  end

  context 'some actions like a scenario test story' do
    context 'action:set some_state1 = 100' do
      before do
        @some_state1 = 100
      end

      it 'check:some_state1 = 100' do
        expect(@some_state1).to eq 100
      end

      context 'action:set some_state2 = 200' do
        before do
          @some_state1 = 100
        end

        it 'check:some_state2 = 200' do
          expect(@some_state2).to eq 200
        end
      end
    end
  end
end
```

First one is more clearly to write story test.

### Branching

You can write that code in spec if you want to branch story.

```ruby
RSpec.describe 'Branch Example' do
  before do
    @some_state1 = nil
    @some_state2 = nil
    @some_state3 = nil
  end

  actions 'some actions like a scenario test story with branching' do
    action 'set some_state1 = 100' do
      @some_state1 = 100
    end

    branch 'branch1' do
      check 'some_state1 = 100' do
        expect(@some_state1).to eq 100
      end

      action 'set some_state2 = 200'
        @some_state2 = 200
      end

      check 'some_state1 = 100 and some_state2 == 200' do
        expect(@some_state1).to eq 100
        expect(@some_state2).to eq 200
      end

      branch 'branch in branch1' do
        action 'set some_state3 = 300'
           @some_state3 = 300
        end

        check 'some_state1 = 100 and some_state2 == 200 and some_state3 == 300' do
          expect(@some_state1).to eq 100
          expect(@some_state2).to eq 200
          expect(@some_state3).to eq 300
        end
      end
      branch 'branch` in branch1' do
        check 'some_state1 = 100 and some_state2 == 200 and some_state3 is nil' do
          expect(@some_state1).to eq 100
          expect(@some_state2).to eq 200
          expect(@some_state3).to be_nil
        end
      end
    end

    branch 'branch2' do
      check 'some_state1 = 100 and some_state2 is nil' do
        expect(@some_state1).to eq 100
        expect(@some_state2).to be_nil
      end
    end
  end
end
```

It output that when It run

```
Branch Example
  some actions like a scenario test story with branching
    action:set some_state1 = 100
      action:branch1
        check:some_state1 = 100
        action:set some_state2 = 200
          check:some_state1 = 100 and some_state2 == 200
          action:branch in branch1
            action:set some_state3 = 300
              check:some_state1 = 100 and some_state2 == 200 and some_state3 == 300
          action:branch` in branch1
            check:some_state1 = 100 and some_state2 == 200 and some_state3 is nil
      action:branch2
        check:some_state1 = 100 and some_state2 is nil
```

It same as ... That code as too long. I will write it when I feel like it.

Both examples contain in `spec/rspec/example/`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec-action-check. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rspec::ActionCheck project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rspec-action-check/blob/master/CODE_OF_CONDUCT.md).
