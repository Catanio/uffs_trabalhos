require 'pg'

begin

    con = PG.connect :dbname => 'cristal-gems', :user => 'ruby', :password => 'saphire'
    
    con.exec "begin"
    con.exec "DROP TABLE IF EXISTS songs"
    con.exec "CREATE TABLE songs(Id SERIAL PRIMARY KEY, band VARCHAR(32), title VARCHAR(64))"

    con.exec   "CREATE OR REPLACE FUNCTION polish()
                RETURNS trigger
                LANGUAGE plpgsql
                AS $function$
                BEGIN
                    IF position('ruby' in lower(NEW.title)) <> 0 THEN
                        RETURN NEW;
                    ELSE
                        RAISE EXCEPTION 'only ruby inserts!';
                    END IF;
                END;
                $function$
                ;"
    conection = con.exec "CREATE TRIGGER verify BEFORE INSERT ON songs FOR EACH ROW EXECUTE PROCEDURE polish();"
    con.exec "end;"

    #inserções padrão
    con.exec "BEGIN"
    con.exec "INSERT INTO songs (band, title) VALUES ('Rolling Stones', 'Ruby tuesday')"
    con.exec "INSERT INTO songs (band, title) VALUES ('Smashing Pumpkins', 'Thru the eyes of a ruby')"
    con.exec "END"

    con.exec "BEGIN"
    con.exec "INSERT INTO songs (band, title) VALUES ('Talking Heads', 'Ruby dear')"
    con.exec "INSERT INTO songs (band, title) VALUES ('Kaiser Chiefs', 'Ruby')"
    con.exec "END"

    con.exec "BEGIN"
    con.exec "INSERT INTO songs (band, title) VALUES ('Ludov', 'Ruby')"
    con.exec "INSERT INTO songs (band, title) VALUES ('Crystal Castles', 'Magic Spells')"
    con.exec "END"
  
    con.exec "BEGIN"
    con.exec "INSERT INTO songs (band, title) VALUES ('Mastodon', 'Diamond in Witch House')"
    con.exec "INSERT INTO songs (band, title) VALUES ('King Diamond', 'The Candle')"
    con.exec "END"

rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end
