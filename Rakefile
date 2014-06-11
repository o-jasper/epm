require 'bundler'
Bundler::GemHelper.install_tasks

desc "Update Sublime Package"
task :sublime do
  Dir.chdir(File.dirname(__FILE__))
  pkg = ENV['HOME'] + "/sites/sublime/EPM/lib"
  FileUtils.cp_r( File.dirname(__FILE__) + "/lib" , pkg )
  Dir.chdir(pkg)
  f = "lib/epm.rb"
  message = "Package updated at reflect changes in Gem to version #{tag}."
  system "git add -A"
  system "git commit -m #{message.shellescape}"
  system "git push github master"
  system "git push wsl master"
  Dir.chdir(File.dirname(__FILE__))
end
