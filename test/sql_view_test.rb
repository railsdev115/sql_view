require_relative "./test_helper"

class SqlViewTest < ActiveSupport::TestCase
  # test 'simple DSL' do
  # end

  test 'model view materialzied' do
    assert_equal "another_views", AnotherView.view_name
    assert_equal "all_old_users", OldUserView.view_name

    OldUserView.sql_view.up

    assert_equal 0, OldUserView.model.count

    a = User.create(age: 42)
    OldUserView.sql_view.refresh
    assert_equal 1, OldUserView.model.count

    b = User.create(age: 5)
    OldUserView.sql_view.refresh
    assert_equal 1, OldUserView.model.count

    assert_equal [a.id], OldUserView.model.pluck(:id)

    OldUserView.sql_view.down
  end

  test 'model view NOT materialzied' do
    AnotherView.sql_view.up

    assert_equal 0, AnotherView.model.count
    User.create(age: 42)
    assert_equal 0, AnotherView.model.count
    User.create(age: 18)
    assert_equal 1, AnotherView.model.count

    AnotherView.sql_view.down
  end

  # test 'migration' do
  #   a = User.create(age: 20)
  #   a = User.create(age: 30)
  #   m = SqlView::Migration.new("test", up: User.where("age > 25"))

  #   m.up

  #   builder = SqlView::Collection.instance
  #   view = builder.register_view("test")
  #   assert_equal 1, view.model.count
  #   assert_equal 30, view.model.first.age

  #   assert ActiveRecord::Base.connection.views.include?("test")

  #   m.down

  #   assert_equal false, ActiveRecord::Base.connection.views.include?("test")
  # end
end
