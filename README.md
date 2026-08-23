# MicroBlaze-Based FPGA SoC for Programmable FIR Filtering

A simulation-based FPGA SoC demonstrating **hardware/software partitioning** using a MicroBlaze processor and a programmable RTL FIR filter.

The project explores how software running on an embedded processor can configure a hardware DSP accelerator through **AXI4-Lite**, while high-throughput sample data is transferred through **AXI4-Stream**.

The complete hardware/software system is functionally co-simulated in Vivado without requiring a physical FPGA board, QEMU, or PetaLinux.

---

## Overview

Digital signal-processing algorithms are often divided between software running on an embedded processor and dedicated hardware accelerators implemented in FPGA fabric.

This project demonstrates that concept using a programmable FIR filter:

- MATLAB is used for filter design, coefficient generation, signal generation, and golden-model verification.
- The FIR filter is implemented in RTL.
- The FIR is integrated as an AXI-based IP.
- A MicroBlaze processor configures the FIR coefficients through AXI4-Lite.
- Input and output samples are transferred using AXI4-Stream.
- The MicroBlaze software is compiled into an ELF executable.
- Vivado simulation executes the processor software together with the RTL hardware.

The key objective is to demonstrate the **hardware/software interface and partitioning**, rather than simply implementing a standalone FIR filter.

---

## System Architecture

![System Architecture](https://github.com/OmarMongy/fpga-microblaze-fir-soc/blob/main/docs/hw_sw_partitioning.jpg)

The system is divided into two main domains:

### Software / Control Plane

The MicroBlaze processor is responsible for:

- Configuring the FIR filter
- Writing the filter coefficients
- Controlling the accelerator
- Reading status information

### Hardware / Data Plane

The FPGA fabric is responsible for:

- Receiving streaming samples
- Performing the FIR filtering operation
- Producing the filtered streaming output

The two domains communicate through AXI interfaces.

```text
                    SOFTWARE
              ┌─────────────────┐
              │    MicroBlaze   │
              │                 │
              │ FIR Control     │
              │ Coefficient     │
              │ Configuration   │
              └────────┬────────┘
                       │
                    AXI4-Lite
                       │
                       ▼
              ┌─────────────────┐
              │ Programmable    │
              │ FIR Registers   │
              └────────┬────────┘
                       │
═══════════════════════╪════════════════════════
                       │
                    HARDWARE
                       │
             AXI4-Stream Input
                       │
                       ▼
              ┌─────────────────┐
              │   FIR Filter    │
              │      RTL        │
              └────────┬────────┘
                       │
             AXI4-Stream Output
                       │
                       ▼
                 Next Stage
```
## Complete Roadmap
```text
┌─────────────────────────────┐
│ 1. Design RTL Accelerator   │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 2. Verify RTL Independently │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 3. Add AXI Interfaces       │
│    AXI4-Lite + AXI4-Stream  │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 4. Package as Vivado IP     │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 5. Create MicroBlaze SoC    │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 6. Integrate Custom IP      │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 7. Assign AXI Addresses     │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 8. Generate Hardware        │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 9. Create Bare-Metal App    │
│    in SDK/Vitis             │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 10. Build Software          │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 11. Generate application.elf│
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 12. Associate ELF with     │
│     MicroBlaze Simulation   │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 13. Run HW/SW Co-Simulation │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│ 14. Verify Hardware +       │
│     Software Interaction    │
└─────────────────────────────┘
