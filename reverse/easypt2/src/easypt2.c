#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/mman.h>
#include<unistd.h>
#include<fcntl.h>
#include<pthread.h>
char *flag=NULL;
int check_cur=0;
unsigned int *rnd;
int *check_idxs;
int load_flag(){
	int fd=open("./flag",O_RDONLY);
	if(fd<0){
		perror("open@load_flag");
		exit(EXIT_FAILURE);
	}
	lseek(fd, 0, SEEK_END);
	int size = lseek(fd, 0, SEEK_CUR);
	flag = malloc(size);
	memset(flag,0,size);
	lseek(fd, 0, SEEK_SET);
	read(fd,flag,size);
	close(fd);
	check_idxs = malloc(size*sizeof(int));
	for(int i=0;i<size;i++){
		check_idxs[i]=i;
	}
	rnd = malloc(size*sizeof(int));

	fd=open("/dev/urandom",O_RDONLY);
	read(fd,rnd,size*sizeof(unsigned int));
	close(fd);
	for(int i=0;i<size;i++){
		rnd[i]=rnd[i]%10;
	}
	return size;
}
void* check_flag(void *arg){
	int check_idx=*(int*)arg;
	sleep(rnd[check_idx]);
	int i;
	for(i=0x20;i<0x7f;i++){
		if(flag[check_idx]==i)
			break;
	}
//	printf("%d:%d %c\n",check_idx,i,(char)i);
	return NULL;
}

int main(){
	int flag_len;
	pthread_t **threads;
	flag_len=load_flag();
	threads=malloc(flag_len*sizeof(size_t));
	for(int i=0;i<flag_len;i++)
		threads[i]=malloc(sizeof(pthread_t));
	for(int i=0;i<flag_len;i++){
		if(pthread_create(threads[i], NULL, check_flag, &check_idxs[i]) == -1){
			printf("fail to create pthread %d\n",i);
			exit(1);
		}
	}
	void *result;
	for(int i=0;i<flag_len;i++){
		if(pthread_join(*(threads[i]), &result) == -1){
			printf("fail to recollect pthread %d\n",i);
			exit(1);
		}
	}
	puts("done");
}


