-- Foxcore Retail EE4 validation queries
USE foxcore_retail;

-- 1. Expected row counts after loading the sample data.
SELECT 'venue' AS table_name, COUNT(*) AS actual_count, 4 AS expected_count FROM venue
UNION ALL SELECT 'retail_event', COUNT(*), 5 FROM retail_event
UNION ALL SELECT 'booth', COUNT(*), 6 FROM booth
UNION ALL SELECT 'salesperson', COUNT(*), 6 FROM salesperson
UNION ALL SELECT 'work_shift', COUNT(*), 18 FROM work_shift
UNION ALL SELECT 'product', COUNT(*), 8 FROM product
UNION ALL SELECT 'sale', COUNT(*), 74 FROM sale;

-- 2. Expected: 74 sale lines, 129 units and $1,805.00 in sales.
SELECT
    COUNT(*) AS sale_lines,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * final_unit_price), 2) AS total_sales
FROM sale;

-- 3. Each foreign-key issue count should be zero.
SELECT 'event_without_venue' AS issue, COUNT(*) AS issue_count
FROM retail_event e
LEFT JOIN venue v ON e.venue_id = v.venue_id
WHERE v.venue_id IS NULL
UNION ALL
SELECT 'booth_without_event', COUNT(*)
FROM booth b
LEFT JOIN retail_event e ON b.event_id = e.event_id
WHERE e.event_id IS NULL
UNION ALL
SELECT 'shift_without_booth', COUNT(*)
FROM work_shift w
LEFT JOIN booth b ON w.booth_id = b.booth_id
WHERE b.booth_id IS NULL
UNION ALL
SELECT 'shift_without_salesperson', COUNT(*)
FROM work_shift w
LEFT JOIN salesperson sp ON w.salesperson_id = sp.salesperson_id
WHERE sp.salesperson_id IS NULL
UNION ALL
SELECT 'sale_without_shift', COUNT(*)
FROM sale s
LEFT JOIN work_shift w ON s.shift_id = w.shift_id
WHERE w.shift_id IS NULL
UNION ALL
SELECT 'sale_without_product', COUNT(*)
FROM sale s
LEFT JOIN product p ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 4. Expected: zero rows.
SELECT *
FROM sale
WHERE quantity <= 0 OR final_unit_price <= 0;

-- 5. Expected: one legacy sale for manager review.
SELECT
    s.sale_id,
    p.product_name,
    s.quantity,
    s.final_unit_price,
    p.minimum_selling_price
FROM sale s
JOIN product p ON s.product_id = p.product_id
WHERE s.final_unit_price < p.minimum_selling_price;

-- 6. Expected: zero rows.
SELECT
    s.sale_id,
    s.sale_datetime,
    w.start_datetime,
    w.end_datetime
FROM sale s
JOIN work_shift w ON s.shift_id = w.shift_id
WHERE s.sale_datetime < w.start_datetime
   OR s.sale_datetime > w.end_datetime;

-- 7. These four provisional records require team/SME confirmation.
-- Sale 30: quantity 3 inferred from $45 total / $15 unit price.
-- Sale 43: $9 unit price is below the $12 listed minimum.
-- Sale 69: corrected handwritten unit price of $17 was used.
-- Sale 74: itemized shift total of $66 was used instead of written total $76.
SELECT
    s.sale_id,
    CONCAT(sp.first_name, ' ', sp.last_name) AS salesperson_name,
    p.product_name,
    s.quantity,
    s.final_unit_price,
    ROUND(s.quantity * s.final_unit_price, 2) AS line_total
FROM sale s
JOIN work_shift w ON s.shift_id = w.shift_id
JOIN salesperson sp ON w.salesperson_id = sp.salesperson_id
JOIN product p ON s.product_id = p.product_id
WHERE s.sale_id IN (30, 43, 69, 74)
ORDER BY s.sale_id;
