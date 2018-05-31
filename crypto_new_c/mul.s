						AREA |.test1|,CODE, READONLY
	
						EXPORT multiply256x256_asm
		
multiply256x256_asm 	PROC
		
						push {r4-r7,lr}
	mov r3, r8										; r3 = r8
	mov r4, r9										; r4 = r9
	mov r5, r10										; r5 = r10
	mov r6, r11										; r6 = r11
	push {r0-r6}									; save r8-r11
	mov r12, r0										; r12 = r0 ( addsress of the result array )
	mov r10, r2										; r10 = r2 ( addsress of 2nd input array )
	mov r11, r1										; r11 = r1 ( addsress of 1st input array )
	mov r0,r2										; r0 = r2 ( now r0 is pointing to 2nd input array 1st addsress )
	;//ldm r0!, {r4,r5,r6,r7}
	ldm r0!, {r4,r5}								; load 2 first word (32 bits ) - r4 = input_2[0] , r5 = input_2[1] , r0 = &input_2[2]
	adds r0,#8										; now r0 = &input_2[4]
	ldm r1!, {r2,r3,r6,r7}							; load 4 first word of input_1 - r2 = input_1[0] , r3 = input_1[1] ,r6 = input_1[2] , r7 = input_1[3] ,r1 = &input_1[4]
	push {r0,r1}									; save current r0 and r1 pointer r0 = &input_2[4]  r1 = &input_1[4]
	;/////////BEGIN LOW PART //////////////////////
	;	/////////MUL128/////////////
	;		//MUL64
			mov r6, r5								; r6 = r5 ??? why have to change r6
			mov r1, r2								; r1 = r2 
			subs r5, r4								; r5 = |r5 - r4| 
			sbcs r0,r0, r0							; 
			eors r5, r0						   		; 
			subs r5, r0								; 
			subs r1, r3								; r1 = |r1 - r3|
			sbcs r7, r7								;
			eors r1, r7								;
			subs r1, r7								;
			eors r7, r0								; compare r7 and r0 | because they use r7 and r0 as "sign" later use I think 
			mov r9, r1								; 						// save the r1 
			mov r8, r5								; 						// save the r5 
			umull r0,r1,r2,r4						; change this 
			umull r2,r3,r3,r6						; optimal for m4
			eors r6, r6								; r6 = r6 * r6 
			adds r2, r1								; r2 = r2 + r1 
			adcs r3, r6								; r3 = r3 + r6 
			mov r1, r9								; r1 = r9 				// get back the saved value of r1 
			mov r5, r8								; r5 = r8 				// get back the saved value of r5
			mov r8, r0								; r8 = r0
			umull r1,r0,r1,r5						; optimal for m4
			eors r1,r7								; r1 = r1 xor r7 
			eors r0,r7								; r0 = r0 xor x7 
			eors r4, r4								; r4 = r4 xor r4 
			asrs r7, r7, #1							; shift r7 right 1 ( keep the sign )
			adcs r1, r2								; r1 = r1 + r2 + C
			adcs r2, r0								; r2 = r2 + r0 + C			
			adcs r7, r4								; r7 = r7 + r4 + C
			mov r0, r8								; r0 = r8 				// save the r0 
			adds r1, r0								; r1 = r1 + r0 
			adcs r2, r3								; r2 = r2 + r3 + C
			adcs r3, r7 							; r3 = r3 + r7 + C
		;//////////////////////////
			mov r4, r12								; r4 = r12   // initial addsress of output array 
			stm r4!, {r0,r1} 						; load the value of r0, r1 to first 2 words into the output array 
			push {r4}								; save the r4 
			push {r0,r1}							; save the r1 and r0 
		mov r1, r10									; r1 = r10				// get the initial addsress of input_2
		mov r10, r2									; r10 = r2				// I don't get this part because r2 does not hold addsress anymore. 
		ldm r1, {r0, r1, r4, r5}					; load 					// load r1 with the value in r1 and now 
		mov r2, r4
		mov r7, r5
		subs r2, r0
		sbcs r7, r1
		sbcs r6, r6
		eors r2, r6
		eors r7, r6
		subs r2, r6
		sbcs r7, r6
		push {r2, r7}
		mov r2, r11
		mov r11, r3
		ldm r2, {r0, r1, r2, r3}
		subs r0, r2
		sbcs r1, r3
		sbcs r7, r7
		eors r0, r7
		eors r1, r7
		subs r0, r7
		sbcs r1, r7
		eors r7, r6	
		mov r12, r7
		push {r0, r1}
			;//MUL64
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5						; r4,r2 input, r0,r1 output
			umull r0,r1,r2,r4				; r6,r3 input, r2,r3 output
			umull r2,r3,r3,r6
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0						; r1,r5 input, r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		mov r4, r10
		mov r5, r11
		eors r6, r6
		adds r0, r4
		adcs r1, r5
		adcs r2, r6
		adcs r3, r6
		mov r10, r2
		mov r11, r3
		pop {r2-r5}
		push {r0, r1}
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5							; r2,r4 input r0,r1 output
			umull r0,r1,r2,r4					; r6,r3 input r2,r3 output
			umull r2,r3,r3,r6 
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0							; r1,r5 input r1,r0 output
			umull r1,r0 ,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		pop {r4, r5}
		mov r6, r12
		mov r7, r12
		eors r0, r6
		eors r1, r6
		eors r2, r6
		eors r3, r6
		asrs r6, r6, #1	
		adcs r0, r4
		adcs r1, r5
		adcs r4, r2
		adcs r5, r3
		eors r2, r2
		adcs r6,r2 
		adcs r7,r2
		pop {r2, r3}
		mov r8, r2
		mov r9, r3
		adds r2, r0
		adcs r3, r1
		mov r0, r10
		mov r1, r11
		adcs r4, r0
		adcs r5, r1
		adcs r6, r0
		adcs r7, r1
	;////////END LOW PART/////////////////////
	pop {r0}
	stm r0!, {r2,r3}
	pop {r1,r2}
	push {r0}
	push {r4-r7}
	mov r10, r1
	mov r11, r2
	ldm r1!, {r4, r5}
	ldm r2, {r2, r3}
	;/////////BEGIN HIGH PART////////////////
	;	/////////MUL128/////////////
	;		//MUL64
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5								; r2,r4 input r0,r1 output
			umull r0,r1,r2,r4						; r3,r6 input r2,r3 output
			umull r2,r3,r3,r6
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0								;r1,r5 input r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		push {r0,r1}
		mov r1, r10
		mov r10, r2
		ldm r1, {r0, r1, r4, r5}
		mov r2, r4
		mov r7, r5
		subs r2, r0
		sbcs r7, r1
		sbcs r6, r6
		eors r2, r6
		eors r7, r6
		subs r2, r6
		sbcs r7, r6
		push {r2, r7}
		mov r2, r11
		mov r11, r3
		ldm r2, {r0, r1, r2, r3}
		subs r0, r2
		sbcs r1, r3
		sbcs r7, r7
		eors r0, r7
		eors r1, r7
		subs r0, r7
		sbcs r1, r7
		eors r7, r6	
		mov r12, r7
		push {r0, r1}
			;//MUL64
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5						; r2,r4 input r0,r1 output
			umull r0,r1,r2,r4				; r3,r6 input r2,r3 output
			umull r2,r3,r3,r6
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0						; r1,r5 intput r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		mov r4, r10
		mov r5, r11
		eors r6, r6
		adds r0, r4
		adcs r1, r5
		adcs r2, r6
		adcs r3, r6
		mov r10, r2
		mov r11, r3
		pop {r2-r5}
		push {r0, r1}
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5					; r4,r2 intput r0,r1 output
			umull r0,r1,r2,r4			; r3,r6 input r2,r3 output
			umull r2,r3,r3,r6
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0					; r1,r5 input r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		pop {r4, r5}
		mov r6, r12
		mov r7, r12
		eors r0, r6
		eors r1, r6
		eors r2, r6
		eors r3, r6
		asrs r6, r6, #1	
		adcs r0, r4
		adcs r1, r5
		adcs r4, r2
		adcs r5, r3
		eors r2, r2
		adcs r6,r2 ;//0,1
		adcs r7,r2
		pop {r2, r3}
		mov r8, r2
		mov r9, r3
		adds r2, r0
		adcs r3, r1
		mov r0, r10
		mov r1, r11
		adcs r4, r0
		adcs r5, r1
		adcs r6, r0
		adcs r7, r1
	;////////END HIGH PART/////////////////////
	mov r0, r8
	mov r1, r9
	mov r8, r6
	mov r9, r7
	pop {r6, r7}
	adds r0, r6
	adcs r1, r7
	pop {r6, r7}
	adcs r2, r6
	adcs r3, r7
	pop {r7}
	stm r7!, {r0-r3}
	mov r10, r7
	eors r0,r0
	mov r6, r8
	mov r7, r9
	adcs r4, r0
	adcs r5, r0
	adcs r6, r0
	adcs r7, r0
	pop {r0,r1,r2}
	mov r12, r2
	push {r0, r4-r7}
	ldm r1, {r0-r7}
	subs r0, r4
	sbcs r1, r5
	sbcs r2, r6
	sbcs r3, r7
	eors r4, r4
	sbcs r4, r4
	eors r0, r4
	eors r1, r4
	eors r2, r4
	eors r3, r4
	subs r0, r4
	sbcs r1, r4
	sbcs r2, r4
	sbcs r3, r4
	mov r6, r12
	mov r12, r4 ;//carry
	mov r5, r10
	stm r5!, {r0-r3}
	mov r11, r5
	mov r8, r0
	mov r9, r1
	ldm r6, {r0-r7}
	subs r4, r0
	sbcs r5, r1
	sbcs r6, r2
	sbcs r7, r3
	eors r0, r0
	sbcs r0, r0
	eors r4, r0
	eors r5, r0
	eors r6, r0
	eors r7, r0
	subs r4, r0
	sbcs r5, r0
	sbcs r6, r0
	sbcs r7, r0
	mov r1, r12
	eors r0, r1
	mov r1, r11
	stm r1!, {r4-r7}
	push {r0}
	mov r2, r8
	mov r3, r9
	;/////////BEGIN MIDDLE PART////////////////
	;	/////////MUL128/////////////
	;		//MUL64
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5					; r2,r4 input r0,r1 output
			umull r0,r1,r2,r4			; r3,r6 input r2,r3 output
			umull r2,r3,r3,r6 
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0					; r1,r5 input r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		push {r0,r1}
		mov r1, r10
		mov r10, r2
		ldm r1, {r0, r1, r4, r5}
		mov r2, r4
		mov r7, r5
		subs r2, r0
		sbcs r7, r1
		sbcs r6, r6
		eors r2, r6
		eors r7, r6
		subs r2, r6
		sbcs r7, r6
		push {r2, r7}
		mov r2, r11
		mov r11, r3
		ldm r2, {r0, r1, r2, r3}
		subs r0, r2
		sbcs r1, r3
		sbcs r7, r7
		eors r0, r7
		eors r1, r7
		subs r0, r7
		sbcs r1, r7
		eors r7, r6	
		mov r12, r7
		push {r0, r1}
			;//MUL64
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5						; r4,r2 input r0,r1 output
			umull r0,r1,r2,r4				; r3,r6 input r2,r3 output
			umull r2,r3,r3,r6
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0						; r1,r5 input r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		mov r4, r10
		mov r5, r11
		eors r6, r6
		adds r0, r4
		adcs r1, r5
		adcs r2, r6
		adcs r3, r6
		mov r10, r2
		mov r11, r3
		pop {r2-r5}
		push {r0, r1}
			mov r6, r5
			mov r1, r2
			subs r5, r4
			sbcs r0, r0
			eors r5, r0
			subs r5, r0
			subs r1, r3
			sbcs r7, r7
			eors r1, r7
			subs r1, r7
			eors r7, r0
			mov r9, r1
			mov r8, r5							; r2,r4 input r0,r1 output
			umull r0,r1,r2,r4					; r3,r6 input r2,r3 output
			umull r2,r3,r3,r6
			eors r6, r6
			adds r2, r1
			adcs r3, r6
			mov r1, r9
			mov r5, r8
			mov r8, r0							; r1,r5 input r1,r0 output
			umull r1,r0,r1,r5
			eors r1,r7
			eors r0,r7
			eors r4, r4
			asrs r7, r7, #1
			adcs r1, r2
			adcs r2, r0
			adcs r7, r4
			mov r0, r8
			adds r1, r0
			adcs r2, r3
			adcs r3, r7 
		pop {r4, r5}
		mov r6, r12
		mov r7, r12
		eors r0, r6
		eors r1, r6
		eors r2, r6
		eors r3, r6
		asrs r6, r6, #1	
		adcs r0, r4
		adcs r1, r5
		adcs r4, r2
		adcs r5, r3
		eors r2, r2
		adcs r6,r2 ;//0,1
		adcs r7,r2
		pop {r2, r3}
		mov r8, r2
		mov r9, r3
		adds r2, r0
		adcs r3, r1
		mov r0, r10
		mov r1, r11
		adcs r4, r0
		adcs r5, r1
		adcs r6, r0
		adcs r7, r1
	;//////////END MIDDLE PART////////////////
	pop {r0,r1} ;//r0,r1
	mov r12, r0 ;//negative
	eors r2, r0
	eors r3, r0
	eors r4, r0
	eors r5, r0
	eors r6, r0
	eors r7, r0
	push {r4-r7}
	ldm r1!, {r4-r7}
	mov r11, r1 ;//reference
	mov r1, r9
	eors r1, r0
	mov r10, r4
	mov r4, r8
	asrs r0, #1
	eors r0, r4
	mov r4, r10
	adcs r0, r4
	adcs r1, r5
	adcs r2, r6
	adcs r3, r7
	eors r4, r4
	adcs r4, r4
	mov r10, r4 ;//carry
	mov r4, r11
	ldm r4, {r4-r7}
	adds r0, r4
	adcs r1, r5
	adcs r2, r6
	adcs r3, r7
	mov r9, r4
	mov r4, r11
	stm r4!, {r0-r3}
	mov r11, r4
	pop {r0-r3}
	mov r4, r9
	adcs r4, r0
	adcs r5, r1
	adcs r6, r2
	adcs r7, r3
	movs r1, #0
	adcs r1, r1
	mov r0, r10
	mov r10, r1 ;//carry
	asrs r0, #1
	pop {r0-r3}
	adcs r4, r0
	adcs r5, r1
	adcs r6, r2
	adcs r7, r3
	mov r8, r0
	mov r0, r11
	stm r0!, {r4-r7}
	mov r11, r0
	mov r0, r8
	mov r6, r12
	mov r5, r10
	eors r4, r4
	adcs r5, r6
	adcs r6, r4
	adds r0, r5
	adcs r1, r6
	adcs r2, r6
	adcs r3, r6
	mov r7, r11
	stm r7!, {r0-r3}
	pop {r3-r6}
	mov r8, r3
	mov r9, r4
	mov r10, r5
	mov r11, r6
	pop {r4-r7,pc}
						BX lr 
		
						ENDP
			
						END