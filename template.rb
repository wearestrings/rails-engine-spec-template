error = false

say %{
-----------------------------------------------------
STRINGS DIGITAL PRODUCTS S.L engine template
This will install rspec, spec/dummy, postgres, 
faker, uuid as id as default and default database.yml
Please remenber to name as [project_name]-[component] 
the new engine to fit Strings requirements
-----------------------------------------------------

}

puts File.join(destination_root, "lib", namespaced_name, "engine.rb").inspect
unless File.exist?(File.join(destination_root, "lib", namespaced_name, "engine.rb"))
  say "ERROR: This is for engines only. You need to create a new engine with"
  say "       'rails plugin new' and specify '--mountable' or '--full'."
  error = true
end

if File.exist?(File.join(destination_root, "test"))
  say "ERROR: You need to generate the plugin with -T specified so it doesn't"
  say "       create a test setup. Delete the plugin directory and try again."
  error = true
end

exit 1 if error

def git_commit(message)
  git add: "."
  git commit: "-m '#{message}' -q"
end

def bundle
  run "bundle install --quiet"
end

say "Creating git repository..."
git :init
git_commit "Initial commit of empty Rails engine."

GEMSPEC_FILE = File.join(destination_root, "#{name}.gemspec")
RECIPE_PATH = File.join(File.dirname(rails_template), "recipes")
RECIPES = %w{normalize_gemspec rspec postgres}

RECIPES.each do |recipe|
  apply File.join(RECIPE_PATH, "#{recipe}.rb")
end

say "Garbage collecting git..."
git gc: "--quiet"

say %{
  Things to do:
    - createdb #{name.underscore}_test
    - rspec
    - guard

    Happy coding!
}
