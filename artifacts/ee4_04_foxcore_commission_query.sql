-- Foxcore Retail EE4 commission queries
USE foxcore_retail;

-- The supplied Foxcore data uses a standard 10 percent commission rate.
SET @commission_rate = 0.10;

-- 1. Commission by salesperson and event.
SELECT
    sp.salesperson_id,
    CONCAT(sp.first_name, ' ', sp.last_name) AS salesperson_name,
    re.event_name,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * s.final_unit_price), 2) AS total_sales,
    ROUND(
        SUM(s.quantity * s.final_unit_price) * @commission_rate,
        2
    ) AS commission_amount
FROM sale s
JOIN work_shift w ON s.shift_id = w.shift_id
JOIN salesperson sp ON w.salesperson_id = sp.salesperson_id
JOIN booth b ON w.booth_id = b.booth_id
JOIN retail_event re ON b.event_id = re.event_id
GROUP BY
    sp.salesperson_id,
    sp.first_name,
    sp.last_name,
    re.event_id,
    re.event_name,
    re.start_date
ORDER BY re.start_date, salesperson_name;

-- 2. Total commission by salesperson.
-- Expected grand total: $180.50.
SELECT
    sp.salesperson_id,
    CONCAT(sp.first_name, ' ', sp.last_name) AS salesperson_name,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * s.final_unit_price), 2) AS total_sales,
    ROUND(
        SUM(s.quantity * s.final_unit_price) * @commission_rate,
        2
    ) AS commission_amount
FROM sale s
JOIN work_shift w ON s.shift_id = w.shift_id
JOIN salesperson sp ON w.salesperson_id = sp.salesperson_id
GROUP BY sp.salesperson_id, sp.first_name, sp.last_name
ORDER BY total_sales DESC;

-- 3. Grand total check.
SELECT
    ROUND(SUM(quantity * final_unit_price), 2) AS total_sales,
    ROUND(
        SUM(quantity * final_unit_price) * @commission_rate,
        2
    ) AS total_commission
FROM sale;
