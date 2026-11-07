-- Create Table
-- 1. Orders
CREATE TABLE IF NOT EXISTS public.orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 2. Order Items
CREATE TABLE IF NOT EXISTS public.order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2)
);

-- 3. Customers
CREATE TABLE IF NOT EXISTS public.customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 4. Sellers
CREATE TABLE IF NOT EXISTS public.sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- 5. Products
CREATE TABLE IF NOT EXISTS public.products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 6. Product Category Translation
CREATE TABLE IF NOT EXISTS public.category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

-- 7. Order Reviews (Tipe TEXT agar ulasan panjang tidak error)
CREATE TABLE IF NOT EXISTS public.order_reviews (
    review_id VARCHAR(100),
    order_id VARCHAR(100),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);


-- Load database
COPY public.orders FROM 'D:/path/folder/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');
COPY public.order_items FROM 'D:/path/folder/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');
COPY public.customers FROM 'D:/path/folder/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');
COPY public.sellers FROM 'D:/path/folder/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');
COPY public.products FROM 'D:/path/folder/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');
COPY public.category_translation FROM 'D:/path/folder/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');
COPY public.order_reviews FROM 'D:/path/folder/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, QUOTE '"', ESCAPE '"');

-- query pertanyaan bisnis

--q1 ketrlambatan distribusi
CREATE OR REPLACE VIEW late_delivery_rate_vw AS
WITH processed_data AS (
    SELECT 
        CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'late'
            ELSE 'On-Time/Early'
        END AS delivery_status,
        COUNT(order_id) AS total_orders
    FROM orders
    WHERE 
        order_status = 'delivered'
        AND order_delivered_customer_date IS NOT NULL
        AND order_estimated_delivery_date IS NOT NULL
    GROUP BY delivery_status
)
SELECT 
    delivery_status,
    total_orders,
    ROUND(total_orders * 100.0 / SUM(total_orders) over(), 2) AS percentage
FROM processed_data;

--q2 keterlambatan per seller
create or replace view keterlambatan_per_seller as 
	SELECT 
    	oi.seller_id,
	    COUNT(o.order_id) AS total_late_orders,
	    ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date))), 1) AS avg_delay_days
	FROM orders o
	JOIN order_items oi ON o.order_id = oi.order_id
	WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date > o.order_estimated_delivery_date
	GROUP BY oi.seller_id
	HAVING COUNT(o.order_id) >= 5
	ORDER BY avg_delay_days DESC
	LIMIT 10;

    --q3 Analisis wilayah/geografi
create  or replace view analisis_geografi as 
	with proses_data as(
		SELECT 
	    	c.customer_state,
	    	COUNT(o.order_id) AS total_orders,
	    	COUNT(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 END) AS total_late_orders
		FROM orders o
		JOIN customers c ON o.customer_id = c.customer_id
		WHERE o.order_status = 'delivered'
  		AND o.order_delivered_customer_date IS NOT NULL
  		AND o.order_estimated_delivery_date IS NOT null
		GROUP BY c.customer_state
		HAVING COUNT(o.order_id) >= 100
	)
	select
		customer_state,
		total_orders,
		total_late_orders,
		round((total_late_orders * 100.0/total_orders ),2) as late_rate_percentage
	from proses_data
	order by late_rate_percentage desc
	limit 5;

--q4 Dampak Biaya Ongkir
create or replace view dampak_biaya_ongkir as
	select 
	    case 
	    	when o.order_delivered_customer_date > o.order_estimated_delivery_date 
	    		then 'Late'
	    		else 'On-time'
	    end as delivery_status,
	    round(AVG(oi.freight_value ), 2) as avg_freight_value,
	    round(AVG(oi.price ), 2) as avg_price
    from orders o 
    join order_items oi on oi.order_id = o.order_id 
    where 
    	o.order_status = 'delivered'
    	and o.order_delivered_customer_date is not null
   		and o.order_estimated_delivery_date is not null
   	group by delivery_status;

--q5 Dampak Keterlamatan ke Rating	
create or replace view dampak_keterlambaptan_ke_rating as
    select 
    	case 
    		when o.order_delivered_customer_date > o.order_estimated_delivery_date 
    			then 'Late'
    			else 'On-time'
    	end as delivery_status,
    	count(distinct o.order_id ) as total_orders,
    	round(AVG(t.review_score ), 2) as avg_reviw_score,
    	round(
    		count(
    			case
    				when t.review_score = 1 then 1
    			end	
    		) * 100 /count(t.review_score),
    		2
    	) as persentase_rating_bintang_1
        from orders o 
        join order_reviews t  on o.order_id  = t.order_id 
        where 
        	o.order_status = 'delivered'
        	and o.order_delivered_customer_date  is not null 
        	and o.order_estimated_delivery_date is not null
        group by delivery_status ;

--q6 Kategori Produk Paling Sering Terlambat
create or replace view kategori_produk_paling_sering_terlambat as
    select 
    	ct.product_category_name  as product_category,
    	count(distinct o.order_id) as total_orders,
    	count(Distinct
    		case
    			when o.order_delivered_customer_date > o.order_estimated_delivery_date then o.order_id 
    		end
    	) as total_late_orders,
    	round(
    		count(Distinct
    			case
    				when o.order_delivered_customer_date > o.order_estimated_delivery_date then o.order_id 
    			end
    		)* 100 / count(distinct o.order_id),
    		2
    	) as late_rate_percentage
    from 
    	orders o 
    	join order_items oi on oi.order_id = o.order_id 
    	join products p on oi.product_id = p.product_id 
    	join category_translation ct on  p.product_category_name  = ct.product_category_name 
    where 
    	o.order_status = 'delivered'
    	and o.order_delivered_customer_date is not null
    	and o.order_estimated_delivery_date is not null
    group by ct.product_category_name  
    having count(distinct o.order_id ) >= 50
    order by late_rate_percentage desc
    limit 5;