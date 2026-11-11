-- Criação do banco de dados (ideal para o contexto da ZaptUtil)
CREATE DATABASE IF NOT EXISTS ecommerce_zaptutil;
USE ecommerce_zaptutil;

-- 1. Tabela Genérica de Cliente
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    endereco_padrao VARCHAR(255) NOT NULL,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Cliente Pessoa Física (PF)
-- O id_cliente é PK e FK simultaneamente, garantindo a relação 1:1 com Cliente
CREATE TABLE Cliente_PF (
    id_cliente INT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    CONSTRAINT fk_cliente_pf FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

-- 3. Tabela de Cliente Pessoa Jurídica (PJ)
CREATE TABLE Cliente_PJ (
    id_cliente INT PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150),
    CONSTRAINT fk_cliente_pj FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

-- 4. Tabela de Formas de Pagamento (1:N com Cliente)
CREATE TABLE Forma_Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_pagamento ENUM('Cartao_Credito', 'Cartao_Debito', 'Pix', 'Boleto') NOT NULL,
    dados_pagamento VARCHAR(50), -- Ex: 'Final 4321' ou chave ofuscada
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

-- 5. Tabela de Produtos
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(150) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT DEFAULT 0
);

-- 6. Tabela de Pedidos
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status_pedido ENUM('Aguardando_Pagamento', 'Processando', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Aguardando_Pagamento',
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

-- 7. Tabela de Relacionamento (N:M) entre Pedido e Produto
CREATE TABLE Item_Pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE
);

-- 8. Tabela de Entrega (1:1 com Pedido)
-- A constraint UNIQUE no id_pedido garante que um pedido tenha no máximo uma entrega
CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL UNIQUE,
    status_entrega ENUM('Em_Processamento', 'Enviado', 'Em_Transito', 'Entregue') DEFAULT 'Em_Processamento',
    codigo_rastreio VARCHAR(50) UNIQUE,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE
);