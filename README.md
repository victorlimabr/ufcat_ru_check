# Sistema de Verificação de Subsídio de Estudantes no Restaurante Universitário da Universidade Federal de Catalão

![TelaDelogin](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/789c3567-8914-4e1f-9a7f-35bce35ae186)

![DiarioDeEntradas](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/3626d988-a747-41d0-9c87-40f876ee41c7)

![NovaPlanilha](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/5ef00afd-727e-40c6-9071-d775b0260852)

![RelatorioDeEntradas](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/062834fe-72e1-4252-aead-96073279ccd2)

![CadastroDeEstudantes](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/5b265158-38b1-44cb-b186-09972faba76d)

![CadastroFuncionario](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/b69a55da-44b3-49c4-8ab4-970b5683717f)

![Configuracoes](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/8c1b2b61-ef58-4a0d-9415-f57550ab9833)





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


## Configurações

* Definir colunas das entradas
* Definir linha inicial da planilha

* Configurar faixa de valores
* Configurar valor dos subsídios





# Estrutura da aplicacão














