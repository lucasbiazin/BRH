SELECT SIGLA,NOME FROM DEPARTAMENTO ORDER BY NOME;

SELECT col.nome AS "Nome do colaborador",
	   dep.nome AS "Nome do dependente",
       dep.data_nascimento AS "Data de nasicmento", 
       dep.parentesco AS "Parentesco"
       FROM colaborador col
       INNER JOIN dependente dep
       ON col.matricula = dep.colaborador;
       

   use brh;

INSERT INTO COLABORADOR 
	(
    MATRICULA_COLABORADOR,
    departamento, 
    cpf, 
    nome,
    salario
    
    )
VALUES
	(
    '123', 
    'EN',
	'111.222.333-44', 
    'FULANO DE TAL', 
     '5000'
     );
    
    INSERT INTO PAPEL
    (ID_PAPEL, nome)
	
VALUES ('8',
	'Especialista de Negócios');
    
   INSERT INTO CONTATO
	(colaborador, telefone_1, telefone_2, email_pessoal, email_corporativo)
VALUES
	('123', '(61) 9 9999-9999', '(61) 9 8888-7777', 'fulanodetal@gmail.com', 'fulano@corp.com');
	
	INSERT INTO ATRIBUICAO
VALUES ("AB123", 6, 8);
    
   
  INSERT INTO PROJETO
	(id_projeto, nome, responsavel, data_inicio, data_final)
VALUES 
('5', 'BI', '123', '05/02/2022', '10/12/2022');
    
    INSERT INTO ENDERECO
	(cep, uf, cidade, bairro, logradouro, complemento)
VALUES
	('87240000', 'PR', 'Terra Boa', 'Residencial Tartarelli', 'Rua Belunno', 'Ed tres rios ap 35');
       
       
       
delete from atribuicao where colaborador in (select matricula from colaborador where departamento = 'SECAP');
delete from telefone_colaborador where colaborador in (select matricula from colaborador where departamento = 'SECAP');
delete from projeto where responsavel in (select matricula from colaborador where departamento = 'SECAP');
delete from dependente where colaborador in (select matricula from colaborador where departamento = 'SECAP');
SET SQL_SAFE_UPDATES=0;
update  departamento set chefe = 'AB123' where chefe in (select matricula from colaborador where departamento = 'SECAP');
SET SQL_SAFE_UPDATES=1;
delete from colaborador where departamento = 'SECAP';
delete from departamento where sigla = 'SECAP';