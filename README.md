# ADI Summer 2025 – Digital IC Design Internship  
## Final Project: Fast Fourier Transform (FFT)  
---

## 📌 Project Overview  
This repository contains the work completed during my **final internship project** at **Analog Devices** as part of the Digital IC Design Internship (Summer 2025).  

The project focuses on the **Fast Fourier Transform (FFT)** and its end-to-end design flow: from **algorithm exploration** to **ASIC and FPGA implementation**.  

---

## 🛠️ Project Phases  

1. **Phase 0 – FFT Algorithm**  
   - Studied **Radix-2 FFT algorithm**.  
   - Derived the **mathematical formulation**.  
   - Explored decomposition approaches: **DIT (Decimation-In-Time)** and **DIF (Decimation-In-Frequency)**.  
   - Implemented the **butterfly operation**, the core building block of FFT.  
   - Implemented an **8-point FFT**, including **bit-reversal reordering**.  

2. **Phase 1 – System Modeling**  
   - Created a **golden reference model** for **bit-true validation**.  
   - Performed **algorithm verification** against reference outputs.  
   - Analyzed **performance prediction using SQNR (Signal-to-Quantization Noise Ratio)**.  
   - Justified why **system modeling comes first** in the design flow.  

3. **Phase 2 – RTL Design**  
   - Designed FFT architecture in **Verilog/SystemVerilog**.  
   - Optimized hardware structure for efficiency.  

4. **Phase 3 – RTL Verification**  
   - Built a **verification testbench**.  
   - Compared RTL results against golden reference vectors.  

5. **Phase 4 – ASIC Implementation**  
   - Synthesized FFT design for ASIC.  
   - Conducted **timing analysis** and **design optimizations**.  

6. **Phase 5 – FPGA Implementation**  
   - Implemented FFT design on FPGA hardware.  
   - Verified correctness and performance in real-time operation.  

