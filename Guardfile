require 'rake'
::Rake.application.init
::Rake.application.load_rakefile

# Run `bundle install` whenever Gemfile changes.
guard :bundler do
  watch('Gemfile')
end

# Run local solr on launch and whenever sunspot config changes.
guard 'sunspot' do
  watch('Gemfile.lock')
  watch('config/sunspot.yml')
end

# Reloads spring whenever configs change.
guard 'spring', bundler: true, environments: %w(development) do
  watch('Gemfile.lock')
  watch(%r{^config/})
end

# Restart the dev server whenever configs change. (The dev server will automatically reload app code.)
guard :rails, port: 8000, host: '0.0.0.0', server: :puma do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end

# Rerun tests whenever test or app code changes.
guard :minitest do
  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }

  watch(%r{^app/(.+)\.rb$})
  watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
  watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/fixtures/.+\.yml$})
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end