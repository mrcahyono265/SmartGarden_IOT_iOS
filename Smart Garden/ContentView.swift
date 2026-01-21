import SwiftUI

// --- KONFIGURASI WARNA TEMA ---
extension Color {
    static let themeBackground = Color(red: 0.96, green: 0.98, blue: 0.96)
    static let themePrimary = Color(red: 0.27, green: 0.60, blue: 0.43)
    static let themeSoil = Color(red: 0.60, green: 0.40, blue: 0.20)
    static let themeTextDark = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let statusRed = Color(red: 0.85, green: 0.3, blue: 0.3)
    static let statusOrange = Color.orange
    static let statusGreen = Color.green
    static let statusBlue = Color.blue
}

struct ContentView: View {
    @StateObject var blynk = BlynkManager()
    
    // --- VARIABEL DATA ---
    @State private var soilMoisture: String = "0"       // V12
    @State private var statusCode: Int = 0              // V10 (0,1,2,3)
    
    // --- STATUS KONEKSI (Fitur Baru) ---
    @State private var isDeviceOnline: Bool = false
    
    // --- SETTINGS ---
    @State private var inputLowMoist: Double = 40       // V7 (Ambang Bawah)
    @State private var inputHighMoist: Double = 75      // V6 (Ambang Atas)

    var body: some View {
        NavigationView {
            ZStack {
                Color.themeBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        
                        // 1. HEADER DENGAN STATUS ONLINE
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sistem Monitoring")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Kelas IOT A2")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.themeTextDark)
                            }
                            Spacer()
                            
                            // Indikator Online/Offline
                            VStack {
                                Circle()
                                    .fill(isDeviceOnline ? Color.green : Color.red)
                                    .frame(width: 15, height: 15)
                                    .shadow(color: isDeviceOnline ? .green.opacity(0.5) : .red.opacity(0.5), radius: 5)
                                Text(isDeviceOnline ? "ONLINE" : "OFFLINE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(isDeviceOnline ? .green : .red)
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 2)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 2. HERO CARD (Kelembapan - V12)
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(LinearGradient(gradient: Gradient(colors: [.themePrimary, .themePrimary.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: .themePrimary.opacity(0.4), radius: 10, x: 0, y: 10)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Kelembapan Tanah")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Text("\(soilMoisture)%")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    // Status Teks berdasarkan V10
                                    Text(getStatusLabel(code: statusCode))
                                        .font(.caption)
                                        .bold()
                                        .padding(8)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Image(systemName: "humidity.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(25)
                        }
                        .frame(height: 160)
                        .padding(.horizontal)

                        // 3. STATUS REKOMENDASI (V10)
                        // Menerjemahkan angka 0-3 dari Arduino menjadi Info Card
                        VStack(alignment: .leading) {
                            Text("Status & Rekomendasi")
                                .font(.headline)
                                .foregroundColor(.themePrimary)
                                .padding(.leading)
                            
                            HStack(spacing: 15) {
                                StatusCard(
                                    title: "Kondisi",
                                    value: getStatusLabel(code: statusCode),
                                    icon: getStatusIcon(code: statusCode),
                                    color: getStatusColor(code: statusCode)
                                )
                            }
                        }
                        .padding(.horizontal)

                        // 4. PENGATURAN PARAMETER (V7 & V6)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Kalibrasi Ambang Batas")
                                .font(.headline)
                                .foregroundColor(.themePrimary)
                                .padding(.leading)
                            
                            SettingSliderCard(
                                title: "Ambang Bawah (Kering)",
                                icon: "sun.max.fill",
                                value: $inputLowMoist,
                                range: 0...50,
                                accentColor: .themeSoil,
                                onCommit: { blynk.writePin(pin: "V7", value: String(Int(inputLowMoist))) }
                            )
                            
                            SettingSliderCard(
                                title: "Ambang Atas (Basah)",
                                icon: "cloud.rain.fill",
                                value: $inputHighMoist,
                                range: 50...100,
                                accentColor: .themePrimary,
                                onCommit: { blynk.writePin(pin: "V6", value: String(Int(inputHighMoist))) }
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Timer Data: Ambil data setiap 2 detik
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    fetchData()
                }
            }
        }
    }
    
    // --- LOGIKA UTAMA ---
    func fetchData() {
        // 1. Cek Koneksi Hardware
        blynk.checkHardwareConnection { online in
            self.isDeviceOnline = online
            
            // Jika Offline, data lain tidak perlu diambil (opsional)
            if !online { return }
            
            // 2. Ambil Kelembapan (V12)
            blynk.readPin(pin: "V12") { val in
                if let v = val, !v.contains("error") {
                    let doubleVal = Double(v) ?? 0
                    self.soilMoisture = String(format: "%.0f", doubleVal)
                }
            }
            
            // 3. Ambil Status Code (V10) - Ini Angka 0,1,2,3
            blynk.readPin(pin: "V10") { val in
                if let v = val, let intVal = Int(v) {
                    self.statusCode = intVal
                }
            }
        }
    }
    
    // Helper: Menerjemahkan Kode Angka Arduino ke Teks/Warna
    func getStatusLabel(code: Int) -> String {
        switch code {
        case 0: return "IDLE (Basah)"
        case 1: return "NORMAL"
        case 2: return "REKOMENDASI SIRAM"
        case 3: return "DARURAT (Kering)"
        default: return "Menunggu Data..."
        }
    }
    
    func getStatusColor(code: Int) -> Color {
        switch code {
        case 0: return .statusBlue    // Basah
        case 1: return .statusGreen   // Normal
        case 2: return .statusOrange  // Warning
        case 3: return .statusRed     // Bahaya
        default: return .gray
        }
    }
    
    func getStatusIcon(code: Int) -> String {
        switch code {
        case 0: return "cloud.rain.fill"
        case 1: return "leaf.fill"
        case 2: return "drop.triangle.fill"
        case 3: return "exclamationmark.triangle.fill"
        default: return "questionmark.circle"
        }
    }
}

// --- SUB-COMPONENTS ---
struct StatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.caption).foregroundColor(.gray)
                Text(value).font(.title3).bold().foregroundColor(color)
            }
            Spacer()
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct SettingSliderCard: View {
    let title: String
    let icon: String
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double = 1
    var accentColor: Color
    var onCommit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon).foregroundColor(accentColor)
                Text(title).font(.subheadline).bold().foregroundColor(.gray)
                Spacer()
                Text("\(String(format: "%.0f", value))").bold().foregroundColor(accentColor)
            }
            Slider(value: $value, in: range, step: step) { editing in
                if !editing { onCommit() }
            }
            .accentColor(accentColor)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}
