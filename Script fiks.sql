-- Data Preparation --
-- Create new schema -- 
CREATE SCHEMA IF NOT EXISTS kimiafarma6;

-- Create table from dataset --
CREATE TABLE IF NOT EXISTS kimiafarma6.barang
(
  kode_barang varchar(7) PRIMARY KEY,
  sektor varchar(3),
  nama_barang varchar(50),
  tipe varchar(4),
  nama_tipe varchar(20),
  kode_lini smallint,
  lini varchar(20),
  kemasan varchar(10)
);
CREATE TABLE IF NOT EXISTS kimiafarma6.pelanggan
(
  id_customer varchar(9),
  cust_level varchar(10),
  nama varchar(30),
  id_cabang_sales varchar(5),
  cabang_sales varchar(50),
  id_group varchar(3),
  cust_group varchar(20)
);

CREATE TABLE IF NOT EXISTS kimiafarma6.penjualan 
(
  id_distributor varchar(5),
  id_cabang varchar(5),
  id_invoice varchar(6),
  tanggal date,
  id_customer varchar(9) references pelanggan(id_customer),
  id_barang varchar(7),
  jumlah_barang numeric,
  unit varchar(10),
  harga numeric,
  mata_uang varchar(3),
  brand_id varchar(7),
  lini varchar(20)
);

SELECT CONCAT(id_invoice, '_', id_barang) AS id_penjualan, 
       id_distributor, 
       id_cabang, 
       id_invoice, 
       tanggal, 
       id_customer, 
       id_barang, 
       jumlah_barang, 
       unit, 
       harga, 
       mata_uang, 
       brand_id, 
       lini
FROM kimiafarma6.penjualan;

SELECT 
    CONCAT(pjl.id_invoice, '_', pjl.id_barang) AS id_penjualan,
    pjl.id_invoice, 
    pjl.tanggal,
    pjl.id_barang,
    brg.nama_barang,
    pjl.harga,
    pjl.unit,
    pjl.jumlah_barang, 
    (pjl.jumlah_barang * pjl.harga) AS total_harga_per_barang, 
    pjl.mata_uang, 
    brg.kode_barang,
    pjl.brand_id,
    pjl.id_customer,
    plg.nama AS nama_customer,
    plg.cabang_sales,
    pjl.id_distributor,
    plg.cust_group AS group_category
FROM kimiafarma6.penjualan pjl 
LEFT JOIN kimiafarma6.barang brg ON (pjl.id_barang = brg.kode_barang)
LEFT JOIN kimiafarma6.pelanggan plg ON (pjl.id_customer = plg.id_customer);

SELECT 
    pjl.id_invoice, 
    pjl.tanggal, 
    pjl.id_customer, 
    plg.nama AS nama_customer, 
    plg.cabang_sales, 
    pjl.id_distributor, 
    plg.cust_group AS group_category, 
    COUNT(DISTINCT pjl.id_barang) AS total_barang, 
    SUM(pjl.jumlah_barang * pjl.harga) AS total_pembelian 
FROM kimiafarma6.penjualan pjl 
LEFT JOIN kimiafarma6.pelanggan plg ON (pjl.id_customer = plg.id_customer) 
GROUP BY 1, 2, 3, 4, 5, 6, 7 
ORDER BY 1;
