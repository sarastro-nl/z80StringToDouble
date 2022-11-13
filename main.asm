chput:        equ   &ha2

	          org   &h4000
ROMheader:          defb    "AB"
                    defw    execute
                    defw    0, 0, 0, 0, 0, 0

.newLine:           defb 13, 10, 0
.doneString:        defb "done", 13, 10, 0

;.dacInput:          defb &hBF, &hE9, &h99, &h99, &h99, &h99, &h99, &h9A ; -0.8
;.dacInput:          defb &h3F, &hF0, &h28, &h74, &h42, &hC7, &hFB, &hAD ; 1.0098765
;.dacInput:          defb &h3F, &hFF, &hCD, &h6A, &h16, &h1E, &h4F, &h76 ; 1.98765
;.dacInput:          defb &h3F, &hF1, &hF9, &h72, &h47, &h45, &h38, &hEF ; 1.1234
;.dacInput:          defb &h40, &h8F, &hFB, &h67, &h25, &hA3, &h78, &h77 ; 1023.4253647586
;.dacInput:          defb &h3D, &h50, &h7F, &h50, &h48, &h27, &h11, &h7D ; 2.34441*10^-13
;.dacInput:          defb &hFF, &hFF, &hFF, &hFF, &hFF, &hFF, &hFF, &hFF
;.dacInput:          defb 255, 255, 255, 255, 255, 255, 255, 251
;.dacInput:          defb 0, 0, 0, 0, 0, 0, 0, 30
;.argInput:          defb 0, 0, 0, 0, 0, 0, 10, 35

;.doubleInput:       defb "+0.12343e-4", 0
;.doubleInput:       defb "-009.123456e-111", 0
;.doubleInput:       defb "0.124999", 0
;.doubleInput:       defb "2.99792458e8", 0
;.doubleInput:       defb "0.12343e-24", 0
.doubleInput:       defb "6.62607015e-34", 0
;.doubleInput:       defb ".7450580596923828125", 0
;.doubleInput:       defb "19.9345", 0

; RAM details
RAM1start:    equ   &hc000
include "U8bit/printU8bit.asm"    ; 0
RAM2start:    equ   RAM1end
include "16bit/print16bit.asm"
RAM3start:    equ   RAM2end
include "UInt64/UInt64.asm"
RAM4start:    equ   RAM3end
include "Double/Double.asm"
dac:          equ   RAM4end         ; 8 bytes
arg:          equ   dac + 8         ; 8 bytes

execute:
              ld    hl, .doubleInput
              call  .printString
              ld    hl, .newLine
              call  .printString

              ld    hl, .doubleInput
              call  parseDouble
              call  initDouble
              call  printDoubleHex

              ld    hl, .doneString
              call  .printString

.done:        jr    .done

.printString:
              ld    a, (hl)
              or    a
              ret   z
              call  chput
              inc   hl
              jr    .printString

.filler:	          defs    &h4000 - ($ - ROMheader)
