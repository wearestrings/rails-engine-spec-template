DATABASE_YML = "spec/dummy/config/database.yml"

say "Installing Postgresql gem..."

gsub_file DATABASE_YML, /^(  adapter: ).*$/, '\1%s' % "postgresql"
gsub_file DATABASE_YML, /^(  database: )dummy_development.*$/, '\1%s' % " #{name}_development"
gsub_file DATABASE_YML, /^(  database: )dummy_test.*$/, '\1%s' % " #{name}_test"
gsub_file DATABASE_YML, /^(  database: )dummy_production.*$/, '\1%s' % " #{name}_production"

inject_into_file DATABASE_YML, after: %r{^  encoding: unicode$} do
  %{
  host: <%= ENV.fetch("DATABASE_HOST") { '0.0.0.0' } %>
  port: <%= ENV.fetch("DATABASE_PORT") { 5432 } %>
  user: <%= ENV.fetch("DATABASE_USERNAME") { 'postgres' } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { 'postgres' } %> 
}
end

bundle

git_commit "Adding Postgresql gems"
