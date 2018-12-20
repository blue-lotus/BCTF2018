#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<fcntl.h>

int init_flag(char **flag)
{
    int fd;
    fd=open("./flag",O_RDONLY);
    lseek(fd, 0, SEEK_END);
    int size = lseek(fd, 0, SEEK_CUR);
    *flag = malloc(size+10);
    lseek(fd, 0, SEEK_SET);
    read(fd,*flag,size);
    close(fd);
    return 0;
}
int main(){
    char *flag;
    int flag_len,i,j;
    init_flag(&flag);
    flag_len=strlen(flag);
    for(i=0;i<flag_len;i++)
        for(j=0x20;j<0x7f;j++)
            if(flag[i]==j)
                break;
    return 0;
}