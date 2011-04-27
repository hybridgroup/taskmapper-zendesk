# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ticketmaster-zendesk}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rafael George"]
  s.date = %q{2011-04-27}
  s.description = %q{Allows ticketmaster to interact with Your System.}
  s.email = %q{george.rafael@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".DS_Store",
    ".rvmrc",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/.DS_Store",
    "lib/provider/comment.rb",
    "lib/provider/project.rb",
    "lib/provider/ticket.rb",
    "lib/provider/zendesk.rb",
    "lib/ticketmaster-zendesk.rb",
    "lib/zendesk/zendesk-api.rb",
    "spec/.DS_Store",
    "spec/comments_spec.rb",
    "spec/fixtures/.DS_Store",
    "spec/fixtures/ticket.json",
    "spec/fixtures/tickets.json",
    "spec/fixtures/tickets.xml",
    "spec/fixtures/tickets/2.xml",
    "spec/fixtures/tickets/5.xml",
    "spec/fixtures/tickets/create.xml",
    "spec/projects_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/ticketmaster-zendesk_spec.rb",
    "spec/tickets_spec.rb",
    "ticketmaster-zendesk.gemspec"
  ]
  s.homepage = %q{http://bandw.tumblr.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.0}
  s.summary = %q{Ticketmaster Provider for Zendesk}
  s.test_files = [
    "spec/comments_spec.rb",
    "spec/projects_spec.rb",
    "spec/spec_helper.rb",
    "spec/ticketmaster-zendesk_spec.rb",
    "spec/tickets_spec.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_runtime_dependency(%q<ticketmaster>, [">= 0.1.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_runtime_dependency(%q<activeresource>, [">= 2.3.2"])
      s.add_runtime_dependency(%q<addressable>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<ticketmaster>, [">= 0.1.0"])
      s.add_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_dependency(%q<activeresource>, [">= 2.3.2"])
      s.add_dependency(%q<addressable>, [">= 2.1.2"])
      s.add_dependency(%q<i18n>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<ticketmaster>, [">= 0.1.0"])
    s.add_dependency(%q<activesupport>, [">= 2.3.2"])
    s.add_dependency(%q<activeresource>, [">= 2.3.2"])
    s.add_dependency(%q<addressable>, [">= 2.1.2"])
    s.add_dependency(%q<i18n>, [">= 0"])
  end
end

