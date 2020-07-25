### Descrição
A finalidade desse trabalho é fazer com que o usuário possa jogar campo minado, com seleção de nível (fácil, médio ou difícil)
O programa deve ser implementado utilizando o conjunto de instruções do MIPS e deve ser executado no simulador SPIM ou no simulador MARS.
O tamanho do campo é definido pela escolha do nível de jogo (fácil 5x5, médio 7x7, difícil 9x9)
Por especificação do trabalho, deve conter as seguintes funções:
* Função calcula_bombas com o seguinte protótipo:
  void calcula_bombas(int * campo[], int num_linhas);
* Função mostra_campo (cada aluno pode definir o protótipo da mesma).
  
#### o programa segue as seguintes convenções:
* Convenção sobre o uso de registradores:
>* Os registos $a0 a $a3 são utilizados para passar parâmetros para os procedimentos;
>* Os registos $v0 e $v1 são utilizados para passar resultados para o procedimento que chamou o procedimento;
>* O registo $sp é utilizado como apontador para o topo da pilha;
>* Os registos $s0 a $s7 são preservados por um procedimento;
>* Os registos $t0 a $t9 não necessitam de ser preservados por um procedimento.
> <p align="right">(Arquitectura de Computadores, pg 36 - Leiria e Moura)</p>
* Antes de iniciar uma função os registradores utilizados (que não os temporários) são empilhados e apontados pelo $sp.
Ao final do da função, são desempilhados aos seus valores originais

#### draw_field
  varre o vetor do campo minado do seguinte modo:
  ```
  for (y = matrix_order; y >= 0; y--) 
    for (x = 0; x < matrix_order; x++)
  ```
  as células na memória são divididas em meia-palavra (half-word). A parte baixa é ondee fica o valor da celula e a parte alta se ela é uma celula já visitada ou não.

#### calc_adjacent_bombs
  quando encontra uma bomba, visita as celulas adjacentes e adiciona um ao valor delas (exceto se bomba)
  é feito na seguinte ordem:
```
  x x x      6 7 8
  x & x  =>  5 & 1
  x x x      4 3 2
```
  onde ```& = endereço da célula-referência``` e ```x = celulas adjacentes```

    os endereços fora do campo são ignorados pela função get_element_adress

#### get_element_adress:
    Calcula o endereço de uma matriz dado o índice
    a0: índice da matriz
    a1: ordem da matriz
    a2: valor em x
    a3: valor y
    v0: retorna o endereço na posição desejada ( -1 se for um endereço inválido)
    v1: flag de erro: se endereço invalido retorna 1

    Operação: ```((ordem_da_matriz * y) + x) * 4Bytes + endereço original```