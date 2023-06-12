# Sistema de Verificação de Subsídio de Estudantes no Restaurante Universitário da Universidade Federal de Catalão

1. Para utilizar o sistema, o funcionário deve acessar o sistema na tela inicial utilizando suas credenciais 
   previamente cadastradas.
![TelaDelogin](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/789c3567-8914-4e1f-9a7f-35bce35ae186)

2. Na página de primeiro acesso o funcionário irá realizar o cadastro no sistema inserindo seus dados nos campos.
![PrimeiroAcesso](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/0bf03956-2abc-4a29-a068-b619ce60aae6)

3. Tela principal do sistema, onde é possível visualizar os registros de utilização do RU por parte dos alunos, 
   esses dados são extraídos das planilhas fornecidas pelo sistema de acesso ao RU que são importadas
   no sistema por meio da opção Adicionar Planilha.
![DiarioDeEntradas](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/3626d988-a747-41d0-9c87-40f876ee41c7)
   
4. A função de adicionar planilha permite ao funcionário inserir um arquivo no sistema por meio do campo Arquivo. 
   O arquivo deve estar no formato XLSX (Planilha do Excel). As informações obtidas serão inseridas no banco de dados
   próprio do sistema.
![NovaPlanilha](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/5ef00afd-727e-40c6-9071-d775b0260852)

5. O sistema é capaz de gerar relatórios utilizando um  período determinado, seja por dia, semana, mês, etc. 
   Também é possível gerar relatório de utilização de um aluno específico, relatando os dias nos quais este  acessou o RU.
   As planilhas já inseridas no sistema são  consultadas considerando os filtros referentes às faixas e requisitos do subsídio, 
   Também é possível visualizar  o valor total das refeições servidas no período especificado e que deve ser repassado para 
   a empresa responsável pelas refeições.
![RelatorioDeEntradas](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/062834fe-72e1-4252-aead-96073279ccd2)

6. Para possibilitar a melhor forma de visualização dos dados dos estudantes cadastrados, a tela de Cadastro dos Estudantes 
   além de exibir os dados de cada estudante em uma lista, também destaca o estudante que está com o cadastro sem atualização 
   por mais de 6 meses.
![CadastroDeEstudantes](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/5b265158-38b1-44cb-b186-09972faba76d)

7. Visando manter atualizado os dados dos funcionários cadastrados, a tela de Cadastro dos Funcionários possibilita a 
   edição e exclusão desses dados, sendo possível alterar o Nome, Email, Usuário e CPF, além de ser possível alterar
   a senha de acesso ao sistema.
![CadastroFuncionario](https://github.com/victorlimabr/ufcat_ru_check/assets/106392990/b69a55da-44b3-49c4-8ab4-970b5683717f)

8. Como um fator de confiabilidade e para que o sistema esteja de acordo com os dados recebidos a longo prazo, os funcionários
   devem ser capazes de modificar as faixas de subsídio existentes para o caso de serem feitas alterações nos requisitos dos 
   benefícios fornecidos, essa manutenção é realizada a partir da tela de Configurações e devem ocorrer de acordo com as 
   configurações de planilhas, subsídios, faixa de renda e relatório.
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














