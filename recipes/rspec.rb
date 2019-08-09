say "Installing rspec can configuring rails_helper..."

# Add test files
inject_into_file GEMSPEC_FILE, after: /s\.files.*$/ do
  %{\n  spec.test_files = Dir["spec/**/*"]}
end

# Add the gems
inject_into_file GEMSPEC_FILE, before: %r{^end$} do
  %{
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'factory_bot_rails'
}
end

bundle

generate "rspec:install"

# Setting rspec and factory_girl as default generators...
insert_into_file "lib/#{name}/engine.rb", after: /isolate_namespace .*$/ do
  %{

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
      g.orm :active_record, primary_key_type: :uuid
    end


    initializer "#{name}.factories", after: "factory_bot.set_factory_paths" do
      if defined?(FactoryBot)
        FactoryBot.definition_file_paths << File.expand_path("../../../../spec/factories", __FILE__)
      end
    end
}
end

# Setting up spec helper for engines...

# RSpec doesn't understand engine dummy path, fix that.
gsub_file "spec/rails_helper.rb", "File.expand_path('../../config/environment', __FILE__)", "File.expand_path('../dummy/config/environment.rb', __FILE__)"

# Require factory girl
insert_into_file "spec/rails_helper.rb", "\nrequire 'factory_bot_rails'", after: "require 'rspec/rails'"

# Add Factory Girl methods to RSpec, and include the route's url_helpers.
insert_into_file "spec/rails_helper.rb", after: "config.use_transactional_fixtures = true" do
  %{
  config.include FactoryBot::Syntax::Methods
  
  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
}
end

git_commit "Installed rspec"
