# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }
end

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end

# group :backend do
#   guard :rspec, :cmd => "--color --format nested zeus bundler",
#                  :all_after_pass => false,
#                  :all_on_start => false do
#     watch(%r{^spec/.+_spec\.rb$})
#     watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
#     watch('spec/spec_helper.rb')  { "spec" }

#     # Rails example
#     watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#     watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
#     watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
#     watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
#     watch('config/routes.rb')                           { "spec/routing" }
#     watch('app/controllers/application_controller.rb')  { "spec/controllers" }
#   end
# end

# group :frontend do
#   guard 'livereload', :apply_css_live => true, :port => '35729', :host => '0.0.0.0' do
#     watch(%r{^app/(.+)\.rb$})
#     watch(%r{app/views/.+\.(erb|haml|slim)$})
#     watch(%r{app/helpers/.+\.rb})
#     watch(%r{public/.+\.(css|js|html)})
#     watch(%r{config/locales/.+\.yml})
#     # Rails Assets Pipeline
#     watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|coffee|js|html))).*}) { |m| "/assets/#{m[3]}" }
#   end
# end
