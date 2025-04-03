CREATE DATABASE db_SistemaControleDopagem;

USE db_SistemaControleDopagem;

CREATE TABLE atleta (
    id_atleta INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    data_nascimento DATE NOT NULL, 
    nacionalidade VARCHAR(50) NOT NULL, 
    sexo ENUM('M', 'F', 'Outro') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE, 
    telefone VARCHAR(20) NOT NULL CHECK (telefone REGEXP '^[0-9+-]+$'),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE documento (
    id_doc INT PRIMARY KEY AUTO_INCREMENT, 
    numero VARCHAR(20) NOT NULL,
    tipo ENUM('RG', 'Passaporte', 'CNH', 'CPF', 'Registro Profissional', 'Título de Eleitor', 'Carteira de Trabalho', 'Certidão de Nascimento', 'Certidão de Casamento', 'Outro') NOT NULL,
    id_atleta_fk INT NOT NULL, 
    UNIQUE(numero, id_atleta_fk),
    FOREIGN KEY (id_atleta_fk) REFERENCES atleta(id_atleta) ON DELETE CASCADE
);

CREATE TABLE esporte (
    id_esporte INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(50) NOT NULL,
    disciplina VARCHAR(50) NOT NULL
);

CREATE TABLE atleta_esporte (
    id_atleta_fk INT,
    id_esporte_fk INT,
    PRIMARY KEY (id_atleta_fk, id_esporte_fk),
    FOREIGN KEY (id_atleta_fk) REFERENCES atleta(id_atleta) ON DELETE CASCADE,
    FOREIGN KEY (id_esporte_fk) REFERENCES esporte(id_esporte) ON DELETE CASCADE
);

CREATE TABLE endereco (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    cep VARCHAR(9) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    id_atleta_fk INT NOT NULL,
    FOREIGN KEY (id_atleta_fk) REFERENCES atleta(id_atleta) ON DELETE CASCADE
);

CREATE TABLE laboratorio (
    id_laboratorio INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(100) NOT NULL,
    contato VARCHAR(50) NOT NULL CHECK (contato REGEXP '^[0-9+-]+$')
);

CREATE TABLE teste (
    id_teste INT PRIMARY KEY AUTO_INCREMENT,
    status ENUM('Aprovado', 'Reprovado', 'Pendente') NOT NULL,
    CodOrdTeste VARCHAR(30) NOT NULL UNIQUE,
    data_teste TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_atleta_fk INT NOT NULL,
    id_esporte_fk INT NOT NULL,
    id_laboratorio_fk INT NOT NULL,
    FOREIGN KEY (id_atleta_fk) REFERENCES atleta(id_atleta) ON DELETE CASCADE,
    FOREIGN KEY (id_esporte_fk) REFERENCES esporte(id_esporte) ON DELETE CASCADE,
    FOREIGN KEY (id_laboratorio_fk) REFERENCES laboratorio(id_laboratorio) ON DELETE CASCADE
);

CREATE TABLE resultado_teste (
    id_resultado INT PRIMARY KEY AUTO_INCREMENT,
    resultado ENUM('Negativo', 'Positivo', 'Inconclusivo') NOT NULL,
    observacoes TEXT,
    data_resultado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_teste_fk INT NOT NULL,
    FOREIGN KEY (id_teste_fk) REFERENCES teste(id_teste) ON DELETE CASCADE
);

CREATE TABLE autoridade (
    id_autoridade INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('Autorizador de Teste', 'Coletor de Amostra', 'Gestor de Resultados', 'Coordenador de Dopagem') NOT NULL,
    nome VARCHAR(100) NOT NULL,
    id_teste_fk INT NOT NULL,
    FOREIGN KEY (id_teste_fk) REFERENCES teste(id_teste) ON DELETE CASCADE
);

CREATE TABLE equipamento (
    id_equipamento INT PRIMARY KEY AUTO_INCREMENT,
    fabricante VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL
);

CREATE TABLE amostra (
    id_amostra INT PRIMARY KEY AUTO_INCREMENT,
    num_amostra_parcial VARCHAR(30) NOT NULL,
    data_hora_selagem TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cod_amostra_parcial VARCHAR(30) NOT NULL,
    inicial_atleta VARCHAR(10) NOT NULL,
    id_atleta_fk INT NOT NULL,
    id_equipamento_fk INT NOT NULL,
    FOREIGN KEY (id_atleta_fk) REFERENCES atleta(id_atleta) ON DELETE CASCADE,
    FOREIGN KEY (id_equipamento_fk) REFERENCES equipamento(id_equipamento) ON DELETE CASCADE
);

CREATE TABLE tipo_amostra (
    id_tipo_amostra INT PRIMARY KEY AUTO_INCREMENT,
    nome ENUM('Urina', 'Sangue', 'Saliva', 'Cabelo', 'Suor', 'Lágrimas', 'Leite Materno', 'Plasma', 'Sêmen') NOT NULL,
    volume DECIMAL(10,2) NOT NULL,
    densidade DECIMAL(10,2) NOT NULL,
    id_amostra_fk INT NOT NULL,
    FOREIGN KEY (id_amostra_fk) REFERENCES amostra(id_amostra) ON DELETE CASCADE
);

CREATE TABLE oficial (
    id_controle INT PRIMARY KEY AUTO_INCREMENT,  
    nome VARCHAR(50) NOT NULL, 
    sobrenome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL CHECK (telefone REGEXP '^[0-9+-]+$')
);

CREATE INDEX idx_email_atleta ON atleta(email);
CREATE INDEX idx_CodOrdTeste ON teste(CodOrdTeste);
CREATE INDEX idx_id_atleta_fk ON atleta_esporte(id_atleta_fk);
CREATE INDEX idx_id_esporte_fk ON atleta_esporte(id_esporte_fk);