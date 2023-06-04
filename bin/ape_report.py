#! /home/alexvanaxe/.pyenv/versions/ape_report/bin/python3 
import locale
import os
import sqlite3
from decimal import Decimal
from tabulate import tabulate

locale.setlocale(locale.LC_ALL, 'pt_BR.UTF-8')
# con = sqlite3.connect('/home/alexvanaxe/Documents/appape/db/ape.db')
ambiente = os.environ['NODE_ENV']

bd = ""
if ambiente == "production":
    bd = '/home/alexvanaxe/Documents/appape/db/ape.db'
else:
    bd = '/home/alexvanaxe/Documents/development/projects/appape/api/appape/db/ape.db'

con = sqlite3.connect(bd)
cur = con.cursor()

class opcoes():
    url = False

def show_news(opcoes):
    if opcoes.url:
        rows = cur.execute("SELECT ape_indexer.apelido, ape_dados.valor, anunciante, url ,novo  FROM (select max(pk) as max_pk, ape_pk, ape_indexer_pk, valor, anunciante, novo from ape_dados group by anunciante) as ape_dados join ape on ape.pk = ape_pk left join ape_indexer on ape_indexer.pk = ape_dados.ape_indexer_pk order by novo desc;")
        print(tabulate(rows, headers=["Apelido", "Valor", "Anunciante", "Url",
                                      "Novo"], disable_numparse=True,
                       maxcolwidths=[None, 130, None, None, None] ))
    else:
        rows = cur.execute("SELECT apelido, group_concat(ape_dados.valor, ' -> '), anunciante, sum(novo) FROM ape_dados left join ape_indexer on ape_indexer_pk = ape_indexer.pk group by ape_indexer.pk order by novo desc")
        print(tabulate(rows, headers=["Apelido", "Valor", "Anunciante",
                                      "Novidade"], disable_numparse=True,
                       maxcolwidths=[None, 130, None, None] ))

def mark_view():
    rows = cur.execute('update ape_dados set novo = 0')
    rows = cur.execute('update ape_grupo set novidade = 0')
    rows = cur.execute('update ape_grupo_dados set novidade = 0')
    con.commit()

def add(param):
    rows = cur.execute('insert into ape_indexer(apelido, engine, grupo, paginas, url) values (?,?,?,?,?)', param)
    con.commit()

def novidades():
    print(tabulate([], headers=["Novos apartamentos incluidos:"], tablefmt="grid"))
    rows = cur.execute('select apelido, engine, descricao, ape_grupo_dados.valor from (select max(pk) as max_pk from ape_grupo_dados group by ape_grupo_pk order by pk) as sel_grupo_dados join ape_grupo_dados on max_pk = ape_grupo_dados.pk join ape_grupo on ape_grupo_pk = ape_grupo.pk left join ape_indexer on ape_grupo.ape_indexer_pk = ape_indexer.pk where ape_grupo.novidade = "1"')
    data=rows.fetchall()
    if len(data) > 0:
        print(tabulate(data, headers=["apelido", "engine", "descricao", "valor"],
                       disable_numparse=True, tablefmt="grid",  maxcolwidths=[None,
                                                                              None,
                                                                              50,
                                                                              100]))


    print(tabulate([], headers=["Apartamentos nao encontrados:"], tablefmt="grid"))
    rows = cur.execute('select apelido, engine, descricao, ape_grupo_dados.valor from (select max(pk) as max_pk from ape_grupo_dados group by ape_grupo_pk order by pk) as sel_grupo_dados join ape_grupo_dados on max_pk = ape_grupo_dados.pk join ape_grupo on ape_grupo_pk = ape_grupo.pk left join ape_indexer on ape_grupo.ape_indexer_pk = ape_indexer.pk where ape_grupo.existe = "0"')
    data = rows.fetchall()
    if len(data) > 0:
        print(tabulate(data, headers=["apelido", "engine", "descricao", "valor"],
                       disable_numparse=True, tablefmt="grid", maxcolwidths=[None,
                                                                             None,
                                                                             50,
                                                                             130]))

    # novidades = cur.execute('select * from (select ape_grupo_pk as pk from ape_grupo_dados where novidade = "1") as novidades join ape_grupo_dados on ape_grupo_dados.ape_grupo_pk = novidades.pk join ape_grupo on ape_grupo.pk = novidades.pk order by ape_grupo.pk, ape_grupo_dados.pk')
    novidades = cur.execute("select descricao, group_concat(valor, ' -> ') from (select ape_grupo_dados.ape_grupo_pk as novidades_pk from ape_grupo_dados where ape_grupo_dados.novidade='1') as novidades join ape_grupo_dados on ape_grupo_dados.ape_grupo_pk = novidades.novidades_pk join ape_grupo on ape_grupo.pk = novidades_pk group by novidades_pk order by ape_grupo_dados.ape_grupo_pk, ape_grupo_dados.pk;")
    print(tabulate([], headers=["Variacao de preços:"], tablefmt="grid"))
    data_novidades = novidades.fetchall()
    if len(data_novidades) > 0:
        print(tabulate(data_novidades, headers=["Descricao", "Preco"], tablefmt="grid",
                       maxcolwidths=[50, 120]))


    preco_medio_return = cur.execute("select apelido, sum(replace(ape_grupo_dados.valor, '.','')), count(ape_grupo.pk) from ape_indexer join ape_grupo on ape_grupo.ape_indexer_pk = ape_indexer.pk join ape_grupo_dados on ape_grupo_dados.ape_grupo_pk = ape_grupo.pk where grupo='1' group by ape_indexer.pk")

    precos = preco_medio_return.fetchall()

    print(tabulate([], headers=["Valor medio dos apartamentos: "], tablefmt="grid"))
    print(tabulate([[preco[0],
                     Decimal(preco[1]/preco[2]).quantize(Decimal('0.01'))] for
                    preco in precos], disable_numparse=True))

    # print(tabulate([[Decimal(preco/total).quantize(Decimal('0.01'))]],
                   # disable_numparse=True))


def _parse_arguments_():
    import argparse

    parser = argparse.ArgumentParser(description='Mostrar as novidades dos apes!')
    parser.add_argument('params', metavar='N', type=str, nargs='*',
                        help='Os parametros da operacao')
    parser.add_argument('-a', '--add', action='store_true',
                        help='Adiciona uma url para verificacao. Params: apelido engine grupo paginas url')
    parser.add_argument('-r', '--ranking', action='store_true',
                        help='Mostra os apartamentos vigiados. Novas atualizações primeiro')
    parser.add_argument('-n', '--novidades', action='store_true',
                        help='Mostra um relatorio com as novidades')
    parser.add_argument('-v', '--view', action='store_true',
                        help='Marca todos como vistos')
    parser.add_argument('-u', '--url', action='store_true',
                        help='Mostra as urls')

    options = parser.parse_args()
    return options

def _main_():
    options = _parse_arguments_()
    ranking = options.ranking
    mark_view_opt = options.view
    url_show = options.url
    add_ape = options.add
    novidades_on = options.novidades

    opcoes.url = url_show

    if ranking:
        show_news(opcoes)

    if mark_view_opt:
        mark_view()

    if add_ape:
        add(options.params)

    if novidades_on:
        novidades()

if __name__ == '__main__':
    _main_()
