import re;
arquivo = open('teste03', 'r')
arquivolist = list(arquivo)    
UNDO = []                       
UNDOcheck = []
REDO = []
REDOcheck = []

  
commit = re.compile(r'commit', re.IGNORECASE) 
start = re.compile(r'start', re.IGNORECASE)
startckpt = re.compile(r'start ckpt', re.IGNORECASE)
endckpt = re.compile(r'end ckpt', re.IGNORECASE)
extracT = re.compile(r'(?!commit\b)(?!CKPT\b)(?!Start\b)\b\w+', re.IGNORECASE) 
words = re.compile(r'\w+', re.IGNORECASE)  

valores = words.findall(arquivolist[0])
variaveis = {}

# Cria array dos valores no inicio e printa eles
for i in range(0,len(valores),2): 
    variaveis[valores[i]]= valores[i+1]
print("", variaveis)

end = 0
for i in range(len(arquivolist)-1, 0, -1): # atravessa a lista de tras pra frente ate achar um start ckpt sucedido por um end ckpt
    linha = arquivolist[i]
    if startckpt.search(linha):
        if end:
            Tx = extracT.findall(linha)
            print("Start Checkpoint Txc", Tx)
            for j in range(0, len(Tx), 1):
                if Tx[j] not in REDO: # se a transacao iniciada antes desse checkpoint nao foi concluida
                    UNDO.append(Tx[j]) # adiciona ela na lista de UNDO
                else:
                    REDOcheck.append(Tx[j]) # REDOcheck fara a verificacao de quanto tem de voltar antes do ultimo ckpt pra refazer

            break 
    elif start.search(linha):   
        Tx = extracT.findall(linha)[0]
        if Tx not in REDO:
            UNDO.append(Tx)

    elif commit.search(linha):   
        Tx = extracT.findall(linha)[0]
        REDO.append(Tx)

    elif endckpt.search(linha):
        print(" End  Checkpoint")
        end = 1
ckpt_line = i

# UNDO
print("\nAplicar UNDO:", UNDO)
for i in range(len(arquivolist)-1, 0, -1): 
    linha = arquivolist[i]
    if start.search(linha) and not startckpt.search(linha): # se achar o inicio de alguma transacaoes
        Tx = extracT.findall(linha)[0]
        if Tx in UNDO: # caso seja uma transacao nao commitada
            UNDO.remove(Tx) # remove da lista de UNDO
            UNDOcheck.append(Tx)

        if Tx in REDOcheck: # caso seja uma transacao comitada
            REDOcheck.remove

        if not len(UNDO) and not len(REDOcheck): # sai do loop indicando ate onde precisou voltar pra achar as transacoes soltas
            break
    elif words.findall(linha)[0] in UNDO: # verifica se a transacao esta na lista de UNDO
        variaveis[words.findall(linha)[1]] = words.findall(linha)[2] # e retorna pro valor anterior

# REDO
print("\nAplicar o REDO:", REDO)
for j in range(i,len(arquivolist)-1,1):
    linha = arquivolist[j]
    if commit.search(linha):
        Tx = extracT.findall(linha)[0]
        if Tx in REDO:
            REDO.remove(Tx)
            REDOcheck.append(Tx)

        if not len(REDO):
            break
    elif words.findall(linha)[0] in REDO: # verifica se a transacao esta na lista de REDO
        variaveis[words.findall(linha)[1]] = words.findall(linha)[3] # e muda o valor para o atualizado

print("Aplicado UNDO:", UNDOcheck)
print("Resultado:", variaveis)
arquivo.close()
