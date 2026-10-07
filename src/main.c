/*
 * main.c — SNES entry point (PVSnesLib)
 *
 * Build:  make
 * Output: wildcard-dx-dev.sfc
 */

#include <snes.h>

int main(void) {
    /* Basic SNES init — sets up DMA, PPU, IRQ */
    consoleInit();

    /* Configure the background: Mode 1, 8×8 tiles, 32×32 tilemap */
    bgSetGfxPtr(BG_GFX, 0x2000);
    bgSetMapPtr(BG_MAP, 0x1000, SC_32x32);
    setMode(BG_MODE1, BG_SIZE_256x224);

    /* Load a simple tile and print text */
    consoleInitText(0, 16 * 2, &snesfont, &snespal);
    consolePrint("Hello, SNES!\n");

    /* Enable display */
    setScreenOn();

    /* Main loop */
    while (1) {
        WaitForVBlank();
    }

    return 0;
}
