
#include <stdint.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <limits.h>
#include <sys/signal.h>

#include <stdlib.h>

#include "syscalls.c"

void c3_call(uint32_t* inA, uint32_t* dest, size_t len);

void main(int argc, char** argv) {
	
	int a=rand();
	//printf("Hello!\n");
    
    uint32_t* srcA =  0x00050000; 
    uint32_t* destA = 0x00060000;
    uint32_t* destB = 0x00068000;
	    
	size_t len=32; 

	// Prepare a list of random numbers
	for (int j=0; j<len; j++) {
	    *((volatile uint32_t*)(srcA+j))=rand()%len;
		destA[j]=0;
	}   

	// Read cycles and instruction count	  		
	uint64_t time1=time(); 
	uint64_t icount1=insn();
	
	// Use c3
	c3_call(srcA, destA, len);

	// Read cycles and instruction count	
	uint64_t time2=time()-time1;
	uint64_t icount2=insn()-icount1;  
	  		  	
  	// Print result	
  	printf("c3 results N %d cyc %llu icount %llu CPI %llu.%02llu ",
  	len,time2, icount2,(time2)/(icount2), 	(((time2)%(icount2))*100)/(icount2));
  	
  	uint64_t int_part = len*150/time2;
  	uint64_t dec_part = ((len*150)%time2)*100/time2;
  	printf("MB/s@150MHz %llu.%02llu \n",int_part,dec_part);
	
	// Do same serially
	for (int j=0; j<len; j++) {
		destB[j]=srcA[j]+1;	
	}
	
	// Check result
	
	int error=0;
	for (int i=0; i<len; i++){
		printf("%d) %d =? %d ", i, destA[i], destB[i]);
		if (destA[i] != destB[i]){
			printf("no\n");
  			error=1; 
  		} else {
  			printf("yes\n");
  		} 				
  	}	
  	printf("\nEnd! error? %s\n", error?"yes":"no");	     
    
    while (1);
    return;
}

// RS1, RD1, RS2, RD2 -> 1, 3, 2, 0
#define immediate_part 0

void c3_call(uint32_t* inA, uint32_t* dest, size_t len)
{ 
	
	for (int i=0; i<len; i++){ 
	 	  	
		int source_register = inA[i];
		int destination_register;
		
		// Call v3
	   	asm volatile ("c3 %0, %1, %2":: "r"(destination_register),  "r"(source_register), "I"(immediate_part));		
	   	
	   	dest[i]=destination_register;
	  
  	}
}

