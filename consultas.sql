-- filtro dependentes

SELECT
    dep.nome            AS "Nome do dependente",
    dep.data_nascimento AS "Data de nascimento",
    col.nome     AS "Colaborador responsável"
FROM
         brh.dependente dep
    INNER JOIN brh.colaborador col
    ON dep.colaborador = col.matricula
WHERE
    upper(dep.nome) LIKE '%H%'
    or  to_char(dep.data_nascimento , 'MM') IN ( '04', '05', '06' )
    ORDER BY col.nome, dep.nome;
    
    
    
    
    
    --Colaborador com maior salário
    
 SELECT
    nome,
    salario
FROM
    brh.colaborador
WHERE
    salario = (
        SELECT
            MAX(salario)
        FROM
            brh.colaborador
    );
    
    

    
    --Relatorio de senioridade
    
SELECT
    matricula,
    nome,
    salario,
    (
        CASE
            WHEN salario <= 3000 THEN
                'Júnior'
            WHEN salario > 3000
                 AND salario < 6000 THEN
                'Pleno'
            WHEN salario > 6000
                 AND salario <= 20000 THEN
                'Sênior'
            ELSE
                'Corpo diretor'
        END
    )Senioridade
FROM
    brh.colaborador
ORDER BY
    salario desc, Senioridade;
    
    

    --Colaborador por projeto
    
    
SELECT 
    dep.nome   AS "Nome departamento",
    proj.nome  AS "Nome do projeto",
    COUNT(*) AS "Colaboradores"
FROM
    brh.atribuicao   atrib
    INNER JOIN brh.projeto      proj 
    ON atrib.projeto = proj.id
    INNER JOIN brh.colaborador  col
    ON col.matricula = atrib.colaborador
    INNER JOIN brh.departamento dep 
    ON dep.sigla = col.departamento 

GROUP BY
    dep.nome,
    proj.nome
    ORDER BY
    dep.nome,
    proj.nome;
    
    
    --Colaborador com mais dependentes
    
 SELECT 
    col.nome colaborador,
    count(*) quantidade_dependentes
           
    FROM BRH.COLABORADOR col
    INNER JOIN BRH.DEPENDENTE dep
    ON  col.matricula = dep.colaborador
    GROUP BY col.nome
    HAVING count(*) >=2
    ORDER BY quantidade_dependentes DESC, col.nome;
    

        --Listar faixa etária dos dependentes   
           
    SELECT 
    col.matricula AS "Matricula do colaborador",
    dep.cpf AS "CPF do dependente",
    dep.nome AS "Nome do Dependente",
    dep.data_nascimento AS "Data de nascimento", 
    dep.parentesco AS "Parentesco",
  
    trunc (MONTHS_BETWEEN (SYSDATE, DATA_NASCIMENTO)/12) AS idade,
      
     	
    CASE 
        WHEN trunc (MONTHS_BETWEEN (SYSDATE, DATA_NASCIMENTO)/12) < 18 THEN 'Menor de Idade'
      	ELSE 'Maior de idade'
     	END AS "CLASSIFICAÇÃO ETÁRIA"
        
        FROM
        BRH.DEPENDENTE dep
        
        INNER JOIN BRH.COLABORADOR col
        ON dep.colaborador = col.matricula
        
        order by col.matricula, dep.nome;
        
        
        
        
    --- VIEW TAXA_DEPENDENTE
   CREATE VIEW VW_TAXA_DEPENDENTE as
    SELECT co.nome       AS nome_colaborador,
       co.salario    AS salario_colaborador,
       ( CASE
           WHEN co.salario <= 3000 THEN 'Júnior'
           WHEN co.salario > 3000
                AND co.salario <= 6000 THEN 'Pleno'
           WHEN co.salario > 6000
                AND co.salario <= 20000 THEN 'Sênior'
           ELSE 'Corpo diretor'
         END )       AS senioridade,
       dp.nome       AS nome_dependente,
       ( CASE
           WHEN Trunc(( sysdate - dp.data_nascimento ) / 365) < 18 THEN
           'Menor de idade'
           ELSE 'Maior de idade'
         END )       AS faixa_etaria_dependete,
       dp.parentesco AS parentesco,
       ( CASE
           WHEN dp.parentesco = 'Cônjuge' THEN 100
           ELSE ( CASE            WHEN Trunc(( sysdate - dp.data_nascimento ) / 365) < 18 THEN
                    ( 25 )
                    ELSE ( 50 )
                  END )
         END )       AS taxa_dependente
FROM   brh.colaborador co
       LEFT JOIN brh.dependente dp
              ON co.matricula = dp.colaborador ;
        
        
        
        
        
    


--Relatorio plano de saúde

SELECT
    nome_colaborador,
    senioridade,
    salario_colaborador,
    (
        CASE
            WHEN senioridade = 'Júnior' THEN
                ( salario_colaborador * 0.01 )
            WHEN senioridade = 'Pleno'  THEN
                ( salario_colaborador * 0.02 )
            WHEN senioridade = 'Sênior' THEN
                ( salario_colaborador * 0.03 )
          else (salario_colaborador*0.05)
        END
    ) + SUM(taxa_dependente) AS taxa_plano_saude
FROM
    brh.vw_taxa_dependente
GROUP BY (
    nome_colaborador,
    salario_colaborador,
    senioridade
)
ORDER BY
    nome_colaborador asc;
    
    
    
    --Paginar colaboradores

SELECT 
* FROM (
    SELECT rownum as linha, t.*
      FROM  brh.colaborador t
      order by nome 
) consulta_paginada
WHERE linha >= 1 AND linha <= 10 ;




-- SELECIONAR COLABORADORES EM TODOS OS PROJETOS



SELECT 
col.nome  as "Nome do colaborador" ,
atrib.colaborador AS "Matricula colaborador", 
COUNT(atrib.projeto) AS quantidade_projetos 
FROM brh.atribuicao atrib
INNER JOIN brh.colaborador col
ON atrib.colaborador = col.matricula
GROUP BY atrib.colaborador,
         col.nome
HAVING COUNT(atrib.projeto) = (SELECT COUNT(*) FROM brh.projeto pj);









