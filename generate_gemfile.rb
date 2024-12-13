# generate_gemfile.rb
installed_gems = `gem list --local`.split("\n")
File.open('Gemfile', 'w') do |file|
  file.puts("source 'https://rubygems.org'")
  installed_gems.each do |gem_info|
    gem_name = gem_info.split(" ").first
    file.puts("gem '#{gem_name}'")
  end
end
