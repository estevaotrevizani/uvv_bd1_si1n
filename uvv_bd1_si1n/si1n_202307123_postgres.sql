--Apagando o bando de dados, se ele existir
DROP DATABASE IF EXISTS uvv;

--Apagando o usuario estevao, se existir
DROP USER IF EXISTS estevao;

--Criando usuario e senha
CREATE USER estevao WITH PASSWORD '12345';

--Criando banco de dados uvv
CREATE DATABASE uvv 
WITH OWNER = estevao 
TEMPLATE = template0 
ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' 
LC_CTYPE = 'pt_BR.UTF-8' 
ALLOW_CONNECTIONS = true;

--Fazendo conexao do bd com meu usario
\c uvv estevao;

--Criando o schema lojas
CREATE SCHEMA lojas AUTHORIZATION estevao;

--Fazendo a mudanca permanente no search_path
ALTER USER estevao
SET search_path TO lojas, "$user", public;

--Criacao de tabelas
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);


COMMENT ON TABLE lojas.produtos IS 'Tabela produtos';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'Id do produto, chave primária';
COMMENT ON COLUMN lojas.produtos.nome IS 'Nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Preco unitario do produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Detalhes do produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Partes non-ASCII da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Arquivo da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Última atualizacao da imagem do p
roduto';


CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);


COMMENT ON TABLE lojas.lojas IS 'Tabela lojas';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'Id da loja, chave primária';
COMMENT ON COLUMN lojas.lojas.nome IS 'Coluna nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Endereco web da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Endereco fisico da loja';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Latitude da loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Longitude da loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'Logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Partes non-ASCII da logo';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Charset da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Última atualizacao da logo';
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);


COMMENT ON TABLE lojas.estoques IS 'Tabela de estoques';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Id do estoque';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'Id da loja, chave secundária';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Id do produto, chave secundária';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade do estoque';
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);


COMMENT ON TABLE lojas.clientes IS 'Tabela clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Id do ciente';
COMMENT ON COLUMN lojas.clientes.email IS 'Email do cliente';
COMMENT ON COLUMN lojas.clientes.nome IS 'Nome do cliente';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Telefone 1 do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Telefone 2 do cliente';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Telefone 3 do cliente';
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);


COMMENT ON TABLE lojas.envios IS 'Tabela de envios';
COMMENT ON COLUMN lojas.envios.envio_id IS 'Id do envio, chave primária';
COMMENT ON COLUMN lojas.envios.loja_id IS 'Id da loja, chave secundária';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'Id do cliente, chave secundária';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereco de entrega dos envios';
COMMENT ON COLUMN lojas.envios.status IS 'Status do envio';
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);


COMMENT ON TABLE lojas.pedidos IS 'Tabela pedidos';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'Id do pedido, chave primária';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Data e hora do pedido';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Id do cliente, chave secundária';
COMMENT ON COLUMN lojas.pedidos.status IS 'Status do pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'Id da loja, chave secundária';
CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id_ PRIMARY KEY (pedido_id, produto_id)
);


COMMENT ON TABLE lojas.pedidos_itens IS 'Tabela de pedidos_itens';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'Id do pedido, chave primária e secundária';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'Id do produto, chave primária e secundária';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Numero da linha dos itens pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Preco unitario dos itens pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Quantidade de itens pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'Id do envio de itens pedidos';

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criacao das restricoes conforme foi orientado 
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT preco_unitario_positivo CHECK (preco_unitario > 0);
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT quantidade_positiva CHECK (quantidade >= 0);
ALTER TABLE lojas.produtos
ADD CONSTRAINT preco_unitario_positivo CHECK (preco_unitario > 0);
ALTER TABLE lojas.estoques
ADD CONSTRAINT quantidade_positiva CHECK (quantidade >= 0);
