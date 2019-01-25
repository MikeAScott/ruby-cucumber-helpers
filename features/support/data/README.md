Data
====

Test Data and page element locators are defined here in YAML (.yml) files.
The data format is simple to use but quite powerful see [YAML Starter](http://www.yaml.org/start.html) for more info.
There is one file for each data type.

e.g.:

```yaml
user:
  email: a_user@gmail.com
  password: secret
  address:
    house_number: "5"
    street:  The lane
    town: Myton
    postcode: MY1 1PC
user_based_on_template:
  template: :user
  email: overriden_email@gmail.com
  #password will be inherited from template
```


A helper class ```DataCollection``` is used to load the data into a hash and convert to an object structure

Data can be preloaded to provide easy access by adding a method to the ```WorldData``` module
e.g:

```ruby
  def users
    @users ||= load_data 'users.yml'
  end
```

