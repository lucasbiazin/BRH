
                                            /*listar departamentoso*/

SELECT
    sigla,
    nome
FROM
    brh.departamento
ORDER BY
    nome;



                                                        /*Dependentes por colaborador */
SELECT
    col.nome            AS "Nome do colaborador",
    dep.nome            AS "Nome do dependente",
    dep.data_nascimento AS "Data de nasicmento",
    dep.parentesco      AS "Parentesco"
FROM
         brh.colaborador col
    INNER JOIN brh.dependente dep ON col.matricula = dep.colaborador;
    
    
    
    
                                        /*INSERT COLOBORADOR*/

INSERT INTO brh.endereco (
    cep,
    uf,
    cidade,
    bairro,
    logradouro
) VALUES (
    '87240000',
    'PR',
    'Terra Boa',
    'Residencial Tartarelli',
    'Rua Belunno'
);

INSERT INTO brh.colaborador (
    matricula,
    nome,
    cpf,
    email_pessoal,
    email_corporativo,
    salario,
    departamento,
    cep,
    complemento_endereco
) VALUES (
    'AB123',
    'FULANO DE TAL',
    '111.222.333-44',
    'FULANODETAL@email.com',
    'FULANODETAL@corp.com',
    '5000',
    'EN',
    '87240000',
    'Apartamento 33 ED-PORTO BELO'
);

INSERT INTO brh.papel ( nome ) VALUES ( 'Especialista de Negócios' );

INSERT INTO brh.atribuicao (
    colaborador,
    projeto,
    papel
) VALUES (
    'AB123',
    5,
    8
);


                                                            /*Insert projeto*/

INSERT INTO brh.prjeto (
    id,
    nome,
    responsavel,
    inicio,
    fim
) VALUES (
    9,
    'BI',
    'A123',
    '30/08/2021',
    '10/12/2022'
);


                                                        /*Dados Colaborador*/

SELECT
    col.matricula,
    col.nome,
    col.email_corporativo,
    tel.numero
FROM
         brh.colaborador col
    INNER JOIN brh.telefone_colaborador tel ON col.matricula = tel.colaborador;




    
    
    
    /*relatório analitico*/

SELECT
    dpto.nome  AS "Nome departamento",
    dpto.chefe AS "Chefe departamento",
    chefe.nome AS "Nome Colaborador",
    proj.nome  AS "Nome projeto",
    pap.nome   AS "Papel",
    tel.numero AS "Tel Colaborador",
    dp.nome    AS "Nome dependente"
FROM
         brh.departamento dpto
    INNER JOIN brh.colaborador          chefe ON dpto.chefe = chefe.matricula
    INNER JOIN brh.colaborador          aloc ON dpto.sigla = aloc.departamento
    LEFT JOIN brh.dependente           dp ON dp.colaborador = aloc.matricula
    LEFT JOIN brh.projeto              proj ON proj.responsavel = chefe.matricula
    INNER JOIN brh.papel                pap ON pap.id = proj.id
    INNER JOIN brh.telefone_colaborador tel ON tel.colaborador = chefe.matricula;