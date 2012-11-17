require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'capybara-screenshot'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.basename(__FILE__)+"/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    Capybara.default_driver = :selenium
    config.before :each do
      Capybara.reset_sessions!
    end

    # Turn on capybara by default, otherwise you'd have to
    # pass :type => :acceptance or :type => :request to each example.
    config.include Capybara::DSL
    config.include Capybara::RSpecMatchers

    # Without Rails, Capybara Screenshot is having trouble finding the root dir
    Capybara.save_and_open_page_path =
      File.dirname(File.dirname(__FILE__))+"/tmp/capybara"

    # Capybara Screenshot also works only for :type => :request by default
    config.after do
      if Capybara::Screenshot.autosave_on_failure && example.exception
        filename_prefix =
          Capybara::Screenshot.filename_prefix_for(:rspec, example)

        saver =
          Capybara::Screenshot::Saver.new(Capybara, Capybara.page,
                                          true, filename_prefix)
        saver.save

        example.metadata[:full_description] +=
          "\n     Screenshot: #{saver.screenshot_path}"
      end
    end

    # Setup some logging since Rails.logger is unavailable
    config.before(:each) do
      descr = "Starting spec: #{example.metadata[:full_description]}"
      logger.info "#{descr}"
    end

    require 'logger'
    config.include(
      Module.new do
        def logger
          Logger.new(File.dirname(__FILE__)+"/../test.log")
        end
      end
    )
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
