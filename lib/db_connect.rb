require 'pg'

DATABASE = PG.connect(dbname: 'postgres', host: '127.0.0.1', port: 5432,  user: 'postgres', password: 'pass')