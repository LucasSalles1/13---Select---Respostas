CREATE DATABASE IF NOT EXISTS Loja;
USE Loja;

-- 1. CRIAÇÃO DAS TABELAS
DROP TABLE IF EXISTS Estoque, Produto, Filial, Fornecedor;

CREATE TABLE Fornecedor (
    cnpj_fornecedor VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(150)
);

CREATE TABLE Filial (
    cnpj_filial VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100)
);

CREATE TABLE Produto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj_fornecedor VARCHAR(20)
);

CREATE TABLE Estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    cnpj_filial VARCHAR(20),
    id_produto INT,
    quantidade INT,
    preco DECIMAL(10,2),
    validade DATE,
    desconto DECIMAL(10,2) NULL
);


-- 2. INSERÇÃO DE DADOS DE TESTE
INSERT INTO Fornecedor VALUES
('11.111.111/0001-11', 'Distribuidora Silva Ltda.', 'Rua das Flores, 123 - São Paulo'),
('22.222.222/0001-22', 'Indústria Alfa', 'Rua Principal, 456 - Belo Horizonte'),
('33.333.333/0001-33', 'Bebidas Carioca Ltda.', 'Avenida Central, 789 - Rio de Janeiro'),
('44.444.444/0001-44', 'Sem Produto Ltda.', 'Rua dos Bobos, 0 - Curitiba');

INSERT INTO Filial VALUES
('99.111.111/0001-01', 'Filial Centro'),
('99.222.222/0001-02', 'Filial Zona Sul');

INSERT INTO Produto VALUES
(1, 'Suco de Laranja 100% 1L', '11.111.111/0001-11'),
(2, 'Biscoito carioca', '33.333.333/0001-33'),
(3, 'Refrigerante Cola 2L', '11.111.111/0001-11'),
(4, 'Chocolate Amargo', '22.222.222/0001-22');

INSERT INTO Estoque (
    cnpj_filial,
    id_produto,
    quantidade,
    preco,
    validade,
    desconto
) VALUES
('99.111.111/0001-01', 1, 15, 8.00, '2026-11-28', 1.00),
('99.111.111/0001-01', 2, 0, 15.00, '2027-01-15', NULL),
('99.222.222/0001-02', 3, 35, 11.50, '2026-10-15', NULL),
('99.222.222/0001-02', 4, 80, 50.00, '2027-05-20', 5.00);



-- 3. EXECUÇÃO DAS 20 CONSULTAS
-- Ex 1
SELECT
    id_estoque,
    (preco * quantidade) + 25.00 AS valor_com_embalagem
FROM Estoque;

-- Ex 2
SELECT
    preco,
    (preco * 0.15) AS imposto,
    (preco + (preco * 0.15)) AS preco_com_imposto
FROM Estoque;

-- Ex 3
SELECT
    CONCAT_WS(' // ', endereco, nome) AS endereco_e_nome
FROM Fornecedor;

-- Ex 4
SELECT *
FROM Estoque
WHERE validade = DATE_ADD('2026-10-29', INTERVAL 30 DAY);

-- Ex 5
SELECT *
FROM Fornecedor
WHERE nome LIKE '%Ltda.';

-- Ex 6
SELECT *
FROM Fornecedor
WHERE endereco LIKE 'Rua%'
  AND endereco NOT LIKE '%Belo Horizonte%';

-- Ex 7 (CORRIGIDO: usando ! para não confundir o leitor de código)
SELECT *
FROM Produto
WHERE nome LIKE '%!%%' ESCAPE '!';

-- Ex 8
SELECT *
FROM Fornecedor
WHERE cnpj_fornecedor NOT IN (
    SELECT cnpj_fornecedor
    FROM Produto
    WHERE cnpj_fornecedor IS NOT NULL
);

-- Ex 9
SELECT *
FROM Estoque
WHERE (preco <= 12.00 OR validade > '2026-12-31')
  AND quantidade <> 0;

-- Ex 10
SELECT
    p.nome AS produto,
    fi.cnpj_filial,
    fi.nome AS filial
FROM Estoque e
INNER JOIN Produto p ON e.id_produto = p.id
INNER JOIN Filial fi ON e.cnpj_filial = fi.cnpj_filial
ORDER BY fi.cnpj_filial ASC, p.nome ASC;

-- Ex 11
SELECT
    nome,
    UPPER(nome) AS nome_maiusculo,
    CHAR_LENGTH(UPPER(nome)) AS qtd_caracteres
FROM Produto;

-- Ex 12
SELECT
    nome,
    LOCATE('a', nome, 4) AS pos_letra_a
FROM Produto;

-- Ex 13
SELECT
    nome,
    REPLACE(nome, 'carioca', 'especial') AS nome_substituido,
    LEFT(REPLACE(nome, 'carioca', 'especial'), 5) AS cinco_primeiras
FROM Produto;

-- Ex 14
SELECT
    ' Produtos em promoção ' AS texto_original,
    TRIM(' Produtos em promoção ') AS texto_sem_espacos;

-- Ex 15
SELECT
    ROUND(1234.567, 2) AS duas_casas,
    ROUND(1234.567, 0) AS unidade,
    ROUND(1234.567, -2) AS centena;

-- Ex 16
SELECT
    CEIL(19.01) AS teto,
    FLOOR(19.01) AS piso,
    SIGN(-24) AS sinal_negativo,
    SIGN(0) AS sinal_zero,
    SIGN(150) AS sinal_positivo;

-- Ex 17
SELECT
    id_estoque,
    quantidade,
    CASE
        WHEN quantidade = 0 THEN 'Esgotado'
        WHEN quantidade <= 20 THEN 'Baixa'
        WHEN quantidade <= 50 THEN 'Normal'
        ELSE 'Alta'
    END AS classificacao
FROM Estoque;

-- Ex 18
SELECT
    id_estoque,
    validade,
    CASE
        WHEN validade < '2026-10-29' THEN 'Vencido'
        WHEN validade BETWEEN '2026-10-29'
             AND DATE_ADD('2026-10-29', INTERVAL 30 DAY)
            THEN 'Vence em breve'
        ELSE 'Prazo regular'
    END AS status_prazo
FROM Estoque;

-- Ex 19
SELECT
    id_estoque,
    preco,
    desconto,
    COALESCE(desconto, preco * 0.10) AS desconto_aplicado,
    preco - COALESCE(desconto, preco * 0.10) AS valor_liquido
FROM Estoque;

-- Ex 20
SELECT
    validade,
    DATE_FORMAT(validade, '%Y') AS ano,
    DATE_FORMAT(validade, '%m/%Y') AS mes_ano,
    DATE_FORMAT(validade, '%W') AS dia_semana
FROM Estoque;