; optimized version for CPU with bigger instruction cache (040+)

	MACHINE	68040





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x1_addx_040
; Chunky 2 Planar conversion, 1 bit per pixel, optimized for 040+.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1_addx_040
	cnop	0,4
_c2p_8x1_addx_040:
	movem.l	d6-d7,-(sp)

	move.l	d0,d6
	lsr.l	#5,d6		; 32 pixels per loop

	dbra.w	d6,.c2p_prefetch
	nop

	cnop	0,64
.c2p_prefetch:
	; Interleaved MOVE + processing (faster than MOVEM on 68040+)
	move.l	(a0)+,d0	; D0 = 0, 1, 2, 3

.c2p_loop:
	move.l	(a0)+,d1	; D1 = 4, 5, 6, 7 (interleaved)
		; D7 will contains bpl0

	lsl.l	#8,d0		; bit 0
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 1
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 2
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 3
	addx.l	d7,d7
		; D0 = free to use

	move.l	(a0)+,d0	; D0 = 8, 9, 10, 11 (interleaved)

	lsl.l	#8,d1		; bit 4
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 5
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 6
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 7
	addx.l	d7,d7
		; D1 = free to use

	move.l	(a0)+,d1	; D1 = 12, 13, 14, 15 (interleaved)

	lsl.l	#8,d0		; bit 8
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 9
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 10
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 11
	addx.l	d7,d7
		; D0 = free to use

	move.l	(a0)+,d0	; D0 = 16, 17, 18, 19 (interleaved)

	lsl.l	#8,d1		; bit 12
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 13
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 14
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 15
	addx.l	d7,d7
		; D1 = free to use

	move.l	(a0)+,d1	; D1 = 20, 21, 22, 23 (interleaved)

	lsl.l	#8,d0		; bit 16
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 17
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 18
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 19
	addx.l	d7,d7
		; D0 = free to use

	move.l	(a0)+,d0	; D0 = 24, 25, 26, 27 (interleaved)

	lsl.l	#8,d1		; bit 20
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 21
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 22
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 23
	addx.l	d7,d7
		; D1 = free to use

	move.l	(a0)+,d1	; D1 = 28, 29, 30, 31 (interleaved)

	lsl.l	#8,d0		; bit 24
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 25
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 26
	addx.l	d7,d7
	lsl.l	#8,d0		; bit 27
	addx.l	d7,d7
		; D0 = free to use

	move.l	(a0)+,d0	; D0 = 0, 1, 2, 3 (interleaved, next round)

	lsl.l	#8,d1		; bit 28
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 29
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 30
	addx.l	d7,d7
	lsl.l	#8,d1		; bit 31
	addx.l	d7,d7
		; D1 = free to use

	move.l	d7,(a1)+		;write bpl0
		;d7 = free for use

	dbra	d6,.c2p_loop
.c2p_loop_end:

;	; DEBUG: trying to calculate the loop code size in bytes
;	lea		.c2p_loop,a0
;	lea		.c2p_loop_end,a1
;	move.l	a1,d0
;	sub.l	a0,d0	; 0x96 = 150 bytes
;	nop

			;------;
			; exit ;
			;------;

.c2p_exit:

	movem.l	(sp)+,d6-d7
	rts
  
	end

