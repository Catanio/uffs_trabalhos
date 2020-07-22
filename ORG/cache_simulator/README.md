### Contexto:

esse simulador é o trabalho final da cadeira de organização de computadores.
Como gostei dele, tenho por objetivo reescrever ele e futuramente escrever um gerador de programas de para testes de complexidades diferentes


### especificações do exercicio dada pelo professor (original)

Na tela do programa deve ser apresentado todo o conteúdo da memória principal, da memória cache, da próxima localização que será substituída (de acordo com a política definida), além de um menu que de acesso às seguintes operações:

- ler o conteúdo de um endereço da memória;

- escrever em um determinado endereço da memória;

- apresentar as estatísticas de acertos e faltas (absolutos e percentuais) para as três situações: leitura, escrita e geral;

- encerrar o programa.

OBS1: Os valores e endereços devem ser apresentados em hexadecimal ou binário.

OBS2: Ao ler um endereço deve informar se encontrou na cache ou não. Qual o número do bloco a que se refere o endereço, qual o quadro na cache que está mapeado e o deslocamento do mesmo.

OBS3: Os contadores da política de substituição possuem 3 bits.