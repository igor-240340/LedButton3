.include "m328Pdef.inc"

.def tmp = r16
.def st_L = r17
.def st_H = r18
.def sw_cod = r22
.def reg_led = r23

.macro testL_sw
            sbic PIND, @0
            rjmp quit
            bld sw_cod, @0
            eor st_L, sw_cod
            mov reg_led, sw_cod
            or reg_led, st_H
            com reg_led
            out PORTB, reg_led
            clr sw_cod
            rcall DELAY_0
            ori reg_led, 0x0f
            out PORTB, reg_led
quit:       nop
.endmacro

.macro testH_sw
            sbic PIND, @0
            rjmp quit
            bld sw_cod, @0
            eor st_H, sw_cod
            mov reg_led, st_H
            com reg_led
            out PORTB, reg_led
            clr reg_led
            clr sw_cod
            rcall Delay
Wait:       sbis PIND, @0
            rjmp Wait
quit:       nop
.endmacro

.org 0x00
            jmp Reset

Reset:      ldi tmp, low(RAMEND)    ; Stack Pointer
            out SPL, tmp
            ldi tmp, high(RAMEND)
            out SPH, tmp
            ser tmp                 ; PORTB out
            out DDRB, tmp
            out PORTB, tmp
            
            clr tmp                 ; PORTD in
            out DDRD, tmp
            ser tmp
            out PORTD, tmp
            
            clr sw_cod
            clr st_L
            clr st_H
            clr reg_led

            set

Input:      testL_sw 0
            testL_sw 1
            testL_sw 2
            testL_sw 3
            
            testH_sw 4
            testH_sw 5
            testH_sw 6
            testH_sw 7
            rjmp Input

Delay_0:    ldi r21, 255
d0:         dec r21
            brne d0
            ret

Delay:      ldi r19, 10
d1:         ldi r20, 255
d2:         ldi r21, 255
d3:         dec r21
            brne d3
            dec r20
            brne d2
            dec r19
            brne d1
            ret
