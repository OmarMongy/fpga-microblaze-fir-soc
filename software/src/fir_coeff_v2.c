#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

// Base address from the Address Editor screenshot
#define FIR_IP_BASE_ADDR   0x44A00000
#define FIR_COEFF_OFFSET   0x00

int main() {
    print("--- FIR Filter Coefficient Loader Started ---\n\r");

    // Array containing your 51 FIR filter coefficients
    const u16 coefficients[51] = {
        0x041C, 0x00DB, 0x00C8, 0x0090, 0x003B, 0xFFCB, 0xFF46, 0xFDFB,
        0xFC72, 0xFDC8, 0xFDD6, 0xFBD3, 0xFB11, 0xFC01, 0xFE0A, 0xFFB7,
        0x0127, 0x02B2, 0x0464, 0x0625, 0x07D8, 0x096C, 0x0AC3, 0x0BC4,
        0x0C6E, 0x0CA0, 0x0C6E, 0x0BC4, 0x0AC3, 0x096C, 0x07D8, 0x0625,
        0x0464, 0x02B2, 0x0127, 0xFFB7, 0xFE0A, 0xFC01, 0xFB11, 0xFBD3,
        0xFDD6, 0xFDC8, 0xFC72, 0xFDFB, 0xFF46, 0xFFCB, 0x003B, 0x0090,
        0x00C8, 0x00DB, 0x041C
    };

    int num_coeffs = sizeof(coefficients) / sizeof(coefficients[0]);
    printf("Writing %d coefficients to FIR IP at base address 0x%08X...\n\r", num_coeffs, FIR_IP_BASE_ADDR);

    // Loop through and write each coefficient using 32-bit AXI-Lite writes
    for (int i = 0; i < num_coeffs; i++) {
        u32 target_addr = FIR_IP_BASE_ADDR + FIR_COEFF_OFFSET + (i * 4);
        Xil_Out32(target_addr, (u32)coefficients[i]);
    }

    print("--- Coefficients Successfully Loaded --- \n\r");
    return 0;
}
