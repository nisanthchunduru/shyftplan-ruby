require 'fileutils'

namespace :gem do
  require 'rake'
  require 'rubygems/package_task'

  desc "Build the gem"
  task :build do
    sh "gem build shyftplan.gemspec"
  end

  desc "Publish the gem to RubyGems"
  task :publish do
    sh "gem push shyftplan-#{Shyftplan::VERSION}.gem"
  end
end

task :console do
  require_relative "./lib/shyftplan"
  require "pry"
  site = "https://v2-15-0.sppt-beta.com"
  user_email = "nisanth.chunduru@ext.shyftplan.com"
  authentication_token = "e6ibfJzYy3M53Q92d7KRpDbpM3cMDoBs"
  shyftplan = Shyftplan.new(site, user_email, authentication_token)
  binding.pry
end
