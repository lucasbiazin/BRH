create or replace NONEDITIONABLE PACKAGE     PKG_PROJETO AS 

PROCEDURE     insere_projeto
       (p_ID PROJETO.ID%type,
        p_NOME PROJETO.NOME%type,
        p_RESPONSAVEL PROJETO.RESPONSAVEL%type,
        p_INICIO PROJETO.INICIO%type,
        p_FIM PROJETO.FIM%type);


 PROCEDURE     define_atribuicao 
    (p_colaborador brh.colaborador.nome%type,
     p_projeto brh.projeto.nome%type,
     p_papel brh.papel.nome%type);



PROCEDURE     valida_projeto
       (p_ID PROJETO.ID%type,
        p_NOME PROJETO.NOME%type,
        p_RESPONSAVEL PROJETO.RESPONSAVEL%type,
        p_INICIO PROJETO.INICIO%type,
        p_FIM PROJETO.FIM%type);




FUNCTION     calcula_idade 

    (v_data_nascimento IN DATE)
     RETURN FLOAT;


FUNCTION     finaliza_projetos
  (p_ID in brh.PROJETO.ID%type)
  RETURN DATE;




END PKG_PROJETO;


















--------------------------------------------------------PACKAGE BODY------------------------------------------------------













create or replace NONEDITIONABLE PACKAGE BODY     PKG_PROJETO
    IS

 PROCEDURE     insere_projeto
       (p_ID PROJETO.ID%type,
        p_NOME PROJETO.NOME%type,
        p_RESPONSAVEL PROJETO.RESPONSAVEL%type,
        p_INICIO PROJETO.INICIO%type,
        p_FIM PROJETO.FIM%type)
IS



RAISER EXCEPTION;
PRAGMA EXCEPTION_INIT (RAISER, -20007);



BEGIN
    IF length(p_NOME) <= 2 THEN dbms_output.put_line ('O projeto deve ter dois ou mais caracteres.');
    RAISE RAISER;
    ELSE
    INSERT INTO brh.PROJETO (ID, NOME, RESPONSAVEL, INICIO, FIM) VALUES (p_ID, p_NOME,     p_RESPONSAVEL, p_INICIO, p_FIM);
    END IF;
END;



PROCEDURE     define_atribuicao 
(p_colaborador brh.colaborador.nome%type,
 p_projeto brh.projeto.nome%type,
 p_papel brh.papel.nome%type)
IS
v_colaborador brh.colaborador.matricula%type;
v_projeto brh.projeto.id%type;
v_papel brh.papel.id%type;
CURSOR cur_colab IS SELECT matricula INTO v_colaborador FROM brh.colaborador WHERE nome = p_colaborador;
CURSOR cur_projeto IS SELECT id INTO v_projeto FROM brh.projeto WHERE nome = p_projeto;
CURSOR cur_papel IS SELECT id INTO v_papel FROM brh.papel WHERE nome = p_papel;
BEGIN
OPEN cur_colab;
FETCH cur_colab INTO v_colaborador;
IF cur_colab%FOUND THEN 
    CLOSE cur_colab;
    OPEN cur_projeto;
    FETCH cur_projeto INTO v_projeto;
    IF cur_projeto%FOUND THEN
            CLOSE cur_projeto;
            OPEN cur_papel;
            FETCH cur_papel INTO v_papel;
            IF cur_papel%FOUND THEN
                CLOSE cur_papel;
                INSERT INTO brh.atribuicao(colaborador,projeto,papel)
                VALUES(v_colaborador,v_projeto,v_papel);
            ELSE
                INSERT INTO brh.papel(nome)
                VALUES(p_papel);
            END IF;
    ELSE
        dbms_output.put_line('Projeto não cadastrado ' ||p_projeto);
    END IF;
ELSE
    dbms_output.put_line('Colaborador não cadastrado.: ' ||p_colaborador);
END IF;
END;



PROCEDURE     valida_projeto
       (p_ID PROJETO.ID%type,
        p_NOME PROJETO.NOME%type,
        p_RESPONSAVEL PROJETO.RESPONSAVEL%type,
        p_INICIO PROJETO.INICIO%type,
        p_FIM PROJETO.FIM%type)
IS



RAISER EXCEPTION;
PRAGMA EXCEPTION_INIT (RAISER, -20004);



BEGIN
    IF length(p_NOME) <= 2 THEN dbms_output.put_line ('O projeto deve ter dois ou mais caracteres.');
    RAISE RAISER;
    ELSE
    INSERT INTO brh.PROJETO (ID, NOME, RESPONSAVEL, INICIO, FIM) VALUES (p_ID, p_NOME,     p_RESPONSAVEL, p_INICIO, p_FIM);
    END IF;
END;



FUNCTION     calcula_idade 

    (v_data_nascimento IN DATE)
        RETURN FLOAT

    IS 

    RAISER EXCEPTION;
PRAGMA EXCEPTION_INIT (RAISER, -20005);

    BEGIN

    IF v_data_nascimento > sysdate THEN dbms_output.put_line ('Data inválida');
     RAISE RAISER;
    ELSIF v_data_nascimento is null THEN dbms_output.put_line ('Impossível calcular data nula'); 
   ELSE 
    RETURN  FLOOR(MONTHS_BETWEEN(sysdate, v_data_nascimento)/12); 
    END IF;
    END;



 FUNCTION     finaliza_projetos
          (p_ID in brh.PROJETO.ID%type)
          RETURN DATE
        IS
          v_data_termino DATE; 
        BEGIN
          v_data_termino := sysdate; 

          UPDATE brh.PROJETO 
             SET FIM = v_data_termino 
           WHERE ID = p_ID; 

          RETURN v_data_termino; 
        END;



END PKG_PROJETO;











