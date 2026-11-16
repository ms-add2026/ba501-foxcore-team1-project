-- FOXCORE EE#4 —setup with sample data

CREATE DATABASE IF NOT EXISTS foxcore_ee4;
USE foxcore_ee4;

CREATE TABLE IF NOT EXISTS venue (
 venue_id INT PRIMARY KEY, venue_name VARCHAR(100) NOT NULL,
 address VARCHAR(255) NOT NULL, parking_instructions VARCHAR(255), description VARCHAR(255)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS retail_event (
 event_id INT PRIMARY KEY, venue_id INT NOT NULL, event_type VARCHAR(50) NOT NULL,
 event_name VARCHAR(100) NOT NULL, start_date DATE NOT NULL, end_date DATE NOT NULL,
 description VARCHAR(255), FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS booth (
 booth_id INT PRIMARY KEY, event_id INT NOT NULL, location_code VARCHAR(30) NOT NULL,
 description VARCHAR(255), FOREIGN KEY (event_id) REFERENCES retail_event(event_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS product (
 product_id INT PRIMARY KEY, product_name VARCHAR(100) NOT NULL,
 description VARCHAR(255), wholesale_cost DECIMAL(10,2) NOT NULL,
 minimum_selling_price DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS salesperson (
 salesperson_id INT PRIMARY KEY, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL,
 address VARCHAR(255), phone_number VARCHAR(25)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS work_shift (
 shift_id INT PRIMARY KEY, booth_id INT NOT NULL, salesperson_id INT NOT NULL,
 start_datetime DATETIME NOT NULL, end_datetime DATETIME NOT NULL,
 FOREIGN KEY (booth_id) REFERENCES booth(booth_id),
 FOREIGN KEY (salesperson_id) REFERENCES salesperson(salesperson_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS sale (
 sale_id INT PRIMARY KEY, shift_id INT NOT NULL, product_id INT NOT NULL,
 sale_datetime DATETIME NOT NULL, quantity INT NOT NULL,
 final_unit_price DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (shift_id) REFERENCES work_shift(shift_id),
 FOREIGN KEY (product_id) REFERENCES product(product_id)
) ENGINE=InnoDB;


-- venue table
INSERT INTO venue (venue_id, venue_name, address, parking_instructions, description) VALUES
 (1, 'Main Street Downtown Core', 'Main St between King and Queen, Kitchener, ON', 'Street closed at 6 AM
ON DUPLICATE KEY UPDATE
  venue_name = VALUES(venue_name),
  address = VALUES(address),
  parking_instructions = VALUES(parking_instructions),
  description = VALUES(description); use city garage on Queen', NULL),
 (2, 'Harbourview Pier', '12 Pier Rd, Kingston, ON', 'Vendor parking east side; check in at security hut', NULL),
 (3, 'Centennial Square', '1 Centennial Sq, Windsor, ON', 'Underground garage, level P2', NULL),
 (4, 'Maple Grove Exhibition Grounds', '300 Exhibition Dr, Barrie, ON', 'Enter via Gate 1; no overnight parking', NULL);

-- retail_event table
INSERT INTO retail_event (event_id, event_name, start_date, end_date, event_type, venue_id, description) VALUES
 (1, 'Steel City Charity Games', '2016-06-10', '2016-06-12', 'Sporting Event', 1, 'Charity sports tournament weekend'),
 (2, 'Brewers Row Summer Fest', '2016-06-24', '2016-06-26', 'Beer Festival', 2, 'Local breweries and live acts'),
 (3, 'Lakeshore Music Weekend', '2016-07-15', '2016-07-17', 'Music Festival', 3, 'Three-day outdoor music festival'),
 (4, 'Riverbank Ribfest', '2016-07-29', '2016-07-31', 'Rib Fest', 4, 'Rib teams from across Ontario'),
 (5, 'Outdoor Adventure Expo', '2016-08-19', '2016-08-21', 'Trade Show', 4, 'Camping, cycling and outdoor gear show')
ON DUPLICATE KEY UPDATE
  event_name = VALUES(event_name),
  start_date = VALUES(start_date),
  end_date = VALUES(end_date),
  event_type = VALUES(event_type),
  venue_id = VALUES(venue_id),
  description = VALUES(description);

-- booth table
INSERT INTO booth (booth_id, event_id, location_code, description) VALUES
 (1, 1, 'P17', NULL),
 (2, 2, 'T17', NULL),
 (3, 2, 'T18', NULL),
 (4, 3, 'D10', NULL),
 (5, 4, 'A17', NULL),
 (6, 5, 'H20', NULL)
ON DUPLICATE KEY UPDATE
  event_id = VALUES(event_id),
  location_code = VALUES(location_code),
  description = VALUES(description);

-- product table
INSERT INTO product (product_id, product_name, wholesale_cost, minimum_selling_price, description) VALUES
 (1, 'Bubble Gun', 5, 11, NULL),
 (2, 'Arctic Skin Cooling Towel', 2.75, 8, NULL),
 (3, 'Neck Fan', 4.25, 14, NULL),
 (4, 'Misting Fan', 6.50, 15, NULL),
 (5, 'Light-Up Shirt', 6, 16, NULL),
 (6, 'Rain Poncho', 2.25, 5, NULL),
 (7, 'Heating Pad', 4.75, 15, NULL),
 (8, 'Emoji Pillow', 3.50, 12, NULL)
ON DUPLICATE KEY UPDATE
  product_name = VALUES(product_name),
  wholesale_cost = VALUES(wholesale_cost),
  minimum_selling_price = VALUES(minimum_selling_price),
  description = VALUES(description);

-- salesperson table
INSERT INTO salesperson (salesperson_id, first_name, last_name, address, phone_number) VALUES
 (1, 'Jordan', 'Patel', '246 Talbot St, London, ON', '519-555-0174'),
 (2, 'Ravi', 'Campbell', '293 Huron St, London, ON', '(519) 555-0198'),
 (3, 'Omar', 'Fraser', '195 Richmond St, London, ON', '5195550103'),
 (4, 'Ben', 'Ortiz', '34 Oxford St, London, ON', '519-555-0154'),
 (5, 'Chloe', 'Ahmed', '339 Wharncliffe Rd, London, ON', NULL),
 (6, 'Julia', 'Singh', '42 Oxford St, London, ON', '5195550190')
ON DUPLICATE KEY UPDATE
  first_name = VALUES(first_name),
  last_name = VALUES(last_name),
  address = VALUES(address),
  phone_number = VALUES(phone_number);

-- work_shift table
INSERT INTO work_shift (shift_id, booth_id, salesperson_id, start_datetime, end_datetime) VALUES
 (1, 1, 6, '2016-06-10 14:00:00', '2016-06-10 20:00:00'),
 (2, 1, 3, '2016-06-11 10:00:00', '2016-06-11 18:00:00'),
 (3, 1, 2, '2016-06-12 10:00:00', '2016-06-12 17:00:00'),
 (4, 2, 2, '2016-06-24 14:00:00', '2016-06-24 20:00:00'),
 (5, 3, 3, '2016-06-24 14:00:00', '2016-06-24 20:00:00'),
 (6, 2, 3, '2016-06-25 10:00:00', '2016-06-25 18:00:00'),
 (7, 3, 1, '2016-06-25 10:00:00', '2016-06-25 18:00:00'),
 (8, 2, 1, '2016-06-26 10:00:00', '2016-06-26 17:00:00'),
 (9, 3, 2, '2016-06-26 10:00:00', '2016-06-26 17:00:00'),
 (10, 4, 1, '2016-07-15 14:00:00', '2016-07-15 20:00:00'),
 (11, 4, 1, '2016-07-16 10:00:00', '2016-07-16 18:00:00'),
 (12, 4, 6, '2016-07-17 10:00:00', '2016-07-17 17:00:00'),
 (13, 5, 2, '2016-07-29 14:00:00', '2016-07-29 20:00:00'),
 (14, 5, 3, '2016-07-30 10:00:00', '2016-07-30 18:00:00'),
 (15, 5, 4, '2016-07-31 10:00:00', '2016-07-31 17:00:00'),
 (16, 6, 4, '2016-08-19 14:00:00', '2016-08-19 20:00:00'),
 (17, 6, 1, '2016-08-20 10:00:00', '2016-08-20 18:00:00'),
 (18, 6, 3, '2016-08-21 10:00:00', '2016-08-21 17:00:00'),
 (19, 6, 3, '2016-08-21 10:00:00', '2016-08-21 17:00:00')
ON DUPLICATE KEY UPDATE
  booth_id = VALUES(booth_id),
  salesperson_id = VALUES(salesperson_id),
  start_datetime = VALUES(start_datetime),
  end_datetime = VALUES(end_datetime);

-- sale table
INSERT INTO sale (sale_id, shift_id, product_id, sale_datetime, quantity, final_unit_price) VALUES
 (1, 1, 8, '2016-06-10 12:00:00', 2, 14.00),
 (2, 1, 6, '2016-06-10 12:00:00', 1, 6.00),
 (3, 1, 7, '2016-06-10 12:00:00', 2, 18.00),
 (4, 1, 6, '2016-06-10 12:00:00', 3, 8.00),
 (5, 1, 7, '2016-06-10 12:00:00', 2, 15.00),
 (6, 2, 7, '2016-06-11 12:00:00', 2, 15.00),
 (7, 2, 6, '2016-06-11 12:00:00', 2, 7.00),
 (8, 2, 7, '2016-06-11 12:00:00', 1, 16.00),
 (9, 3, 8, '2016-06-12 12:00:00', 1, 12.00),
 (10, 3, 6, '2016-06-12 12:00:00', 2, 8.00),
 (11, 3, 5, '2016-06-12 12:00:00', 2, 18.00),
 (12, 3, 5, '2016-06-12 12:00:00', 1, 16.00),
 (13, 3, 7, '2016-06-12 12:00:00', 1, 18.00),
 (14, 4, 7, '2016-06-24 12:00:00', 2, 16.00),
 (15, 4, 2, '2016-06-24 12:00:00', 1, 11.00),
 (16, 4, 7, '2016-06-24 12:00:00', 2, 18.00),
 (17, 4, 2, '2016-06-24 12:00:00', 2, 10.00),
 (18, 5, 5, '2016-06-24 12:00:00', 1, 16.00),
 (19, 5, 2, '2016-06-24 12:00:00', 2, 10.00),
 (20, 5, 3, '2016-06-24 12:00:00', 1, 16.00),
 (21, 5, 2, '2016-06-24 12:00:00', 2, 8.00),
 (22, 5, 5, '2016-06-24 12:00:00', 1, 18.00),
 (23, 6, 5, '2016-06-25 12:00:00', 1, 17.00),
 (24, 6, 2, '2016-06-25 12:00:00', 1, 9.00),
 (25, 6, 7, '2016-06-25 12:00:00', 1, 17.00),
 (26, 6, 5, '2016-06-25 12:00:00', 1, 16.00),
 (27, 7, 2, '2016-06-25 12:00:00', 1, 9.00),
 (28, 7, 7, '2016-06-25 12:00:00', 3, 18.00),
 (29, 7, 7, '2016-06-25 12:00:00', 1, 16.00),
 (30, 8, 7, '2016-06-26 12:00:00', 3, 15.00),
 (31, 8, 7, '2016-06-26 12:00:00', 3, 15.00),
 (32, 8, 2, '2016-06-26 12:00:00', 3, 8.00),
 (33, 8, 3, '2016-06-26 12:00:00', 1, 16.00),
 (34, 8, 2, '2016-06-26 12:00:00', 2, 11.00),
 (35, 9, 5, '2016-06-26 12:00:00', 1, 19.00),
 (36, 9, 2, '2016-06-26 12:00:00', 1, 9.00),
 (37, 9, 3, '2016-06-26 12:00:00', 3, 14.00),
 (38, 9, 7, '2016-06-26 12:00:00', 2, 16.00),
 (39, 9, 3, '2016-06-26 12:00:00', 2, 14.00),
 (40, 10, 5, '2016-07-15 12:00:00', 3, 17.00),
 (41, 10, 5, '2016-07-15 12:00:00', 2, 17.00),
 (42, 10, 3, '2016-07-15 12:00:00', 1, 14.00),
 (43, 10, 8, '2016-07-15 12:00:00', 2, 9.00),
 (44, 10, 4, '2016-07-15 12:00:00', 1, 16.00),
 (45, 11, 3, '2016-07-16 12:00:00', 2, 15.00),
 (46, 11, 8, '2016-07-16 12:00:00', 1, 14.00),
 (47, 11, 5, '2016-07-16 12:00:00', 2, 18.00),
 (48, 11, 4, '2016-07-16 12:00:00', 2, 18.00),
 (49, 12, 5, '2016-07-17 12:00:00', 2, 18.00),
 (50, 12, 5, '2016-07-17 12:00:00', 3, 19.00),
 (51, 12, 3, '2016-07-17 12:00:00', 1, 16.00),
 (52, 13, 8, '2016-07-29 16:36:00', 2, 12.00),
 (53, 13, 6, '2016-07-29 17:18:00', 2, 5.00),
 (54, 13, 6, '2016-07-29 17:19:00', 1, 8.00),
 (55, 13, 5, '2016-07-29 19:40:00', 1, 19.00),
 (56, 14, 3, '2016-07-30 11:20:00', 3, 14.00),
 (57, 14, 8, '2016-07-30 13:56:00', 3, 12.00),
 (58, 14, 3, '2016-07-30 14:26:00', 2, 14.00),
 (59, 14, 6, '2016-07-30 17:04:00', 1, 7.00),
 (60, 15, 3, '2016-07-31 10:23:00', 3, 17.00),
 (61, 15, 8, '2016-07-31 11:35:00', 2, 12.00),
 (62, 15, 5, '2016-07-31 12:33:00', 2, 18.00),
 (63, 15, 5, '2016-07-31 13:18:00', 2, 16.00),
 (64, 15, 6, '2016-07-31 14:00:00', 1, 7.00),
 (65, 16, 7, '2016-08-19 16:36:00', 2, 16.00),
 (66, 16, 8, '2016-08-19 17:01:00', 3, 15.00),
 (67, 16, 7, '2016-08-19 19:33:00', 1, 15.00),
 (68, 17, 8, '2016-08-20 10:25:00', 1, 12.00),
 (69, 17, 3, '2016-08-20 14:14:00', 3, 17.00),
 (70, 17, 8, '2016-08-20 16:08:00', 1, 15.00),
 (71, 19, 8, '2016-08-21 11:06:00', 1, 12.00),
 (72, 19, 7, '2016-08-21 14:12:00', 2, 15.00),
 (73, 19, 6, '2016-08-21 14:48:00', 1, 7.00),
 (74, 19, 3, '2016-08-21 15:35:00', 1, 17.00)
ON DUPLICATE KEY UPDATE
  shift_id = VALUES(shift_id),
  product_id = VALUES(product_id),
  sale_datetime = VALUES(sale_datetime),
  quantity = VALUES(quantity),
  final_unit_price = VALUES(final_unit_price);


SELECT
    sp.salesperson_id,
    CONCAT(sp.first_name, ' ', sp.last_name) AS salesperson,
    COUNT(s.sale_id) AS total_transactions,
    SUM(s.quantity) AS total_units_sold,
    ROUND(SUM(s.quantity * s.final_unit_price), 2) AS total_sales,
    ROUND(SUM(s.quantity * s.final_unit_price) * 0.10, 2)
        AS commission
FROM salesperson sp
JOIN work_shift ws
    ON sp.salesperson_id = ws.salesperson_id
JOIN sale s
    ON ws.shift_id = s.shift_id
GROUP BY
    sp.salesperson_id,
    sp.first_name,
    sp.last_name
ORDER BY total_sales DESC;
