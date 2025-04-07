import mysql.connector as conn

conexao = conn.connect(
    host = "localhost",
    user = "root",
    password = "1406",
    database = "db_sistemacontroledopagem"
)

cursor = conexao.cursor()

print("Comando executado!")
