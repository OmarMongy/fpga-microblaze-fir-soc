#include <stdint.h>
#include "xil_io.h"

#define FIR_BASEADDR  0x44A00000U
#define NUM_TAPS      51U

int main(void)
{
    uint32_t i;

    const uint32_t coeff[NUM_TAPS] =
    {
        0x041C, /*  0.0321 */
        0x00DB, /*  0.0067 */
        0x00C8, /*  0.0061 */
        0x0090, /*  0.0044 */
        0x003B, /*  0.0018 */
        0xFFCB, /* -0.0016 */
        0xFF46, /* -0.0056 */
        0xFDFB, /* -0.0099 */
        0xFC72, /* -0.0140 */
        0xFDC8, /* -0.0174 */
        0xFDD6, /* -0.0197 */
        0xFBD3, /* -0.0204 */
        0xFB11, /* -0.0191 */
        0xFC01, /* -0.0156 */
        0xFE0A, /* -0.0096 */
        0xFFB7, /* -0.0014 */
        0x0127, /*  0.0090 */
        0x02B2, /*  0.0211 */
        0x0464, /*  0.0343 */
        0x0625, /*  0.0480 */
        0x07D8, /*  0.0614 */
        0x096C, /*  0.0737 */
        0x0AC3, /*  0.0841 */
        0x0BC4, /*  0.0921 */
        0x0C6E, /*  0.0972 */
        0x0CA0, /*  0.0989 */
        0x0C6E, /*  0.0972 */
        0x0BC4, /*  0.0921 */
        0x0AC3, /*  0.0841 */
        0x096C, /*  0.0737 */
        0x07D8, /*  0.0614 */
        0x0625, /*  0.0480 */
        0x0464, /*  0.0343 */
        0x02B2, /*  0.0211 */
        0x0127, /*  0.0090 */
        0xFFB7, /* -0.0014 */
        0xFE0A, /* -0.0096 */
        0xFC01, /* -0.0156 */
        0xFB11, /* -0.0191 */
        0xFBD3, /* -0.0204 */
        0xFDD6, /* -0.0197 */
        0xFDC8, /* -0.0174 */
        0xFC72, /* -0.0140 */
        0xFDFB, /* -0.0099 */
        0xFF46, /* -0.0056 */
        0xFFCB, /* -0.0016 */
        0x003B, /*  0.0018 */
        0x0090, /*  0.0044 */
        0x00C8, /*  0.0061 */
        0x00DB, /*  0.0067 */
        0x041C  /*  0.0321 */
    };

    /* Configure FIR coefficients */
    for (i = 0; i < NUM_TAPS; i++)
    {
        Xil_Out32(FIR_BASEADDR + (i * 4U), coeff[i]);
    }

    /*
     * MicroBlaze has finished configuring the FIR.
     *
     * AXI4-Stream data processing is handled entirely
     * by the FIR hardware.
     */

    while (1)
    {
        /* CPU can remain idle */
    }

    return 0;
}
