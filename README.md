# Alchemist

Release: 0.3.1b (Beta Release 3 with Documentation)

A pure-Ruby DSL for use in casting, transforming or translating data and objects.

### Current Status

This library has basic functionality, though it is in a beta state. This means that the API for examining operations in tests as well as the DSL is subject to change and expansion as we continue to implement the feature set.

## Rationale

Casting complex objects from one type to another can be an uncomfortable process to express well. Objects that we use on a daily basis are not always in our control, and, even when they are, some don't lend themselves to simple construction. Remote service communication objects or complex data structures from libraries we use in our applications can result in large piles of casting code.

This circumstance often produces large swaths of procedural code, even if split up into separate function calls. This code can be not only difficult to understand, but difficult to test if an object requires a great deal of set up. Field or method assignments midway through can change and break the entire operation.

The goal of this project is to provide a method of defining easily digestible specifications for object translation that are also easily testable and changeable. **The project focuses on writing specifications for transformations and not doing direct mutation in the recipes.** The result is something that should seem somewhat functional, but also exceedingly separable.

## Basic Usage

Alchemist "transmutes" objects from one type to another using recipes that describe all of the separate operations needed to communicate the data from start to finish. The simplest example of a recipe would be transferring a single field between two different classes.

### Simple Example

````ruby
class User
  attr_accessor :name
end

class Admin
  attr_accessor :full_name
end

Alchemist::RecipeBook.write User, Admin do

  transfer :name, :full_name

end

user = User.new
user.name = "Shannon"

admin = Alchemist.transmute(user, Admin)
admin.full_name # => "Shannon"
````

There are two major components to this:

* The Recipe definition from the Alchemist::RecipeBook.write call
* The invocation of the recipe by Alchemist.transmute

Alchemist will automatically detect what class your object is an instance of and attempts to match it to an appropriate recipe for transmuting. There are currently five primary DSL functions available inside of a recipe as well as optional traits that can be applied the a given transmutation if you so desire them.

### Rituals (DSL Operations)

#### Result

**This method will be subject to change soon. The desire behavior is of a .new call on the result class by default if no block is specified, as well as a better syntax for creating the instance without direct access to the source object's pointer.**

The result ritual is what provides your recipe with the object you are going to be transmuting *into*. This could be as simple a creating a new instance of the object or performing a database query via your favorite ORM. Below is an example of fetching a result by ActiveRecord query.

````ruby
Alchemist::RecipeBook.write User, Admin do

  result do |source|
    Admin.where(full_name: nil).first
  end

end
````

#### Guard

The guard ritual is a form of validation for your source object. You can use guards to ensure that your source is sane before Alchemist will begin performing destructive operations on your result. Each guard operation will give you access to the value of a method on your source with which you can create a boolean expression. If the result of your block is not truthy, then the guard will fail and raise an exception. (Exceptions are detailed further down the README.)

````ruby
Alchemist::RecipeBook.write User, Admin do

  result do |source|
    Admin.new
  end

  guard :name do
    name != "Bob Smith"
  end

end
````

#### Transfer

The transfer ritual is the most basic form of conveying data. It takes the result of a given method on your source objects and passes it to a method or field assignment on your result object with optional translation. It has an optional second field argument and optional block to mutate the data in-route to the result.

````ruby
Alchemist::RecipeBook.write User, Admin do

  result do |source|
    Admin.new
  end

  transfer :name

  transfer :name, :full_name

  transfer :name do |user_name|
    user_name.strip
  end

  transfer :name, :full_name do |user_name|
    user_name.strip
  end

end
````

* When called with a single field, the operation assumes the method has the same name on both source and result
* When called with two, the operation calls the first on the source and passes it to the second on the result
* If a block is given in any case, the block will be used to get the final value passed to the result

#### Aggregate Onto

The aggregation ritual is an N to 1 translation from methods on the source object to a single method on the result. The field list is defined using the `from` function. The accompanying `with` call accepts a block that has the method values available as locals of the same name and, like translate, will assign the result of the block to the field defined in the initial `aggregate_onto` call.

````ruby
Alchemist::RecipeBook.write User, Admin do

  result do |source|
    Admin.new
  end

  aggregate_onto :full_name do

    from :first_name, :last_name

    with do
      "#{first_name} #{last_name}"
    end

  end

end
````

#### Distribute From

The distribution ritual is the inverse of aggregate: 1 to N. The distribute_from makes the value of the given method on the source available in each target block as a local. Each field stipulated on a given `target` call will receive the results of the block.

````ruby
Alchemist::RecipeBook.write Admin, User do

  result do |source|
    Admin.new
  end

  distribute_from :full_name do

    target :first_name do
      full_name.split(' ').first
    end

    target :last_name, :maiden_name do
      full_name.split(' ')
    end

  end

end
````

#### Traits

Traits can be given to recipes to stipulate special behavior. Recipes with traits will override any operations on the base, un-traited recipe if one is defined. Using this, you can apply traits to all recipes, or have common functionality in the un-traited recipe and any special instructions that differ from the common-case in the traited recipe.

Traited recipes will only override or add functionality. All operations defined on an un-traited recipes that are not replaced will be executed as well.

````ruby
Alchemist::RecipeBook.write User, Admin do

  result do |source|
    Admin.new
  end

  transfer :name, :full_name

end

Alchemist::RecipeBook.write User, Admin, :from_database do

  result do |source|
    Admin.where(full_name: nil).first
  end

end

user = User.new
user.name = "Shannon'

# Invoke the "common" recipe

admin = Alchemist.transmute(user, Admin)
admin.full_name # => "Shannon"

# Invoke the recipe with the alternate result call

admin = Alchemist.transmute(user, Admin, :from_database)
admin.full_name # => "Shannon"
````

## Testing Recipes

Recipes can currently be tested with two primary methods: full execution or specific operation.

### Full Execution

This method is executing the entire recipe on a fully realized instance of your source and asserting about the qualities of the result. It requires the most cumbersome set up, but allows you to ensure the entire scope of what you're doing is valid.

#### Recipe Example

````ruby
Alchemist::RecipeBook.write SomeClass, SomeOtherclass do

  result do |source|
    SomeOtherClass.new
  end

  transfer :some_field do |some_field_value|
    some_field_value.to_i
  end

end
````

#### RSpec Example

````ruby
require 'spec_helper'

describe 'SomeClass to SomeOtherClass recipe' do

  let(:source) { SomeClass.new }
  let(:result) { Alchemist.transmute(source, SomeOtherClass) }

  let(:expected_some_field) { "expected value" }

  subject { result }

  its(:some_field) { should eq(expected_some_field) }

end
````

### Testing Specific Operations

**This method does not yet have a fully formed API, but it does, at least, have a functional one. This bit of functionality is subject to change very soon (or at least being superseded by something easier to use).**

There are methods for each DSL operation provided on an instance of a recipe. These methods can be used to locate a specific operation and execute it such that you may then test the results of its operation in isolation from the rest of the recipe.

#### Recipe Example

````ruby
Alchemist::RecipeBook.write SomeClass, SomeOtherClass do

  result do |source|
    SomeOtherClass.new
  end

  guard :field1 do |field1_value|
    field1_value < 10
  end

  transfer :field1
  transfer :field2, :field_two

  aggregate_onto :aggregate_field do
    from :field1, :field2

    with do
      field1 + field2
    end
  end

  distribute_from :array_field do
    target :element_one { array_field[0] }
    target :element_two { array_field[1] }
  end

end

Alchemist::RecipeBook.write SomeClass, SomeOtherClass, :some_trait do

  result do |source|
    SomeOtherClass.new(optional_attribute: true)
  end

end
````

#### RSpec Example

````ruby
require 'spec_helper'

let(:source) { SomeClass.new }

describe 'SomeClass to SomeOtherClass' do

  let(:recipe) { Alchemist::RecipeBook.lookup(SomeClass, SomeOtherClass, :some_trait) }

  let(:context) { Alchemist::Context.new(source, result) }
  let(:result)  { operation.call(context) }

  describe 'guard for field1' do

    let(:operation) { recipe.guard_for(:field1) }

    it 'fails if field1 is greater than 10' do
      expect { result }.to raise_error(Alchemist::Errors::GuardFailure)
    end

  end

  describe 'transfer for field1' do

    let(:operation) { recipe.transfer_for(:field1) }

    it 'populates field1' do
      expect(result.field1).to eq(source.field1)
    end

  end

  describe 'transfer for field2 to field_two' do

    let(:operation) { recipe.transfer_for(:field2, :field_two) }

    it 'populates field_two' do
      expect(result.field_two).to eq(source.field2)
    end

  end

  describe 'aggregation for aggregate_field' do

    let(:operation) { recipe.guard_for(:field1) }

    let(:expected_value) { source.field1 + source.field2 }

    it 'populates aggregate_field' do
      expect(result.aggregate_field).to eq(expected_value)
    end

  end

  describe 'distribution for array_field' do

    let(:operation) { recipe.guard_for(:field1) }

    it 'populates element_one' do
      expect(result.element_one).to eq(source.array_field[0])
    end

    it 'populates element_two' do
      expect(result.element_two).to eq(source.array_field[1])
    end

  end

end

describe 'SomeClass to SomeOtherClass with :some_trait' do

  let(:recipe) { Alchemist::RecipeBook.lookup(SomeClass, SomeOtherClass, :some_trait) }

  describe 'result ritual' do

    let(:operation) { recipe.result_ritual }
    let(:result)    { operation.call(source) }

    it 'returns an instance of SomeOtherClass with optional_attribute set to true' do
      expect(result.optional_attribute).to be_true
    end

  end

end
````

## Errors

#### Alchemist::Errors::GuardFailure

This is the exception raise in the event a guard call fails on a recipe.

#### Alchemist::Errors::InvalidSourceMethod

This exception is raised when a method is defined for any ritual, and that method does not exist in the public API of the source object.

#### Alchemist::Errors::InvalidResultMethod

This exception is raised when a method is defined for any ritual, and that method does not exist in the public API of the result object.

#### Alchemist::Errors::InvalidTransmutationMethod

This is raised when the parameters given to Alchemist.transmute or Alchemist::RecipeBook.lookup cannot produce a valid recipe from the definitions required into ruby.

#### Alchemist::Errors::NoTargetReceived

This is not currently used, but will be implemented as part of no valid result instance being produced.

#### Alchemist::Errors::TransmutationError

This is the base exception type that will never be raised directly. If you ever have need to catch exceptions from normal use of this library, this is what you should rescue.

## Rails Integration

Rails integration does not yet exist at this time. Recipes will need to be required manually through whatever method you desire. A Railtie file, as well as lazy-loading conventions for recipes, is on the requirement list for the 1.0 release.

## Authors

* [James Christie](https://github.com/jameschristie)
* [Alex Williams](https://github.com/robovirtuoso)

## License

Copyright (C) 2013 Acumen Brands, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
 NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
