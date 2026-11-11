--1. Faturamento e Ticket Médio por Tipo de Cliente (PF vs PJ) Esta query avalia se o maior volume financeiro vem de compras 
--corporativas ou de consumidores finais, 
--considerando apenas pedidos que já avançaram no funil de vendas.

SELECT 
    c.tipo_cliente,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    SUM(p.valor_total) AS faturamento_total,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
WHERE p.status_pedido IN ('Enviado', 'Entregue')
GROUP BY c.tipo_cliente
ORDER BY faturamento_total DESC;

--2. Curva ABC: Top Produtos que Mais Geram Receita
--Cruza os itens do pedido com o catálogo de produtos para 
--listar os itens essenciais da loja, calculando a receita real gerada por cada um (excluindo pedidos cancelados).

SELECT 
    pr.nome_produto,
    SUM(ip.quantidade) AS unidades_vendidas,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_gerada
FROM Produto pr
JOIN Item_Pedido ip ON pr.id_produto = ip.id_produto
JOIN Pedido p ON ip.id_pedido = p.id_pedido
WHERE p.status_pedido != 'Cancelado'
GROUP BY pr.id_produto, pr.nome_produto
ORDER BY receita_gerada DESC
LIMIT 5;

--3. Relatório de Logística e Identificação de Cliente (Tratando a Herança)
--Esta é uma query estrutural importante. 
--Como o nome do cliente está separado em Cliente_PF ou Cliente_PJ, 
--usamos LEFT JOIN e a função COALESCE para retornar o 
--nome correto independentemente do tipo de conta, 
--cruzando com os dados de rastreio.

SELECT 
    p.id_pedido,
    e.codigo_rastreio,
    e.status_entrega,
    COALESCE(cpf.nome_completo, cpj.razao_social) AS nome_cliente,
    c.email,
    p.data_pedido
FROM Pedido p
JOIN Entrega e ON p.id_pedido = e.id_pedido
JOIN Cliente c ON p.id_cliente = c.id_cliente
LEFT JOIN Cliente_PF cpf ON c.id_cliente = cpf.id_cliente
LEFT JOIN Cliente_PJ cpj ON c.id_cliente = cpj.id_cliente
WHERE e.status_entrega IN ('Em_Processamento', 'Em_Transito')
ORDER BY p.data_pedido ASC;

--4. Retenção de Clientes por Método de Pagamento Específico
--Filtra clientes que realizaram compras recorrentes (mais de um pedido) 
--e que possuem um método de pagamento específico cadastrado (ex: Pix), 
--utilizando HAVING para a filtragem pós-agregação.

SELECT 
    c.id_cliente,
    c.email,
    c.tipo_cliente,
    COUNT(DISTINCT p.id_pedido) AS volume_compras
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
JOIN Forma_Pagamento fp ON c.id_cliente = fp.id_cliente
WHERE fp.tipo_pagamento = 'Pix'
GROUP BY c.id_cliente, c.email, c.tipo_cliente
HAVING COUNT(DISTINCT p.id_pedido) >= 1
ORDER BY volume_compras DESC;

