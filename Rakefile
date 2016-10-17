task default: %i(test)

task :test do
  FileList['test/*_test.rb'].each { |file| ruby file }
end
