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
     <img width="862" height="434" alt="image" src="https://github.com/user-attachments/assets/14d2578d-2151-4ff0-965d-a9abc605ba45" />
   ---
2. **Phase 1 – System Modeling**  
   - Created a **golden reference model** for **bit-true validation**.  
   - Performed **algorithm verification** against reference outputs.
     <img width="1400" height="241" alt="image" src="https://github.com/user-attachments/assets/98c4f1c3-b78d-432b-a61e-c3487a5e130d" />
   - Analyzed **performance prediction using SQNR (Signal-to-Quantization Noise Ratio)**.
     <img width="1000" height="273" alt="image" src="https://github.com/user-attachments/assets/06aa2e3e-7186-435c-8ac1-a21701867d9e" />
   - Justified why **system modeling comes first** in the design flow.  
   ---
3. **Phase 2 – RTL Design**  
   - Designed FFT architecture in **Verilog**.
     <img width="919" height="715" alt="image" src="https://github.com/user-attachments/assets/a61d443f-125c-412b-8420-9d75b3cceb2e" />
   - Implemented Round & Sat to match Matlab Model
   - Permitted a small tolerance (0.02348) between RTL and Matlab Model
   - Optimized hardware structure for efficiency.
     <img width="1743" height="192" alt="image" src="https://github.com/user-attachments/assets/81501c4c-4807-4723-8fff-5c9b8e0bd40d" />
   ---
4. **Phase 3 – RTL Verification**  
   - Built a **verification testbench**.
    <img width="993" height="376" alt="image" src="https://github.com/user-attachments/assets/54c9b206-56c0-4aa5-ae58-375ddcad5672" />
   - Compared RTL results against golden reference vectors.
    <img width="606" height="290" alt="image" src="https://github.com/user-attachments/assets/922c18f4-32b7-4d01-99b7-e1ccce1a6696" />

   ---
5. **Phase 4 – ASIC Implementation**  
   - Synthesized FFT design for ASIC Implementation.  
   - Conducted **timing analysis** and **design optimizations**.
    <img width="956" height="786" alt="image" src="https://github.com/user-attachments/assets/2fc0634e-106a-469c-926c-7b97f9066129" />

   ---
6. **Phase 5 – FPGA Implementation**  
   - Implemented FFT design on FPGA hardware.
     <img width="996" height="359" alt="image" src="https://github.com/user-attachments/assets/80d0ad2f-7903-47b7-bf3e-76cf60373925" />
   - Verified correctness and performance in real-time operation.    
  ---
  **Thanks for exploeing my project, if there is any question do not hesitate to reach me out through mail:**
   ***khalid1422003123@gmail.com***
