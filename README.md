# Operations & Logistics Delivery Performance Analysis

## 📌 Latar Belakang & Masalah Bisnis
Dalam industri e-commerce dan ritel modern, ketepatan waktu pengiriman (*Delivery Service Level Agreement / SLA*) dan efisiensi biaya operasional merupakan dua faktor kunci yang menentukan kepuasan pelanggan serta keberlanjutan margin bisnis. Keterlambatan pengiriman tidak hanya meningkatkan biaya penanganan (*handling cost*) dan retur barang, tetapi juga berdampak langsung pada penurunan skor kepuasan pelanggan (*customer rating*) serta hilangnya potensi pemesanan ulang (*repurchase rate*).

Proyek analisis data ini bertujuan untuk mengevaluasi performa operasional logistik secara menyeluruh. Dengan menganalisis data transaksi pengiriman, proyek ini berfokus pada pengidentifikasian akar penyebab keterlambatan, pemetaan wilayah berisiko tinggi, serta evaluasi dampaknya terhadap kepuasan pelanggan dan biaya pengiriman.

---

## 📂 Sumber Dataset & Lisensi
* **Dataset:** Brazilian E-Commerce Public Dataset by Olist / E-Commerce Logistics Dataset
* **Sumber Data:** [Kaggle - Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* **Lisensi:** CC0: Public Domain (Open-access data untuk penggunaan analisis publik dan portofolio)
* **Skema Data:** Terdiri dari entitas relasional meliputi transaksi pemesanan (`orders`), rinci barang (`order_items`), pelanggan (`customers`), lokasi/wilayah (`geolocation`), serta ulasan ulasan pelanggan (`order_reviews`).

---

## ❓ Daftar 6 Pertanyaan Bisnis (SQL Analysis)
1. **Performa SLA Pengiriman:** Berapa persentase total pesanan yang mengalami keterlambatan pengiriman (*late delivery rate*) dibandingkan estimasi tanggal tiba (*promised delivery date*)?
2. **Keterlambatan per Mitra/Kurir:** Mitra/ekspedisi pengiriman (*seller/carrier*) mana yang memiliki rata-rata durasi keterlambatan (*avg delay days*) paling tinggi?
3. **Analisis Wilayah (Geografi):** 5 kota/wilayah tujuan (*customer city/state*) mana yang memiliki tingkat keterlambatan pengiriman terbanyak?
4. **Dampak Biaya Ongkir:** Berapa perbedaan rata-rata biaya pengiriman (*shipping cost*) antara pesanan yang tiba tepat waktu dibandingkan pesanan yang terlambat?
5. **Dampak pada Rating Pelanggan:** Berapa penurunan rata-rata skor ulasan pelanggan (*customer review score*) akibat keterlambatan pengiriman?
6. **Optimasi Wilayah Asal/Gudang:** Wilayah asal pengiriman (*seller/warehouse location*) mana yang menyumbang tingkat keterlambatan terbanyak?

---

## 🛠️ Tools & Teknologi
* **Database:** PostgreSQL / MySQL / SQLite
* **SQL Querying:** `JOIN`, `GROUP BY`, Aggregate Functions, CTE (`WITH`), Window Functions (`ROW_NUMBER`, `RANK`)
* **Documentation:** Git & GitHub, Markdown