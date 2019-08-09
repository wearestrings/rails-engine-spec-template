say "Installing guard..."

inject_into_file GEMSPEC_FILE, before: %r{^end$} do
%{
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rails'
}
end

bundle

run 'bundle exec guard init'

git_commit "Installed guard"
