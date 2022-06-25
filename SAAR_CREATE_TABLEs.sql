DROP TABLE IF EXISTS Garcom_atende_Mesa;
DROP TABLE IF EXISTS Pedido_tem_Item_com_Tamanho;
DROP TABLE IF EXISTS Item_com_Tamanho;
DROP TABLE IF EXISTS Item_Adicional;
DROP TABLE IF EXISTS Ingrediente;
DROP TABLE IF EXISTS Tamanho;
DROP TABLE IF EXISTS Item_do_menu;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Comanda;
DROP TABLE IF EXISTS Atendimento;
DROP TABLE IF EXISTS Mesa;
DROP TABLE IF EXISTS Impressora;
DROP TABLE IF EXISTS Departamento;
DROP TABLE IF EXISTS Categoria;
DROP TABLE IF EXISTS Credencial;
DROP TABLE IF EXISTS Funcion_garcom;
DROP TABLE IF EXISTS Funcion_gerente;
DROP TABLE IF EXISTS Funcionario;

CREATE TABLE Funcionario (
    id INTEGER,
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    telefone CHAR(11),
    PRIMARY KEY (id)
);

CREATE TABLE Funcion_gerente (
    id INTEGER,
    salario DECIMAL(15 , 2 ),
    PRIMARY KEY (id),
    FOREIGN KEY (id)
        REFERENCES Funcionario (id)
);

CREATE TABLE Funcion_garcom (
    id INTEGER,
    horas_trab INTEGER,
    salario_hora DECIMAL(15 , 2 ),
    comissao_atend DECIMAL(15 , 2 ),
    PRIMARY KEY (id),
    FOREIGN KEY (id)
        REFERENCES Funcionario (id)
);

CREATE TABLE Credencial (
    login VARCHAR(20),
    senha VARCHAR(30) NOT NULL,
    status_acesso BOOLEAN NOT NULL,
    id INTEGER UNIQUE NOT NULL,
    PRIMARY KEY (login),
    FOREIGN KEY (id)
        REFERENCES Funcionario (id)
);

CREATE TABLE Categoria (
    nome VARCHAR(60),
    PRIMARY KEY (nome)
);

CREATE TABLE Departamento (
    nome VARCHAR(60),
    responsavel_por VARCHAR(60),
    PRIMARY KEY (nome),
    FOREIGN KEY (responsavel_por)
        REFERENCES Categoria (nome)
);

CREATE TABLE Impressora (
    nome_depto VARCHAR(60),
    id INTEGER,
    endereco_ip INT(4) UNSIGNED NOT NULL,
    FOREIGN KEY (nome_depto)
        REFERENCES Departamento (nome)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (nome_depto , id)
);

CREATE TABLE Mesa (
    numero INTEGER AUTO_INCREMENT,
    PRIMARY KEY (numero)
);

CREATE TABLE Atendimento (
    numero INTEGER AUTO_INCREMENT,
    num_mesa INTEGER,
    num_clientes INTEGER,
    inicio_atend DATETIME,
    fim_atend DATETIME,
    PRIMARY KEY (numero),
    FOREIGN KEY (num_mesa)
        REFERENCES Mesa (numero)
);

CREATE TABLE Comanda (
    numero INTEGER AUTO_INCREMENT,
    tipo_pagmnt ENUM(
		'Dinheiro', 
        'Cartão de débito', 
        'Cartão de crédito', 
        'PIX', 
        'Transferência'
	),
    hora_pagmnt DATETIME,
    PRIMARY KEY (numero)
);

CREATE TABLE Pedido (
    numero INTEGER AUTO_INCREMENT,
    emissao DATETIME,
    observacoes VARCHAR(300),
    num_comanda INTEGER,
    PRIMARY KEY (numero),
    FOREIGN KEY (num_comanda)
        REFERENCES Comanda (numero)
);

CREATE TABLE Item_do_menu (
    id INTEGER AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(300),
    foto VARCHAR(300),
    video VARCHAR(300),
    categoria VARCHAR(60),
    PRIMARY KEY (id),
    FOREIGN KEY (categoria)
        REFERENCES Categoria (nome)
);

CREATE TABLE Tamanho (
    qtde VARCHAR(15),
    sigla ENUM('U', 'P', 'M', 'G'),
    num_porcoes INTEGER,
    PRIMARY KEY (qtde)
);

CREATE TABLE Ingrediente (
    id_item INTEGER,
    nome VARCHAR(100),
    descricao VARCHAR(300),
    procedencia VARCHAR(300),
    FOREIGN KEY (id_item)
        REFERENCES Item_do_menu (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_item , nome)
);

CREATE TABLE Item_Adicional (
    id_item INTEGER,
    id_adicional INTEGER,
    PRIMARY KEY (id_item , id_adicional),
    FOREIGN KEY (id_item)
        REFERENCES Item_do_menu (id),
    FOREIGN KEY (id_adicional)
        REFERENCES Item_do_menu (id)
);

CREATE TABLE Item_com_Tamanho (
    preco DECIMAL(15 , 2 ),
    id_item INTEGER,
    qtde_tam VARCHAR(15),
    PRIMARY KEY (id_item , sigla_tam),
    FOREIGN KEY (id_item)
        REFERENCES Item_do_menu (id),
    FOREIGN KEY (sigla_tam)
        REFERENCES Tamanho (sigla)
);

CREATE TABLE Pedido_tem_Item_com_Tamanho (
    num_pedido INTEGER,
    id_item INTEGER,
    sigla_tam ENUM('U', 'P', 'M', 'G'),
    PRIMARY KEY (num_pedido , id_item , sigla_tam),
    FOREIGN KEY (num_pedido)
        REFERENCES Pedido (numero),
    FOREIGN KEY (id_item , sigla_tam)
        REFERENCES Item_com_Tamanho (id_item , sigla_tam)
);

CREATE TABLE Garcom_atende_Mesa (
    gorjeta DECIMAL(15 , 2 ),
    hora_atend DATETIME,
    id_garcom INTEGER,
    num_mesa INTEGER,
    PRIMARY KEY (id_garcom , num_mesa),
    FOREIGN KEY (id_garcom)
        REFERENCES Funcion_garcom (id),
    FOREIGN KEY (num_mesa)
        REFERENCES Mesa (numero)
);