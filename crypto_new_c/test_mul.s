					AREA |.test1|,CODE, READONLY
	
					EXPORT multiply32x32_asm
		
multiply32x32_asm 	PROC
	
	push {r3-r5}
	; R0 input , R1 input 2, R3 output address
	lsrs r3,r1,#16								; r3 = hi[2]
	uxth r1,r1									; r1 = lo[2]
	mov  r4,r1									; r4 = lo[2]
	uxth r5,r0									; r5 = lo[1]
	lsrs r0,#16									; r0 = hi[1]
	muls r4,r5,r4								; lo[1] x lo[2] => save into lo[2] 
	muls r5,r3,r5 								; hi[2] x lo[1] => save into lo[1] hilo1
	muls r1,r0,r1 								; hi[1] x lo[2] => save into lo[2] hilo2
	muls r3,r0,r3 								; hi[1] x hi[2] => save into hi[2] 
	lsls r0,r5,#16								; L of hilo 1
	lsrs r5,r5,#16								; R of hilo 1
	adds r4,r0									; lolo + L hilo1
	adcs r3,r5									; hihi + R hilo1
	lsls r0,r1,#16								; L of hilo2
	lsrs r5,r1,#16								; R of hilo2
	adds r4,r0									; lolo + L hilo2
	adcs r3,r5									; hihi + R hilo2
	str  r4,[r2,#0x00]
	str  r3,[r2,#0x04]	
	pop  {r3-r5}
	
					BX lr
					
					ENDP
						
						AREA |.test1|,CODE, READONLY
	
						EXPORT multiply32x32_asm_m4
		
multiply32x32_asm_m4 	PROC					

	umull r0,r1,r0,r1
	str  r0,[r2,#0x00]
	str  r1,[r2,#0x04]
						BX lr
					
						ENDP


					EXPORT test_low_mid
test_low_mid 		PROC
	; r0 address of low
	; r1 address of mid 
	push {r3-r7}
	ldm r0!,{r3,r4,r5,r6}			; move first 4 words of low
	stm r2!,{r3,r4,r5,r6}			; save first 4 words of low
	ldm r0!,{r3,r4,r5,r6}			; move 2nd first 4 word of low
	stm r2!,{r3,r4,r5,r6}			; save 2nd 4 words of low
	ldm r0!,{r3,r4,r5,r6}			; move 3rd 4 word of low
	ldr r7,[r1,#0x00]				; get 1st word of mid 
	adds r3,r3,r7					; update 9th word	
	ldr r7,[r1,#0x04]				; get 2nd word of mid
	adcs r4,r4,r7					; update 10th word
	ldr r7,[r1,#0x08]				; get 3rd word of mid 
	adcs r5,r5,r7					; update 11th word
	ldr r7,[r1,#0x0C]				; get 4th word of mid 
	adcs r6,r6,r7					; update 12th word
	stm r2!,{r3,r4,r5,r6}			; save 4 words of low + 4 first word mid
	ldm r0!,{r3,r4,r5,r6}			; move last 4 word of low
	ldr r7,[r1,#0x10]				; get 5th word of mid 
	adcs r3,r3,r7					; update 13th word	
	ldr r7,[r1,#0x14]				; get 6th word of mid
	adcs r4,r4,r7					; update 14th word
	ldr r7,[r1,#0x18]				; get 7th word of mid 
	adcs r5,r5,r7					; update 15th word
	ldr r7,[r1,#0x1C]				; get 8th word of mid 
	adcs r6,r6,r7					; update 16th word
	stm r2!,{r3,r4,r5,r6}			; save last 4 words of low + 4 first word mid	
	ldr r3,[r1,#0x20]				; get 9th word of mid 
	adcs r3,r3,#0x00				; update the c flag 9th word mid
	ldr r4,[r1,#0x24]				; get 10th word of mid 
	adcs r4,r4,#0x00				; update the c flag 10th word mid
	ldr r5,[r1,#0x28]				; get 11th word of mid 
	adcs r5,r5,#0x00				; update the c flag 11th word mid
	ldr r6,[r1,#0x2C]				; get 12th word of mid 
	adcs r6,r6,#0x00				; update the c flag 12th word mid
	stm r2!,{r3,r4,r5,r6}			; save 2nd 4 words of low
	ldr r3,[r1,#0x30]				; get 13th word of mid 
	adcs r3,r3,#0x00				; update the c flag 13th word mid
	ldr r4,[r1,#0x34]				; get 14th word of mid 
	adcs r4,r4,#0x00				; update the c flag 14th word mid
	ldr r5,[r1,#0x38]				; get 15th word of mid 
	adcs r5,r5,#0x00				; update the c flag 15th word mid
	ldr r6,[r1,#0x3C]				; get 16th word of mid 
	adcs r6,r6,#0x00				; update the c flag 16th word mid
	movs r7,#0x00
	adcs r7,r7,#0x00				; update the c flag 17th word mid
	stm r2!,{r3,r4,r5,r6,r7}		; save 2nd 4 words of low
	pop {r3-r7}
	
	
					BX lr
	
					ENDP






				EXPORT test_mid
test_mid 		PROC
	; r0 address of mid
	; r1 address of output 
	push {r3-r7}
	add r1,r1,#0x20					; point the output to the 8th word
	ldm r1,{r3,r4,r5,r6}			; load first 4 words
	ldr r7,[r0,#0x00]				; get 1st word of mid 
	adds r3,r3,r7					; update 1st word	
	ldr r7,[r0,#0x04]				; get 2nd word of mid
	adcs r4,r4,r7					; update 2nd word
	ldr r7,[r0,#0x08]				; get 3rd word of mid 
	adcs r5,r5,r7					; update 3rd word
	ldr r7,[r0,#0x0C]				; get 4th word of mid 
	adcs r6,r6,r7					; update 4th word
	stm r1!,{r3,r4,r5,r6}			; save 4 words + 4 first word mid
	; next 4 words
	ldm r1,{r3,r4,r5,r6}			; load first 4 words
	ldr r7,[r0,#0x10]				; get 5th word of mid 
	adcs r3,r3,r7					; update 5th word	
	ldr r7,[r0,#0x14]				; get 6th word of mid
	adcs r4,r4,r7					; update 6th word
	ldr r7,[r0,#0x18]				; get 7th word of mid 
	adcs r5,r5,r7					; update 7th word
	ldr r7,[r0,#0x1C]				; get 8th word of mid 
	adcs r6,r6,r7					; update 8th word
	stm r1!,{r3,r4,r5,r6}			; save 4 words + 4 first word mid
	; next 4 words
	ldm r1,{r3,r4,r5,r6}			; load first 4 words
	ldr r7,[r0,#0x20]				; get 9th word of mid 
	adcs r3,r3,r7					; update 9th word	
	ldr r7,[r0,#0x24]				; get 10th word of mid
	adcs r4,r4,r7					; update 10th word
	ldr r7,[r0,#0x28]				; get 11th word of mid 
	adcs r5,r5,r7					; update 11th word
	ldr r7,[r0,#0x2C]				; get 12th word of mid 
	adcs r6,r6,r7					; update 12th word
	stm r1!,{r3,r4,r5,r6}			; save 4 words + 4 first word mid
	; next 4 words
	ldm r1,{r3,r4,r5,r6}			; load first 4 words
	ldr r7,[r0,#0x30]				; get 13th word of mid 
	adcs r3,r3,r7					; update 13th word	
	ldr r7,[r0,#0x34]				; get 14th word of mid
	adcs r4,r4,r7					; update 14th word
	ldr r7,[r0,#0x38]				; get 15th word of mid 
	adcs r5,r5,r7					; update 15th word
	ldr r7,[r0,#0x3C]				; get 16th word of mid 
	adcs r6,r6,r7					; update 16th word
	movs r7,#0x00
	adcs r7,r7,#0x00				; update the c flag 17th word mid
	stm r1!,{r3,r4,r5,r6,r7}		; save 2nd 4 words of low
	pop {r3-r7}
	
	
				BX lr
	
				ENDP


				EXPORT test_high
test_high 		PROC
	; r0 address of high
	; r1 address of output 
	; only care first 8 words	
	push {r3-r7}
	add r1,r1,#0x40
	ldm r1,{r3,r4,r5,r6}			; load first 4 words
	ldr r7,[r0,#0x00]				; get 1st word of mid 
	adds r3,r3,r7					; update 1st word	
	ldr r7,[r0,#0x04]				; get 2nd word of mid
	adcs r4,r4,r7					; update 2nd word
	ldr r7,[r0,#0x08]				; get 3rd word of mid 
	adcs r5,r5,r7					; update 3rd word
	ldr r7,[r0,#0x0C]				; get 4th word of mid 
	adcs r6,r6,r7					; update 4th word
	stm r1!,{r3,r4,r5,r6}			; save 4 words + 4 first word high_low1
	; next 4 words
	ldm r1,{r3,r4,r5,r6}			; load first 4 words
	ldr r7,[r0,#0x10]				; get 5th word of mid 
	adcs r3,r3,r7					; update 5th word	
	ldr r7,[r0,#0x14]				; get 6th word of mid
	adcs r4,r4,r7					; update 6th word
	ldr r7,[r0,#0x18]				; get 7th word of mid 
	adcs r5,r5,r7					; update 7th word
	ldr r7,[r0,#0x1C]				; get 8th word of mid 
	adcs r6,r6,r7					; update 8th word
	stm r1!,{r3,r4,r5,r6}			; save 4 words + 4 first word high_low2
	; next 8 words just need to get the data and update them
	
	ldr r3,[r0,#0x20]				; get 24th word of end
	ldr r7,[r1,#0x00]
	adcs r3,r3,r7					; update the c flag 9th word mid
	ldr r4,[r0,#0x24]				; get 10th word of mid 
	adcs r4,r4,#0x00				; update the c flag 10th word mid
	ldr r5,[r0,#0x28]				; get 11th word of mid 
	adcs r5,r5,#0x00				; update the c flag 11th word mid
	ldr r6,[r0,#0x2C]				; get 12th word of mid 
	adcs r6,r6,#0x00				; update the c flag 12th word mid
	stm r1!,{r3,r4,r5,r6}			; save 2nd 4 words of low
	ldr r3,[r0,#0x30]				; get 13th word of mid 
	adcs r3,r3,#0x00				; update the c flag 13th word mid
	ldr r4,[r0,#0x34]				; get 14th word of mid 
	adcs r4,r4,#0x00				; update the c flag 14th word mid
	ldr r5,[r0,#0x38]				; get 15th word of mid 
	adcs r5,r5,#0x00				; update the c flag 15th word mid
	ldr r6,[r0,#0x3C]				; get 16th word of mid 
	adcs r6,r6,#0x00				; update the c flag 16th word mid
	stm r1!,{r3,r4,r5,r6}			; save 2nd 4 words of low
	pop {r3-r7}
	
	
				BX lr
	
				ENDP



					END