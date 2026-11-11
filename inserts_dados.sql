USE ecommerce_zaptutil;

-- 1. Inserir Clientes Genéricos
INSERT INTO Cliente (email, endereco_padrao, tipo_cliente) VALUES
('joao.silva@email.com', 'Rua XV de Novembro, 100 - Blumenau, SC', 'PF'),
('maria.souza@email.com', 'Av. Brasil, 200 - Balneário Camboriú, SC', 'PF'),
('contato@techsolutions.com.br', 'Rua Sete de Setembro, 500 - Blumenau, SC', 'PJ'),
('compras@infotech.com.br', 'Av. Paulista, 1000 - São Paulo, SP', 'PJ');

-- 2. Inserir Clientes PF (IDs 1 e 2)
INSERT INTO Cliente_PF (id_cliente, cpf, nome_completo) VALUES
(1, '11122233344', 'João da Silva'),
(2, '55566677788', 'Maria de Souza');

-- 3. Inserir Clientes PJ (IDs 3 e 4)
INSERT INTO Cliente_PJ (id_cliente, cnpj, razao_social, nome_fantasia) VALUES
(3, '12345678000199', 'Tech Solutions Informática LTDA', 'Tech Solutions'),
(4, '98765432000188', 'InfoTech Comércio de Eletrônicos SA', 'InfoTech');

-- 4. Inserir Formas de Pagamento
INSERT INTO Forma_Pagamento (id_cliente, tipo_pagamento, dados_pagamento) VALUES
(1, 'Cartao_Credito', 'Final 4321'),
(1, 'Pix', 'Chave CPF'),
(2, 'Pix', 'Chave Email'),
(3, 'Boleto', NULL),
(4, 'Cartao_Credito', 'Final 9988');

-- 5. Inserir Produtos (Foco em Informática e Periféricos)
INSERT INTO Produto (nome_produto, descricao, preco, quantidade_estoque) VALUES
('Processador AMD Ryzen 7 5800X', 'Processador AM4, 8 Núcleos, 16 Threads', 1450.00, 15),
('Placa Mãe ASUS ROG Strix B550-F', 'Placa mãe gamer AM4 ATX', 1200.00, 10),
('Memória RAM Corsair Vengeance 16GB', 'DDR4 3200MHz', 250.00, 50),
('SSD Kingston NV2 1TB', 'NVMe M.2 2280', 380.00, 30),
('Monitor LG UltraGear 24', '144Hz IPS 1ms', 950.00, 20);

-- 6. Inserir Pedidos
INSERT INTO Pedido (id_cliente, valor_total, status_pedido) VALUES
(1, 1700.00, 'Entregue'),
(3, 4750.00, 'Enviado'),
(2, 380.00, 'Processando');

-- 7. Inserir Itens dos Pedidos
-- Pedido 1 (João - Comprou Processador + RAM) -> 1450 + 250 = 1700
INSERT INTO Item_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1450.00),
(1, 3, 1, 250.00);

-- Pedido 2 (Tech Solutions - Comprou 5 Monitores) -> 5 * 950 = 4750
INSERT INTO Item_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(2, 5, 5, 950.00);

-- Pedido 3 (Maria - Comprou 1 SSD) -> 1 * 380 = 380
INSERT INTO Item_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(3, 4, 1, 380.00);

-- 8. Inserir Entregas
INSERT INTO Entrega (id_pedido, status_entrega, codigo_rastreio) VALUES
(1, 'Entregue', 'BR123456789BR'),
(2, 'Em_Transito', 'BR987654321BR'),
(3, 'Em_Processamento', NULL);