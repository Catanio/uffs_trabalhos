require 'pg'

begin

    con = PG.connect :dbname => 'cristal-gems', :user => 'ruby', :password => 'saphire'
    
    puts "number of inserts"
    n_ins = gets.chomp

    con.exec"begin"
    for i in 1..n_ins.to_i
        puts "Band's name"
        band = gets.chomp
        puts "song title"
        title = gets.chomp

        exec = con.exec "INSERT INTO songs (band, title) VALUES ('#{band}', '#{title}')"
        puts "#{exec}"
    end
    con.exec "end;"

    
rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end
