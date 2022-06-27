-- 1. Selecione o nome dos garçons que receberam gorjeta
select F.nome 
from Funcionario F, Funcion_garcom G
where F.id = G.id
and exists (
	select id_garcom
    from Garcom_atende_Mesa A
    where A.gorjeta is not null
    and A.id_garcom = F.id
);

-- 2. Selecione as comandas que pediram apenas porções
select C.numero
from Comanda C
where C.numero not in (
	select P.num_comanda
    from Pedido P, Pedido_tem_Item_com_Tamanho PIT, Item_do_menu I, Categoria C 
    where P.numero = PIT.num_pedido
    and PIT.id_item = I.id
    and I.categoria = C.nome
    and C.nome != 'Porções'
);

-- 3. Selecione as comandas que pediram apenas porções e as que pediram apenas cervejas artesanais
select C.numero
from Comanda C
where C.numero not in (
	select P.num_comanda
    from Pedido P, Pedido_tem_Item_com_Tamanho PIT, Item_do_menu I, Categoria C 
    where P.numero = PIT.num_pedido
    and PIT.id_item = I.id
	and I.categoria = C.nome
    and C.nome != 'Porções'
)
union
select C.numero
from Comanda C
where C.numero not in (
	select P.num_comanda
    from Pedido P, Pedido_tem_Item_com_Tamanho PIT, Item_do_menu I, Categoria C 
    where P.numero = PIT.num_pedido
    and PIT.id_item = I.id
    and I.categoria = C.nome
    and C.nome != 'Cervejas Artesanais'
);

-- 4. Selecione as comandas que pediram porções mas não pediram adicionais
select C.numero
from Comanda C
where C.numero in (
	select P.num_comanda
    from Pedido P, Pedido_tem_Item_com_Tamanho PIT, Item_do_menu I, Categoria C 
    where P.numero = PIT.num_pedido
    and PIT.id_item = I.id
    and I.categoria = C.nome
    and C.nome = 'Porções'
    and P.num_comanda not in (
		select P2.num_comanda
		from Pedido P2, Pedido_tem_Item_com_Tamanho PIT2, Item_do_menu I2, Categoria C2
		where P2.numero = PIT2.num_pedido
		and PIT2.id_item = I2.id
		and I2.categoria = C2.nome
		and C2.nome = 'Adicionais'
	)
);

-- 5. Selecione as comandas que pediram porções e pediram adicionais
select C.numero
from Comanda C
where C.numero in (
	select P.num_comanda
    from Pedido P, Pedido_tem_Item_com_Tamanho PIT, Item_do_menu I, Categoria C 
    where P.numero = PIT.num_pedido
    and PIT.id_item = I.id
    and I.categoria = C.nome
    and C.nome = 'Porções'
    and P.num_comanda in (
		select P2.num_comanda
		from Pedido P2, Pedido_tem_Item_com_Tamanho PIT2, Item_do_menu I2, Categoria C2
		where P2.numero = PIT2.num_pedido
		and PIT2.id_item = I2.id
		and I2.categoria = C2.nome
		and C2.nome = 'Adicionais'
	)
);

-- 6. Selecione o IP das impressoras que imprimiram mais de 1 item
select inet_ntoa(I.endereco_ip)
from Impressora I, Departamento D, Categoria C
where I.nome_depto = D.nome
and D.responsavel_por = C.nome
and C.nome in (
	select C2.nome
    from Categoria C2, Item_do_menu I, Item_com_Tamanho IT, Pedido_tem_Item_com_Tamanho PIT
    where C2.nome = I.categoria
    and IT.id_item = I.id
    and PIT.id_item = IT.id_item
    group by C2.nome
    having count(*) > 1
);

-- 7. Selecione o nome dos gerentes que tem credenciais ativas e dos garçons com credenciais inativas
select F.nome
from Funcionario F, Funcion_gerente GR, Credencial C
where F.id = GR.id 
and C.id = F.id
and C.status_acesso is true
union
select F.nome
from Funcionario F, Funcion_garcom GC, Credencial C
where F.id = GC.id 
and C.id = F.id
and C.status_acesso is false;

-- 8. Selecione o nome e o salário dos gerentes que recebem mais que a média de salários de gerente
select F.nome, G.salario
from Funcionario F, Funcion_gerente G
where F.id = G.id
and G.salario > (
	select avg(FG.salario)
    from Funcion_gerente FG
);

-- 9. Selecione o nome e o número de atendimentos do garcom que mais realizou atendimentos
-- *Esse select foi feito de maneira muito questionável, queria saber como fazer de um jeito melhor
select F.nome, N.num_atendimentos
from Funcionario F, (
	select GAM.id_garcom as id, count(*) as num_atendimentos
    from Garcom_atende_Mesa GAM
    group by GAM.id_garcom
) as N
where N.id = F.id
and N.num_atendimentos = (
	select max(NN.Num_atendimentos) from (
		select GAM.id_garcom as id, count(*) as num_atendimentos
		from Garcom_atende_Mesa GAM, Funcion_garcom G
        where G.id = GAM.id_garcom
		group by GAM.id_garcom
	) as NN
);

-- 10. Selecione o nome e quanto os garçons que realizaram algum atendimento ganharam por comissão
select F.nome, N.num_atendimentos*G.comissao_atend as total_comissao
from Funcionario F, (
	select GAM.id_garcom as id, count(*) as num_atendimentos
    from Garcom_atende_Mesa GAM
    group by GAM.id_garcom
) as N, Funcion_garcom G
where N.id = F.id
and F.id = G.id;
