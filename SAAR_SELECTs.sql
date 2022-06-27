-- 1. Selecione o nome dos garçons que receberam gorjeta
select F.nome 
from Funcionario F, Funcion_garcom G
where F.id = G.id
and G.id in (
	select id_garcom
    from Garcom_atende_Mesa
    where gorjeta is not null
);

