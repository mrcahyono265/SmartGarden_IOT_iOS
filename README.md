# 🌱 Smart Garden Monitoring System (iOS App)

![Platform](https://img.shields.io/badge/Platform-iOS-blue)
![Language](https://img.shields.io/badge/Language-Swift-orange)
![Hardware](https://img.shields.io/badge/Hardware-ESP32-green)
![Cloud](https://img.shields.io/badge/Cloud-Blynk-success)

Aplikasi iOS untuk memantau kelembapan tanah dan memberikan rekomendasi penyiraman otomatis berbasis IoT. Proyek ini dibuat untuk memenuhi tugas **Kelas IOT A2**.

## 📱 Fitur Utama

- **Real-time Monitoring:** Menampilkan persentase kelembapan tanah secara langsung dari sensor.
- **Status Connection:** Indikator otomatis untuk mengetahui apakah alat (ESP32) sedang Online atau Offline.
- **Sistem Rekomendasi Cerdas:** Memberikan status aksi berdasarkan kondisi tanah:
  - 🔵 **IDLE:** Tanah basah (Aman).
  - 🟢 **NORMAL:** Kondisi tanah ideal.
  - 🟠 **REKOMENDASI SIRAM:** Tanah mulai kering.
  - 🔴 **DARURAT:** Tanah sangat kering.
- **Kalibrasi Parameter:** Slider untuk mengatur ambang batas (Threshold) kering dan basah langsung dari aplikasi.

## 🛠️ Teknologi yang Digunakan

- **Software:**
  - Swift 5 & SwiftUI (iOS Development).
  - Xcode 15+.
  - Platform IO.
  - Framework Arduino.
  - Blynk IoT HTTP REST API.
- **Hardware:**
  - ESP32 DevKit V1.
  - Capacitive Soil Moisture Sensor.

## 🚀 Cara Menjalankan Project

1.  Clone repository ini:
    ```bash
    git clone [https://github.com/username-kalian/smart-garden-ios.git](https://github.com/username-kalian/smart-garden-ios.git)
    ```
2.  Buka file `SmartGarden.xcodeproj` menggunakan Xcode.
3.  Buka file `BlynkManager.swift`.
4.  Masukkan **Auth Token** Blynk kalian pada variabel:
    ```swift
    let authToken = "MASUKKAN_TOKEN_BLYNK_DISINI"
    ```
5.  Jalankan aplikasi (Cmd + R) ke Simulator atau Device iPhone asli.

## 👥 Tim Pengembang (Kelas IOT A2)
### 💻 Programming
•⁠  ⁠*Mohammad Ridho Cahyono*
•⁠  ⁠*Muhammad Rafi Aditya*
•⁠  ⁠*Hasbi Abdullah*
•⁠  ⁠*Rizky Cahyono*
•⁠  ⁠*Rizky Al-Ghifary*


### ⚙️ Mekanikal
•⁠  ⁠*Nero Caesar Suprobo*
•⁠  ⁠*Jauhan Ahmad*
•⁠  ⁠*Muhammad Setya Adjie*
•⁠  ⁠*Raffa Arvel*
•⁠  ⁠*Firdis Firnadi*
•⁠  ⁠*Muhammad Irfansyah*
•⁠  ⁠*Nur Muhammad Ridho As-syauqi*

### ⚡ Elektrika
•⁠  ⁠*Wafa Bila Syaefurakhman*
•⁠  ⁠*Muhammad Misbahul Muflihin*
•⁠  ⁠*Ghulam Musthofa*
•⁠  ⁠*MHD. Nurdhin Al-Kahfi*
•⁠  ⁠*Muhammad Faiz Nashih Rozaq*
•⁠  ⁠*Yusuf Al-bana*
•⁠  ⁠*Muhammad Akmal Najib Gunawan*
•⁠  ⁠*Muhammad Haekal*
•⁠  ⁠*Syaifan Nur Irawan*

# Smart Irrigation Decision Support System (DSS) - ESP32 & Blynk
---
Dikembangkan oleh **TI A2**
Mahasiswa Teknik Informatika - Universitas Darussalam Gontor - Angkatan 2023
