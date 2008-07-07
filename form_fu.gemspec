Gem::Specification.new do |s|
  s.name = 'form_fu'
  s.version = '0.1'
  s.date = '2008-07-05'
  
  s.summary = "Allows easier rails form creation and processing"
  s.description = "ViewFu is a Rails plugin that provides all the miscellaneous View tasks. It's a combination of the functionality of Styler, Javascripter, and Headline (from Patrick Crowley, the.railsi.st) - along with additional tweaks such as providing commonly used View Helpers Methods."
  
  s.authors = ['Tyler Crocker']
  s.email = 'neorails@gmail.com'
  s.homepage = 'http://github.com/neorails/form_fu'
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]

  s.add_dependency 'rails', ['>= 2.1']

  s.files = ["LICENSE",
             "README",
             "form_fu.gemspec",
             "init.rb",
             "lib/form_fu/form_builder.rb",
             "lib/form_fu/helpers.rb",
             "lib/form_fu.rb",
             "rails/init.rb"]

  s.test_files = ["test/form_fu_test.rb"]

end