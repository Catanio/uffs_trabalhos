require 'pg'
puts 'Version of libpg: ' + PG.library_version.to_s

begin

    con = PG.connect :dbname => 'cristal-gems', :user => 'ruby'
    puts "Server Version: #{con.server_version}"

rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end
