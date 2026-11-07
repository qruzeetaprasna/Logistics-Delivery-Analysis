# RINGKASAN EKSEKUTIF: AUDIT PERFORMA LOGISTIK & SLA OLIST BRAZIL

**Target Audiens:** Head of Logistics & Operations Olist  
**Penulis:** Data Analyst  
**Dataset:** Transaksi E-Commerce Olist Brazil (~99,4k Pesanan)  

---

## 1. Ringkasan Eksekutif (Executive Brief)

Analisis operasional terhadap 99.441 pesanan menunjukkan bahwa **Tingkat Keterlambatan Pengiriman (*Late Delivery Rate*) Olist saat ini berada di angka 8,11%** (7.827 pesanan terkirim melebihi batas estimasi SLA). Meskipun tingkat ketepatan waktu secara keseluruhan mencapai 91,89%, keterlambatan pengiriman terbukti menjadi faktor tunggal utama yang merusak kepuasan pelanggan:

* **Dampak terhadap Skor Rating (*Review Score*):** Pesanan yang terkirim Tepat Waktu mendapatkan rata-rata rating **4,29 / 5.0**, sedangkan pesanan yang Terlambat anjlok drastis menjadi **2,57 / 5.0** (penurunan ~40%).
* **Risiko Bisnis:** Keterlambatan memicu peningkatan tiket komplain *customer service*, meningkatkan angka *customer churn*, dan memperbesar total beban pengembalian biaya ongkir (*freight refund*).

---

## 2. Temuan Utama Operasional (Key Operational Findings)

### A. Kendala Penjual (Worst Performing Sellers)
* Keterlambatan pengiriman sangat terkonsentrasi pada penjual-penjual tertentu. Penjual terparah tercatat memiliki rata-rata keterlambatan hingga **64,7 hari** di luar janjinya SLA.
* **Akar Masalah:** Ketidakoperasionalkan proses *fulfillment* internal penjual (pemrosesan dan pengemasan barang) sebelum diserahkan ke kurir logistik.

### B. Kerentanan Geografis (Analisis Tingkat Negara Bagian)
* Wilayah **Alagoas (AL)** di timur laut Brasil mencatatkan tingkat keterlambatan tertinggi di angka **23,93%**—hampir 3 kali lipat dari rata-rata nasional (8,11%).
* **Akar Masalah:** Perhitungan algoritma estimasi waktu tiba (*dynamic SLA*) yang terlalu optimistis untuk rute jarak jauh, dikombinasikan dengan terbatasnya kapasitas kurir lokal di wilayah tersebut.

### C. Disparitas Biaya Ongkir (Freight Value vs Delivery SLA)
* Pesanan yang mengalami keterlambatan memiliki **rata-rata biaya ongkos kirim yang lebih mahal** dibandingkan pesanan yang tepat waktu.
* **Akar Masalah:** Pelanggan yang membayar ongkir lebih mahal (karena jarak pengiriman lebih jauh atau ukuran barang lebih besar) justru mendapatkan kualitas layanan logistik terburuk, yang melipatgandakan rasa kecewa mereka.

### D. Kerentanan Kategori Produk
* Kategori **`fashion_underwear_e_moda_praia`** (pakaian dalam & busana pantai) serta **`audio`** mencatatkan persentase keterlambatan tertinggi di tingkat kategori, yaitu sebesar **~12,00%**.

---

## 3. Rekomendasi Bisnis & Aksi Nyata (Actionable Business Recommendations)

| Bidang | Masalah Teridentifikasi | Rekomendasi Strategis | Target Indikator Kinerja (KPI) |
| --- | --- | --- | --- |
| **Seller Management** | Keterlambatan ekstrem dari penjual (hingga 64,7 hari). | **Penjenjangan SLA & Penalti:** Menerapkan pembatasan kuota pesanan (*order throttling*) atau pembekuan akun sementara bagi penjual dengan rata-rata keterlambatan *fulfillment* > 5 hari. | Menurunkan batas keterlambatan penjual dari **64,7 hari** menjadi **< 7,0 hari**. |
| **Logistics & Routing** | Keterlambatan 23,93% di wilayah Alagoas (AL). | **Rekalibrasi SLA Dinamis:** Menambahkan *buffer time* 3 hingga 5 hari pada algoritma estimasi pengiriman khusus untuk tujuan wilayah Timur Laut Brasil. | Menurunkan *late rate* di wilayah AL dari **23,93%** menjadi **< 12,00%**. |
| **Customer Experience** | Rata-rata rating anjlok ke 2,57 saat terjadi keterlambatan. | **Notifikasi Proaktif & Kredit Ongkir:** Mengirim notifikasi pemantauan otomatis sebelum SLA terlewati serta memberikan voucer potongan ongkir untuk pembelian berikutnya. | Meningkatkan *review score* pesanan terlambat dari **2,57** menjadi **> 3,20**. |
| **Product Inventory** | *Late rate* ~12% pada kategori Audio dan Fashion. | **Prioritisasi Fulfillment Center:** Memindahkan stok produk kategori berpermintaan tinggi ke *hub* distribusi yang lebih dekat dengan pusat jaringan pengiriman utama. | Menurunkan *late rate* kategori terparah dari **12,00%** menjadi **< 8,00%**. |

---

## 4. Matriks Proyeksi Dampak Bisnis (Projected Impact)

```text
[Kondisi Saat Ini]                      [Target Setelah Implementasi]
• Late Delivery Rate: 8.11%      --->   • Target Late Rate: < 5.00%
• Avg Rating (Late): 2.57        --->   • Target Rating (Late): > 3.20
• Max Seller Delay: 64.7 Hari    --->   • Target Max Delay: < 7.0 Hari
```