/*
    @autor Maurício Catanio
    this program  was made as a final project for computer architecture class
    The main purpose of the program is to simulate read and write instructions to a cache memory
    and give statistics of the misses or hits

    for future implementations: read files with lots of reads/writes
 */

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <math.h>

#define FALSE 0
#define TRUE 1
#define main_memory_size 128
#define cache_lines 8
#define block_width 4
/* 
    A precise definition for the size_t of the label_width would follow
    
    (int)((8+(log2(main_memory_size) - log2(block_width) - log2(cache_lines)))/8)

    but since it returns "variably modified" error by the compiler when used in an array
    I'll consider the main case as an unsigned int (4bytes)
*/

struct cache_memory 
{
    unsigned char line[cache_lines][block_width];
    unsigned char valid[cache_lines];
    unsigned char modified[cache_lines];
    unsigned int label[cache_lines];
}typedef cache_memory;



/* headers */
void clean_input();
unsigned int cache_access(char operator, unsigned int adress, char *main_memory, cache_memory *cache);
void cache_change(char *main_memory, cache_memory *cache, unsigned int adress);

/************************
 * program
 */
int main(int argc, char const *argv[])
{
    char main_memory[main_memory_size];
    unsigned int miss = 0, adress, loop = TRUE, instruction_counter = 0, read_miss = 0, write_miss = 0;
    unsigned int read = 0, write = 0;
    cache_memory cache;
    char option;

    printf("type an option:\nR - Read in memory (from adress)\nW - Write in memory (in adress)\nS - view statistics\n");
    printf(">-- OR type any other key to leave\n");
    
    /*clear memory loop */
    for (int i = 0; i < cache_lines; i++){
        for (int x = 0; x < 4; x++){
            cache.line[i][x] = 0;
        }
        cache.modified[i] = 0;
        cache.valid[i] = 0;
        cache.label[i] = 0;
    }
    for (int i = 0; i < main_memory_size; i++) {
        main_memory[i] = 0;
    }

    /* Program */
    /*
        > ler o conteúdo de um endereço da memória;
        > escrever em um determinado endereço da memória;
        > apresentar as estatísticas de acertos e faltas (absolutos e percentuais)
                                    para as três situações: leitura, escrita e geral;
        > encerrar o programa.
    */
    do
    {
        scanf("%c", &option);
        clean_input();
        //tolower(option);
        
        if (option == 'r' || option == 'w')
        {
            
            printf("Adress: ");
            scanf("%x", &adress);
            clean_input();

            miss = 0;
            miss = cache_access(option, adress, main_memory, &cache);

            if (option == 'r'){
                read_miss += miss;
                read++;
                }
            else if (option == 'w'){
                write_miss += miss;
                write++;
                }
                
            instruction_counter++;
            
            /* Save memory in a file */
            FILE *file = fopen("main_memory.dat", "w");
            fprintf(file, "operations: %03d\n", instruction_counter);
            fprintf(file, "-r: %02d // m: %02d\n", read, read_miss);
            fprintf(file, "-w: %02d // m: %02d\n", write, write_miss);
            fwrite( main_memory, sizeof(unsigned char), 128, file);
            fclose(file);

        }
        else if (option == 's')
        {
            unsigned int total_miss = write_miss+read_miss;
            printf("Statistcs:\n");
            printf("total operations: %d\nmisses: %d\nmiss percentual:%d\n",instruction_counter,read_miss+write_miss, (total_miss*100)/instruction_counter);
            printf("reads: %d  -- read misses: %d -- percentual: %d\n", read, read_miss, (read_miss*100)/read);
            printf("write: %d  -- write misses: %d -- percentual: %d\n", write, write_miss, (write_miss*100)/write);
            loop = FALSE;
        }
        else
        {
            printf("broke\n");
            /* update memory */
            for (int i = 0; i < main_memory_size; i++){
                cache_change(main_memory, &cache, i);
            }
            /*saves memory in a file */
            FILE *file = fopen("main_memory.dat", "w");
            fprintf(file, "operations: %03d\n", instruction_counter);
            fprintf(file, "-r: %02d // m: %02d\n", read, read_miss);
            fprintf(file, "-w: %02d // m: %02d\n", write, write_miss);
            fwrite( main_memory, sizeof(unsigned char), 128, file);
            fclose(file);
            loop = FALSE;
        }
    } while (loop);
    return 0;
}

/* returns a byte vector of 2 positions - [0] = byte value, [1] miss(true/false) */
unsigned int cache_access(char operator, unsigned int adress, char *main_memory, cache_memory *cache) {
    unsigned int label, cell, line;
    // unsigned char *result =(unsigned char*)malloc(sizeof(unsigned char)*2);
    unsigned int miss = FALSE;
    
    /* Check if it has a valid adress */
    if (adress >= main_memory_size || adress < 0)
    {
        printf("invalid adress\n");
        return miss;
        miss = TRUE;
    }
    
    /* Separates the adress parts */
    cell = adress % block_width;
    label = adress /(int)pow(2,log2(cache_lines)+log2(block_width));
    line = (adress >> (int)(log2(block_width))) % cache_lines;
    
    /* if validation bit is false or label isn't the same, it's a miss */ 
    if ((cache->valid[line] == FALSE) || (cache->label[line] != label))
    {
        miss = TRUE;
        cache_change( main_memory, cache, adress);
        //why it doesn't enter when adress is 0 for the first time?
        printf("miss! \n");
    }

    printf("cell: %d\n", cell);
    printf("label: %d\n", label);
    printf("line: %d\n", line);

    if (operator == 'r')
    {
        printf("R: 0x%08x  (%02x)\n", adress, cache->line[line][cell]);
    }

    else if (operator == 'w')
    {
        unsigned char new_value;
        printf("new value: ");
        scanf("%c", &new_value);
        clean_input();
        cache->modified[line] = TRUE;
        cache->line[line][cell] = new_value;
        printf("W: 0x%08x (%02x)\n", adress, cache->line[line][cell]);
    }

    return miss;
}

void cache_change(char *main_memory, cache_memory *cache, unsigned int adress) {
    unsigned int label, line, block;
    
    //cell = adress % block_width;
    label = adress /(int)pow(2,log2(cache_lines)+log2(block_width));
    line = (adress >> (int)(log2(block_width))) % cache_lines;
    block = adress/block_width;
    
    if (cache->modified[line] == TRUE) {
        unsigned int store_block;
        store_block = cache->label[line];
        store_block = store_block << (int)log2(cache_lines);
        store_block += line;
        for (int shift = 0; shift < block_width; shift++)
        {
            main_memory[shift+(store_block*block_width)] = cache->line[line][shift];
        }
    }

    cache->valid[line] = TRUE;
    cache->label[line] = label;
    cache->modified[line] = FALSE;

    for (int shift = 0; shift < block_width; shift++)
    {
        cache->line[line][shift] = main_memory[shift+(block*block_width)];
    }

}
/*used after char scanf */
void clean_input() {
    fflush(stdin);
    while (getchar() != '\n');
}