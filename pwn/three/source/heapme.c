#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define NUM 3
#define SIZ 0x40
char* notes[3];

void initialize(){
    setvbuf(stdin,0,2,0);
    setvbuf(stderr,0,2,0);
    setvbuf(stdout,0,2,0);
    alarm(0x20);
}

void readn(char* p,size_t n){
    read(0,p,n);
}

int getint(){
    char s[0x20];
    memset(s,0,0x20);
    readn(s,0x20-1);
    return atoi(s);
}

int menu(){
    puts("1. new");
    puts("2. edit");
    puts("3. delete");
    printf("Your choice:");
    return getint();
}

void alloc(){
    int i=0;
    for(;i<NUM;i++){
        if(!notes[i]){
            break;
        }
    }

    if(i==NUM){
        puts("Too many notes!");
        return;
    }
    
    printf("Input the content:");
    notes[i]=(char*)malloc(SIZ);
    readn(notes[i],SIZ);
    puts("Done!");
}

void edit(){
    printf("Input the idx:");
    int i=getint();
    if(0>i||i>=NUM||!notes[i]){
        puts("No such note!");
        return;
    }

    printf("Input the content:");
    readn(notes[i],SIZ);
    puts("Done!");
}

void del(){
    printf("Input the idx:");
    int i=getint();
    if(0>i||i>=NUM||!notes[i]){
        puts("No such note!");
        return;
    }
    free(notes[i]);
    printf("Clear?(y/n):");
    char c[2];
    readn(c,2);
    if(c[0]=='y'){
        notes[i]=0;
    }
    puts("Done!");
}

int main()
{
    initialize();
    while(1){
        switch(menu()){
        case 1:
            alloc();
            break;
        case 2:
            edit();
            break;
        case 3:
            del();
            break;
        default:
            exit(0);
        }
    }
    return 0;
}

