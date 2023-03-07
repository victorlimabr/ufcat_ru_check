# Requisitos
1. Login PRPE
   1. email
   2. senha
2. Inserir planilha diária
   1. Comparar renda, vinculo, categoria
3. Integração SIGAA (estudantes e funcionários)
4. Gerar relatórios
   1. Diário, semanal, mensal
   2. Por aluno, por período
   3. Conferir valor pago de acordo com faixa de subsidio (sigaa)
   4. Conferir se estão matriculados no semestre (sigaa)
   5. Valor total das refeições
   6. Valor total pago
   7. Valor subisidiado por período
   8. Total de refeições por aluno
   9. Quantidade de refeições por categoria
   10. Tempo da ultima atualização do aluno
5. Filtros
   1. Data, período
   2. Por aluno, nome, matrícula, cpf
6. Ajuste do valor das faixas
7. Destacar primeira refeição subsidiada

# Relatório

## Filtros
* Filtro de período
* Filtro de estudante (nome, matricula, cpf)
* Filtro de refeições
* Filtro de categoria
* Filtro de níveis

## Verificações
* Listar estudantes não encontrados no sistema
* Listar estudantes não matriculados
* Listar estudantes que faixa não bate com renda
* Listar estudantes que não atualizaram os dados no período

## Totalizadores
* Quantidade de refeições (total, por categoria, por nível, por refeição)
* Total de refeições por aluno (quando filtrar por aluno)
* Valor total das refeições
* Valor total pago pelos estudantes
* Valor total subsidiado


## Confiugrações

* Definir colunas das entradas
* Definir linha inicial da planilha

* Configurar faixa de valores
* Configurar valor dos subsídios





# Estrutura da aplicacão
