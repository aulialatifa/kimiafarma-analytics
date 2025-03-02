CREATE OR REPLACE TABLE kimia_farma.analisa AS
SELECT
    t.transaction_id,
    t.date,
    c.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    p.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    CASE
        WHEN COALESCE(t.price,0)<=50000 THEN 0.1
        WHEN COALESCE(t.price,0)>50000 AND COALESCE(t.price,0)<=100000 THEN 0.15
        WHEN COALESCE(t.price,0)>100000 AND COALESCE(t.price,0)<=300000 THEN 0.2
        WHEN COALESCE(t.price,0)>300000 AND COALESCE(t.price,0)<=500000 THEN 0.25
        WHEN COALESCE(t.price,0)>500000 THEN 0.3
        ELSE 0
    END AS persentase_gross_laba,
    t.price - (t.price * discount_percentage / 100) AS nett_sales,
    (t.price - (t.price * discount_percentage / 100)) *
    (CASE
        WHEN COALESCE(t.price,0)<=50000 THEN 0.1
        WHEN COALESCE(t.price,0)>50000 AND COALESCE(t.price,0)<=100000 THEN 0.15
        WHEN COALESCE(t.price,0)>100000 AND COALESCE(t.price,0)<=300000 THEN 0.2
        WHEN COALESCE(t.price,0)>300000 AND COALESCE(t.price,0)<=500000 THEN 0.25
        WHEN COALESCE(t.price,0)>500000 THEN 0.3
        ELSE 0
    END) AS nett_profit,
    t.rating AS rating_transaksi,
FROM kimia_farma.kf_final_transaction t 
JOIN kimia_farma.kf_kantor_cabang c
    ON t.branch_id = c.branch_id
JOIN kimia_farma.kf_product p  
    ON t.product_id = p.product_id