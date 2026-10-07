; main.asm — 65816 assembly scratch / low-level routines
;
; This file is assembled by WLA-DX (bundled with PVSnesLib).
; Called from C via: extern void my_routine(void);
;
; Useful for performance-critical code, DMA setup,
; or direct hardware register access.
;
; ─────────────────────────────────────────────────────────────
; SNES memory map quick reference (LoROM):
;   $000000–$3FFFFF   ROM banks (mirrored)
;   $7E0000–$7FFFFF   WRAM (128KB)
;   $2100–$213F       PPU registers
;   $4200–$421F       I/O / IRQ registers
;   $4300–$437F       DMA registers
; ─────────────────────────────────────────────────────────────

.include "hdr.asm"    ; PVSnesLib SNES header definitions

.bank 0
.section "ExampleRoutine"

; void example_nop_loop(void)
; Callable from C. Does nothing useful — replace with real code.
example_nop_loop:
    php                 ; save processor flags
    rep #$30            ; 16-bit A and X/Y
    nop
    plp                 ; restore flags
    rtl                 ; long return (required for inter-bank calls)

.ends
