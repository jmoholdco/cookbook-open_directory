notification :gntp, host: '127.0.0.1'

guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^recipes/(.+)\.rb$}) { |m| "spec/unit/recipes/#{m[1]}_spec.rb" }
end

#  vim: set ts=8 sw=2 tw=0 ft=ruby et :
