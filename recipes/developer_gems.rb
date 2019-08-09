say "Installing thin, pry, awesome_print, better_errors, and hirb..."

inject_into_file GEMSPEC_FILE, before: %r{^end$} do
  %{
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'faker'
}
end

bundle

git_commit "Adding development gems"
