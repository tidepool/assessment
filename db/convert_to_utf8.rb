require 'CSV'
profile_path = File.expand_path('../profile_descriptions.csv', __FILE__)
profile_output = File.expand_path('../profile_descriptions_utf8.csv', __FILE__)

output = ''
File.open(profile_path, 'r:windows-1251:utf-8').each_line do |line|
  output += line
end

File.open(profile_output, 'w') do |file|
  file.write(output)
end

CSV.foreach(profile_path) do |row|
  puts row
end
