# Ruby

https://github.com/JuanitoFatas/ruby-style-guide/blob/master/README-zhTW.md

- 有個名為 bundler 的 tool, 用來協助管理 project 的 environment
  - by tracking and installing the exact gems and versions that are needed
  - `gem install bundler`
- gem
  - ruby 的 pkg manager

```bash
### Create Gemfile
bundle init


### Install gems
bundle install


###
bundle exec pod install
# run the same CocoaPods gem version installed in the Gemfile


###
```

```ruby
class Greeter
    attr_accessor :XXX
end
# 修改 Greeter, 讓外界可訪問 XXX
```



# try-catch-finally

```ruby

# Ruby 的 try catch finally
begin

  rescue



  ensure

end


```

# 
.ruboca