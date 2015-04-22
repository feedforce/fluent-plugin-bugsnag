require 'test_helper'

class HogeOutputTest < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
      bugsnag_proxy_host localhost
      bugsnag_proxy_port 8888
      bugsnag_proxy_user user
      bugsnag_proxy_password password
      bugsnag_timeout 10
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::BugsnagOutput).configure(conf)
  end

  def test_configure
    d = create_driver

    assert_equal 'localhost', d.instance.bugsnag_proxy_host
    assert_equal 8888, d.instance.bugsnag_proxy_port
    assert_equal 'user', d.instance.bugsnag_proxy_user
    assert_equal 'password', d.instance.bugsnag_proxy_password
    assert_equal 10, d.instance.bugsnag_timeout
  end

  def test_write
    d = create_driver ''

    stub_request(:post, "https://www.example.com/")
      .with(:body => 'json', :headers => {'Content-Type' => 'application/json'})
      .to_return(:status => 200, :body => "", :headers => {})

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.emit({'url' => 'https://www.example.com/', 'body' => 'json'}, time)
    d.run
  end
end
