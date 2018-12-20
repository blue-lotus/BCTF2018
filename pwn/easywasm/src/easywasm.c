
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <time.h>
#include <emscripten.h>


struct person{
	int id;
    int inuse;
	char name[60];
	void  (*intro)(char*);
};
struct person person_list[1000];
int person_count=0;
EMSCRIPTEN_KEEPALIVE
void tutor_hello(char *name){
	printf("I am a tutor, My name is %s\n",name);
    return 0;
}

void student_hello(char *name){
	printf("I am a student, My name is %s\n", name);
    return 0;

}
EMSCRIPTEN_KEEPALIVE
int add_person(char *name,int istutor){

	int i;
	if(person_count>=1000){
		puts("too much person");
		return -1;
	}
	for(i=0;i<1000;i++){
		if(!person_list[i].inuse){
			person_list[i].id=i;
            person_list[i].inuse=1;
			break;
		}
	}
    strcpy(person_list[i].name,name);
    person_list[i].intro=emscripten_run_script;
    if(istutor)
        person_list[i].intro=tutor_hello;
    else
        person_list[i].intro=student_hello;


    return i;
}
EMSCRIPTEN_KEEPALIVE
void init(){
	setbuf(stdin,0);
    setbuf(stdout,0);
    person_count=0;
    for(int i=0;i<1000;i++)
		person_list[i].inuse=0;
}
EMSCRIPTEN_KEEPALIVE
int delete_person(int id){
	
	if(id<0||id>=1000||!person_list[id].inuse){
		puts("person id is invalid");
		return -1;
	}

	person_list[id].inuse=0;
	return 0;
}
EMSCRIPTEN_KEEPALIVE
int change_name(int id,char *new_name){
    if(id<0||id>=1000||!person_list[id].inuse){
        puts("person id is invalid");
		return -1;
	}
	strcpy(person_list[id].name,new_name);

	//memcpy(person_list[id].name,new_name,24);
    return 0;
}
EMSCRIPTEN_KEEPALIVE
int intro(int id){
	if(id<0||id>=1000||!person_list[id].inuse){
		return -1;
	}

	person_list[id].intro(person_list[id].name);
	return 0;
}
