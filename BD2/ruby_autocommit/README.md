Esse trabalho mosta exemplo de transações (commit e rollback) feitas a partir de um programa escrito em rubby.
*a linguagem selecionada para implementação (ruby) foi sorteada pelo professor*
__________________________________
[1. Setup do postgres, ruby e bibliotecas](#1-setup-do-postgres-ruby-e-bibliotecas-para-compilar)<br />
[2. Compilando e rodando o código](#2-compilando-e-rodando-o-c%C3%B3digo)<br />
[3. Problemas encontrados](#3-problemas-encontrados)<br />
[4. Referências](#4-referencias)<br />
[5. Futuras implementações](#5-futuras-implementações)
__________________________________
#### 1. Setup do postgres, ruby e bibliotecas para compilar:
##### instalação do postgre: 
``` sudo apt-get install postgresql ```
##### atualizando senha do postgres:
```
sudo -u postgres psql postgres
postgres=# \password postgres 
```

##### instalação do lib-pq: 
```sudo apt-get install libpq-dev ```

##### instalação do ruby dev: 
``` sudo apt-get install ruby-dev ```
##### instalação das bibliotecas pra comunicação com o postgres: 
``` sudo gem install pg ```
##### comandos para servidor do postgres:
```
sudo service postgresql start
sudo service postgresql stop
sudo service postgresql status
```

##### criando um novo usuário para autenticação via política trust
```
sudo -u postgres createuser ruby
sudo -u postgres psql postgres
postgres=# ALTER USER ruby WITH password 'saphire';
```

##### criando um banco de dados para o teste
```
sudo -u postgres cristal-gem testdb --owner ruby
```
___________________
#### 2. Compilando e rodando o código
Para compilar os arquivos em ruby, acessar o terminal e digitar
```
ruby <arquivo>.rb
```
A ordem _necessária_ para esse trabalho é a seguinte:
```
ruby create.rb
ruby insert.rb
```
O arquivo _create.rb_ cria a tabela e o trigger que filtra as inserções<br />
O arquivo _insert.rb_ serve pra inserir novas tuplas de modo consecutivo à tabela
___________________
#### 3. Problemas encontrados:

##### Instalação do lib-pq:
durante a instalação ocorreu um erro especificado em ```/var/lib/gems/2.5.0/extensions/x86_64-linux/2.5.0/pg-1.1.4/mkmf.log```
envolvendo stdio.h e foi resolvido [assim](http://www.ubuntubuzz.com/2017/01/fix-missing-stdioh-in-linux-mint.html)

##### Problema com autenticação ao conectar no banco de dados via ruby:
Se ao rodar o arquivo _conection.rb_ retornar:
> "FATAL:  Peer authentication failed for user"

para corrigir, basta acessar ```/etc/postgresql/<versão>/main/pg_hba.confv``` e mudar de ***peer*** para _trust_ ou _md5_:
```
\# "local" is for Unix domain socket connections only
local    all             all                        peer
```
____________________
#### 4. Referencias:
[Setup do postgres, ruby e lib-pg](http://zetcode.com/db/postgresqlruby)<br />
[I/O em ruby](http://zetcode.com/lang/rubytutorial/io)<br />
[Peer autentication](https://stackoverflow.com/questions/33951528/fatal-peer-authentication-failed-for-user-rails)
____________________
### 5. Futuras implementações: 
[Importar a duração das músicas do spotify](https://developer.spotify.com/documentation/web-api/reference/tracks/get-track)
