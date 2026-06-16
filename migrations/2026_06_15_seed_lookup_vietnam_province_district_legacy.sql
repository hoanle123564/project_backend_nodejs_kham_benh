-- Vietnam province/district/ward lookup seed (legacy 3-level administrative model for app compatibility)
-- Generated on 2026-06-15 from https://provinces.open-api.vn/api/v1/?depth=3
-- Scope: PROVINCE, DISTRICT, and WARD.

-- PROVINCE lookup block
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01', 'PROVINCE', NULL, 'Hà Nội', 'Thanh pho Ha Noi'),
('02', 'PROVINCE', NULL, 'Hà Giang', 'Ha Giang'),
('04', 'PROVINCE', NULL, 'Cao Bằng', 'Cao Bang'),
('06', 'PROVINCE', NULL, 'Bắc Kạn', 'Bac Kan'),
('08', 'PROVINCE', NULL, 'Tuyên Quang', 'Tuyen Quang'),
('10', 'PROVINCE', NULL, 'Lào Cai', 'Lao Cai'),
('11', 'PROVINCE', NULL, 'Điện Biên', 'Dien Bien'),
('12', 'PROVINCE', NULL, 'Lai Châu', 'Lai Chau'),
('14', 'PROVINCE', NULL, 'Sơn La', 'Son La'),
('15', 'PROVINCE', NULL, 'Yên Bái', 'Yen Bai'),
('17', 'PROVINCE', NULL, 'Hoà Bình', 'Hoa Binh'),
('19', 'PROVINCE', NULL, 'Thái Nguyên', 'Thai Nguyen'),
('20', 'PROVINCE', NULL, 'Lạng Sơn', 'Lang Son'),
('22', 'PROVINCE', NULL, 'Quảng Ninh', 'Quang Ninh'),
('24', 'PROVINCE', NULL, 'Bắc Giang', 'Bac Giang'),
('25', 'PROVINCE', NULL, 'Phú Thọ', 'Phu Tho'),
('26', 'PROVINCE', NULL, 'Vĩnh Phúc', 'Vinh Phuc'),
('27', 'PROVINCE', NULL, 'Bắc Ninh', 'Bac Ninh'),
('30', 'PROVINCE', NULL, 'Hải Dương', 'Hai Duong'),
('31', 'PROVINCE', NULL, 'Hải Phòng', 'Hai Phong'),
('33', 'PROVINCE', NULL, 'Hưng Yên', 'Hung Yen'),
('34', 'PROVINCE', NULL, 'Thái Bình', 'Thai Binh'),
('35', 'PROVINCE', NULL, 'Hà Nam', 'Ha Nam'),
('36', 'PROVINCE', NULL, 'Nam Định', 'Nam Dinh'),
('37', 'PROVINCE', NULL, 'Ninh Bình', 'Ninh Binh'),
('38', 'PROVINCE', NULL, 'Thanh Hóa', 'Thanh Hoa'),
('40', 'PROVINCE', NULL, 'Nghệ An', 'Nghe An'),
('42', 'PROVINCE', NULL, 'Hà Tĩnh', 'Ha Tinh'),
('44', 'PROVINCE', NULL, 'Quảng Bình', 'Quang Binh'),
('45', 'PROVINCE', NULL, 'Quảng Trị', 'Quang Tri'),
('46', 'PROVINCE', NULL, 'Huế', 'Thanh pho Hue'),
('48', 'PROVINCE', NULL, 'Đà Nẵng', 'Thanh pho Da Nang'),
('49', 'PROVINCE', NULL, 'Quảng Nam', 'Quang Nam'),
('51', 'PROVINCE', NULL, 'Quảng Ngãi', 'Quang Ngai'),
('52', 'PROVINCE', NULL, 'Bình Định', 'Binh Dinh'),
('54', 'PROVINCE', NULL, 'Phú Yên', 'Phu Yen'),
('56', 'PROVINCE', NULL, 'Khánh Hòa', 'Khanh Hoa'),
('58', 'PROVINCE', NULL, 'Ninh Thuận', 'Ninh Thuan'),
('60', 'PROVINCE', NULL, 'Bình Thuận', 'Binh Thuan'),
('62', 'PROVINCE', NULL, 'Kon Tum', 'Kon Tum'),
('64', 'PROVINCE', NULL, 'Gia Lai', 'Gia Lai'),
('66', 'PROVINCE', NULL, 'Đắk Lắk', 'Dak Lak'),
('67', 'PROVINCE', NULL, 'Đắk Nông', 'Dak Nong'),
('68', 'PROVINCE', NULL, 'Lâm Đồng', 'Lam Dong'),
('70', 'PROVINCE', NULL, 'Bình Phước', 'Binh Phuoc'),
('72', 'PROVINCE', NULL, 'Tây Ninh', 'Tay Ninh'),
('74', 'PROVINCE', NULL, 'Bình Dương', 'Binh Duong'),
('75', 'PROVINCE', NULL, 'Đồng Nai', 'Dong Nai'),
('77', 'PROVINCE', NULL, 'Bà Rịa - Vũng Tàu', 'Ba Ria - Vung Tau'),
('79', 'PROVINCE', NULL, 'Hồ Chí Minh', 'Thanh pho Ho Chi Minh'),
('80', 'PROVINCE', NULL, 'Long An', 'Long An'),
('82', 'PROVINCE', NULL, 'Tiền Giang', 'Tien Giang'),
('83', 'PROVINCE', NULL, 'Bến Tre', 'Ben Tre'),
('84', 'PROVINCE', NULL, 'Trà Vinh', 'Tra Vinh'),
('86', 'PROVINCE', NULL, 'Vĩnh Long', 'Vinh Long'),
('87', 'PROVINCE', NULL, 'Đồng Tháp', 'Dong Thap'),
('89', 'PROVINCE', NULL, 'An Giang', 'An Giang'),
('91', 'PROVINCE', NULL, 'Kiên Giang', 'Kien Giang'),
('92', 'PROVINCE', NULL, 'Cần Thơ', 'Can Tho'),
('93', 'PROVINCE', NULL, 'Hậu Giang', 'Hau Giang'),
('94', 'PROVINCE', NULL, 'Sóc Trăng', 'Soc Trang'),
('95', 'PROVINCE', NULL, 'Bạc Liêu', 'Bac Lieu'),
('96', 'PROVINCE', NULL, 'Cà Mau', 'Ca Mau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 01 - Hà Nội
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('001', 'DISTRICT', '01', 'Ba Đình', 'Ba Dinh'),
('002', 'DISTRICT', '01', 'Hoàn Kiếm', 'Hoan Kiem'),
('003', 'DISTRICT', '01', 'Tây Hồ', 'Tay Ho'),
('004', 'DISTRICT', '01', 'Long Biên', 'Long Bien'),
('005', 'DISTRICT', '01', 'Cầu Giấy', 'Cau Giay'),
('006', 'DISTRICT', '01', 'Đống Đa', 'Dong Da'),
('007', 'DISTRICT', '01', 'Hai Bà Trưng', 'Hai Ba Trung'),
('008', 'DISTRICT', '01', 'Hoàng Mai', 'Hoang Mai'),
('009', 'DISTRICT', '01', 'Thanh Xuân', 'Thanh Xuan'),
('016', 'DISTRICT', '01', 'Sóc Sơn', 'Soc Son'),
('017', 'DISTRICT', '01', 'Đông Anh', 'Dong Anh'),
('018', 'DISTRICT', '01', 'Gia Lâm', 'Gia Lam'),
('019', 'DISTRICT', '01', 'Nam Từ Liêm', 'Nam Tu Liem'),
('020', 'DISTRICT', '01', 'Thanh Trì', 'Thanh Tri'),
('021', 'DISTRICT', '01', 'Bắc Từ Liêm', 'Bac Tu Liem'),
('250', 'DISTRICT', '01', 'Mê Linh', 'Me Linh'),
('268', 'DISTRICT', '01', 'Hà Đông', 'Ha Dong'),
('269', 'DISTRICT', '01', 'Thị Sơn Tây', 'Thi Son Tay'),
('271', 'DISTRICT', '01', 'Ba Vì', 'Ba Vi'),
('272', 'DISTRICT', '01', 'Phúc Thọ', 'Phuc Tho'),
('273', 'DISTRICT', '01', 'Đan Phượng', 'Dan Phuong'),
('274', 'DISTRICT', '01', 'Hoài Đức', 'Hoai Duc'),
('275', 'DISTRICT', '01', 'Quốc Oai', 'Quoc Oai'),
('276', 'DISTRICT', '01', 'Thạch Thất', 'Thach That'),
('277', 'DISTRICT', '01', 'Chương Mỹ', 'Chuong My'),
('278', 'DISTRICT', '01', 'Thanh Oai', 'Thanh Oai'),
('279', 'DISTRICT', '01', 'Thường Tín', 'Thuong Tin'),
('280', 'DISTRICT', '01', 'Phú Xuyên', 'Phu Xuyen'),
('281', 'DISTRICT', '01', 'Ứng Hòa', 'Ung Hoa'),
('282', 'DISTRICT', '01', 'Mỹ Đức', 'My Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 001 - Ba Đình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00001', 'WARD', '001', 'Phúc Xá', 'Phuc Xa'),
('00004', 'WARD', '001', 'Trúc Bạch', 'Truc Bach'),
('00006', 'WARD', '001', 'Vĩnh Phúc', 'Vinh Phuc'),
('00007', 'WARD', '001', 'Cống Vị', 'Cong Vi'),
('00008', 'WARD', '001', 'Liễu Giai', 'Lieu Giai'),
('00013', 'WARD', '001', 'Quán Thánh', 'Thanh'),
('00016', 'WARD', '001', 'Ngọc Hà', 'Ngoc Ha'),
('00019', 'WARD', '001', 'Điện Biên', 'Dien Bien'),
('00022', 'WARD', '001', 'Đội Cấn', 'Doi Can'),
('00025', 'WARD', '001', 'Ngọc Khánh', 'Ngoc Khanh'),
('00028', 'WARD', '001', 'Kim Mã', 'Kim Ma'),
('00031', 'WARD', '001', 'Giảng Võ', 'Giang Vo'),
('00034', 'WARD', '001', 'Thành Công', 'Thanh Cong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 002 - Hoàn Kiếm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00037', 'WARD', '002', 'Phúc Tân', 'Phuc Tan'),
('00040', 'WARD', '002', 'Đồng Xuân', 'Dong Xuan'),
('00043', 'WARD', '002', 'Hàng Mã', 'Hang Ma'),
('00046', 'WARD', '002', 'Hàng Buồm', 'Hang Buom'),
('00049', 'WARD', '002', 'Hàng Đào', 'Hang Dao'),
('00052', 'WARD', '002', 'Hàng Bồ', 'Hang Bo'),
('00055', 'WARD', '002', 'Cửa Đông', 'Cua Dong'),
('00058', 'WARD', '002', 'Lý Thái Tổ', 'Ly Thai To'),
('00061', 'WARD', '002', 'Hàng Bạc', 'Hang Bac'),
('00064', 'WARD', '002', 'Hàng Gai', 'Hang Gai'),
('00067', 'WARD', '002', 'Chương Dương', 'Chuong Duong'),
('00070', 'WARD', '002', 'Hàng Trống', 'Hang Trong'),
('00073', 'WARD', '002', 'Cửa Nam', 'Cua Nam'),
('00076', 'WARD', '002', 'Hàng Bông', 'Hang Bong'),
('00079', 'WARD', '002', 'Tràng Tiền', 'Trang Tien'),
('00082', 'WARD', '002', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('00085', 'WARD', '002', 'Phan Chu Trinh', 'Phan Chu Trinh'),
('00088', 'WARD', '002', 'Hàng Bài', 'Hang Bai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 003 - Tây Hồ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00091', 'WARD', '003', 'Phú Thượng', 'Phu Thuong'),
('00094', 'WARD', '003', 'Nhật Tân', 'Nhat Tan'),
('00097', 'WARD', '003', 'Tứ Liên', 'Tu Lien'),
('00100', 'WARD', '003', 'Quảng An', 'Quang An'),
('00103', 'WARD', '003', 'Xuân La', 'Xuan La'),
('00106', 'WARD', '003', 'Yên Phụ', 'Yen Phu'),
('00109', 'WARD', '003', 'Bưởi', 'Buoi'),
('00112', 'WARD', '003', 'Thụy Khuê', 'Thuy Khue')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 004 - Long Biên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00115', 'WARD', '004', 'Thượng Thanh', 'Thuong Thanh'),
('00118', 'WARD', '004', 'Ngọc Thụy', 'Ngoc Thuy'),
('00121', 'WARD', '004', 'Giang Biên', 'Giang Bien'),
('00124', 'WARD', '004', 'Đức Giang', 'Duc Giang'),
('00127', 'WARD', '004', 'Việt Hưng', 'Viet Hung'),
('00130', 'WARD', '004', 'Gia Thụy', 'Gia Thuy'),
('00133', 'WARD', '004', 'Ngọc Lâm', 'Ngoc Lam'),
('00136', 'WARD', '004', 'Phúc Lợi', 'Phuc Loi'),
('00139', 'WARD', '004', 'Bồ Đề', 'Bo De'),
('00145', 'WARD', '004', 'Long Biên', 'Long Bien'),
('00148', 'WARD', '004', 'Thạch Bàn', 'Thach Ban'),
('00151', 'WARD', '004', 'Phúc Đồng', 'Phuc Dong'),
('00154', 'WARD', '004', 'Cự Khối', 'Cu Khoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 005 - Cầu Giấy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00157', 'WARD', '005', 'Nghĩa Đô', 'Nghia Do'),
('00160', 'WARD', '005', 'Nghĩa Tân', 'Nghia Tan'),
('00163', 'WARD', '005', 'Mai Dịch', 'Mai Dich'),
('00166', 'WARD', '005', 'Dịch Vọng', 'Dich Vong'),
('00167', 'WARD', '005', 'Dịch Vọng Hậu', 'Dich Vong Hau'),
('00169', 'WARD', '005', 'Hoa', 'Hoa'),
('00172', 'WARD', '005', 'Yên Hoà', 'Yen Hoa'),
('00175', 'WARD', '005', 'Trung Hoà', 'Trung Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 006 - Đống Đa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00178', 'WARD', '006', 'Cát Linh', 'Cat Linh'),
('00181', 'WARD', '006', 'Văn Miếu - Quốc Tử Giám', 'Van Mieu - Quoc Tu Giam'),
('00187', 'WARD', '006', 'Láng Thượng', 'Lang Thuong'),
('00190', 'WARD', '006', 'Ô Chợ Dừa', 'O Cho Dua'),
('00193', 'WARD', '006', 'Văn Chương', 'Van Chuong'),
('00196', 'WARD', '006', 'Hàng Bột', 'Hang Bot'),
('00199', 'WARD', '006', 'Láng Hạ', 'Lang Ha'),
('00202', 'WARD', '006', 'Khâm Thiên', 'Kham Thien'),
('00205', 'WARD', '006', 'Thổ Quan', 'Tho Quan'),
('00208', 'WARD', '006', 'Nam Đồng', 'Nam Dong'),
('00214', 'WARD', '006', 'Quang Trung', 'Quang Trung'),
('00217', 'WARD', '006', 'Trung Liệt', 'Trung Liet'),
('00226', 'WARD', '006', 'Phương Liên - Trung Tự', 'Lien - Trung Tu'),
('00229', 'WARD', '006', 'Kim Liên', 'Kim Lien'),
('00232', 'WARD', '006', 'Phương Mai', 'Mai'),
('00235', 'WARD', '006', 'Thịnh Quang', 'Thinh Quang'),
('00238', 'WARD', '006', 'Khương Thượng', 'Khuong Thuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 007 - Hai Bà Trưng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00241', 'WARD', '007', 'Nguyễn Du', 'Nguyen Du'),
('00244', 'WARD', '007', 'Bạch Đằng', 'Bach Dang'),
('00247', 'WARD', '007', 'Phạm Đình Hổ', 'Pham Dinh Ho'),
('00256', 'WARD', '007', 'Lê Đại Hành', 'Le Dai Hanh'),
('00259', 'WARD', '007', 'Đồng Nhân', 'Dong Nhan'),
('00262', 'WARD', '007', 'Phố Huế', 'Pho Hue'),
('00268', 'WARD', '007', 'Thanh Lương', 'Thanh Luong'),
('00271', 'WARD', '007', 'Thanh Nhàn', 'Thanh Nhan'),
('00277', 'WARD', '007', 'Bách Khoa', 'Bach Khoa'),
('00280', 'WARD', '007', 'Đồng Tâm', 'Dong Tam'),
('00283', 'WARD', '007', 'Vĩnh Tuy', 'Vinh Tuy'),
('00289', 'WARD', '007', 'Quỳnh Mai', 'Quynh Mai'),
('00292', 'WARD', '007', 'Bạch Mai', 'Bach Mai'),
('00295', 'WARD', '007', 'Minh Khai', 'Minh Khai'),
('00298', 'WARD', '007', 'Trương Định', 'Truong Dinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 008 - Hoàng Mai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00301', 'WARD', '008', 'Thanh Trì', 'Thanh Tri'),
('00304', 'WARD', '008', 'Vĩnh Hưng', 'Vinh Hung'),
('00307', 'WARD', '008', 'Định Công', 'Dinh Cong'),
('00310', 'WARD', '008', 'Mai Động', 'Mai Dong'),
('00313', 'WARD', '008', 'Tương Mai', 'Tuong Mai'),
('00316', 'WARD', '008', 'Đại Kim', 'Dai Kim'),
('00319', 'WARD', '008', 'Tân Mai', 'Tan Mai'),
('00322', 'WARD', '008', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('00325', 'WARD', '008', 'Giáp Bát', 'Giap Bat'),
('00328', 'WARD', '008', 'Lĩnh Nam', 'Linh Nam'),
('00331', 'WARD', '008', 'Thịnh Liệt', 'Thinh Liet'),
('00334', 'WARD', '008', 'Trần Phú', 'Tran Phu'),
('00337', 'WARD', '008', 'Hoàng Liệt', 'Hoang Liet'),
('00340', 'WARD', '008', 'Yên Sở', 'Yen So')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 009 - Thanh Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00343', 'WARD', '009', 'Nhân Chính', 'Nhan Chinh'),
('00346', 'WARD', '009', 'Thượng Đình', 'Thuong Dinh'),
('00349', 'WARD', '009', 'Khương Trung', 'Khuong Trung'),
('00352', 'WARD', '009', 'Khương Mai', 'Khuong Mai'),
('00355', 'WARD', '009', 'Thanh Xuân Trung', 'Thanh Xuan Trung'),
('00358', 'WARD', '009', 'Phương Liệt', 'Liet'),
('00364', 'WARD', '009', 'Khương Đình', 'Khuong Dinh'),
('00367', 'WARD', '009', 'Thanh Xuân Bắc', 'Thanh Xuan Bac'),
('00373', 'WARD', '009', 'Hạ Đình', 'Ha Dinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 016 - Sóc Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00376', 'WARD', '016', 'Thị trấn Sóc Sơn', 'Thi tran Soc Son'),
('00379', 'WARD', '016', 'Bắc Sơn', 'Bac Son'),
('00382', 'WARD', '016', 'Minh Trí', 'Minh Tri'),
('00385', 'WARD', '016', 'Hồng Kỳ', 'Hong Ky'),
('00388', 'WARD', '016', 'Nam Sơn', 'Nam Son'),
('00391', 'WARD', '016', 'Trung Giã', 'Trung Gia'),
('00394', 'WARD', '016', 'Tân Hưng', 'Tan Hung'),
('00397', 'WARD', '016', 'Minh Phú', 'Minh Phu'),
('00400', 'WARD', '016', 'Phù Linh', 'Phu Linh'),
('00403', 'WARD', '016', 'Bắc Phú', 'Bac Phu'),
('00406', 'WARD', '016', 'Tân Minh', 'Tan Minh'),
('00409', 'WARD', '016', 'Quang Tiến', 'Quang Tien'),
('00412', 'WARD', '016', 'Hiền Ninh', 'Hien Ninh'),
('00415', 'WARD', '016', 'Tân Dân', 'Tan Dan'),
('00418', 'WARD', '016', 'Tiên Dược', 'Tien Duoc'),
('00421', 'WARD', '016', 'Việt Long', 'Viet Long'),
('00424', 'WARD', '016', 'Xuân Giang', 'Xuan Giang'),
('00427', 'WARD', '016', 'Mai Đình', 'Mai Dinh'),
('00430', 'WARD', '016', 'Đức Hoà', 'Duc Hoa'),
('00433', 'WARD', '016', 'Thanh Xuân', 'Thanh Xuan'),
('00436', 'WARD', '016', 'Đông Xuân', 'Dong Xuan'),
('00439', 'WARD', '016', 'Kim Lũ', 'Kim Lu'),
('00442', 'WARD', '016', 'Phú Cường', 'Phu Cuong'),
('00445', 'WARD', '016', 'Phú Minh', 'Phu Minh'),
('00448', 'WARD', '016', 'Phù Lỗ', 'Phu Lo'),
('00451', 'WARD', '016', 'Xuân Thu', 'Xuan Thu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 017 - Đông Anh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00454', 'WARD', '017', 'Thị trấn Đông Anh', 'Thi tran Dong Anh'),
('00457', 'WARD', '017', 'Xuân Nộn', 'Xuan Non'),
('00460', 'WARD', '017', 'Thuỵ Lâm', 'Thuy Lam'),
('00463', 'WARD', '017', 'Bắc Hồng', 'Bac Hong'),
('00466', 'WARD', '017', 'Nguyên Khê', 'Nguyen Khe'),
('00469', 'WARD', '017', 'Nam Hồng', 'Nam Hong'),
('00472', 'WARD', '017', 'Tiên Dương', 'Tien Duong'),
('00475', 'WARD', '017', 'Vân Hà', 'Van Ha'),
('00478', 'WARD', '017', 'Uy Nỗ', 'Uy No'),
('00481', 'WARD', '017', 'Vân Nội', 'Van Noi'),
('00484', 'WARD', '017', 'Liên Hà', 'Lien Ha'),
('00487', 'WARD', '017', 'Việt Hùng', 'Viet Hung'),
('00490', 'WARD', '017', 'Kim Nỗ', 'Kim No'),
('00493', 'WARD', '017', 'Kim Chung', 'Kim Chung'),
('00496', 'WARD', '017', 'Dục Tú', 'Duc Tu'),
('00499', 'WARD', '017', 'Đại Mạch', 'Dai Mach'),
('00502', 'WARD', '017', 'Vĩnh Ngọc', 'Vinh Ngoc'),
('00505', 'WARD', '017', 'Cổ Loa', 'Co Loa'),
('00508', 'WARD', '017', 'Hải Bối', 'Hai Boi'),
('00511', 'WARD', '017', 'Xuân Canh', 'Xuan Canh'),
('00514', 'WARD', '017', 'Võng La', 'Vong La'),
('00517', 'WARD', '017', 'Tàm Xá', 'Tam Xa'),
('00520', 'WARD', '017', 'Mai Lâm', 'Mai Lam'),
('00523', 'WARD', '017', 'Đông Hội', 'Dong Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 018 - Gia Lâm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00526', 'WARD', '018', 'Thị trấn Yên Viên', 'Thi tran Yen Vien'),
('00529', 'WARD', '018', 'Yên Thường', 'Yen Thuong'),
('00532', 'WARD', '018', 'Yên Viên', 'Yen Vien'),
('00535', 'WARD', '018', 'Ninh Hiệp', 'Ninh Hiep'),
('00541', 'WARD', '018', 'Thiên Đức', 'Thien Duc'),
('00544', 'WARD', '018', 'Phù Đổng', 'Phu Dong'),
('00550', 'WARD', '018', 'Lệ Chi', 'Le Chi'),
('00553', 'WARD', '018', 'Cổ Bi', 'Co Bi'),
('00556', 'WARD', '018', 'Đặng Xá', 'Dang Xa'),
('00562', 'WARD', '018', 'Phú Sơn', 'Phu Son'),
('00565', 'WARD', '018', 'Thị trấn Trâu Quỳ', 'Thi tran Trau Quy'),
('00568', 'WARD', '018', 'Dương Quang', 'Duong Quang'),
('00571', 'WARD', '018', 'Dương Xá', 'Duong Xa'),
('00577', 'WARD', '018', 'Đa Tốn', 'Da Ton'),
('00580', 'WARD', '018', 'Kiêu Kỵ', 'Kieu Ky'),
('00583', 'WARD', '018', 'Bát Tràng', 'Bat Trang'),
('00589', 'WARD', '018', 'Kim Đức', 'Kim Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 019 - Nam Từ Liêm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00592', 'WARD', '019', 'Cầu Diễn', 'Cau Dien'),
('00622', 'WARD', '019', 'Xuân Phương', 'Xuan Phuong'),
('00623', 'WARD', '019', 'Phương Canh', 'Canh'),
('00625', 'WARD', '019', 'Mỹ Đình 1', 'My Dinh 1'),
('00626', 'WARD', '019', 'Mỹ Đình 2', 'My Dinh 2'),
('00628', 'WARD', '019', 'Tây Mỗ', 'Tay Mo'),
('00631', 'WARD', '019', 'Mễ Trì', 'Me Tri'),
('00632', 'WARD', '019', 'Phú Đô', 'Phu Do'),
('00634', 'WARD', '019', 'Đại Mỗ', 'Dai Mo'),
('00637', 'WARD', '019', 'Trung Văn', 'Trung Van')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 020 - Thanh Trì
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00640', 'WARD', '020', 'Thị trấn Văn Điển', 'Thi tran Van Dien'),
('00643', 'WARD', '020', 'Tân Triều', 'Tan Trieu'),
('00646', 'WARD', '020', 'Thanh Liệt', 'Thanh Liet'),
('00649', 'WARD', '020', 'Tả Thanh Oai', 'Ta Thanh Oai'),
('00652', 'WARD', '020', 'Hữu Hoà', 'Huu Hoa'),
('00655', 'WARD', '020', 'Tam Hiệp', 'Tam Hiep'),
('00658', 'WARD', '020', 'Tứ Hiệp', 'Tu Hiep'),
('00661', 'WARD', '020', 'Yên Mỹ', 'Yen My'),
('00664', 'WARD', '020', 'Vĩnh Quỳnh', 'Vinh Quynh'),
('00667', 'WARD', '020', 'Ngũ Hiệp', 'Ngu Hiep'),
('00670', 'WARD', '020', 'Duyên Hà', 'Duyen Ha'),
('00673', 'WARD', '020', 'Ngọc Hồi', 'Ngoc Hoi'),
('00676', 'WARD', '020', 'Vạn Phúc', 'Van Phuc'),
('00679', 'WARD', '020', 'Đại áng', 'Dai ang'),
('00682', 'WARD', '020', 'Liên Ninh', 'Lien Ninh'),
('00685', 'WARD', '020', 'Đông Mỹ', 'Dong My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 021 - Bắc Từ Liêm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00595', 'WARD', '021', 'Thượng Cát', 'Thuong Cat'),
('00598', 'WARD', '021', 'Liên Mạc', 'Lien Mac'),
('00601', 'WARD', '021', 'Đông Ngạc', 'Dong Ngac'),
('00602', 'WARD', '021', 'Đức Thắng', 'Duc Thang'),
('00604', 'WARD', '021', 'Thụy Phương', 'Thuy Phuong'),
('00607', 'WARD', '021', 'Tây Tựu', 'Tay Tuu'),
('00610', 'WARD', '021', 'Xuân Đỉnh', 'Xuan Dinh'),
('00611', 'WARD', '021', 'Xuân Tảo', 'Xuan Tao'),
('00613', 'WARD', '021', 'Minh Khai', 'Minh Khai'),
('00616', 'WARD', '021', 'Cổ Nhuế 1', 'Co Nhue 1'),
('00617', 'WARD', '021', 'Cổ Nhuế 2', 'Co Nhue 2'),
('00619', 'WARD', '021', 'Phú Diễn', 'Phu Dien'),
('00620', 'WARD', '021', 'Phúc Diễn', 'Phuc Dien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 250 - Mê Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08973', 'WARD', '250', 'Thị trấn Chi Đông', 'Thi tran Chi Dong'),
('08974', 'WARD', '250', 'Đại Thịnh', 'Dai Thinh'),
('08977', 'WARD', '250', 'Kim Hoa', 'Kim Hoa'),
('08980', 'WARD', '250', 'Thạch Đà', 'Thach Da'),
('08983', 'WARD', '250', 'Tiến Thắng', 'Tien Thang'),
('08986', 'WARD', '250', 'Tự Lập', 'Tu Lap'),
('08989', 'WARD', '250', 'Thị trấn Quang Minh', 'Thi tran Quang Minh'),
('08992', 'WARD', '250', 'Thanh Lâm', 'Thanh Lam'),
('08995', 'WARD', '250', 'Tam Đồng', 'Tam Dong'),
('08998', 'WARD', '250', 'Liên Mạc', 'Lien Mac'),
('09004', 'WARD', '250', 'Chu Phan', 'Chu Phan'),
('09007', 'WARD', '250', 'Tiến Thịnh', 'Tien Thinh'),
('09010', 'WARD', '250', 'Mê Linh', 'Me Linh'),
('09013', 'WARD', '250', 'Văn Khê', 'Van Khe'),
('09016', 'WARD', '250', 'Hoàng Kim', 'Hoang Kim'),
('09019', 'WARD', '250', 'Tiền Phong', 'Tien Phong'),
('09022', 'WARD', '250', 'Tráng Việt', 'Trang Viet')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 268 - Hà Đông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09538', 'WARD', '268', 'Quang Trung', 'Quang Trung'),
('09541', 'WARD', '268', 'Mộ Lao', 'Mo Lao'),
('09542', 'WARD', '268', 'Văn Quán', 'Van Quan'),
('09544', 'WARD', '268', 'Vạn Phúc', 'Van Phuc'),
('09551', 'WARD', '268', 'La Khê', 'La Khe'),
('09552', 'WARD', '268', 'Phú La', 'Phu La'),
('09553', 'WARD', '268', 'Phúc La', 'Phuc La'),
('09556', 'WARD', '268', 'Hà Cầu', 'Ha Cau'),
('09562', 'WARD', '268', 'Yên Nghĩa', 'Yen Nghia'),
('09565', 'WARD', '268', 'Kiến Hưng', 'Kien Hung'),
('09568', 'WARD', '268', 'Phú Lãm', 'Phu Lam'),
('09571', 'WARD', '268', 'Phú Lương', 'Phu Luong'),
('09886', 'WARD', '268', 'Dương Nội', 'Duong Noi'),
('10117', 'WARD', '268', 'Đồng Mai', 'Dong Mai'),
('10123', 'WARD', '268', 'Biên Giang', 'Bien Giang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 269 - Thị Sơn Tây
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09574', 'WARD', '269', 'Ngô Quyền', 'Ngo Quyen'),
('09577', 'WARD', '269', 'Phú Thịnh', 'Phu Thinh'),
('09586', 'WARD', '269', 'Sơn Lộc', 'Son Loc'),
('09589', 'WARD', '269', 'Xuân Khanh', 'Xuan Khanh'),
('09592', 'WARD', '269', 'Đường Lâm', 'Duong Lam'),
('09595', 'WARD', '269', 'Viên Sơn', 'Vien Son'),
('09598', 'WARD', '269', 'Xuân Sơn', 'Xuan Son'),
('09601', 'WARD', '269', 'Trung Hưng', 'Trung Hung'),
('09604', 'WARD', '269', 'Thanh Mỹ', 'Thanh My'),
('09607', 'WARD', '269', 'Trung Sơn Trầm', 'Trung Son Tram'),
('09610', 'WARD', '269', 'Kim Sơn', 'Kim Son'),
('09613', 'WARD', '269', 'Sơn Đông', 'Son Dong'),
('09616', 'WARD', '269', 'Cổ Đông', 'Co Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 271 - Ba Vì
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09619', 'WARD', '271', 'Thị trấn Tây Đằng', 'Thi tran Tay Dang'),
('09625', 'WARD', '271', 'Phú Cường', 'Phu Cuong'),
('09628', 'WARD', '271', 'Cổ Đô', 'Co Do'),
('09634', 'WARD', '271', 'Vạn Thắng', 'Van Thang'),
('09640', 'WARD', '271', 'Phong Vân', 'Phong Van'),
('09643', 'WARD', '271', 'Phú Đông', 'Phu Dong'),
('09646', 'WARD', '271', 'Phú Hồng', 'Phu Hong'),
('09649', 'WARD', '271', 'Phú Châu', 'Phu Chau'),
('09652', 'WARD', '271', 'Thái Hòa', 'Thai Hoa'),
('09655', 'WARD', '271', 'Đồng Thái', 'Dong Thai'),
('09658', 'WARD', '271', 'Phú Sơn', 'Phu Son'),
('09661', 'WARD', '271', 'Minh Châu', 'Minh Chau'),
('09664', 'WARD', '271', 'Vật Lại', 'Vat Lai'),
('09667', 'WARD', '271', 'Chu Minh', 'Chu Minh'),
('09670', 'WARD', '271', 'Tòng Bạt', 'Tong Bat'),
('09673', 'WARD', '271', 'Cẩm Lĩnh', 'Cam Linh'),
('09676', 'WARD', '271', 'Sơn Đà', 'Son Da'),
('09679', 'WARD', '271', 'Đông Quang', 'Dong Quang'),
('09682', 'WARD', '271', 'Tiên Phong', 'Tien Phong'),
('09685', 'WARD', '271', 'Thụy An', 'Thuy An'),
('09688', 'WARD', '271', 'Cam Thượng', 'Cam Thuong'),
('09691', 'WARD', '271', 'Thuần Mỹ', 'Thuan My'),
('09694', 'WARD', '271', 'Tản Lĩnh', 'Tan Linh'),
('09697', 'WARD', '271', 'Ba Trại', 'Ba Trai'),
('09700', 'WARD', '271', 'Minh Quang', 'Minh Quang'),
('09703', 'WARD', '271', 'Ba Vì', 'Ba Vi'),
('09706', 'WARD', '271', 'Vân Hòa', 'Van Hoa'),
('09709', 'WARD', '271', 'Yên Bài', 'Yen Bai'),
('09712', 'WARD', '271', 'Khánh Thượng', 'Khanh Thuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 272 - Phúc Thọ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09715', 'WARD', '272', 'Thị trấn Phúc Thọ', 'Thi tran Phuc Tho'),
('09721', 'WARD', '272', 'Vân Phúc', 'Van Phuc'),
('09724', 'WARD', '272', 'Nam Hà', 'Nam Ha'),
('09727', 'WARD', '272', 'Xuân Đình', 'Xuan Dinh'),
('09733', 'WARD', '272', 'Sen Phương', 'Sen Phuong'),
('09739', 'WARD', '272', 'Võng Xuyên', 'Vong Xuyen'),
('09742', 'WARD', '272', 'Tích Lộc', 'Tich Loc'),
('09745', 'WARD', '272', 'Long Thượng', 'Long Thuong'),
('09751', 'WARD', '272', 'Hát Môn', 'Hat Mon'),
('09757', 'WARD', '272', 'Thanh Đa', 'Thanh Da'),
('09760', 'WARD', '272', 'Trạch Mỹ Lộc', 'Trach My Loc'),
('09763', 'WARD', '272', 'Phúc Hòa', 'Phuc Hoa'),
('09766', 'WARD', '272', 'Ngọc Tảo', 'Ngoc Tao'),
('09769', 'WARD', '272', 'Phụng Thượng', 'Phung Thuong'),
('09772', 'WARD', '272', 'Tam Thuấn', 'Tam Thuan'),
('09775', 'WARD', '272', 'Tam Hiệp', 'Tam Hiep'),
('09778', 'WARD', '272', 'Hiệp Thuận', 'Hiep Thuan'),
('09781', 'WARD', '272', 'Liên Hiệp', 'Lien Hiep')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 273 - Đan Phượng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09784', 'WARD', '273', 'Thị trấn Phùng', 'Thi tran Phung'),
('09787', 'WARD', '273', 'Trung Châu', 'Trung Chau'),
('09790', 'WARD', '273', 'Thọ An', 'Tho An'),
('09793', 'WARD', '273', 'Thọ Xuân', 'Tho Xuan'),
('09796', 'WARD', '273', 'Hồng Hà', 'Hong Ha'),
('09799', 'WARD', '273', 'Liên Hồng', 'Lien Hong'),
('09802', 'WARD', '273', 'Liên Hà', 'Lien Ha'),
('09805', 'WARD', '273', 'Hạ Mỗ', 'Ha Mo'),
('09808', 'WARD', '273', 'Liên Trung', 'Lien Trung'),
('09811', 'WARD', '273', 'Phương Đình', 'Dinh'),
('09814', 'WARD', '273', 'Thượng Mỗ', 'Thuong Mo'),
('09817', 'WARD', '273', 'Tân Hội', 'Tan Hoi'),
('09820', 'WARD', '273', 'Tân Lập', 'Tan Lap'),
('09823', 'WARD', '273', 'Đan Phượng', 'Dan Phuong'),
('09826', 'WARD', '273', 'Đồng Tháp', 'Dong Thap'),
('09829', 'WARD', '273', 'Song Phượng', 'Song Phuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 274 - Hoài Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09832', 'WARD', '274', 'Thị trấn Trạm Trôi', 'Thi tran Tram Troi'),
('09835', 'WARD', '274', 'Đức Thượng', 'Duc Thuong'),
('09838', 'WARD', '274', 'Minh Khai', 'Minh Khai'),
('09841', 'WARD', '274', 'Dương Liễu', 'Duong Lieu'),
('09844', 'WARD', '274', 'Di Trạch', 'Di Trach'),
('09847', 'WARD', '274', 'Đức Giang', 'Duc Giang'),
('09850', 'WARD', '274', 'Cát Quế', 'Cat Que'),
('09853', 'WARD', '274', 'Kim Chung', 'Kim Chung'),
('09856', 'WARD', '274', 'Yên Sở', 'Yen So'),
('09859', 'WARD', '274', 'Sơn Đồng', 'Son Dong'),
('09862', 'WARD', '274', 'Vân Canh', 'Van Canh'),
('09865', 'WARD', '274', 'Đắc Sở', 'Dac So'),
('09868', 'WARD', '274', 'Lại Yên', 'Lai Yen'),
('09871', 'WARD', '274', 'Tiền Yên', 'Tien Yen'),
('09874', 'WARD', '274', 'Song Phương', 'Song Phuong'),
('09877', 'WARD', '274', 'An Khánh', 'An Khanh'),
('09880', 'WARD', '274', 'An Thượng', 'An Thuong'),
('09883', 'WARD', '274', 'Vân Côn', 'Van Con'),
('09889', 'WARD', '274', 'La Phù', 'La Phu'),
('09892', 'WARD', '274', 'Đông La', 'Dong La')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 275 - Quốc Oai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04939', 'WARD', '275', 'Đông Xuân', 'Dong Xuan'),
('09895', 'WARD', '275', 'Thị trấn Quốc Oai', 'Thi tran Quoc Oai'),
('09898', 'WARD', '275', 'Sài Sơn', 'Sai Son'),
('09904', 'WARD', '275', 'Phượng Sơn', 'Son'),
('09907', 'WARD', '275', 'Ngọc Liệp', 'Ngoc Liep'),
('09910', 'WARD', '275', 'Ngọc Mỹ', 'Ngoc My'),
('09916', 'WARD', '275', 'Thạch Thán', 'Thach Than'),
('09919', 'WARD', '275', 'Đồng Quang', 'Dong Quang'),
('09922', 'WARD', '275', 'Phú Cát', 'Phu Cat'),
('09925', 'WARD', '275', 'Tuyết Nghĩa', 'Tuyet Nghia'),
('09928', 'WARD', '275', 'Liệp Nghĩa', 'Liep Nghia'),
('09931', 'WARD', '275', 'Cộng Hòa', 'Cong Hoa'),
('09934', 'WARD', '275', 'Hưng Đạo', 'Hung Dao'),
('09940', 'WARD', '275', 'Phú Mãn', 'Phu Man'),
('09943', 'WARD', '275', 'Cấn Hữu', 'Can Huu'),
('09949', 'WARD', '275', 'Hòa Thạch', 'Hoa Thach'),
('09952', 'WARD', '275', 'Đông Yên', 'Dong Yen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 276 - Thạch Thất
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04927', 'WARD', '276', 'Yên Trung', 'Yen Trung'),
('04930', 'WARD', '276', 'Yên Bình', 'Yen Binh'),
('04936', 'WARD', '276', 'Tiến Xuân', 'Tien Xuan'),
('09955', 'WARD', '276', 'Thị trấn Liên Quan', 'Thi tran Lien Quan'),
('09958', 'WARD', '276', 'Đại Đồng', 'Dai Dong'),
('09961', 'WARD', '276', 'Cẩm Yên', 'Cam Yen'),
('09964', 'WARD', '276', 'Lại Thượng', 'Lai Thuong'),
('09967', 'WARD', '276', 'Phú Kim', 'Phu Kim'),
('09970', 'WARD', '276', 'Hương Ngải', 'Huong Ngai'),
('09973', 'WARD', '276', 'Lam Sơn', 'Lam Son'),
('09976', 'WARD', '276', 'Kim Quan', 'Kim Quan'),
('09982', 'WARD', '276', 'Bình Yên', 'Binh Yen'),
('09988', 'WARD', '276', 'Thạch Hoà', 'Thach Hoa'),
('09991', 'WARD', '276', 'Cần Kiệm', 'Can Kiem'),
('09997', 'WARD', '276', 'Phùng Xá', 'Phung Xa'),
('10000', 'WARD', '276', 'Tân Xã', 'Tan Xa'),
('10003', 'WARD', '276', 'Thạch Xá', 'Thach Xa'),
('10006', 'WARD', '276', 'Quang Trung', 'Quang Trung'),
('10009', 'WARD', '276', 'Hạ Bằng', 'Ha Bang'),
('10012', 'WARD', '276', 'Đồng Trúc', 'Dong Truc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 277 - Chương Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10015', 'WARD', '277', 'Thị trấn Chúc Sơn', 'Thi tran Chuc Son'),
('10018', 'WARD', '277', 'Thị trấn Xuân Mai', 'Thi tran Xuan Mai'),
('10021', 'WARD', '277', 'Phụng Châu', 'Phung Chau'),
('10024', 'WARD', '277', 'Tiên Phương', 'Tien Phuong'),
('10027', 'WARD', '277', 'Đông Sơn', 'Dong Son'),
('10030', 'WARD', '277', 'Đông Phương Yên', 'Dong Yen'),
('10033', 'WARD', '277', 'Phú Nghĩa', 'Phu Nghia'),
('10039', 'WARD', '277', 'Trường Yên', 'Truong Yen'),
('10042', 'WARD', '277', 'Ngọc Hòa', 'Ngoc Hoa'),
('10045', 'WARD', '277', 'Thủy Xuân Tiên', 'Thuy Xuan Tien'),
('10048', 'WARD', '277', 'Thanh Bình', 'Thanh Binh'),
('10051', 'WARD', '277', 'Trung Hòa', 'Trung Hoa'),
('10054', 'WARD', '277', 'Đại Yên', 'Dai Yen'),
('10057', 'WARD', '277', 'Thụy Hương', 'Thuy Huong'),
('10060', 'WARD', '277', 'Tốt Động', 'Tot Dong'),
('10063', 'WARD', '277', 'Lam Điền', 'Lam Dien'),
('10066', 'WARD', '277', 'Tân Tiến', 'Tan Tien'),
('10069', 'WARD', '277', 'Nam Phương Tiến', 'Nam Tien'),
('10072', 'WARD', '277', 'Hợp Đồng', 'Hop Dong'),
('10075', 'WARD', '277', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('10078', 'WARD', '277', 'Hoàng Diệu', 'Hoang Dieu'),
('10081', 'WARD', '277', 'Hữu Văn', 'Huu Van'),
('10084', 'WARD', '277', 'Quảng Bị', 'Quang Bi'),
('10087', 'WARD', '277', 'Mỹ Lương', 'My Luong'),
('10090', 'WARD', '277', 'Thượng Vực', 'Thuong Vuc'),
('10096', 'WARD', '277', 'Hồng Phú', 'Hong Phu'),
('10099', 'WARD', '277', 'Trần Phú', 'Tran Phu'),
('10102', 'WARD', '277', 'Văn Võ', 'Van Vo'),
('10105', 'WARD', '277', 'Đồng Lạc', 'Dong Lac'),
('10108', 'WARD', '277', 'Hòa Phú', 'Hoa Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 278 - Thanh Oai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10114', 'WARD', '278', 'Thị trấn Kim Bài', 'Thi tran Kim Bai'),
('10120', 'WARD', '278', 'Cự Khê', 'Cu Khe'),
('10126', 'WARD', '278', 'Bích Hòa', 'Bich Hoa'),
('10129', 'WARD', '278', 'Mỹ Hưng', 'My Hung'),
('10132', 'WARD', '278', 'Cao Viên', 'Cao Vien'),
('10135', 'WARD', '278', 'Bình Minh', 'Binh Minh'),
('10138', 'WARD', '278', 'Tam Hưng', 'Tam Hung'),
('10141', 'WARD', '278', 'Thanh Cao', 'Thanh Cao'),
('10144', 'WARD', '278', 'Thanh Thùy', 'Thanh Thuy'),
('10147', 'WARD', '278', 'Thanh Mai', 'Thanh Mai'),
('10150', 'WARD', '278', 'Thanh Văn', 'Thanh Van'),
('10153', 'WARD', '278', 'Đỗ Động', 'Do Dong'),
('10156', 'WARD', '278', 'Kim An', 'Kim An'),
('10159', 'WARD', '278', 'Kim Thư', 'Kim Thu'),
('10162', 'WARD', '278', 'Phương Trung', 'Trung'),
('10165', 'WARD', '278', 'Tân Ước', 'Tan Uoc'),
('10168', 'WARD', '278', 'Dân Hòa', 'Dan Hoa'),
('10171', 'WARD', '278', 'Liên Châu', 'Lien Chau'),
('10174', 'WARD', '278', 'Cao Xuân Dương', 'Cao Xuan Duong'),
('10180', 'WARD', '278', 'Hồng Dương', 'Hong Duong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 279 - Thường Tín
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10183', 'WARD', '279', 'Thị trấn Thường Tín', 'Thi tran Thuong Tin'),
('10186', 'WARD', '279', 'Ninh Sở', 'Ninh So'),
('10189', 'WARD', '279', 'Nhị Khê', 'Nhi Khe'),
('10192', 'WARD', '279', 'Duyên Thái', 'Duyen Thai'),
('10195', 'WARD', '279', 'Khánh Hà', 'Khanh Ha'),
('10198', 'WARD', '279', 'Hòa Bình', 'Hoa Binh'),
('10201', 'WARD', '279', 'Văn Bình', 'Van Binh'),
('10204', 'WARD', '279', 'Hiền Giang', 'Hien Giang'),
('10207', 'WARD', '279', 'Hồng Vân', 'Hong Van'),
('10210', 'WARD', '279', 'Vân Tảo', 'Van Tao'),
('10213', 'WARD', '279', 'Liên Phương', 'Lien Phuong'),
('10216', 'WARD', '279', 'Văn Phú', 'Van Phu'),
('10219', 'WARD', '279', 'Tự Nhiên', 'Tu Nhien'),
('10222', 'WARD', '279', 'Tiền Phong', 'Tien Phong'),
('10225', 'WARD', '279', 'Hà Hồi', 'Ha Hoi'),
('10231', 'WARD', '279', 'Nguyễn Trãi', 'Nguyen Trai'),
('10234', 'WARD', '279', 'Quất Động', 'Quat Dong'),
('10237', 'WARD', '279', 'Chương Dương', 'Chuong Duong'),
('10240', 'WARD', '279', 'Tân Minh', 'Tan Minh'),
('10243', 'WARD', '279', 'Lê Lợi', 'Le Loi'),
('10246', 'WARD', '279', 'Thắng Lợi', 'Thang Loi'),
('10249', 'WARD', '279', 'Dũng Tiến', 'Dung Tien'),
('10255', 'WARD', '279', 'Nghiêm Xuyên', 'Nghiem Xuyen'),
('10258', 'WARD', '279', 'Tô Hiệu', 'To Hieu'),
('10261', 'WARD', '279', 'Văn Tự', 'Van Tu'),
('10264', 'WARD', '279', 'Vạn Nhất', 'Van Nhat'),
('10267', 'WARD', '279', 'Minh Cường', 'Minh Cuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 280 - Phú Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10270', 'WARD', '280', 'Thị trấn Phú Minh', 'Thi tran Phu Minh'),
('10273', 'WARD', '280', 'Thị trấn Phú Xuyên', 'Thi tran Phu Xuyen'),
('10276', 'WARD', '280', 'Hồng Minh', 'Hong Minh'),
('10279', 'WARD', '280', 'Phượng Dực', 'Duc'),
('10282', 'WARD', '280', 'Nam Tiến', 'Nam Tien'),
('10291', 'WARD', '280', 'Văn Hoàng', 'Van Hoang'),
('10294', 'WARD', '280', 'Phú Túc', 'Phu Tuc'),
('10300', 'WARD', '280', 'Hồng Thái', 'Hong Thai'),
('10303', 'WARD', '280', 'Hoàng Long', 'Hoang Long'),
('10312', 'WARD', '280', 'Nam Phong', 'Nam Phong'),
('10315', 'WARD', '280', 'Tân Dân', 'Tan Dan'),
('10318', 'WARD', '280', 'Quang Hà', 'Quang Ha'),
('10321', 'WARD', '280', 'Chuyên Mỹ', 'CMy'),
('10324', 'WARD', '280', 'Khai Thái', 'Khai Thai'),
('10327', 'WARD', '280', 'Phúc Tiến', 'Phuc Tien'),
('10330', 'WARD', '280', 'Vân Từ', 'Van Tu'),
('10333', 'WARD', '280', 'Tri Thủy', 'Tri Thuy'),
('10336', 'WARD', '280', 'Đại Xuyên', 'Dai Xuyen'),
('10339', 'WARD', '280', 'Phú Yên', 'Phu Yen'),
('10342', 'WARD', '280', 'Bạch Hạ', 'Bach Ha'),
('10345', 'WARD', '280', 'Quang Lãng', 'Quang Lang'),
('10348', 'WARD', '280', 'Châu Can', 'Chau Can'),
('10351', 'WARD', '280', 'Minh Tân', 'Minh Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 281 - Ứng Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10354', 'WARD', '281', 'Thị trấn Vân Đình', 'Thi tran Van Dinh'),
('10363', 'WARD', '281', 'Hoa Viên', 'Hoa Vien'),
('10366', 'WARD', '281', 'Quảng Phú Cầu', 'Quang Phu Cau'),
('10369', 'WARD', '281', 'Trường Thịnh', 'Truong Thinh'),
('10375', 'WARD', '281', 'Liên Bạt', 'Lien Bat'),
('10378', 'WARD', '281', 'Cao Sơn Tiến', 'Cao Son Tien'),
('10384', 'WARD', '281', 'Phương Tú', 'Tu'),
('10387', 'WARD', '281', 'Trung Tú', 'Trung Tu'),
('10390', 'WARD', '281', 'Đồng Tân', 'Dong Tan'),
('10393', 'WARD', '281', 'Tảo Dương Văn', 'Tao Duong Van'),
('10396', 'WARD', '281', 'Thái Hòa', 'Thai Hoa'),
('10399', 'WARD', '281', 'Minh Đức', 'Minh Duc'),
('10402', 'WARD', '281', 'Trầm Lộng', 'Tram Long'),
('10411', 'WARD', '281', 'Kim Đường', 'Kim Duong'),
('10417', 'WARD', '281', 'Hòa Phú', 'Hoa Phu'),
('10423', 'WARD', '281', 'Đại Hùng', 'Dai Hung'),
('10426', 'WARD', '281', 'Đông Lỗ', 'Dong Lo'),
('10429', 'WARD', '281', 'Phù Lưu', 'Phu Luu'),
('10432', 'WARD', '281', 'Đại Cường', 'Dai Cuong'),
('10435', 'WARD', '281', 'Bình Lưu Quang', 'Binh Luu Quang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 282 - Mỹ Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10441', 'WARD', '282', 'Thị trấn Đại Nghĩa', 'Thi tran Dai Nghia'),
('10444', 'WARD', '282', 'Đồng Tâm', 'Dong Tam'),
('10447', 'WARD', '282', 'Thượng Lâm', 'Thuong Lam'),
('10450', 'WARD', '282', 'Tuy Lai', 'Tuy Lai'),
('10453', 'WARD', '282', 'Phúc Lâm', 'Phuc Lam'),
('10459', 'WARD', '282', 'Mỹ Xuyên', 'My Xuyen'),
('10462', 'WARD', '282', 'An Mỹ', 'An My'),
('10465', 'WARD', '282', 'Hồng Sơn', 'Hong Son'),
('10468', 'WARD', '282', 'Lê Thanh', 'Le Thanh'),
('10471', 'WARD', '282', 'Xuy Xá', 'Xuy Xa'),
('10474', 'WARD', '282', 'Phùng Xá', 'Phung Xa'),
('10477', 'WARD', '282', 'Phù Lưu Tế', 'Phu Luu Te'),
('10480', 'WARD', '282', 'Đại Hưng', 'Dai Hung'),
('10483', 'WARD', '282', 'Vạn Tín', 'Van Tin'),
('10489', 'WARD', '282', 'Hương Sơn', 'Huong Son'),
('10492', 'WARD', '282', 'Hùng Tiến', 'Hung Tien'),
('10495', 'WARD', '282', 'An Tiến', 'An Tien'),
('10498', 'WARD', '282', 'Hợp Tiến', 'Hop Tien'),
('10501', 'WARD', '282', 'Hợp Thanh', 'Hop Thanh'),
('10504', 'WARD', '282', 'An Phú', 'An Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 02 - Hà Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('024', 'DISTRICT', '02', 'Hà Giang', 'Ha Giang'),
('026', 'DISTRICT', '02', 'Đồng Văn', 'Dong Van'),
('027', 'DISTRICT', '02', 'Mèo Vạc', 'Meo Vac'),
('028', 'DISTRICT', '02', 'Yên Minh', 'Yen Minh'),
('029', 'DISTRICT', '02', 'Quản Bạ', 'Ba'),
('030', 'DISTRICT', '02', 'Vị Xuyên', 'Vi Xuyen'),
('031', 'DISTRICT', '02', 'Bắc Mê', 'Bac Me'),
('032', 'DISTRICT', '02', 'Hoàng Su Phì', 'Hoang Su Phi'),
('033', 'DISTRICT', '02', 'Xín Mần', 'Xin Man'),
('034', 'DISTRICT', '02', 'Bắc Quang', 'Bac Quang'),
('035', 'DISTRICT', '02', 'Quang Bình', 'Quang Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 024 - Hà Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00688', 'WARD', '024', 'Quang Trung', 'Quang Trung'),
('00691', 'WARD', '024', 'Trần Phú', 'Tran Phu'),
('00692', 'WARD', '024', 'Ngọc Hà', 'Ngoc Ha'),
('00694', 'WARD', '024', 'Nguyễn Trãi', 'Nguyen Trai'),
('00697', 'WARD', '024', 'Minh Khai', 'Minh Khai'),
('00700', 'WARD', '024', 'Ngọc Đường', 'Ngoc Duong'),
('00946', 'WARD', '024', 'Phương Độ', 'Do'),
('00949', 'WARD', '024', 'Phương Thiện', 'Thien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 026 - Đồng Văn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00712', 'WARD', '026', 'Thị trấn Phó Bảng', 'Thi tran Pho Bang'),
('00715', 'WARD', '026', 'Lũng Cú', 'Lung Cu'),
('00718', 'WARD', '026', 'Má Lé', 'Ma Le'),
('00721', 'WARD', '026', 'Thị trấn Đồng Văn', 'Thi tran Dong Van'),
('00724', 'WARD', '026', 'Lũng Táo', 'Lung Tao'),
('00727', 'WARD', '026', 'Phố Là', 'Pho La'),
('00730', 'WARD', '026', 'Thài Phìn Tủng', 'Thai Phin Tung'),
('00733', 'WARD', '026', 'Sủng Là', 'Sung La'),
('00736', 'WARD', '026', 'Xà Phìn', 'Phin'),
('00739', 'WARD', '026', 'Tả Phìn', 'Ta Phin'),
('00742', 'WARD', '026', 'Tả Lủng', 'Ta Lung'),
('00745', 'WARD', '026', 'Phố Cáo', 'Pho Cao'),
('00748', 'WARD', '026', 'Sính Lủng', 'Sinh Lung'),
('00751', 'WARD', '026', 'Sảng Tủng', 'Sang Tung'),
('00754', 'WARD', '026', 'Lũng Thầu', 'Lung Thau'),
('00757', 'WARD', '026', 'Hố Quáng Phìn', 'Ho Quang Phin'),
('00760', 'WARD', '026', 'Vần Chải', 'Van Chai'),
('00763', 'WARD', '026', 'Lũng Phìn', 'Lung Phin'),
('00766', 'WARD', '026', 'Sủng Trái', 'Sung Trai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 027 - Mèo Vạc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00769', 'WARD', '027', 'Thị trấn Mèo Vạc', 'Thi tran Meo Vac'),
('00772', 'WARD', '027', 'Thượng Phùng', 'Thuong Phung'),
('00775', 'WARD', '027', 'Pải Lủng', 'Pai Lung'),
('00778', 'WARD', '027', 'Xín Cái', 'Xin Cai'),
('00781', 'WARD', '027', 'Pả Vi', 'Pa Vi'),
('00784', 'WARD', '027', 'Giàng Chu Phìn', 'Giang Chu Phin'),
('00787', 'WARD', '027', 'Sủng Trà', 'Sung Tra'),
('00790', 'WARD', '027', 'Sủng Máng', 'Sung Mang'),
('00793', 'WARD', '027', 'Sơn Vĩ', 'Son Vi'),
('00796', 'WARD', '027', 'Tả Lủng', 'Ta Lung'),
('00799', 'WARD', '027', 'Cán Chu Phìn', 'Can Chu Phin'),
('00802', 'WARD', '027', 'Lũng Pù', 'Lung Pu'),
('00805', 'WARD', '027', 'Lũng Chinh', 'Lung Chinh'),
('00808', 'WARD', '027', 'Tát Ngà', 'Tat Nga'),
('00811', 'WARD', '027', 'Nậm Ban', 'Nam Ban'),
('00814', 'WARD', '027', 'Khâu Vai', 'Khau Vai'),
('00815', 'WARD', '027', 'Niêm Tòng', 'Niem Tong'),
('00817', 'WARD', '027', 'Niêm Sơn', 'Niem Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 028 - Yên Minh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00820', 'WARD', '028', 'Thị trấn Yên Minh', 'Thi tran Yen Minh'),
('00823', 'WARD', '028', 'Thắng Mố', 'Thang Mo'),
('00826', 'WARD', '028', 'Phú Lũng', 'Phu Lung'),
('00829', 'WARD', '028', 'Sủng Tráng', 'Sung Trang'),
('00832', 'WARD', '028', 'Bạch Đích', 'Bach Dich'),
('00835', 'WARD', '028', 'Na Khê', 'Na Khe'),
('00838', 'WARD', '028', 'Sủng Thài', 'Sung Thai'),
('00841', 'WARD', '028', 'Hữu Vinh', 'Huu Vinh'),
('00844', 'WARD', '028', 'Lao Và Chải', 'Lao Va Chai'),
('00847', 'WARD', '028', 'Mậu Duệ', 'Mau Due'),
('00850', 'WARD', '028', 'Đông Minh', 'Dong Minh'),
('00853', 'WARD', '028', 'Mậu Long', 'Mau Long'),
('00856', 'WARD', '028', 'Ngam La', 'Ngam La'),
('00859', 'WARD', '028', 'Ngọc Long', 'Ngoc Long'),
('00862', 'WARD', '028', 'Đường Thượng', 'Duong Thuong'),
('00865', 'WARD', '028', 'Lũng Hồ', 'Lung Ho'),
('00868', 'WARD', '028', 'Du Tiến', 'Du Tien'),
('00871', 'WARD', '028', 'Du Già', 'Du Gia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 029 - Quản Bạ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00874', 'WARD', '029', 'Thị trấn Tam Sơn', 'Thi tran Tam Son'),
('00877', 'WARD', '029', 'Bát Đại Sơn', 'Bat Dai Son'),
('00880', 'WARD', '029', 'Nghĩa Thuận', 'Nghia Thuan'),
('00883', 'WARD', '029', 'Cán Tỷ', 'Can Ty'),
('00886', 'WARD', '029', 'Cao Mã Pờ', 'Cao Ma Po'),
('00889', 'WARD', '029', 'Thanh Vân', 'Thanh Van'),
('00892', 'WARD', '029', 'Tùng Vài', 'Tung Vai'),
('00895', 'WARD', '029', 'Đông Hà', 'Dong Ha'),
('00898', 'WARD', '029', 'Quản Bạ', 'Ba'),
('00901', 'WARD', '029', 'Lùng Tám', 'Lung Tam'),
('00904', 'WARD', '029', 'Quyết Tiến', 'Quyet Tien'),
('00907', 'WARD', '029', 'Tả Ván', 'Ta Van'),
('00910', 'WARD', '029', 'Thái An', 'Thai An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 030 - Vị Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00703', 'WARD', '030', 'Kim Thạch', 'Kim Thach'),
('00706', 'WARD', '030', 'Phú Linh', 'Phu Linh'),
('00709', 'WARD', '030', 'Kim Linh', 'Kim Linh'),
('00913', 'WARD', '030', 'Thị trấn Vị Xuyên', 'Thi tran Vi Xuyen'),
('00916', 'WARD', '030', 'Thị trấn Nông Trường Việt Lâm', 'Thi tran Nong Truong Viet Lam'),
('00919', 'WARD', '030', 'Minh Tân', 'Minh Tan'),
('00922', 'WARD', '030', 'Thuận Hoà', 'Thuan Hoa'),
('00925', 'WARD', '030', 'Tùng Bá', 'Tung Ba'),
('00928', 'WARD', '030', 'Thanh Thủy', 'Thanh Thuy'),
('00931', 'WARD', '030', 'Thanh Đức', 'Thanh Duc'),
('00934', 'WARD', '030', 'Phong Quang', 'Phong Quang'),
('00937', 'WARD', '030', 'Xín Chải', 'Xin Chai'),
('00940', 'WARD', '030', 'Phương Tiến', 'Tien'),
('00943', 'WARD', '030', 'Lao Chải', 'Lao Chai'),
('00952', 'WARD', '030', 'Cao Bồ', 'Cao Bo'),
('00955', 'WARD', '030', 'Đạo Đức', 'Dao Duc'),
('00958', 'WARD', '030', 'Thượng Sơn', 'Thuong Son'),
('00961', 'WARD', '030', 'Linh Hồ', 'Linh Ho'),
('00964', 'WARD', '030', 'Quảng Ngần', 'Quang Ngan'),
('00967', 'WARD', '030', 'Việt Lâm', 'Viet Lam'),
('00970', 'WARD', '030', 'Ngọc Linh', 'Ngoc Linh'),
('00973', 'WARD', '030', 'Ngọc Minh', 'Ngoc Minh'),
('00976', 'WARD', '030', 'Bạch Ngọc', 'Bach Ngoc'),
('00979', 'WARD', '030', 'Trung Thành', 'Trung Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 031 - Bắc Mê
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('00982', 'WARD', '031', 'Minh Sơn', 'Minh Son'),
('00985', 'WARD', '031', 'Giáp Trung', 'Giap Trung'),
('00988', 'WARD', '031', 'Yên Định', 'Yen Dinh'),
('00991', 'WARD', '031', 'Thị trấn Yên Phú', 'Thi tran Yen Phu'),
('00994', 'WARD', '031', 'Minh Ngọc', 'Minh Ngoc'),
('00997', 'WARD', '031', 'Yên Phong', 'Yen Phong'),
('01000', 'WARD', '031', 'Lạc Nông', 'Lac Nong'),
('01003', 'WARD', '031', 'Phú Nam', 'Phu Nam'),
('01006', 'WARD', '031', 'Yên Cường', 'Yen Cuong'),
('01009', 'WARD', '031', 'Thượng Tân', 'Thuong Tan'),
('01012', 'WARD', '031', 'Đường Âm', 'Duong Am'),
('01015', 'WARD', '031', 'Đường Hồng', 'Duong Hong'),
('01018', 'WARD', '031', 'Phiêng Luông', 'Phieng Luong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 032 - Hoàng Su Phì
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01021', 'WARD', '032', 'Thị trấn Vinh Quang', 'Thi tran Vinh Quang'),
('01024', 'WARD', '032', 'Bản Máy', 'Ban May'),
('01027', 'WARD', '032', 'Thàng Tín', 'Thang Tin'),
('01030', 'WARD', '032', 'Thèn Chu Phìn', 'Then Chu Phin'),
('01033', 'WARD', '032', 'Pố Lồ', 'Po Lo'),
('01036', 'WARD', '032', 'Bản Phùng', 'Ban Phung'),
('01039', 'WARD', '032', 'Túng Sán', 'Tung San'),
('01042', 'WARD', '032', 'Chiến Phố', 'Chien Pho'),
('01045', 'WARD', '032', 'Đản Ván', 'Dan Van'),
('01048', 'WARD', '032', 'Tụ Nhân', 'Tu Nhan'),
('01051', 'WARD', '032', 'Tân Tiến', 'Tan Tien'),
('01054', 'WARD', '032', 'Nàng Đôn', 'Nang Don'),
('01057', 'WARD', '032', 'Pờ Ly Ngài', 'Po Ly Ngai'),
('01060', 'WARD', '032', 'Sán Xả Hồ', 'San Ho'),
('01063', 'WARD', '032', 'Bản Luốc', 'Ban Luoc'),
('01066', 'WARD', '032', 'Ngàm Đăng Vài', 'Ngam Dang Vai'),
('01069', 'WARD', '032', 'Bản Nhùng', 'Ban Nhung'),
('01072', 'WARD', '032', 'Tả Sử Choóng', 'Ta Su Choong'),
('01075', 'WARD', '032', 'Nậm Dịch', 'Nam Dich'),
('01081', 'WARD', '032', 'Hồ Thầu', 'Ho Thau'),
('01084', 'WARD', '032', 'Nam Sơn', 'Nam Son'),
('01087', 'WARD', '032', 'Nậm Tỵ', 'Nam Ty'),
('01090', 'WARD', '032', 'Thông Nguyên', 'Thong Nguyen'),
('01093', 'WARD', '032', 'Nậm Khòa', 'Nam Khoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 033 - Xín Mần
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01096', 'WARD', '033', 'Thị trấn Cốc Pài', 'Thi tran Coc Pai'),
('01099', 'WARD', '033', 'Nàn Xỉn', 'Nan Xin'),
('01102', 'WARD', '033', 'Bản Díu', 'Ban Diu'),
('01105', 'WARD', '033', 'Chí Cà', 'Chi Ca'),
('01108', 'WARD', '033', 'Xín Mần', 'Xin Man'),
('01114', 'WARD', '033', 'Thèn Phàng', 'Then Phang'),
('01117', 'WARD', '033', 'Trung Thịnh', 'Trung Thinh'),
('01120', 'WARD', '033', 'Pà Vầy Sủ', 'Pa Vay Su'),
('01123', 'WARD', '033', 'Cốc Rế', 'Coc Re'),
('01126', 'WARD', '033', 'Thu Tà', 'Thu Ta'),
('01129', 'WARD', '033', 'Nàn Ma', 'Nan Ma'),
('01132', 'WARD', '033', 'Tả Nhìu', 'Ta Nhiu'),
('01135', 'WARD', '033', 'Bản Ngò', 'Ban Ngo'),
('01138', 'WARD', '033', 'Chế Là', 'Che La'),
('01141', 'WARD', '033', 'Nấm Dẩn', 'Nam Dan'),
('01144', 'WARD', '033', 'Quảng Nguyên', 'Quang Nguyen'),
('01147', 'WARD', '033', 'Nà Chì', 'Na Chi'),
('01150', 'WARD', '033', 'Khuôn Lùng', 'Khuon Lung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 034 - Bắc Quang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01153', 'WARD', '034', 'Thị trấn Việt Quang', 'Thi tran Viet Quang'),
('01156', 'WARD', '034', 'Thị trấn Vĩnh Tuy', 'Thi tran Vinh Tuy'),
('01159', 'WARD', '034', 'Tân Lập', 'Tan Lap'),
('01162', 'WARD', '034', 'Tân Thành', 'Tan Thanh'),
('01165', 'WARD', '034', 'Đồng Tiến', 'Dong Tien'),
('01168', 'WARD', '034', 'Đồng Tâm', 'Dong Tam'),
('01171', 'WARD', '034', 'Tân Quang', 'Tan Quang'),
('01174', 'WARD', '034', 'Thượng Bình', 'Thuong Binh'),
('01177', 'WARD', '034', 'Hữu Sản', 'Huu San'),
('01180', 'WARD', '034', 'Kim Ngọc', 'Kim Ngoc'),
('01183', 'WARD', '034', 'Việt Vinh', 'Viet Vinh'),
('01186', 'WARD', '034', 'Bằng Hành', 'Bang Hanh'),
('01189', 'WARD', '034', 'Quang Minh', 'Quang Minh'),
('01192', 'WARD', '034', 'Liên Hiệp', 'Lien Hiep'),
('01195', 'WARD', '034', 'Vô Điếm', 'Vo Diem'),
('01198', 'WARD', '034', 'Việt Hồng', 'Viet Hong'),
('01201', 'WARD', '034', 'Hùng An', 'Hung An'),
('01204', 'WARD', '034', 'Đức Xuân', 'Duc Xuan'),
('01207', 'WARD', '034', 'Tiên Kiều', 'Tien Kieu'),
('01210', 'WARD', '034', 'Vĩnh Hảo', 'Vinh Hao'),
('01213', 'WARD', '034', 'Vĩnh Phúc', 'Vinh Phuc'),
('01216', 'WARD', '034', 'Đồng Yên', 'Dong Yen'),
('01219', 'WARD', '034', 'Đông Thành', 'Dong Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 035 - Quang Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01222', 'WARD', '035', 'Xuân Minh', 'Xuan Minh'),
('01225', 'WARD', '035', 'Tiên Nguyên', 'Tien Nguyen'),
('01228', 'WARD', '035', 'Tân Nam', 'Tan Nam'),
('01231', 'WARD', '035', 'Bản Rịa', 'Ban Ria'),
('01234', 'WARD', '035', 'Yên Thành', 'Yen Thanh'),
('01237', 'WARD', '035', 'Thị trấn Yên Bình', 'Thi tran Yen Binh'),
('01240', 'WARD', '035', 'Tân Trịnh', 'Tan Trinh'),
('01243', 'WARD', '035', 'Tân Bắc', 'Tan Bac'),
('01246', 'WARD', '035', 'Bằng Lang', 'Bang Lang'),
('01249', 'WARD', '035', 'Yên Hà', 'Yen Ha'),
('01252', 'WARD', '035', 'Hương Sơn', 'Huong Son'),
('01255', 'WARD', '035', 'Xuân Giang', 'Xuan Giang'),
('01258', 'WARD', '035', 'Nà Khương', 'Na Khuong'),
('01261', 'WARD', '035', 'Tiên Yên', 'Tien Yen'),
('01264', 'WARD', '035', 'Vĩ Thượng', 'Vi Thuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 04 - Cao Bằng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('040', 'DISTRICT', '04', 'Cao Bằng', 'Cao Bang'),
('042', 'DISTRICT', '04', 'Bảo Lâm', 'Bao Lam'),
('043', 'DISTRICT', '04', 'Bảo Lạc', 'Bao Lac'),
('045', 'DISTRICT', '04', 'Hà Quảng', 'Ha Quang'),
('047', 'DISTRICT', '04', 'Trùng Khánh', 'Trung Khanh'),
('048', 'DISTRICT', '04', 'Hạ Lang', 'Ha Lang'),
('049', 'DISTRICT', '04', 'Quảng Hòa', 'Quang Hoa'),
('051', 'DISTRICT', '04', 'Hoà An', 'Hoa An'),
('052', 'DISTRICT', '04', 'Nguyên Bình', 'Nguyen Binh'),
('053', 'DISTRICT', '04', 'Thạch An', 'Thach An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 040 - Cao Bằng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01267', 'WARD', '040', 'Sông Hiến', 'Song Hien'),
('01270', 'WARD', '040', 'Sông Bằng', 'Song Bang'),
('01273', 'WARD', '040', 'Hợp Giang', 'Hop Giang'),
('01276', 'WARD', '040', 'Tân Giang', 'Tan Giang'),
('01279', 'WARD', '040', 'Ngọc Xuân', 'Ngoc Xuan'),
('01282', 'WARD', '040', 'Đề Thám', 'De Tham'),
('01285', 'WARD', '040', 'Hoà Chung', 'Hoa Chung'),
('01288', 'WARD', '040', 'Duyệt Trung', 'Duyet Trung'),
('01693', 'WARD', '040', 'Vĩnh Quang', 'Vinh Quang'),
('01705', 'WARD', '040', 'Hưng Đạo', 'Hung Dao'),
('01720', 'WARD', '040', 'Chu Trinh', 'Chu Trinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 042 - Bảo Lâm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01290', 'WARD', '042', 'Thị trấn Pác Miầu', 'Thi tran Pac Miau'),
('01291', 'WARD', '042', 'Đức Hạnh', 'Duc Hanh'),
('01294', 'WARD', '042', 'Lý Bôn', 'Ly Bon'),
('01296', 'WARD', '042', 'Nam Cao', 'Nam Cao'),
('01297', 'WARD', '042', 'Nam Quang', 'Nam Quang'),
('01300', 'WARD', '042', 'Vĩnh Quang', 'Vinh Quang'),
('01303', 'WARD', '042', 'Quảng Lâm', 'Quang Lam'),
('01304', 'WARD', '042', 'Thạch Lâm', 'Thach Lam'),
('01309', 'WARD', '042', 'Vĩnh Phong', 'Vinh Phong'),
('01312', 'WARD', '042', 'Mông Ân', 'Mong An'),
('01315', 'WARD', '042', 'Thái Học', 'Thai Hoc'),
('01316', 'WARD', '042', 'Thái Sơn', 'Thai Son'),
('01318', 'WARD', '042', 'Yên Thổ', 'Yen Tho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 043 - Bảo Lạc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01321', 'WARD', '043', 'Thị trấn Bảo Lạc', 'Thi tran Bao Lac'),
('01324', 'WARD', '043', 'Cốc Pàng', 'Coc Pang'),
('01327', 'WARD', '043', 'Thượng Hà', 'Thuong Ha'),
('01330', 'WARD', '043', 'Cô Ba', 'Co Ba'),
('01333', 'WARD', '043', 'Bảo Toàn', 'Bao Toan'),
('01336', 'WARD', '043', 'Khánh Xuân', 'Khanh Xuan'),
('01339', 'WARD', '043', 'Xuân Trường', 'Xuan Truong'),
('01342', 'WARD', '043', 'Hồng Trị', 'Hong Tri'),
('01343', 'WARD', '043', 'Kim Cúc', 'Kim Cuc'),
('01345', 'WARD', '043', 'Phan Thanh', 'Phan Thanh'),
('01348', 'WARD', '043', 'Hồng An', 'Hong An'),
('01351', 'WARD', '043', 'Hưng Đạo', 'Hung Dao'),
('01352', 'WARD', '043', 'Hưng Thịnh', 'Hung Thinh'),
('01354', 'WARD', '043', 'Huy Giáp', 'Huy Giap'),
('01357', 'WARD', '043', 'Đình Phùng', 'Dinh Phung'),
('01359', 'WARD', '043', 'Sơn Lập', 'Son Lap'),
('01360', 'WARD', '043', 'Sơn Lộ', 'Son Lo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 045 - Hà Quảng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01363', 'WARD', '045', 'Thị trấn Thông Nông', 'Thi tran Thong Nong'),
('01366', 'WARD', '045', 'Cần Yên', 'Can Yen'),
('01367', 'WARD', '045', 'Cần Nông', 'Can Nong'),
('01372', 'WARD', '045', 'Lương Thông', 'Luong Thong'),
('01375', 'WARD', '045', 'Đa Thông', 'Da Thong'),
('01378', 'WARD', '045', 'Ngọc Động', 'Ngoc Dong'),
('01381', 'WARD', '045', 'Yên Sơn', 'Yen Son'),
('01384', 'WARD', '045', 'Lương Can', 'Luong Can'),
('01387', 'WARD', '045', 'Thanh Long', 'Thanh Long'),
('01392', 'WARD', '045', 'Thị trấn Xuân Hòa', 'Thi tran Xuan Hoa'),
('01393', 'WARD', '045', 'Lũng Nặm', 'Lung Nam'),
('01399', 'WARD', '045', 'Trường Hà', 'Truong Ha'),
('01402', 'WARD', '045', 'Cải Viên', 'Cai Vien'),
('01411', 'WARD', '045', 'Nội Thôn', 'Noi Thon'),
('01414', 'WARD', '045', 'Tổng Cọt', 'Tong Cot'),
('01417', 'WARD', '045', 'Sóc Hà', 'Soc Ha'),
('01420', 'WARD', '045', 'Thượng Thôn', 'Thuong Thon'),
('01429', 'WARD', '045', 'Hồng Sỹ', 'Hong Sy'),
('01432', 'WARD', '045', 'Quý Quân', 'Quy Quan'),
('01435', 'WARD', '045', 'Mã Ba', 'Ma Ba'),
('01438', 'WARD', '045', 'Ngọc Đào', 'Ngoc Dao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 047 - Trùng Khánh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01447', 'WARD', '047', 'Thị trấn Trà Lĩnh', 'Thi tran Tra Linh'),
('01453', 'WARD', '047', 'Tri Phương', 'Tri Phuong'),
('01456', 'WARD', '047', 'Quang Hán', 'Quang Han'),
('01462', 'WARD', '047', 'Xuân Nội', 'Xuan Noi'),
('01465', 'WARD', '047', 'Quang Trung', 'Quang Trung'),
('01468', 'WARD', '047', 'Quang Vinh', 'Quang Vinh'),
('01471', 'WARD', '047', 'Cao Chương', 'Cao Chuong'),
('01477', 'WARD', '047', 'Thị trấn Trùng Khánh', 'Thi tran Trung Khanh'),
('01480', 'WARD', '047', 'Ngọc Khê', 'Ngoc Khe'),
('01481', 'WARD', '047', 'Ngọc Côn', 'Ngoc Con'),
('01483', 'WARD', '047', 'Phong Nậm', 'Phong Nam'),
('01489', 'WARD', '047', 'Đình Phong', 'Dinh Phong'),
('01495', 'WARD', '047', 'Đàm Thuỷ', 'Dam Thuy'),
('01498', 'WARD', '047', 'Khâm Thành', 'Kham Thanh'),
('01501', 'WARD', '047', 'Chí Viễn', 'Chi Vien'),
('01504', 'WARD', '047', 'Lăng Hiếu', 'Lang Hieu'),
('01507', 'WARD', '047', 'Phong Châu', 'Phong Chau'),
('01516', 'WARD', '047', 'Trung Phúc', 'Trung Phuc'),
('01519', 'WARD', '047', 'Cao Thăng', 'Cao Thang'),
('01522', 'WARD', '047', 'Đức Hồng', 'Duc Hong'),
('01525', 'WARD', '047', 'Đoài Dương', 'Doai Duong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 048 - Hạ Lang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01534', 'WARD', '048', 'Minh Long', 'Minh Long'),
('01537', 'WARD', '048', 'Lý Quốc', 'Ly Quoc'),
('01540', 'WARD', '048', 'Thắng Lợi', 'Thang Loi'),
('01543', 'WARD', '048', 'Đồng Loan', 'Dong Loan'),
('01546', 'WARD', '048', 'Đức Quang', 'Duc Quang'),
('01549', 'WARD', '048', 'Kim Loan', 'Kim Loan'),
('01552', 'WARD', '048', 'Quang Long', 'Quang Long'),
('01555', 'WARD', '048', 'An Lạc', 'An Lac'),
('01558', 'WARD', '048', 'Thị trấn Thanh Nhật', 'Thi tran Thanh Nhat'),
('01561', 'WARD', '048', 'Vinh Quý', 'Vinh Quy'),
('01564', 'WARD', '048', 'Thống Nhất', 'Thong Nhat'),
('01567', 'WARD', '048', 'Cô Ngân', 'Co Ngan'),
('01573', 'WARD', '048', 'Thị Hoa', 'Thi Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 049 - Quảng Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01474', 'WARD', '049', 'Quốc Toản', 'Quoc Toan'),
('01576', 'WARD', '049', 'Thị trấn Quảng Uyên', 'Thi tran Quang Uyen'),
('01579', 'WARD', '049', 'Phi Hải', 'Phi Hai'),
('01582', 'WARD', '049', 'Quảng Hưng', 'Quang Hung'),
('01594', 'WARD', '049', 'Độc Lập', 'Doc Lap'),
('01597', 'WARD', '049', 'Cai Bộ', 'Cai Bo'),
('01603', 'WARD', '049', 'Phúc Sen', 'Phuc Sen'),
('01606', 'WARD', '049', 'Chí Thảo', 'Chi Thao'),
('01609', 'WARD', '049', 'Tự Do', 'Tu Do'),
('01615', 'WARD', '049', 'Hồng Quang', 'Hong Quang'),
('01618', 'WARD', '049', 'Ngọc Động', 'Ngoc Dong'),
('01624', 'WARD', '049', 'Hạnh Phúc', 'Hanh Phuc'),
('01627', 'WARD', '049', 'Thị trấn Tà Lùng', 'Thi tran Ta Lung'),
('01630', 'WARD', '049', 'Bế Văn Đàn', 'Be Van Dan'),
('01636', 'WARD', '049', 'Cách Linh', 'Cach Linh'),
('01639', 'WARD', '049', 'Đại Sơn', 'Dai Son'),
('01645', 'WARD', '049', 'Tiên Thành', 'Tien Thanh'),
('01648', 'WARD', '049', 'Thị trấn Hoà Thuận', 'Thi tran Hoa Thuan'),
('01651', 'WARD', '049', 'Mỹ Hưng', 'My Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 051 - Hoà An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01654', 'WARD', '051', 'Thị trấn Nước Hai', 'Thi tran Nuoc Hai'),
('01657', 'WARD', '051', 'Dân Chủ', 'Dan Chu'),
('01660', 'WARD', '051', 'Nam Tuấn', 'Nam Tuan'),
('01666', 'WARD', '051', 'Đại Tiến', 'Dai Tien'),
('01669', 'WARD', '051', 'Đức Long', 'Duc Long'),
('01672', 'WARD', '051', 'Ngũ Lão', 'Ngu Lao'),
('01675', 'WARD', '051', 'Trương Lương', 'Truong Luong'),
('01687', 'WARD', '051', 'Hồng Việt', 'Hong Viet'),
('01696', 'WARD', '051', 'Hoàng Tung', 'Hoang Tung'),
('01699', 'WARD', '051', 'Nguyễn Huệ', 'Nguyen Hue'),
('01702', 'WARD', '051', 'Quang Trung', 'Quang Trung'),
('01708', 'WARD', '051', 'Bạch Đằng', 'Bach Dang'),
('01711', 'WARD', '051', 'Bình Dương', 'Binh Duong'),
('01714', 'WARD', '051', 'Lê Chung', 'Le Chung'),
('01723', 'WARD', '051', 'Hồng Nam', 'Hong Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 052 - Nguyên Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01726', 'WARD', '052', 'Thị trấn Nguyên Bình', 'Thi tran Nguyen Binh'),
('01729', 'WARD', '052', 'Thị trấn Tĩnh Túc', 'Thi tran Tuc'),
('01732', 'WARD', '052', 'Yên Lạc', 'Yen Lac'),
('01735', 'WARD', '052', 'Triệu Nguyên', 'Trieu Nguyen'),
('01738', 'WARD', '052', 'Ca Thành', 'Ca Thanh'),
('01744', 'WARD', '052', 'Vũ Nông', 'Vu Nong'),
('01747', 'WARD', '052', 'Minh Tâm', 'Minh Tam'),
('01750', 'WARD', '052', 'Thể Dục', 'The Duc'),
('01756', 'WARD', '052', 'Mai Long', 'Mai Long'),
('01762', 'WARD', '052', 'Vũ Minh', 'Vu Minh'),
('01765', 'WARD', '052', 'Hoa Thám', 'Hoa Tham'),
('01768', 'WARD', '052', 'Phan Thanh', 'Phan Thanh'),
('01771', 'WARD', '052', 'Quang Thành', 'Quang Thanh'),
('01774', 'WARD', '052', 'Tam Kim', 'Tam Kim'),
('01777', 'WARD', '052', 'Thành Công', 'Thanh Cong'),
('01780', 'WARD', '052', 'Thịnh Vượng', 'Thinh Vuong'),
('01783', 'WARD', '052', 'Hưng Đạo', 'Hung Dao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 053 - Thạch An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01786', 'WARD', '053', 'Thị trấn Đông Khê', 'Thi tran Dong Khe'),
('01789', 'WARD', '053', 'Canh Tân', 'Canh Tan'),
('01792', 'WARD', '053', 'Kim Đồng', 'Kim Dong'),
('01795', 'WARD', '053', 'Minh Khai', 'Minh Khai'),
('01801', 'WARD', '053', 'Đức Thông', 'Duc Thong'),
('01804', 'WARD', '053', 'Thái Cường', 'Thai Cuong'),
('01807', 'WARD', '053', 'Vân Trình', 'Van Trinh'),
('01810', 'WARD', '053', 'Thụy Hùng', 'Thuy Hung'),
('01813', 'WARD', '053', 'Quang Trọng', 'Quang Trong'),
('01816', 'WARD', '053', 'Trọng Con', 'Trong Con'),
('01819', 'WARD', '053', 'Lê Lai', 'Le Lai'),
('01822', 'WARD', '053', 'Đức Long', 'Duc Long'),
('01828', 'WARD', '053', 'Lê Lợi', 'Le Loi'),
('01831', 'WARD', '053', 'Đức Xuân', 'Duc Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 06 - Bắc Kạn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('058', 'DISTRICT', '06', 'Bắc Kạn', 'Bac Kan'),
('060', 'DISTRICT', '06', 'Pác Nặm', 'Pac Nam'),
('061', 'DISTRICT', '06', 'Ba Bể', 'Ba Be'),
('062', 'DISTRICT', '06', 'Ngân Sơn', 'Ngan Son'),
('063', 'DISTRICT', '06', 'Bạch Thông', 'Bach Thong'),
('064', 'DISTRICT', '06', 'Chợ Đồn', 'Cho Don'),
('065', 'DISTRICT', '06', 'Chợ Mới', 'Cho Moi'),
('066', 'DISTRICT', '06', 'Na Rì', 'Na Ri')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 058 - Bắc Kạn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01834', 'WARD', '058', 'Nguyễn Thị Minh Khai', 'Nguyen Thi Minh Khai'),
('01837', 'WARD', '058', 'Sông Cầu', 'Song Cau'),
('01840', 'WARD', '058', 'Đức Xuân', 'Duc Xuan'),
('01843', 'WARD', '058', 'Phùng Chí Kiên', 'Phung Chi Kien'),
('01846', 'WARD', '058', 'Huyền Tụng', 'Tung'),
('01849', 'WARD', '058', 'Dương Quang', 'Duong Quang'),
('01852', 'WARD', '058', 'Nông Thượng', 'Nong Thuong'),
('01855', 'WARD', '058', 'Xuất Hóa', 'Xuat Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 060 - Pác Nặm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01858', 'WARD', '060', 'Bằng Thành', 'Bang Thanh'),
('01861', 'WARD', '060', 'Nhạn Môn', 'Nhan Mon'),
('01864', 'WARD', '060', 'Bộc Bố', 'Boc Bo'),
('01867', 'WARD', '060', 'Công Bằng', 'Cong Bang'),
('01870', 'WARD', '060', 'Giáo Hiệu', 'Giao Hieu'),
('01873', 'WARD', '060', 'Xuân La', 'Xuan La'),
('01876', 'WARD', '060', 'An Thắng', 'An Thang'),
('01879', 'WARD', '060', 'Cổ Linh', 'Co Linh'),
('01882', 'WARD', '060', 'Nghiên Loan', 'Nghien Loan'),
('01885', 'WARD', '060', 'Cao Tân', 'Cao Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 061 - Ba Bể
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01888', 'WARD', '061', 'Thị trấn Chợ Rã', 'Thi tran Cho Ra'),
('01891', 'WARD', '061', 'Bành Trạch', 'Banh Trach'),
('01894', 'WARD', '061', 'Phúc Lộc', 'Phuc Loc'),
('01897', 'WARD', '061', 'Hà Hiệu', 'Ha Hieu'),
('01900', 'WARD', '061', 'Cao Thượng', 'Cao Thuong'),
('01906', 'WARD', '061', 'Khang Ninh', 'Khang Ninh'),
('01909', 'WARD', '061', 'Nam Mẫu', 'Nam Mau'),
('01912', 'WARD', '061', 'Thượng Giáo', 'Thuong Giao'),
('01915', 'WARD', '061', 'Địa Linh', 'Dia Linh'),
('01918', 'WARD', '061', 'Yến Dương', 'Yen Duong'),
('01921', 'WARD', '061', 'Chu Hương', 'Chu Huong'),
('01924', 'WARD', '061', 'Quảng Khê', 'Quang Khe'),
('01927', 'WARD', '061', 'Mỹ Phương', 'My Phuong'),
('01930', 'WARD', '061', 'Hoàng Trĩ', 'Hoang Tri'),
('01933', 'WARD', '061', 'Đồng Phúc', 'Dong Phuc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 062 - Ngân Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01936', 'WARD', '062', 'Thị trấn Nà Phặc', 'Thi tran Na Phac'),
('01939', 'WARD', '062', 'Thượng Ân', 'Thuong An'),
('01942', 'WARD', '062', 'Bằng Vân', 'Bang Van'),
('01945', 'WARD', '062', 'Cốc Đán', 'Coc Dan'),
('01948', 'WARD', '062', 'Trung Hoà', 'Trung Hoa'),
('01951', 'WARD', '062', 'Đức Vân', 'Duc Van'),
('01954', 'WARD', '062', 'Thị trấn Vân Tùng', 'Thi tran Van Tung'),
('01957', 'WARD', '062', 'Thượng Quan', 'Thuong Quan'),
('01960', 'WARD', '062', 'Hiệp Lực', 'Hiep Luc'),
('01963', 'WARD', '062', 'Thuần Mang', 'Thuan Mang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 063 - Bạch Thông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('01969', 'WARD', '063', 'Thị trấn Phủ Thông', 'Thi tran Phu Thong'),
('01975', 'WARD', '063', 'Vi Hương', 'Vi Huong'),
('01978', 'WARD', '063', 'Sĩ Bình', 'Si Binh'),
('01981', 'WARD', '063', 'Vũ Muộn', 'Vu Muon'),
('01984', 'WARD', '063', 'Đôn Phong', 'Don Phong'),
('01990', 'WARD', '063', 'Lục Bình', 'Luc Binh'),
('01993', 'WARD', '063', 'Tân Tú', 'Tan Tu'),
('01999', 'WARD', '063', 'Nguyên Phúc', 'Nguyen Phuc'),
('02002', 'WARD', '063', 'Cao Sơn', 'Cao Son'),
('02005', 'WARD', '063', 'Quân Hà', 'Ha'),
('02008', 'WARD', '063', 'Cẩm Giàng', 'Cam Giang'),
('02011', 'WARD', '063', 'Mỹ Thanh', 'My Thanh'),
('02014', 'WARD', '063', 'Dương Phong', 'Duong Phong'),
('02017', 'WARD', '063', 'Quang Thuận', 'Quang Thuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 064 - Chợ Đồn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02020', 'WARD', '064', 'Thị trấn Bằng Lũng', 'Thi tran Bang Lung'),
('02023', 'WARD', '064', 'Xuân Lạc', 'Xuan Lac'),
('02026', 'WARD', '064', 'Nam Cường', 'Nam Cuong'),
('02029', 'WARD', '064', 'Đồng Lạc', 'Dong Lac'),
('02032', 'WARD', '064', 'Tân Lập', 'Tan Lap'),
('02035', 'WARD', '064', 'Bản Thi', 'Ban Thi'),
('02038', 'WARD', '064', 'Quảng Bạch', 'Quang Bach'),
('02041', 'WARD', '064', 'Bằng Phúc', 'Bang Phuc'),
('02044', 'WARD', '064', 'Yên Thịnh', 'Yen Thinh'),
('02047', 'WARD', '064', 'Yên Thượng', 'Yen Thuong'),
('02050', 'WARD', '064', 'Phương Viên', 'Vien'),
('02053', 'WARD', '064', 'Ngọc Phái', 'Ngoc Phai'),
('02059', 'WARD', '064', 'Đồng Thắng', 'Dong Thang'),
('02062', 'WARD', '064', 'Lương Bằng', 'Luong Bang'),
('02065', 'WARD', '064', 'Bằng Lãng', 'Bang Lang'),
('02068', 'WARD', '064', 'Đại Sảo', 'Dai Sao'),
('02071', 'WARD', '064', 'Nghĩa Tá', 'Nghia Ta'),
('02077', 'WARD', '064', 'Yên Mỹ', 'Yen My'),
('02080', 'WARD', '064', 'Bình Trung', 'Binh Trung'),
('02083', 'WARD', '064', 'Yên Phong', 'Yen Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 065 - Chợ Mới
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02086', 'WARD', '065', 'Thị trấn Đồng Tâm', 'Thi tran Dong Tam'),
('02089', 'WARD', '065', 'Tân Sơn', 'Tan Son'),
('02092', 'WARD', '065', 'Thanh Vận', 'Thanh Van'),
('02095', 'WARD', '065', 'Mai Lạp', 'Mai Lap'),
('02098', 'WARD', '065', 'Hoà Mục', 'Hoa Muc'),
('02101', 'WARD', '065', 'Thanh Mai', 'Thanh Mai'),
('02104', 'WARD', '065', 'Cao Kỳ', 'Cao Ky'),
('02107', 'WARD', '065', 'Nông Hạ', 'Nong Ha'),
('02110', 'WARD', '065', 'Yên Cư', 'Yen Cu'),
('02113', 'WARD', '065', 'Thanh Thịnh', 'Thanh Thinh'),
('02116', 'WARD', '065', 'Yên Hân', 'Yen Han'),
('02122', 'WARD', '065', 'Như Cố', 'Nhu Co'),
('02125', 'WARD', '065', 'Bình Văn', 'Binh Van'),
('02131', 'WARD', '065', 'Quảng Chu', 'Quang Chu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 066 - Na Rì
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02137', 'WARD', '066', 'Văn Vũ', 'Van Vu'),
('02140', 'WARD', '066', 'Văn Lang', 'Van Lang'),
('02143', 'WARD', '066', 'Lương Thượng', 'Luong Thuong'),
('02146', 'WARD', '066', 'Kim Hỷ', 'Kim Hy'),
('02152', 'WARD', '066', 'Cường Lợi', 'Cuong Loi'),
('02155', 'WARD', '066', 'Thị trấn Yến Lạc', 'Thi tran Yen Lac'),
('02158', 'WARD', '066', 'Kim Lư', 'Kim Lu'),
('02161', 'WARD', '066', 'Sơn Thành', 'Son Thanh'),
('02170', 'WARD', '066', 'Văn Minh', 'Van Minh'),
('02173', 'WARD', '066', 'Côn Minh', 'Con Minh'),
('02176', 'WARD', '066', 'Cư Lễ', 'Cu Le'),
('02179', 'WARD', '066', 'Trần Phú', 'Tran Phu'),
('02185', 'WARD', '066', 'Quang Phong', 'Quang Phong'),
('02188', 'WARD', '066', 'Dương Sơn', 'Duong Son'),
('02191', 'WARD', '066', 'Xuân Dương', 'Xuan Duong'),
('02194', 'WARD', '066', 'Đổng Xá', 'Dong Xa'),
('02197', 'WARD', '066', 'Liêm Thuỷ', 'Liem Thuy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 08 - Tuyên Quang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('070', 'DISTRICT', '08', 'Tuyên Quang', 'Thanh pho Tuyen Quang'),
('071', 'DISTRICT', '08', 'Lâm Bình', 'Lam Binh'),
('072', 'DISTRICT', '08', 'Na Hang', 'Na Hang'),
('073', 'DISTRICT', '08', 'Chiêm Hóa', 'Chiem Hoa'),
('074', 'DISTRICT', '08', 'Hàm Yên', 'Ham Yen'),
('075', 'DISTRICT', '08', 'Yên Sơn', 'Yen Son'),
('076', 'DISTRICT', '08', 'Sơn Dương', 'Son Duong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 070 - Tuyên Quang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02200', 'WARD', '070', 'Phan Thiết', 'Phan Thiet'),
('02203', 'WARD', '070', 'Minh Xuân', 'Minh Xuan'),
('02206', 'WARD', '070', 'Tân Quang', 'Tan Quang'),
('02209', 'WARD', '070', 'Tràng Đà', 'Trang Da'),
('02212', 'WARD', '070', 'Nông Tiến', 'Nong Tien'),
('02215', 'WARD', '070', 'Ỷ La', 'Y La'),
('02216', 'WARD', '070', 'Tân Hà', 'Tan Ha'),
('02218', 'WARD', '070', 'Hưng Thành', 'Hung Thanh'),
('02497', 'WARD', '070', 'Kim Phú', 'Kim Phu'),
('02503', 'WARD', '070', 'An Khang', 'An Khang'),
('02509', 'WARD', '070', 'Mỹ Lâm', 'My Lam'),
('02512', 'WARD', '070', 'An Tường', 'An Tuong'),
('02515', 'WARD', '070', 'Lưỡng Vượng', 'Luong Vuong'),
('02521', 'WARD', '070', 'Thái Long', 'Thai Long'),
('02524', 'WARD', '070', 'Đội Cấn', 'Doi Can')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 071 - Lâm Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02233', 'WARD', '071', 'Phúc Yên', 'Phuc Yen'),
('02242', 'WARD', '071', 'Xuân Lập', 'Xuan Lap'),
('02251', 'WARD', '071', 'Khuôn Hà', 'Khuon Ha'),
('02266', 'WARD', '071', 'Thị trấn Lăng Can', 'Thi tran Lang Can'),
('02269', 'WARD', '071', 'Thượng Lâm', 'Thuong Lam'),
('02290', 'WARD', '071', 'Bình An', 'Binh An'),
('02293', 'WARD', '071', 'Hồng Quang', 'Hong Quang'),
('02296', 'WARD', '071', 'Thổ Bình', 'Tho Binh'),
('02299', 'WARD', '071', 'Phúc Sơn', 'Phuc Son'),
('02302', 'WARD', '071', 'Minh Quang', 'Minh Quang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 072 - Na Hang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02221', 'WARD', '072', 'Thị trấn Na Hang', 'Thi tran Na Hang'),
('02227', 'WARD', '072', 'Sinh Long', 'Sinh Long'),
('02230', 'WARD', '072', 'Thượng Giáp', 'Thuong Giap'),
('02239', 'WARD', '072', 'Thượng Nông', 'Thuong Nong'),
('02245', 'WARD', '072', 'Côn Lôn', 'Con Lon'),
('02248', 'WARD', '072', 'Yên Hoa', 'Yen Hoa'),
('02254', 'WARD', '072', 'Hồng Thái', 'Hong Thai'),
('02260', 'WARD', '072', 'Đà Vị', 'Da Vi'),
('02263', 'WARD', '072', 'Khau Tinh', 'Khau Tinh'),
('02275', 'WARD', '072', 'Sơn Phú', 'Son Phu'),
('02281', 'WARD', '072', 'Năng Khả', 'Nang Kha'),
('02284', 'WARD', '072', 'Thanh Tương', 'Thanh Tuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 073 - Chiêm Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02287', 'WARD', '073', 'Thị trấn Vĩnh Lộc', 'Thi tran Vinh Loc'),
('02305', 'WARD', '073', 'Trung Hà', 'Trung Ha'),
('02308', 'WARD', '073', 'Tân Mỹ', 'Tan My'),
('02311', 'WARD', '073', 'Hà Lang', 'Ha Lang'),
('02314', 'WARD', '073', 'Hùng Mỹ', 'Hung My'),
('02317', 'WARD', '073', 'Yên Lập', 'Yen Lap'),
('02320', 'WARD', '073', 'Tân An', 'Tan An'),
('02323', 'WARD', '073', 'Bình Phú', 'Binh Phu'),
('02326', 'WARD', '073', 'Xuân Quang', 'Xuan Quang'),
('02329', 'WARD', '073', 'Ngọc Hội', 'Ngoc Hoi'),
('02332', 'WARD', '073', 'Phú Bình', 'Phu Binh'),
('02335', 'WARD', '073', 'Hòa Phú', 'Hoa Phu'),
('02338', 'WARD', '073', 'Phúc Thịnh', 'Phuc Thinh'),
('02341', 'WARD', '073', 'Kiên Đài', 'Kien Dai'),
('02344', 'WARD', '073', 'Tân Thịnh', 'Tan Thinh'),
('02347', 'WARD', '073', 'Trung Hòa', 'Trung Hoa'),
('02350', 'WARD', '073', 'Kim Bình', 'Kim Binh'),
('02353', 'WARD', '073', 'Hòa An', 'Hoa An'),
('02356', 'WARD', '073', 'Vinh Quang', 'Vinh Quang'),
('02359', 'WARD', '073', 'Tri Phú', 'Tri Phu'),
('02362', 'WARD', '073', 'Nhân Lý', 'Nhan Ly'),
('02365', 'WARD', '073', 'Yên Nguyên', 'Yen Nguyen'),
('02368', 'WARD', '073', 'Linh Phú', 'Linh Phu'),
('02371', 'WARD', '073', 'Bình Nhân', 'Binh Nhan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 074 - Hàm Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02374', 'WARD', '074', 'Thị trấn Tân Yên', 'Thi tran Tan Yen'),
('02377', 'WARD', '074', 'Yên Thuận', 'Yen Thuan'),
('02380', 'WARD', '074', 'Bạch Xa', 'Bach Xa'),
('02383', 'WARD', '074', 'Minh Khương', 'Minh Khuong'),
('02386', 'WARD', '074', 'Yên Lâm', 'Yen Lam'),
('02389', 'WARD', '074', 'Minh Dân', 'Minh Dan'),
('02392', 'WARD', '074', 'Phù Lưu', 'Phu Luu'),
('02395', 'WARD', '074', 'Minh Hương', 'Minh Huong'),
('02398', 'WARD', '074', 'Yên Phú', 'Yen Phu'),
('02401', 'WARD', '074', 'Tân Thành', 'Tan Thanh'),
('02404', 'WARD', '074', 'Bình Xa', 'Binh Xa'),
('02407', 'WARD', '074', 'Thái Sơn', 'Thai Son'),
('02410', 'WARD', '074', 'Nhân Mục', 'Nhan Muc'),
('02413', 'WARD', '074', 'Thành Long', 'Thanh Long'),
('02416', 'WARD', '074', 'Bằng Cốc', 'Bang Coc'),
('02419', 'WARD', '074', 'Thái Hòa', 'Thai Hoa'),
('02422', 'WARD', '074', 'Đức Ninh', 'Duc Ninh'),
('02425', 'WARD', '074', 'Hùng Đức', 'Hung Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 075 - Yên Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02431', 'WARD', '075', 'Quí Quân', 'Qui Quan'),
('02434', 'WARD', '075', 'Lực Hành', 'Luc Hanh'),
('02437', 'WARD', '075', 'Kiến Thiết', 'Kien Thiet'),
('02440', 'WARD', '075', 'Trung Minh', 'Trung Minh'),
('02443', 'WARD', '075', 'Chiêu Yên', 'Chieu Yen'),
('02446', 'WARD', '075', 'Trung Trực', 'Trung Truc'),
('02449', 'WARD', '075', 'Xuân Vân', 'Xuan Van'),
('02452', 'WARD', '075', 'Phúc Ninh', 'Phuc Ninh'),
('02455', 'WARD', '075', 'Hùng Lợi', 'Hung Loi'),
('02458', 'WARD', '075', 'Trung Sơn', 'Trung Son'),
('02461', 'WARD', '075', 'Tân Tiến', 'Tan Tien'),
('02464', 'WARD', '075', 'Tứ Quận', 'Tu Quan'),
('02467', 'WARD', '075', 'Đạo Viện', 'Dao Vien'),
('02470', 'WARD', '075', 'Tân Long', 'Tan Long'),
('02473', 'WARD', '075', 'Thị trấn Yên Sơn', 'Thi tran Yen Son'),
('02476', 'WARD', '075', 'Kim Quan', 'Kim Quan'),
('02479', 'WARD', '075', 'Lang Quán', 'Lang Quan'),
('02482', 'WARD', '075', 'Phú Thịnh', 'Phu Thinh'),
('02485', 'WARD', '075', 'Công Đa', 'Cong Da'),
('02488', 'WARD', '075', 'Trung Môn', 'Trung Mon'),
('02491', 'WARD', '075', 'Chân Sơn', 'Chan Son'),
('02494', 'WARD', '075', 'Thái Bình', 'Thai Binh'),
('02500', 'WARD', '075', 'Tiến Bộ', 'Tien Bo'),
('02506', 'WARD', '075', 'Mỹ Bằng', 'My Bang'),
('02518', 'WARD', '075', 'Hoàng Khai', 'Hoang Khai'),
('02527', 'WARD', '075', 'Nhữ Hán', 'Nhu Han'),
('02530', 'WARD', '075', 'Nhữ Khê', 'Nhu Khe'),
('02533', 'WARD', '075', 'Đội Bình', 'Doi Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 076 - Sơn Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02536', 'WARD', '076', 'Thị trấn Sơn Dương', 'Thi tran Son Duong'),
('02539', 'WARD', '076', 'Trung Yên', 'Trung Yen'),
('02542', 'WARD', '076', 'Minh Thanh', 'Minh Thanh'),
('02545', 'WARD', '076', 'Tân Trào', 'Tan Trao'),
('02548', 'WARD', '076', 'Vĩnh Lợi', 'Vinh Loi'),
('02551', 'WARD', '076', 'Thượng Ấm', 'Thuong Am'),
('02554', 'WARD', '076', 'Bình Yên', 'Binh Yen'),
('02557', 'WARD', '076', 'Lương Thiện', 'Luong Thien'),
('02560', 'WARD', '076', 'Tú Thịnh', 'Tu Thinh'),
('02563', 'WARD', '076', 'Cấp Tiến', 'Cap Tien'),
('02566', 'WARD', '076', 'Hợp Thành', 'Hop Thanh'),
('02569', 'WARD', '076', 'Phúc Ứng', 'Phuc Ung'),
('02572', 'WARD', '076', 'Đông Thọ', 'Dong Tho'),
('02575', 'WARD', '076', 'Kháng Nhật', 'Khang Nhat'),
('02578', 'WARD', '076', 'Hợp Hòa', 'Hop Hoa'),
('02584', 'WARD', '076', 'Quyết Thắng', 'Quyet Thang'),
('02587', 'WARD', '076', 'Đồng Quý', 'Dong Quy'),
('02590', 'WARD', '076', 'Tân Thanh', 'Tan Thanh'),
('02596', 'WARD', '076', 'Văn Phú', 'Van Phu'),
('02599', 'WARD', '076', 'Chi Thiết', 'Chi Thiet'),
('02602', 'WARD', '076', 'Đông Lợi', 'Dong Loi'),
('02605', 'WARD', '076', 'Thiện Kế', 'Thien Ke'),
('02608', 'WARD', '076', 'Hồng Sơn', 'Hong Son'),
('02611', 'WARD', '076', 'Phú Lương', 'Phu Luong'),
('02614', 'WARD', '076', 'Ninh Lai', 'Ninh Lai'),
('02617', 'WARD', '076', 'Đại Phú', 'Dai Phu'),
('02620', 'WARD', '076', 'Sơn Nam', 'Son Nam'),
('02623', 'WARD', '076', 'Hào Phú', 'Hao Phu'),
('02626', 'WARD', '076', 'Tam Đa', 'Tam Da'),
('02632', 'WARD', '076', 'Trường Sinh', 'Truong Sinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 10 - Lào Cai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('080', 'DISTRICT', '10', 'Lào Cai', 'Thanh pho Lao Cai'),
('082', 'DISTRICT', '10', 'Bát Xát', 'Bat Xat'),
('083', 'DISTRICT', '10', 'Mường Khương', 'Muong Khuong'),
('084', 'DISTRICT', '10', 'Si Ma Cai', 'Si Ma Cai'),
('085', 'DISTRICT', '10', 'Bắc Hà', 'Bac Ha'),
('086', 'DISTRICT', '10', 'Bảo Thắng', 'Bao Thang'),
('087', 'DISTRICT', '10', 'Bảo Yên', 'Bao Yen'),
('088', 'DISTRICT', '10', 'Thị Sa Pa', 'Thi Sa Pa'),
('089', 'DISTRICT', '10', 'Văn Bàn', 'Van Ban')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 080 - Lào Cai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02635', 'WARD', '080', 'Duyên Hải', 'Duyen Hai'),
('02641', 'WARD', '080', 'Lào Cai', 'Lao Cai'),
('02644', 'WARD', '080', 'Cốc Lếu', 'Coc Leu'),
('02647', 'WARD', '080', 'Kim Tân', 'Kim Tan'),
('02650', 'WARD', '080', 'Bắc Lệnh', 'Bac Lenh'),
('02653', 'WARD', '080', 'Pom Hán', 'Pom Han'),
('02656', 'WARD', '080', 'Xuân Tăng', 'Xuan Tang'),
('02658', 'WARD', '080', 'Bình Minh', 'Binh Minh'),
('02659', 'WARD', '080', 'Thống Nhất', 'Thong Nhat'),
('02662', 'WARD', '080', 'Đồng Tuyển', 'Dong Tuyen'),
('02665', 'WARD', '080', 'Vạn Hoà', 'Van Hoa'),
('02668', 'WARD', '080', 'Bắc Cường', 'Bac Cuong'),
('02671', 'WARD', '080', 'Nam Cường', 'Nam Cuong'),
('02674', 'WARD', '080', 'Cam Đường', 'Cam Duong'),
('02677', 'WARD', '080', 'Tả Phời', 'Ta Phoi'),
('02680', 'WARD', '080', 'Hợp Thành', 'Hop Thanh'),
('02746', 'WARD', '080', 'Cốc San', 'Coc San')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 082 - Bát Xát
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02683', 'WARD', '082', 'Thị trấn Bát Xát', 'Thi tran Bat Xat'),
('02686', 'WARD', '082', 'A Mú Sung', 'A Mu Sung'),
('02689', 'WARD', '082', 'Nậm Chạc', 'Nam Chac'),
('02692', 'WARD', '082', 'A Lù', 'A Lu'),
('02695', 'WARD', '082', 'Trịnh Tường', 'Trinh Tuong'),
('02701', 'WARD', '082', 'Y Tý', 'Y Ty'),
('02704', 'WARD', '082', 'Cốc Mỳ', 'Coc My'),
('02707', 'WARD', '082', 'Dền Sáng', 'Den Sang'),
('02710', 'WARD', '082', 'Bản Vược', 'Ban Vuoc'),
('02713', 'WARD', '082', 'Sàng Ma Sáo', 'Sang Ma Sao'),
('02716', 'WARD', '082', 'Bản Qua', 'Ban Qua'),
('02719', 'WARD', '082', 'Mường Vi', 'Muong Vi'),
('02722', 'WARD', '082', 'Dền Thàng', 'Den Thang'),
('02725', 'WARD', '082', 'Bản Xèo', 'Ban Xeo'),
('02728', 'WARD', '082', 'Mường Hum', 'Muong Hum'),
('02731', 'WARD', '082', 'Trung Lèng Hồ', 'Trung Leng Ho'),
('02734', 'WARD', '082', 'Quang Kim', 'Quang Kim'),
('02737', 'WARD', '082', 'Pa Cheo', 'Pa Cheo'),
('02740', 'WARD', '082', 'Nậm Pung', 'Nam Pung'),
('02743', 'WARD', '082', 'Phìn Ngan', 'Phin Ngan'),
('02749', 'WARD', '082', 'Tòng Sành', 'Tong Sanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 083 - Mường Khương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02752', 'WARD', '083', 'Pha Long', 'Pha Long'),
('02755', 'WARD', '083', 'Tả Ngải Chồ', 'Ta Ngai Cho'),
('02758', 'WARD', '083', 'Tung Chung Phố', 'Tung Chung Pho'),
('02761', 'WARD', '083', 'Thị trấn Mường Khương', 'Thi tran Muong Khuong'),
('02764', 'WARD', '083', 'Dìn Chin', 'Din Chin'),
('02767', 'WARD', '083', 'Tả Gia Khâu', 'Ta Gia Khau'),
('02770', 'WARD', '083', 'Nậm Chảy', 'Nam Chay'),
('02773', 'WARD', '083', 'Nấm Lư', 'Nam Lu'),
('02776', 'WARD', '083', 'Lùng Khấu Nhin', 'Lung Khau Nhin'),
('02779', 'WARD', '083', 'Thanh Bình', 'Thanh Binh'),
('02782', 'WARD', '083', 'Cao Sơn', 'Cao Son'),
('02785', 'WARD', '083', 'Lùng Vai', 'Lung Vai'),
('02788', 'WARD', '083', 'Bản Lầu', 'Ban Lau'),
('02791', 'WARD', '083', 'La Pan Tẩn', 'La Pan Tan'),
('02794', 'WARD', '083', 'Tả Thàng', 'Ta Thang'),
('02797', 'WARD', '083', 'Bản Sen', 'Ban Sen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 084 - Si Ma Cai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02800', 'WARD', '084', 'Nàn Sán', 'Nan San'),
('02803', 'WARD', '084', 'Thào Chư Phìn', 'Thao Chu Phin'),
('02806', 'WARD', '084', 'Bản Mế', 'Ban Me'),
('02809', 'WARD', '084', 'Thị trấn Si Ma Cai', 'Thi tran Si Ma Cai'),
('02812', 'WARD', '084', 'Sán Chải', 'San Chai'),
('02818', 'WARD', '084', 'Lùng Thẩn', 'Lung Than'),
('02821', 'WARD', '084', 'Cán Cấu', 'Can Cau'),
('02824', 'WARD', '084', 'Sín Chéng', 'Sin Cheng'),
('02827', 'WARD', '084', 'Hồ Thẩn', 'Ho Than'),
('02836', 'WARD', '084', 'Nàn Xín', 'Nan Xin')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 085 - Bắc Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02839', 'WARD', '085', 'Thị trấn Bắc Hà', 'Thi tran Bac Ha'),
('02842', 'WARD', '085', 'Lùng Cải', 'Lung Cai'),
('02848', 'WARD', '085', 'Lùng Phình', 'Lung Phinh'),
('02851', 'WARD', '085', 'Tả Van Chư', 'Ta Van Chu'),
('02854', 'WARD', '085', 'Tả Củ Tỷ', 'Ta Cu Ty'),
('02857', 'WARD', '085', 'Thải Giàng Phố', 'Thai Giang Pho'),
('02863', 'WARD', '085', 'Hoàng Thu Phố', 'Hoang Thu Pho'),
('02866', 'WARD', '085', 'Bản Phố', 'Ban Pho'),
('02869', 'WARD', '085', 'Bản Liền', 'Ban Lien'),
('02875', 'WARD', '085', 'Na Hối', 'Na Hoi'),
('02878', 'WARD', '085', 'Cốc Ly', 'Coc Ly'),
('02881', 'WARD', '085', 'Nậm Mòn', 'Nam Mon'),
('02884', 'WARD', '085', 'Nậm Đét', 'Nam Det'),
('02887', 'WARD', '085', 'Nậm Khánh', 'Nam Khanh'),
('02890', 'WARD', '085', 'Bảo Nhai', 'Bao Nhai'),
('02893', 'WARD', '085', 'Nậm Lúc', 'Nam Luc'),
('02896', 'WARD', '085', 'Cốc Lầu', 'Coc Lau'),
('02899', 'WARD', '085', 'Bản Cái', 'Ban Cai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 086 - Bảo Thắng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02902', 'WARD', '086', 'Thị trấn N.T Phong Hải', 'Thi tran N.T Phong Hai'),
('02905', 'WARD', '086', 'Thị trấn Phố Lu', 'Thi tran Pho Lu'),
('02908', 'WARD', '086', 'Thị trấn Tằng Loỏng', 'Thi tran Tang Loong'),
('02911', 'WARD', '086', 'Bản Phiệt', 'Ban Phiet'),
('02914', 'WARD', '086', 'Bản Cầm', 'Ban Cam'),
('02917', 'WARD', '086', 'Thái Niên', 'Thai Nien'),
('02920', 'WARD', '086', 'Phong Niên', 'Phong Nien'),
('02923', 'WARD', '086', 'Gia Phú', 'Gia Phu'),
('02926', 'WARD', '086', 'Xuân Quang', 'Xuan Quang'),
('02929', 'WARD', '086', 'Sơn Hải', 'Son Hai'),
('02932', 'WARD', '086', 'Xuân Giao', 'Xuan Giao'),
('02935', 'WARD', '086', 'Trì Quang', 'Tri Quang'),
('02938', 'WARD', '086', 'Sơn Hà', 'Son Ha'),
('02944', 'WARD', '086', 'Phú Nhuận', 'Phu Nhuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 087 - Bảo Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('02947', 'WARD', '087', 'Thị trấn Phố Ràng', 'Thi tran Pho Rang'),
('02950', 'WARD', '087', 'Tân Tiến', 'Tan Tien'),
('02953', 'WARD', '087', 'Nghĩa Đô', 'Nghia Do'),
('02956', 'WARD', '087', 'Vĩnh Yên', 'Vinh Yen'),
('02959', 'WARD', '087', 'Điện Quan', 'Dien Quan'),
('02962', 'WARD', '087', 'Xuân Hoà', 'Xuan Hoa'),
('02965', 'WARD', '087', 'Tân Dương', 'Tan Duong'),
('02968', 'WARD', '087', 'Thượng Hà', 'Thuong Ha'),
('02971', 'WARD', '087', 'Kim Sơn', 'Kim Son'),
('02974', 'WARD', '087', 'Cam Cọn', 'Cam Con'),
('02977', 'WARD', '087', 'Minh Tân', 'Minh Tan'),
('02980', 'WARD', '087', 'Xuân Thượng', 'Xuan Thuong'),
('02983', 'WARD', '087', 'Việt Tiến', 'Viet Tien'),
('02986', 'WARD', '087', 'Yên Sơn', 'Yen Son'),
('02989', 'WARD', '087', 'Bảo Hà', 'Bao Ha'),
('02992', 'WARD', '087', 'Lương Sơn', 'Luong Son'),
('02998', 'WARD', '087', 'Phúc Khánh', 'Phuc Khanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 088 - Thị Sa Pa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03001', 'WARD', '088', 'Sa Pa', 'Sa Pa'),
('03002', 'WARD', '088', 'Sa Pả', 'Sa Pa'),
('03003', 'WARD', '088', 'Ô Quý Hồ', 'O Quy Ho'),
('03004', 'WARD', '088', 'Ngũ Chỉ Sơn', 'Ngu Chi Son'),
('03006', 'WARD', '088', 'Phan Si Păng', 'Phan Si Pang'),
('03010', 'WARD', '088', 'Trung Chải', 'Trung Chai'),
('03013', 'WARD', '088', 'Tả Phìn', 'Ta Phin'),
('03016', 'WARD', '088', 'Hàm Rồng', 'Ham Rong'),
('03019', 'WARD', '088', 'Hoàng Liên', 'Hoang Lien'),
('03022', 'WARD', '088', 'Thanh Bình', 'Thanh Binh'),
('03028', 'WARD', '088', 'Cầu Mây', 'Cau May'),
('03037', 'WARD', '088', 'Mường Hoa', 'Muong Hoa'),
('03040', 'WARD', '088', 'Tả Van', 'Ta Van'),
('03043', 'WARD', '088', 'Mường Bo', 'Muong Bo'),
('03046', 'WARD', '088', 'Bản Hồ', 'Ban Ho'),
('03052', 'WARD', '088', 'Liên Minh', 'Lien Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 089 - Văn Bàn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03055', 'WARD', '089', 'Thị trấn Khánh Yên', 'Thi tran Khanh Yen'),
('03061', 'WARD', '089', 'Võ Lao', 'Vo Lao'),
('03064', 'WARD', '089', 'Sơn Thuỷ', 'Son Thuy'),
('03067', 'WARD', '089', 'Nậm Mả', 'Nam Ma'),
('03070', 'WARD', '089', 'Tân Thượng', 'Tan Thuong'),
('03073', 'WARD', '089', 'Nậm Rạng', 'Nam Rang'),
('03076', 'WARD', '089', 'Nậm Chầy', 'Nam Chay'),
('03079', 'WARD', '089', 'Tân An', 'Tan An'),
('03082', 'WARD', '089', 'Khánh Yên Thượng', 'Khanh Yen Thuong'),
('03085', 'WARD', '089', 'Nậm Xé', 'Nam Xe'),
('03088', 'WARD', '089', 'Dần Thàng', 'Dan Thang'),
('03091', 'WARD', '089', 'Chiềng Ken', 'Chieng Ken'),
('03094', 'WARD', '089', 'Làng Giàng', 'Lang Giang'),
('03097', 'WARD', '089', 'Hoà Mạc', 'Hoa Mac'),
('03100', 'WARD', '089', 'Khánh Yên Trung', 'Khanh Yen Trung'),
('03103', 'WARD', '089', 'Khánh Yên Hạ', 'Khanh Yen Ha'),
('03106', 'WARD', '089', 'Dương Quỳ', 'Duong Quy'),
('03109', 'WARD', '089', 'Nậm Tha', 'Nam Tha'),
('03112', 'WARD', '089', 'Minh Lương', 'Minh Luong'),
('03115', 'WARD', '089', 'Thẩm Dương', 'Tham Duong'),
('03118', 'WARD', '089', 'Liêm Phú', 'Liem Phu'),
('03121', 'WARD', '089', 'Nậm Xây', 'Nam Xay')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 11 - Điện Biên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('094', 'DISTRICT', '11', 'Điện Biên Phủ', 'Thanh pho Dien Bien Phu'),
('095', 'DISTRICT', '11', 'Thị Mường Lay', 'Thi Muong Lay'),
('096', 'DISTRICT', '11', 'Mường Nhé', 'Muong Nhe'),
('097', 'DISTRICT', '11', 'Mường Chà', 'Muong Cha'),
('098', 'DISTRICT', '11', 'Tủa Chùa', 'Tua Chua'),
('099', 'DISTRICT', '11', 'Tuần Giáo', 'Tuan Giao'),
('100', 'DISTRICT', '11', 'Điện Biên', 'Dien Bien'),
('101', 'DISTRICT', '11', 'Điện Biên Đông', 'Dien Bien Dong'),
('102', 'DISTRICT', '11', 'Mường Ảng', 'Muong Ang'),
('103', 'DISTRICT', '11', 'Nậm Pồ', 'Nam Po')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 094 - Điện Biên Phủ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03124', 'WARD', '094', 'Noong Bua', 'Noong Bua'),
('03127', 'WARD', '094', 'Him Lam', 'Him Lam'),
('03130', 'WARD', '094', 'Thanh Bình', 'Thanh Binh'),
('03133', 'WARD', '094', 'Tân Thanh', 'Tan Thanh'),
('03136', 'WARD', '094', 'Mường Thanh', 'Muong Thanh'),
('03139', 'WARD', '094', 'Nam Thanh', 'Nam Thanh'),
('03142', 'WARD', '094', 'Thanh Trường', 'Thanh Truong'),
('03145', 'WARD', '094', 'Thanh Minh', 'Thanh Minh'),
('03316', 'WARD', '094', 'Nà Tấu', 'Na Tau'),
('03317', 'WARD', '094', 'Nà Nhạn', 'Na Nhan'),
('03325', 'WARD', '094', 'Mường Phăng', 'Muong Phang'),
('03326', 'WARD', '094', 'Pá Khoang', 'Pa Khoang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 095 - Thị Mường Lay
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03148', 'WARD', '095', 'Sông Đà', 'Song Da'),
('03151', 'WARD', '095', 'Na Lay', 'Na Lay'),
('03184', 'WARD', '095', 'Lay Nưa', 'Lay Nua')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 096 - Mường Nhé
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03154', 'WARD', '096', 'Sín Thầu', 'Sin Thau'),
('03155', 'WARD', '096', 'Sen Thượng', 'Sen Thuong'),
('03157', 'WARD', '096', 'Chung Chải', 'Chung Chai'),
('03158', 'WARD', '096', 'Leng Su Sìn', 'Leng Su Sin'),
('03159', 'WARD', '096', 'Pá Mỳ', 'Pa My'),
('03160', 'WARD', '096', 'Mường Nhé', 'Muong Nhe'),
('03161', 'WARD', '096', 'Nậm Vì', 'Nam Vi'),
('03162', 'WARD', '096', 'Nậm Kè', 'Nam Ke'),
('03163', 'WARD', '096', 'Mường Toong', 'Muong Toong'),
('03164', 'WARD', '096', 'Quảng Lâm', 'Quang Lam'),
('03177', 'WARD', '096', 'Huổi Lếnh', 'Huoi Lenh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 097 - Mường Chà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03172', 'WARD', '097', 'Thị trấn Mường Chà', 'Thi tran Muong Cha'),
('03178', 'WARD', '097', 'Xá Tổng', 'Tong'),
('03181', 'WARD', '097', 'Mường Tùng', 'Muong Tung'),
('03190', 'WARD', '097', 'Hừa Ngài', 'Hua Ngai'),
('03191', 'WARD', '097', 'Huổi Mí', 'Huoi Mi'),
('03193', 'WARD', '097', 'Pa Ham', 'Pa Ham'),
('03194', 'WARD', '097', 'Nậm Nèn', 'Nam Nen'),
('03196', 'WARD', '097', 'Huổi Lèng', 'Huoi Leng'),
('03197', 'WARD', '097', 'Sa Lông', 'Sa Long'),
('03200', 'WARD', '097', 'Ma Thì Hồ', 'Ma Thi Ho'),
('03201', 'WARD', '097', 'Na Sang', 'Na Sang'),
('03202', 'WARD', '097', 'Mường Mươn', 'Muong Muon')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 098 - Tủa Chùa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03217', 'WARD', '098', 'Thị trấn Tủa Chùa', 'Thi tran Tua Chua'),
('03220', 'WARD', '098', 'Huổi Só', 'Huoi So'),
('03223', 'WARD', '098', 'Xín Chải', 'Xin Chai'),
('03226', 'WARD', '098', 'Tả Sìn Thàng', 'Ta Sin Thang'),
('03229', 'WARD', '098', 'Lao Xả Phình', 'Lao Phinh'),
('03232', 'WARD', '098', 'Tả Phìn', 'Ta Phin'),
('03235', 'WARD', '098', 'Tủa Thàng', 'Tua Thang'),
('03238', 'WARD', '098', 'Trung Thu', 'Trung Thu'),
('03241', 'WARD', '098', 'Sính Phình', 'Sinh Phinh'),
('03244', 'WARD', '098', 'Sáng Nhè', 'Sang Nhe'),
('03247', 'WARD', '098', 'Mường Đun', 'Muong Dun'),
('03250', 'WARD', '098', 'Mường Báng', 'Muong Bang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 099 - Tuần Giáo
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03253', 'WARD', '099', 'Thị trấn Tuần Giáo', 'Thi tran Tuan Giao'),
('03259', 'WARD', '099', 'Phình Sáng', 'Phinh Sang'),
('03260', 'WARD', '099', 'Rạng Đông', 'Rang Dong'),
('03262', 'WARD', '099', 'Mùn Chung', 'Mun Chung'),
('03263', 'WARD', '099', 'Nà Tòng', 'Na Tong'),
('03265', 'WARD', '099', 'Ta Ma', 'Ta Ma'),
('03268', 'WARD', '099', 'Mường Mùn', 'Muong Mun'),
('03269', 'WARD', '099', 'Pú Xi', 'Pu Xi'),
('03271', 'WARD', '099', 'Pú Nhung', 'Pu Nhung'),
('03274', 'WARD', '099', 'Quài Nưa', 'Quai Nua'),
('03277', 'WARD', '099', 'Mường Thín', 'Muong Thin'),
('03280', 'WARD', '099', 'Tỏa Tình', 'Toa Tinh'),
('03283', 'WARD', '099', 'Nà Sáy', 'Na Say'),
('03284', 'WARD', '099', 'Mường Khong', 'Muong Khong'),
('03289', 'WARD', '099', 'Quài Cang', 'Quai Cang'),
('03295', 'WARD', '099', 'Quài Tở', 'Quai To'),
('03298', 'WARD', '099', 'Chiềng Sinh', 'Chieng Sinh'),
('03299', 'WARD', '099', 'Chiềng Đông', 'Chieng Dong'),
('03304', 'WARD', '099', 'Tênh Phông', 'Tenh Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 100 - Điện Biên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03319', 'WARD', '100', 'Mường Pồn', 'Muong Pon'),
('03322', 'WARD', '100', 'Thanh Nưa', 'Thanh Nua'),
('03323', 'WARD', '100', 'Hua Thanh', 'Hua Thanh'),
('03328', 'WARD', '100', 'Thanh Luông', 'Thanh Luong'),
('03331', 'WARD', '100', 'Thanh Hưng', 'Thanh Hung'),
('03334', 'WARD', '100', 'Thanh Xương', 'Thanh Xuong'),
('03337', 'WARD', '100', 'Thanh Chăn', 'Thanh Chan'),
('03340', 'WARD', '100', 'Pa Thơm', 'Pa Thom'),
('03343', 'WARD', '100', 'Thanh An', 'Thanh An'),
('03346', 'WARD', '100', 'Thanh Yên', 'Thanh Yen'),
('03349', 'WARD', '100', 'Noong Luống', 'Noong Luong'),
('03352', 'WARD', '100', 'Noọng Hẹt', 'Noong Het'),
('03355', 'WARD', '100', 'Sam Mứn', 'Sam Mun'),
('03356', 'WARD', '100', 'Pom Lót', 'Pom Lot'),
('03358', 'WARD', '100', 'Núa Ngam', 'Nua Ngam'),
('03359', 'WARD', '100', 'Hẹ Muông', 'He Muong'),
('03361', 'WARD', '100', 'Na Ư', 'Na U'),
('03364', 'WARD', '100', 'Mường Nhà', 'Muong Nha'),
('03365', 'WARD', '100', 'Na Tông', 'Na Tong'),
('03367', 'WARD', '100', 'Mường Lói', 'Muong Loi'),
('03368', 'WARD', '100', 'Phu Luông', 'Phu Luong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 101 - Điện Biên Đông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03203', 'WARD', '101', 'Thị trấn Điện Biên Đông', 'Thi tran Dien Bien Dong'),
('03205', 'WARD', '101', 'Na Son', 'Na Son'),
('03208', 'WARD', '101', 'Phì Nhừ', 'Phi Nhu'),
('03211', 'WARD', '101', 'Chiềng Sơ', 'Chieng So'),
('03214', 'WARD', '101', 'Mường Luân', 'Muong Luan'),
('03370', 'WARD', '101', 'Pú Nhi', 'Pu Nhi'),
('03371', 'WARD', '101', 'Nong U', 'Nong U'),
('03373', 'WARD', '101', 'Dung', 'Dung'),
('03376', 'WARD', '101', 'Keo Lôm', 'Keo Lom'),
('03379', 'WARD', '101', 'Luân Giới', 'Luan Gioi'),
('03382', 'WARD', '101', 'Phình Giàng', 'Phinh Giang'),
('03383', 'WARD', '101', 'Pú Hồng', 'Pu Hong'),
('03384', 'WARD', '101', 'Tìa Dình', 'Tia Dinh'),
('03385', 'WARD', '101', 'Háng Lìa', 'Hang Lia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 102 - Mường Ảng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03256', 'WARD', '102', 'Thị trấn Mường Ảng', 'Thi tran Muong Ang'),
('03286', 'WARD', '102', 'Mường Đăng', 'Muong Dang'),
('03287', 'WARD', '102', 'Ngối Cáy', 'Ngoi Cay'),
('03292', 'WARD', '102', 'Ẳng Tở', 'Ang To'),
('03301', 'WARD', '102', 'Búng Lao', 'Bung Lao'),
('03302', 'WARD', '102', 'Xuân Lao', 'Xuan Lao'),
('03307', 'WARD', '102', 'Ẳng Nưa', 'Ang Nua'),
('03310', 'WARD', '102', 'Ẳng Cang', 'Ang Cang'),
('03312', 'WARD', '102', 'Nặm Lịch', 'Nam Lich'),
('03313', 'WARD', '102', 'Mường Lạn', 'Muong Lan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 103 - Nậm Pồ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03156', 'WARD', '103', 'Nậm Tin', 'Nam Tin'),
('03165', 'WARD', '103', 'Pa Tần', 'Pa Tan'),
('03166', 'WARD', '103', 'Chà Cang', 'Cha Cang'),
('03167', 'WARD', '103', 'Na Cô Sa', 'Na Co Sa'),
('03168', 'WARD', '103', 'Nà Khoa', 'Na Khoa'),
('03169', 'WARD', '103', 'Nà Hỳ', 'Na Hy'),
('03170', 'WARD', '103', 'Nà Bủng', 'Na Bung'),
('03171', 'WARD', '103', 'Nậm Nhừ', 'Nam Nhu'),
('03173', 'WARD', '103', 'Nậm Chua', 'Nam Chua'),
('03174', 'WARD', '103', 'Nậm Khăn', 'Nam Khan'),
('03175', 'WARD', '103', 'Chà Tở', 'Cha To'),
('03176', 'WARD', '103', 'Vàng Đán', 'Vang Dan'),
('03187', 'WARD', '103', 'Chà Nưa', 'Cha Nua'),
('03198', 'WARD', '103', 'Phìn Hồ', 'Phin Ho'),
('03199', 'WARD', '103', 'Si Pa Phìn', 'Si Pa Phin')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 12 - Lai Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('105', 'DISTRICT', '12', 'Lai Châu', 'Thanh pho Lai Chau'),
('106', 'DISTRICT', '12', 'Tam Đường', 'Tam Duong'),
('107', 'DISTRICT', '12', 'Mường Tè', 'Muong Te'),
('108', 'DISTRICT', '12', 'Sìn Hồ', 'Sin Ho'),
('109', 'DISTRICT', '12', 'Phong Thổ', 'Phong Tho'),
('110', 'DISTRICT', '12', 'Than Uyên', 'Than Uyen'),
('111', 'DISTRICT', '12', 'Tân Uyên', 'Tan Uyen'),
('112', 'DISTRICT', '12', 'Nậm Nhùn', 'Nam Nhun')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 105 - Lai Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03386', 'WARD', '105', 'Quyết Thắng', 'Quyet Thang'),
('03387', 'WARD', '105', 'Tân Phong', 'Tan Phong'),
('03388', 'WARD', '105', 'Quyết Tiến', 'Quyet Tien'),
('03389', 'WARD', '105', 'Đoàn Kết', 'Doan Ket'),
('03403', 'WARD', '105', 'Sùng Phài', 'Sung Phai'),
('03408', 'WARD', '105', 'Đông Phong', 'Dong Phong'),
('03409', 'WARD', '105', 'San Thàng', 'San Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 106 - Tam Đường
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03390', 'WARD', '106', 'Thị trấn Tam Đường', 'Thi tran Tam Duong'),
('03394', 'WARD', '106', 'Thèn Sin', 'Then Sin'),
('03400', 'WARD', '106', 'Tả Lèng', 'Ta Leng'),
('03405', 'WARD', '106', 'Giang Ma', 'Giang Ma'),
('03406', 'WARD', '106', 'Hồ Thầu', 'Ho Thau'),
('03412', 'WARD', '106', 'Bình Lư', 'Binh Lu'),
('03413', 'WARD', '106', 'Sơn Bình', 'Son Binh'),
('03415', 'WARD', '106', 'Nùng Nàng', 'Nung Nang'),
('03418', 'WARD', '106', 'Bản Giang', 'Ban Giang'),
('03421', 'WARD', '106', 'Bản Hon', 'Ban Hon'),
('03424', 'WARD', '106', 'Bản Bo', 'Ban Bo'),
('03427', 'WARD', '106', 'Nà Tăm', 'Na Tam'),
('03430', 'WARD', '106', 'Khun Há', 'Khun Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 107 - Mường Tè
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03433', 'WARD', '107', 'Thị trấn Mường Tè', 'Thi tran Muong Te'),
('03436', 'WARD', '107', 'Thu Lũm', 'Thu Lum'),
('03439', 'WARD', '107', 'Ka Lăng', 'Ka Lang'),
('03440', 'WARD', '107', 'Tá Bạ', 'Ta Ba'),
('03442', 'WARD', '107', 'Pa ủ', 'Pa u'),
('03445', 'WARD', '107', 'Mường Tè', 'Muong Te'),
('03448', 'WARD', '107', 'Pa Vệ Sử', 'Pa Ve Su'),
('03451', 'WARD', '107', 'Mù Cả', 'Mu Ca'),
('03454', 'WARD', '107', 'Bum Tở', 'Bum To'),
('03457', 'WARD', '107', 'Nậm Khao', 'Nam Khao'),
('03463', 'WARD', '107', 'Tà Tổng', 'Ta Tong'),
('03466', 'WARD', '107', 'Bum Nưa', 'Bum Nua'),
('03467', 'WARD', '107', 'Vàng San', 'Vang San'),
('03469', 'WARD', '107', 'Kan Hồ', 'Kan Ho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 108 - Sìn Hồ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03478', 'WARD', '108', 'Thị trấn Sìn Hồ', 'Thi tran Sin Ho'),
('03487', 'WARD', '108', 'Chăn Nưa', 'Chan Nua'),
('03493', 'WARD', '108', 'Pa Tần', 'Pa Tan'),
('03496', 'WARD', '108', 'Phìn Hồ', 'Phin Ho'),
('03499', 'WARD', '108', 'Hồng Thu', 'Hong Thu'),
('03505', 'WARD', '108', 'Phăng Sô Lin', 'Phang So Lin'),
('03508', 'WARD', '108', 'Ma Quai', 'Ma Quai'),
('03509', 'WARD', '108', 'Lùng Thàng', 'Lung Thang'),
('03511', 'WARD', '108', 'Tả Phìn', 'Ta Phin'),
('03514', 'WARD', '108', 'Sà Dề Phìn', 'Sa De Phin'),
('03517', 'WARD', '108', 'Nậm Tăm', 'Nam Tam'),
('03520', 'WARD', '108', 'Tả Ngảo', 'Ta Ngao'),
('03523', 'WARD', '108', 'Pu Sam Cáp', 'Pu Sam Cap'),
('03526', 'WARD', '108', 'Nậm Cha', 'Nam Cha'),
('03527', 'WARD', '108', 'Pa Khoá', 'Pa Khoa'),
('03529', 'WARD', '108', 'Làng Mô', 'Lang Mo'),
('03532', 'WARD', '108', 'Noong Hẻo', 'Noong Heo'),
('03535', 'WARD', '108', 'Nậm Mạ', 'Nam Ma'),
('03538', 'WARD', '108', 'Căn Co', 'Can Co'),
('03541', 'WARD', '108', 'Tủa Sín Chải', 'Tua Sin Chai'),
('03544', 'WARD', '108', 'Nậm Cuổi', 'Nam Cuoi'),
('03547', 'WARD', '108', 'Nậm Hăn', 'Nam Han')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 109 - Phong Thổ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03391', 'WARD', '109', 'Lả Nhì Thàng', 'La Nhi Thang'),
('03490', 'WARD', '109', 'Huổi Luông', 'Huoi Luong'),
('03549', 'WARD', '109', 'Thị trấn Phong Thổ', 'Thi tran Phong Tho'),
('03550', 'WARD', '109', 'Sì Lở Lầu', 'Si Lo Lau'),
('03553', 'WARD', '109', 'Mồ Sì San', 'Mo Si San'),
('03559', 'WARD', '109', 'Pa Vây Sử', 'Pa Vay Su'),
('03562', 'WARD', '109', 'Vàng Ma Chải', 'Vang Ma Chai'),
('03565', 'WARD', '109', 'Tông Qua Lìn', 'Tong Qua Lin'),
('03568', 'WARD', '109', 'Mù Sang', 'Mu Sang'),
('03571', 'WARD', '109', 'Dào San', 'Dao San'),
('03574', 'WARD', '109', 'Ma Ly Pho', 'Ma Ly Pho'),
('03577', 'WARD', '109', 'Bản Lang', 'Ban Lang'),
('03580', 'WARD', '109', 'Hoang Thèn', 'Hoang Then'),
('03583', 'WARD', '109', 'Khổng Lào', 'Khong Lao'),
('03586', 'WARD', '109', 'Nậm Xe', 'Nam Xe'),
('03589', 'WARD', '109', 'Mường So', 'Muong So'),
('03592', 'WARD', '109', 'Sin Suối Hồ', 'Sin Suoi Ho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 110 - Than Uyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03595', 'WARD', '110', 'Thị trấn Than Uyên', 'Thi tran Than Uyen'),
('03618', 'WARD', '110', 'Phúc Than', 'Phuc Than'),
('03619', 'WARD', '110', 'Mường Than', 'Muong Than'),
('03625', 'WARD', '110', 'Mường Mít', 'Muong Mit'),
('03628', 'WARD', '110', 'Pha Mu', 'Pha Mu'),
('03631', 'WARD', '110', 'Mường Cang', 'Muong Cang'),
('03632', 'WARD', '110', 'Hua Nà', 'Hua Na'),
('03634', 'WARD', '110', 'Tà Hừa', 'Ta Hua'),
('03637', 'WARD', '110', 'Mường Kim', 'Muong Kim'),
('03638', 'WARD', '110', 'Tà Mung', 'Ta Mung'),
('03640', 'WARD', '110', 'Tà Gia', 'Ta Gia'),
('03643', 'WARD', '110', 'Khoen On', 'Khoen On')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 111 - Tân Uyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03598', 'WARD', '111', 'Thị trấn Tân Uyên', 'Thi tran Tan Uyen'),
('03601', 'WARD', '111', 'Mường Khoa', 'Muong Khoa'),
('03602', 'WARD', '111', 'Phúc Khoa', 'Phuc Khoa'),
('03604', 'WARD', '111', 'Thân Thuộc', 'Than Thuoc'),
('03605', 'WARD', '111', 'Trung Đồng', 'Trung Dong'),
('03607', 'WARD', '111', 'Hố Mít', 'Ho Mit'),
('03610', 'WARD', '111', 'Nậm Cần', 'Nam Can'),
('03613', 'WARD', '111', 'Nậm Sỏ', 'Nam So'),
('03616', 'WARD', '111', 'Pắc Ta', 'Pac Ta'),
('03622', 'WARD', '111', 'Tà Mít', 'Ta Mit')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 112 - Nậm Nhùn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03434', 'WARD', '112', 'Thị trấn Nậm Nhùn', 'Thi tran Nam Nhun'),
('03460', 'WARD', '112', 'Hua Bun', 'Hua Bun'),
('03472', 'WARD', '112', 'Mường Mô', 'Muong Mo'),
('03473', 'WARD', '112', 'Nậm Chà', 'Nam Cha'),
('03474', 'WARD', '112', 'Nậm Manh', 'Nam Manh'),
('03475', 'WARD', '112', 'Nậm Hàng', 'Nam Hang'),
('03481', 'WARD', '112', 'Lê Lợi', 'Le Loi'),
('03484', 'WARD', '112', 'Pú Đao', 'Pu Dao'),
('03488', 'WARD', '112', 'Nậm Pì', 'Nam Pi'),
('03502', 'WARD', '112', 'Nậm Ban', 'Nam Ban'),
('03503', 'WARD', '112', 'Trung Chải', 'Trung Chai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 14 - Sơn La
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('116', 'DISTRICT', '14', 'Sơn La', 'Thanh pho Son La'),
('118', 'DISTRICT', '14', 'Quỳnh Nhai', 'Quynh Nhai'),
('119', 'DISTRICT', '14', 'Thuận Châu', 'Thuan Chau'),
('120', 'DISTRICT', '14', 'Mường La', 'Muong La'),
('121', 'DISTRICT', '14', 'Bắc Yên', 'Bac Yen'),
('122', 'DISTRICT', '14', 'Phù Yên', 'Phu Yen'),
('123', 'DISTRICT', '14', 'Mộc Châu', 'Moc Chau'),
('124', 'DISTRICT', '14', 'Yên Châu', 'Yen Chau'),
('125', 'DISTRICT', '14', 'Mai Sơn', 'Mai Son'),
('126', 'DISTRICT', '14', 'Sông Mã', 'Song Ma'),
('127', 'DISTRICT', '14', 'Sốp Cộp', 'Sop Cop'),
('128', 'DISTRICT', '14', 'Vân Hồ', 'Van Ho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 116 - Sơn La
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03646', 'WARD', '116', 'Chiềng Lề', 'Chieng Le'),
('03649', 'WARD', '116', 'Tô Hiệu', 'To Hieu'),
('03652', 'WARD', '116', 'Quyết Thắng', 'Quyet Thang'),
('03655', 'WARD', '116', 'Quyết Tâm', 'Quyet Tam'),
('03658', 'WARD', '116', 'Chiềng Cọ', 'Chieng Co'),
('03661', 'WARD', '116', 'Chiềng Đen', 'Chieng Den'),
('03664', 'WARD', '116', 'Chiềng Xôm', 'Chieng Xom'),
('03667', 'WARD', '116', 'Chiềng An', 'Chieng An'),
('03670', 'WARD', '116', 'Chiềng Cơi', 'Chieng Coi'),
('03673', 'WARD', '116', 'Chiềng Ngần', 'Chieng Ngan'),
('03676', 'WARD', '116', 'Hua La', 'Hua La'),
('03679', 'WARD', '116', 'Chiềng Sinh', 'Chieng Sinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 118 - Quỳnh Nhai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03682', 'WARD', '118', 'Mường Chiên', 'Muong Chien'),
('03685', 'WARD', '118', 'Cà Nàng', 'Ca Nang'),
('03688', 'WARD', '118', 'Chiềng Khay', 'Chieng Khay'),
('03694', 'WARD', '118', 'Mường Giôn', 'Muong Gion'),
('03697', 'WARD', '118', 'Pá Ma Pha Khinh', 'Pa Ma Pha Khinh'),
('03700', 'WARD', '118', 'Chiềng Ơn', 'Chieng On'),
('03703', 'WARD', '118', 'Mường Giàng', 'Muong Giang'),
('03706', 'WARD', '118', 'Chiềng Bằng', 'Chieng Bang'),
('03709', 'WARD', '118', 'Mường Sại', 'Muong Sai'),
('03712', 'WARD', '118', 'Nậm ét', 'Nam et'),
('03718', 'WARD', '118', 'Chiềng Khoang', 'Chieng Khoang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 119 - Thuận Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03721', 'WARD', '119', 'Thị trấn Thuận Châu', 'Thi tran Thuan Chau'),
('03724', 'WARD', '119', 'Phổng Lái', 'Phong Lai'),
('03727', 'WARD', '119', 'Mường é', 'Muong e'),
('03730', 'WARD', '119', 'Chiềng Pha', 'Chieng Pha'),
('03733', 'WARD', '119', 'Chiềng La', 'Chieng La'),
('03736', 'WARD', '119', 'Chiềng Ngàm', 'Chieng Ngam'),
('03739', 'WARD', '119', 'Liệp Tè', 'Liep Te'),
('03742', 'WARD', '119', 'é Tòng', 'e Tong'),
('03745', 'WARD', '119', 'Phổng Lập', 'Phong Lap'),
('03748', 'WARD', '119', 'Phổng Lăng', 'Phong Lang'),
('03751', 'WARD', '119', 'Chiềng Ly', 'Chieng Ly'),
('03754', 'WARD', '119', 'Noong Lay', 'Noong Lay'),
('03757', 'WARD', '119', 'Mường Khiêng', 'Muong Khieng'),
('03760', 'WARD', '119', 'Mường Bám', 'Muong Bam'),
('03763', 'WARD', '119', 'Long Hẹ', 'Long He'),
('03766', 'WARD', '119', 'Chiềng Bôm', 'Chieng Bom'),
('03769', 'WARD', '119', 'Thôm Mòn', 'Thom Mon'),
('03772', 'WARD', '119', 'Tông Lạnh', 'Tong Lanh'),
('03775', 'WARD', '119', 'Tông Cọ', 'Tong Co'),
('03778', 'WARD', '119', 'Bó Mười', 'Bo Muoi'),
('03781', 'WARD', '119', 'Co Mạ', 'Co Ma'),
('03784', 'WARD', '119', 'Púng Tra', 'Pung Tra'),
('03787', 'WARD', '119', 'Chiềng Pấc', 'Chieng Pac'),
('03790', 'WARD', '119', 'Nậm Lầu', 'Nam Lau'),
('03793', 'WARD', '119', 'Bon Phặng', 'Bon Phang'),
('03796', 'WARD', '119', 'Co Tòng', 'Co Tong'),
('03799', 'WARD', '119', 'Muổi Nọi', 'Muoi Noi'),
('03802', 'WARD', '119', 'Pá Lông', 'Pa Long'),
('03805', 'WARD', '119', 'Bản Lầm', 'Ban Lam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 120 - Mường La
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03808', 'WARD', '120', 'Thị trấn Ít Ong', 'Thi tran It Ong'),
('03811', 'WARD', '120', 'Nậm Giôn', 'Nam Gion'),
('03814', 'WARD', '120', 'Chiềng Lao', 'Chieng Lao'),
('03817', 'WARD', '120', 'Hua Trai', 'Hua Trai'),
('03820', 'WARD', '120', 'Ngọc Chiến', 'Ngoc Chien'),
('03823', 'WARD', '120', 'Mường Trai', 'Muong Trai'),
('03826', 'WARD', '120', 'Nậm Păm', 'Nam Pam'),
('03829', 'WARD', '120', 'Chiềng Muôn', 'Chieng Muon'),
('03832', 'WARD', '120', 'Chiềng Ân', 'Chieng An'),
('03835', 'WARD', '120', 'Pi Toong', 'Pi Toong'),
('03838', 'WARD', '120', 'Chiềng Công', 'Chieng Cong'),
('03841', 'WARD', '120', 'Tạ Bú', 'Ta Bu'),
('03844', 'WARD', '120', 'Chiềng San', 'Chieng San'),
('03847', 'WARD', '120', 'Mường Bú', 'Muong Bu'),
('03850', 'WARD', '120', 'Chiềng Hoa', 'Chieng Hoa'),
('03853', 'WARD', '120', 'Mường Chùm', 'Muong Chum')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 121 - Bắc Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03856', 'WARD', '121', 'Thị trấn Bắc Yên', 'Thi tran Bac Yen'),
('03859', 'WARD', '121', 'Phiêng Ban', 'Phieng Ban'),
('03862', 'WARD', '121', 'Hang Chú', 'Hang Chu'),
('03865', 'WARD', '121', 'Xím Vàng', 'Xim Vang'),
('03868', 'WARD', '121', 'Tà Xùa', 'Ta Xua'),
('03869', 'WARD', '121', 'Háng Đồng', 'Hang Dong'),
('03871', 'WARD', '121', 'Pắc Ngà', 'Pac Nga'),
('03874', 'WARD', '121', 'Làng Chếu', 'Lang Cheu'),
('03877', 'WARD', '121', 'Chim Vàn', 'Chim Van'),
('03880', 'WARD', '121', 'Mường Khoa', 'Muong Khoa'),
('03883', 'WARD', '121', 'Song Pe', 'Song Pe'),
('03886', 'WARD', '121', 'Hồng Ngài', 'Hong Ngai'),
('03889', 'WARD', '121', 'Tạ Khoa', 'Ta Khoa'),
('03890', 'WARD', '121', 'Hua Nhàn', 'Hua Nhan'),
('03892', 'WARD', '121', 'Phiêng Côn', 'Phieng Con'),
('03895', 'WARD', '121', 'Chiềng Sại', 'Chieng Sai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 122 - Phù Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03898', 'WARD', '122', 'Thị trấn Phù Yên', 'Thi tran Phu Yen'),
('03901', 'WARD', '122', 'Suối Tọ', 'Suoi To'),
('03904', 'WARD', '122', 'Mường Thải', 'Muong Thai'),
('03907', 'WARD', '122', 'Mường Cơi', 'Muong Coi'),
('03910', 'WARD', '122', 'Quang Huy', 'Quang Huy'),
('03913', 'WARD', '122', 'Huy Bắc', 'Huy Bac'),
('03916', 'WARD', '122', 'Huy Thượng', 'Huy Thuong'),
('03919', 'WARD', '122', 'Tân Lang', 'Tan Lang'),
('03922', 'WARD', '122', 'Gia Phù', 'Gia Phu'),
('03925', 'WARD', '122', 'Tường Phù', 'Tuong Phu'),
('03928', 'WARD', '122', 'Huy Hạ', 'Huy Ha'),
('03931', 'WARD', '122', 'Huy Tân', 'Huy Tan'),
('03934', 'WARD', '122', 'Mường Lang', 'Muong Lang'),
('03937', 'WARD', '122', 'Suối Bau', 'Suoi Bau'),
('03940', 'WARD', '122', 'Huy Tường', 'Huy Tuong'),
('03943', 'WARD', '122', 'Mường Do', 'Muong Do'),
('03946', 'WARD', '122', 'Sập Xa', 'Sap Xa'),
('03949', 'WARD', '122', 'Tường Thượng', 'Tuong Thuong'),
('03952', 'WARD', '122', 'Tường Tiến', 'Tuong Tien'),
('03955', 'WARD', '122', 'Tường Phong', 'Tuong Phong'),
('03958', 'WARD', '122', 'Tường Hạ', 'Tuong Ha'),
('03961', 'WARD', '122', 'Kim Bon', 'Kim Bon'),
('03964', 'WARD', '122', 'Mường Bang', 'Muong Bang'),
('03967', 'WARD', '122', 'Đá Đỏ', 'Da Do'),
('03970', 'WARD', '122', 'Tân Phong', 'Tan Phong'),
('03973', 'WARD', '122', 'Nam Phong', 'Nam Phong'),
('03976', 'WARD', '122', 'Bắc Phong', 'Bac Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 123 - Mộc Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03979', 'WARD', '123', 'Thị trấn Mộc Châu', 'Thi tran Moc Chau'),
('03982', 'WARD', '123', 'Thị trấn NT Mộc Châu', 'Thi tran NT Moc Chau'),
('03985', 'WARD', '123', 'Chiềng Sơn', 'Chieng Son'),
('03988', 'WARD', '123', 'Tân Hợp', 'Tan Hop'),
('03991', 'WARD', '123', 'Qui Hướng', 'Qui Huong'),
('03997', 'WARD', '123', 'Tân Lập', 'Tan Lap'),
('04000', 'WARD', '123', 'Nà Mường', 'Na Muong'),
('04003', 'WARD', '123', 'Tà Lai', 'Ta Lai'),
('04012', 'WARD', '123', 'Chiềng Hắc', 'Chieng Hac'),
('04015', 'WARD', '123', 'Hua Păng', 'Hua Pang'),
('04024', 'WARD', '123', 'Chiềng Khừa', 'Chieng Khua'),
('04027', 'WARD', '123', 'Mường Sang', 'Muong Sang'),
('04030', 'WARD', '123', 'Đông Sang', 'Dong Sang'),
('04033', 'WARD', '123', 'Phiêng Luông', 'Phieng Luong'),
('04045', 'WARD', '123', 'Lóng Sập', 'Long Sap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 124 - Yên Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04060', 'WARD', '124', 'Thị trấn Yên Châu', 'Thi tran Yen Chau'),
('04063', 'WARD', '124', 'Chiềng Đông', 'Chieng Dong'),
('04066', 'WARD', '124', 'Sập Vạt', 'Sap Vat'),
('04069', 'WARD', '124', 'Chiềng Sàng', 'Chieng Sang'),
('04072', 'WARD', '124', 'Chiềng Pằn', 'Chieng Pan'),
('04075', 'WARD', '124', 'Viêng Lán', 'Vieng Lan'),
('04078', 'WARD', '124', 'Chiềng Hặc', 'Chieng Hac'),
('04081', 'WARD', '124', 'Mường Lựm', 'Muong Lum'),
('04084', 'WARD', '124', 'Chiềng On', 'Chieng On'),
('04087', 'WARD', '124', 'Yên Sơn', 'Yen Son'),
('04090', 'WARD', '124', 'Chiềng Khoi', 'Chieng Khoi'),
('04093', 'WARD', '124', 'Tú Nang', 'Tu Nang'),
('04096', 'WARD', '124', 'Lóng Phiêng', 'Long Phieng'),
('04099', 'WARD', '124', 'Phiêng Khoài', 'Phieng Khoai'),
('04102', 'WARD', '124', 'Chiềng Tương', 'Chieng Tuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 125 - Mai Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04105', 'WARD', '125', 'Thị trấn Hát Lót', 'Thi tran Hat Lot'),
('04108', 'WARD', '125', 'Chiềng Sung', 'Chieng Sung'),
('04111', 'WARD', '125', 'Mường Bằng', 'Muong Bang'),
('04114', 'WARD', '125', 'Chiềng Chăn', 'Chieng Chan'),
('04117', 'WARD', '125', 'Mương Chanh', 'Muong Chanh'),
('04120', 'WARD', '125', 'Chiềng Ban', 'Chieng Ban'),
('04123', 'WARD', '125', 'Chiềng Mung', 'Chieng Mung'),
('04126', 'WARD', '125', 'Mường Bon', 'Muong Bon'),
('04129', 'WARD', '125', 'Chiềng Chung', 'Chieng Chung'),
('04132', 'WARD', '125', 'Chiềng Mai', 'Chieng Mai'),
('04135', 'WARD', '125', 'Hát Lót', 'Hat Lot'),
('04136', 'WARD', '125', 'Nà Pó', 'Na Po'),
('04138', 'WARD', '125', 'Cò Nòi', 'Co Noi'),
('04141', 'WARD', '125', 'Chiềng Nơi', 'Chieng Noi'),
('04144', 'WARD', '125', 'Phiêng Cằm', 'Phieng Cam'),
('04147', 'WARD', '125', 'Chiềng Dong', 'Chieng Dong'),
('04150', 'WARD', '125', 'Chiềng Kheo', 'Chieng Kheo'),
('04153', 'WARD', '125', 'Chiềng Ve', 'Chieng Ve'),
('04156', 'WARD', '125', 'Chiềng Lương', 'Chieng Luong'),
('04159', 'WARD', '125', 'Phiêng Pằn', 'Phieng Pan'),
('04162', 'WARD', '125', 'Nà Ơt', 'Na Ot'),
('04165', 'WARD', '125', 'Tà Hộc', 'Ta Hoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 126 - Sông Mã
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04168', 'WARD', '126', 'Thị trấn Sông Mã', 'Thi tran Song Ma'),
('04171', 'WARD', '126', 'Bó Sinh', 'Bo Sinh'),
('04174', 'WARD', '126', 'Pú Pẩu', 'Pu Pau'),
('04177', 'WARD', '126', 'Chiềng Phung', 'Chieng Phung'),
('04180', 'WARD', '126', 'Chiềng En', 'Chieng En'),
('04183', 'WARD', '126', 'Mường Lầm', 'Muong Lam'),
('04186', 'WARD', '126', 'Nậm Ty', 'Nam Ty'),
('04189', 'WARD', '126', 'Đứa Mòn', 'Dua Mon'),
('04192', 'WARD', '126', 'Yên Hưng', 'Yen Hung'),
('04195', 'WARD', '126', 'Chiềng Sơ', 'Chieng So'),
('04198', 'WARD', '126', 'Nà Nghịu', 'Na Nghiu'),
('04201', 'WARD', '126', 'Nậm Mằn', 'Nam Man'),
('04204', 'WARD', '126', 'Chiềng Khoong', 'Chieng Khoong'),
('04207', 'WARD', '126', 'Chiềng Cang', 'Chieng Cang'),
('04210', 'WARD', '126', 'Huổi Một', 'Huoi Mot'),
('04213', 'WARD', '126', 'Mường Sai', 'Muong Sai'),
('04216', 'WARD', '126', 'Mường Cai', 'Muong Cai'),
('04219', 'WARD', '126', 'Mường Hung', 'Muong Hung'),
('04222', 'WARD', '126', 'Chiềng Khương', 'Chieng Khuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 127 - Sốp Cộp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04225', 'WARD', '127', 'Sam Kha', 'Sam Kha'),
('04228', 'WARD', '127', 'Púng Bánh', 'Pung Banh'),
('04231', 'WARD', '127', 'Sốp Cộp', 'Sop Cop'),
('04234', 'WARD', '127', 'Dồm Cang', 'Dom Cang'),
('04237', 'WARD', '127', 'Nậm Lạnh', 'Nam Lanh'),
('04240', 'WARD', '127', 'Mường Lèo', 'Muong Leo'),
('04243', 'WARD', '127', 'Mường Và', 'Muong Va'),
('04246', 'WARD', '127', 'Mường Lạn', 'Muong Lan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 128 - Vân Hồ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('03994', 'WARD', '128', 'Suối Bàng', 'Suoi Bang'),
('04006', 'WARD', '128', 'Song Khủa', 'Song Khua'),
('04009', 'WARD', '128', 'Liên Hoà', 'Lien Hoa'),
('04018', 'WARD', '128', 'Tô Múa', 'To Mua'),
('04021', 'WARD', '128', 'Mường Tè', 'Muong Te'),
('04036', 'WARD', '128', 'Chiềng Khoa', 'Chieng Khoa'),
('04039', 'WARD', '128', 'Mường Men', 'Muong Men'),
('04042', 'WARD', '128', 'Quang Minh', 'Quang Minh'),
('04048', 'WARD', '128', 'Vân Hồ', 'Van Ho'),
('04051', 'WARD', '128', 'Lóng Luông', 'Long Luong'),
('04054', 'WARD', '128', 'Chiềng Yên', 'Chieng Yen'),
('04056', 'WARD', '128', 'Chiềng Xuân', 'Chieng Xuan'),
('04057', 'WARD', '128', 'Xuân Nha', 'Xuan Nha'),
('04058', 'WARD', '128', 'Tân Xuân', 'Tan Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 15 - Yên Bái
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('132', 'DISTRICT', '15', 'Yên Bái', 'Thanh pho Yen Bai'),
('133', 'DISTRICT', '15', 'Thị Nghĩa Lộ', 'Thi Nghia Lo'),
('135', 'DISTRICT', '15', 'Lục Yên', 'Luc Yen'),
('136', 'DISTRICT', '15', 'Văn Yên', 'Van Yen'),
('137', 'DISTRICT', '15', 'Mù Căng Chải', 'Mu Cang Chai'),
('138', 'DISTRICT', '15', 'Trấn Yên', 'Tran Yen'),
('139', 'DISTRICT', '15', 'Trạm Tấu', 'Tram Tau'),
('140', 'DISTRICT', '15', 'Văn Chấn', 'Van Chan'),
('141', 'DISTRICT', '15', 'Yên Bình', 'Yen Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 132 - Yên Bái
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04249', 'WARD', '132', 'Yên Thịnh', 'Yen Thinh'),
('04252', 'WARD', '132', 'Yên Ninh', 'Yen Ninh'),
('04255', 'WARD', '132', 'Minh Tân', 'Minh Tan'),
('04258', 'WARD', '132', 'Nguyễn Thái Học', 'Nguyen Thai Hoc'),
('04261', 'WARD', '132', 'Đồng Tâm', 'Dong Tam'),
('04264', 'WARD', '132', 'Hồng Hà', 'Hong Ha'),
('04270', 'WARD', '132', 'Minh Bảo', 'Minh Bao'),
('04273', 'WARD', '132', 'Nam Cường', 'Nam Cuong'),
('04276', 'WARD', '132', 'Tuy Lộc', 'Tuy Loc'),
('04279', 'WARD', '132', 'Tân Thịnh', 'Tan Thinh'),
('04540', 'WARD', '132', 'Âu Lâu', 'Au Lau'),
('04543', 'WARD', '132', 'Giới Phiên', 'Gioi Phien'),
('04546', 'WARD', '132', 'Hợp Minh', 'Hop Minh'),
('04558', 'WARD', '132', 'Văn Phú', 'Van Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 133 - Thị Nghĩa Lộ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04282', 'WARD', '133', 'Pú Trạng', 'Pu Trang'),
('04285', 'WARD', '133', 'Trung Tâm', 'Trung Tam'),
('04288', 'WARD', '133', 'Tân An', 'Tan An'),
('04291', 'WARD', '133', 'Cầu Thia', 'Cau Thia'),
('04294', 'WARD', '133', 'Nghĩa Lợi', 'Nghia Loi'),
('04297', 'WARD', '133', 'Nghĩa Phúc', 'Nghia Phuc'),
('04300', 'WARD', '133', 'Nghĩa An', 'Nghia An'),
('04624', 'WARD', '133', 'Nghĩa Lộ', 'Nghia Lo'),
('04660', 'WARD', '133', 'Sơn A', 'Son A'),
('04663', 'WARD', '133', 'Phù Nham', 'Phu Nham'),
('04675', 'WARD', '133', 'Thanh Lương', 'Thanh Luong'),
('04678', 'WARD', '133', 'Hạnh Sơn', 'Hanh Son'),
('04681', 'WARD', '133', 'Phúc Sơn', 'Phuc Son'),
('04684', 'WARD', '133', 'Thạch Lương', 'Thach Luong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 135 - Lục Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04303', 'WARD', '135', 'Thị trấn Yên Thế', 'Thi tran Yen The'),
('04306', 'WARD', '135', 'Tân Phượng', 'Tan Phuong'),
('04309', 'WARD', '135', 'Lâm Thượng', 'Lam Thuong'),
('04312', 'WARD', '135', 'Khánh Thiện', 'Khanh Thien'),
('04315', 'WARD', '135', 'Minh Chuẩn', 'Minh Chuan'),
('04318', 'WARD', '135', 'Mai Sơn', 'Mai Son'),
('04321', 'WARD', '135', 'Khai Trung', 'Khai Trung'),
('04324', 'WARD', '135', 'Mường Lai', 'Muong Lai'),
('04327', 'WARD', '135', 'An Lạc', 'An Lac'),
('04330', 'WARD', '135', 'Minh Xuân', 'Minh Xuan'),
('04333', 'WARD', '135', 'Tô Mậu', 'To Mau'),
('04336', 'WARD', '135', 'Tân Lĩnh', 'Tan Linh'),
('04339', 'WARD', '135', 'Yên Thắng', 'Yen Thang'),
('04342', 'WARD', '135', 'Khánh Hoà', 'Khanh Hoa'),
('04345', 'WARD', '135', 'Vĩnh Lạc', 'Vinh Lac'),
('04348', 'WARD', '135', 'Liễu Đô', 'Lieu Do'),
('04351', 'WARD', '135', 'Động Quan', 'Dong Quan'),
('04354', 'WARD', '135', 'Tân Lập', 'Tan Lap'),
('04357', 'WARD', '135', 'Minh Tiến', 'Minh Tien'),
('04360', 'WARD', '135', 'Trúc Lâu', 'Truc Lau'),
('04363', 'WARD', '135', 'Phúc Lợi', 'Phuc Loi'),
('04366', 'WARD', '135', 'Phan Thanh', 'Phan Thanh'),
('04369', 'WARD', '135', 'An Phú', 'An Phu'),
('04372', 'WARD', '135', 'Trung Tâm', 'Trung Tam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 136 - Văn Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04375', 'WARD', '136', 'Thị trấn Mậu A', 'Thi tran Mau A'),
('04378', 'WARD', '136', 'Lang Thíp', 'Lang Thip'),
('04381', 'WARD', '136', 'Lâm Giang', 'Lam Giang'),
('04384', 'WARD', '136', 'Châu Quế Thượng', 'Chau Que Thuong'),
('04387', 'WARD', '136', 'Châu Quế Hạ', 'Chau Que Ha'),
('04390', 'WARD', '136', 'An Bình', 'An Binh'),
('04393', 'WARD', '136', 'Quang Minh', 'Quang Minh'),
('04396', 'WARD', '136', 'Đông An', 'Dong An'),
('04399', 'WARD', '136', 'Đông Cuông', 'Dong Cuong'),
('04402', 'WARD', '136', 'Phong Dụ Hạ', 'Phong Du Ha'),
('04405', 'WARD', '136', 'Mậu Đông', 'Mau Dong'),
('04408', 'WARD', '136', 'Ngòi A', 'Ngoi A'),
('04411', 'WARD', '136', 'Xuân Tầm', 'Xuan Tam'),
('04414', 'WARD', '136', 'Tân Hợp', 'Tan Hop'),
('04417', 'WARD', '136', 'An Thịnh', 'An Thinh'),
('04420', 'WARD', '136', 'Yên Thái', 'Yen Thai'),
('04423', 'WARD', '136', 'Phong Dụ Thượng', 'Phong Du Thuong'),
('04426', 'WARD', '136', 'Yên Hợp', 'Yen Hop'),
('04429', 'WARD', '136', 'Đại Sơn', 'Dai Son'),
('04435', 'WARD', '136', 'Đại Phác', 'Dai Phac'),
('04438', 'WARD', '136', 'Yên Phú', 'Yen Phu'),
('04441', 'WARD', '136', 'Xuân Ái', 'Xuan Ai'),
('04447', 'WARD', '136', 'Viễn Sơn', 'Vien Son'),
('04450', 'WARD', '136', 'Mỏ Vàng', 'Mo Vang'),
('04453', 'WARD', '136', 'Nà Hẩu', 'Na Hau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 137 - Mù Căng Chải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04456', 'WARD', '137', 'Thị trấn Mù Căng Chải', 'Thi tran Mu Cang Chai'),
('04459', 'WARD', '137', 'Hồ Bốn', 'Ho Bon'),
('04462', 'WARD', '137', 'Nậm Có', 'Nam Co'),
('04465', 'WARD', '137', 'Khao Mang', 'Khao Mang'),
('04468', 'WARD', '137', 'Mồ Dề', 'Mo De'),
('04471', 'WARD', '137', 'Chế Cu Nha', 'Che Cu Nha'),
('04474', 'WARD', '137', 'Lao Chải', 'Lao Chai'),
('04477', 'WARD', '137', 'Kim Nọi', 'Kim Noi'),
('04480', 'WARD', '137', 'Cao Phạ', 'Cao Pha'),
('04483', 'WARD', '137', 'La Pán Tẩn', 'La Pan Tan'),
('04486', 'WARD', '137', 'Dế Su Phình', 'De Su Phinh'),
('04489', 'WARD', '137', 'Chế Tạo', 'Che Tao'),
('04492', 'WARD', '137', 'Púng Luông', 'Pung Luong'),
('04495', 'WARD', '137', 'Nậm Khắt', 'Nam Khat')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 138 - Trấn Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04498', 'WARD', '138', 'Thị trấn Cổ Phúc', 'Thi tran Co Phuc'),
('04501', 'WARD', '138', 'Tân Đồng', 'Tan Dong'),
('04504', 'WARD', '138', 'Báo Đáp', 'Bao Dap'),
('04510', 'WARD', '138', 'Thành Thịnh', 'Thanh Thinh'),
('04513', 'WARD', '138', 'Hòa Cuông', 'Hoa Cuong'),
('04516', 'WARD', '138', 'Minh Quán', 'Minh Quan'),
('04519', 'WARD', '138', 'Quy Mông', 'Quy Mong'),
('04522', 'WARD', '138', 'Cường Thịnh', 'Cuong Thinh'),
('04525', 'WARD', '138', 'Kiên Thành', 'Kien Thanh'),
('04531', 'WARD', '138', 'Y Can', 'Y Can'),
('04537', 'WARD', '138', 'Lương Thịnh', 'Luong Thinh'),
('04564', 'WARD', '138', 'Việt Cường', 'Viet Cuong'),
('04567', 'WARD', '138', 'Minh Quân', 'Minh Quan'),
('04570', 'WARD', '138', 'Hồng Ca', 'Hong Ca'),
('04573', 'WARD', '138', 'Hưng Thịnh', 'Hung Thinh'),
('04576', 'WARD', '138', 'Hưng Khánh', 'Hung Khanh'),
('04579', 'WARD', '138', 'Việt Hồng', 'Viet Hong'),
('04582', 'WARD', '138', 'Vân Hội', 'Van Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 139 - Trạm Tấu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04585', 'WARD', '139', 'Thị trấn Trạm Tấu', 'Thi tran Tram Tau'),
('04588', 'WARD', '139', 'Túc Đán', 'Tuc Dan'),
('04591', 'WARD', '139', 'Pá Lau', 'Pa Lau'),
('04594', 'WARD', '139', 'Xà Hồ', 'Ho'),
('04597', 'WARD', '139', 'Phình Hồ', 'Phinh Ho'),
('04600', 'WARD', '139', 'Trạm Tấu', 'Tram Tau'),
('04603', 'WARD', '139', 'Tà Si Láng', 'Ta Si Lang'),
('04606', 'WARD', '139', 'Pá Hu', 'Pa Hu'),
('04609', 'WARD', '139', 'Làng Nhì', 'Lang Nhi'),
('04612', 'WARD', '139', 'Bản Công', 'Ban Cong'),
('04615', 'WARD', '139', 'Bản Mù', 'Ban Mu'),
('04618', 'WARD', '139', 'Hát Lìu', 'Hat Liu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 140 - Văn Chấn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04621', 'WARD', '140', 'Thị trấn NT Liên Sơn', 'Thi tran NT Lien Son'),
('04627', 'WARD', '140', 'Thị trấn NT Trần Phú', 'Thi tran NT Tran Phu'),
('04630', 'WARD', '140', 'Tú Lệ', 'Tu Le'),
('04633', 'WARD', '140', 'Nậm Búng', 'Nam Bung'),
('04636', 'WARD', '140', 'Gia Hội', 'Gia Hoi'),
('04639', 'WARD', '140', 'Sùng Đô', 'Sung Do'),
('04642', 'WARD', '140', 'Nậm Mười', 'Nam Muoi'),
('04645', 'WARD', '140', 'An Lương', 'An Luong'),
('04648', 'WARD', '140', 'Nậm Lành', 'Nam Lanh'),
('04651', 'WARD', '140', 'Sơn Lương', 'Son Luong'),
('04654', 'WARD', '140', 'Suối Quyền', 'Suoi Quyen'),
('04657', 'WARD', '140', 'Suối Giàng', 'Suoi Giang'),
('04666', 'WARD', '140', 'Nghĩa Sơn', 'Nghia Son'),
('04669', 'WARD', '140', 'Suối Bu', 'Suoi Bu'),
('04672', 'WARD', '140', 'Thị trấn Sơn Thịnh', 'Thi tran Son Thinh'),
('04687', 'WARD', '140', 'Đại Lịch', 'Dai Lich'),
('04690', 'WARD', '140', 'Đồng Khê', 'Dong Khe'),
('04693', 'WARD', '140', 'Cát Thịnh', 'Cat Thinh'),
('04696', 'WARD', '140', 'Tân Thịnh', 'Tan Thinh'),
('04699', 'WARD', '140', 'Chấn Thịnh', 'Chan Thinh'),
('04702', 'WARD', '140', 'Bình Thuận', 'Binh Thuan'),
('04705', 'WARD', '140', 'Thượng Bằng La', 'Thuong Bang La'),
('04708', 'WARD', '140', 'Minh An', 'Minh An'),
('04711', 'WARD', '140', 'Nghĩa Tâm', 'Nghia Tam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 141 - Yên Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04714', 'WARD', '141', 'Thị trấn Yên Bình', 'Thi tran Yen Binh'),
('04717', 'WARD', '141', 'Thị trấn Thác Bà', 'Thi tran Thac Ba'),
('04720', 'WARD', '141', 'Xuân Long', 'Xuan Long'),
('04726', 'WARD', '141', 'Cảm Nhân', 'Cam Nhan'),
('04729', 'WARD', '141', 'Ngọc Chấn', 'Ngoc Chan'),
('04732', 'WARD', '141', 'Tân Nguyên', 'Tan Nguyen'),
('04735', 'WARD', '141', 'Phúc Ninh', 'Phuc Ninh'),
('04738', 'WARD', '141', 'Bảo Ái', 'Bao Ai'),
('04741', 'WARD', '141', 'Mỹ Gia', 'My Gia'),
('04744', 'WARD', '141', 'Xuân Lai', 'Xuan Lai'),
('04747', 'WARD', '141', 'Mông Sơn', 'Mong Son'),
('04750', 'WARD', '141', 'Cảm Ân', 'Cam An'),
('04753', 'WARD', '141', 'Yên Thành', 'Yen Thanh'),
('04756', 'WARD', '141', 'Tân Hương', 'Tan Huong'),
('04759', 'WARD', '141', 'Phúc An', 'Phuc An'),
('04762', 'WARD', '141', 'Bạch Hà', 'Bach Ha'),
('04765', 'WARD', '141', 'Vũ Linh', 'Vu Linh'),
('04768', 'WARD', '141', 'Đại Đồng', 'Dai Dong'),
('04771', 'WARD', '141', 'Vĩnh Kiên', 'Vinh Kien'),
('04777', 'WARD', '141', 'Thịnh Hưng', 'Thinh Hung'),
('04780', 'WARD', '141', 'Hán Đà', 'Han Da'),
('04783', 'WARD', '141', 'Phú Thịnh', 'Phu Thinh'),
('04786', 'WARD', '141', 'Đại Minh', 'Dai Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 17 - Hoà Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('148', 'DISTRICT', '17', 'Hòa Bình', 'Thanh pho Hoa Binh'),
('150', 'DISTRICT', '17', 'Đà Bắc', 'Da Bac'),
('152', 'DISTRICT', '17', 'Lương Sơn', 'Luong Son'),
('153', 'DISTRICT', '17', 'Kim Bôi', 'Kim Boi'),
('154', 'DISTRICT', '17', 'Cao Phong', 'Cao Phong'),
('155', 'DISTRICT', '17', 'Tân Lạc', 'Tan Lac'),
('156', 'DISTRICT', '17', 'Mai Châu', 'Mai Chau'),
('157', 'DISTRICT', '17', 'Lạc Sơn', 'Lac Son'),
('158', 'DISTRICT', '17', 'Yên Thủy', 'Yen Thuy'),
('159', 'DISTRICT', '17', 'Lạc Thủy', 'Lac Thuy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 148 - Hòa Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04789', 'WARD', '148', 'Thái Bình', 'Thai Binh'),
('04792', 'WARD', '148', 'Tân Hòa', 'Tan Hoa'),
('04795', 'WARD', '148', 'Thịnh Lang', 'Thinh Lang'),
('04798', 'WARD', '148', 'Hữu Nghị', 'Huu Nghi'),
('04801', 'WARD', '148', 'Tân Thịnh', 'Tan Thinh'),
('04804', 'WARD', '148', 'Đồng Tiến', 'Dong Tien'),
('04807', 'WARD', '148', 'Phương Lâm', 'Lam'),
('04813', 'WARD', '148', 'Yên Mông', 'Yen Mong'),
('04816', 'WARD', '148', 'Quỳnh Lâm', 'Quynh Lam'),
('04819', 'WARD', '148', 'Dân Chủ', 'Dan Chu'),
('04825', 'WARD', '148', 'Hòa Bình', 'Hoa Binh'),
('04828', 'WARD', '148', 'Thống Nhất', 'Thong Nhat'),
('04894', 'WARD', '148', 'Kỳ Sơn', 'Ky Son'),
('04897', 'WARD', '148', 'Thịnh Minh', 'Thinh Minh'),
('04903', 'WARD', '148', 'Hợp Thành', 'Hop Thanh'),
('04906', 'WARD', '148', 'Quang Tiến', 'Quang Tien'),
('04912', 'WARD', '148', 'Mông Hóa', 'Mong Hoa'),
('04918', 'WARD', '148', 'Trung Minh', 'Trung Minh'),
('04921', 'WARD', '148', 'Độc Lập', 'Doc Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 150 - Đà Bắc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04831', 'WARD', '150', 'Thị trấn Đà Bắc', 'Thi tran Da Bac'),
('04834', 'WARD', '150', 'Nánh Nghê', 'Nanh Nghe'),
('04840', 'WARD', '150', 'Giáp Đắt', 'Giap Dat'),
('04846', 'WARD', '150', 'Mường Chiềng', 'Muong Chieng'),
('04849', 'WARD', '150', 'Tân Pheo', 'Tan Pheo'),
('04852', 'WARD', '150', 'Đồng Chum', 'Dong Chum'),
('04855', 'WARD', '150', 'Tân Minh', 'Tan Minh'),
('04858', 'WARD', '150', 'Đoàn Kết', 'Doan Ket'),
('04861', 'WARD', '150', 'Đồng Ruộng', 'Dong Ruong'),
('04867', 'WARD', '150', 'Tú Lý', 'Tu Ly'),
('04870', 'WARD', '150', 'Trung Thành', 'Trung Thanh'),
('04873', 'WARD', '150', 'Yên Hòa', 'Yen Hoa'),
('04876', 'WARD', '150', 'Cao Sơn', 'Cao Son'),
('04879', 'WARD', '150', 'Toàn Sơn', 'Toan Son'),
('04885', 'WARD', '150', 'Hiền Lương', 'Hien Luong'),
('04888', 'WARD', '150', 'Tiền Phong', 'Tien Phong'),
('04891', 'WARD', '150', 'Vầy Nưa', 'Vay Nua')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 152 - Lương Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04924', 'WARD', '152', 'Thị trấn Lương Sơn', 'Thi tran Luong Son'),
('04942', 'WARD', '152', 'Lâm Sơn', 'Lam Son'),
('04945', 'WARD', '152', 'Hòa Sơn', 'Hoa Son'),
('04951', 'WARD', '152', 'Tân Vinh', 'Tan Vinh'),
('04954', 'WARD', '152', 'Nhuận Trạch', 'Nhuan Trach'),
('04957', 'WARD', '152', 'Cao Sơn', 'Cao Son'),
('04960', 'WARD', '152', 'Cư Yên', 'Cu Yen'),
('04969', 'WARD', '152', 'Liên Sơn', 'Lien Son'),
('05008', 'WARD', '152', 'Cao Dương', 'Cao Duong'),
('05041', 'WARD', '152', 'Thanh Sơn', 'Thanh Son'),
('05047', 'WARD', '152', 'Thanh Cao', 'Thanh Cao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 153 - Kim Bôi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04978', 'WARD', '153', 'Thị trấn Bo', 'Thi tran Bo'),
('04984', 'WARD', '153', 'Đú Sáng', 'Du Sang'),
('04987', 'WARD', '153', 'Hùng Sơn', 'Hung Son'),
('04990', 'WARD', '153', 'Bình Sơn', 'Binh Son'),
('04999', 'WARD', '153', 'Tú Sơn', 'Tu Son'),
('05005', 'WARD', '153', 'Vĩnh Tiến', 'Vinh Tien'),
('05014', 'WARD', '153', 'Đông Bắc', 'Dong Bac'),
('05017', 'WARD', '153', 'Xuân Thủy', 'Xuan Thuy'),
('05026', 'WARD', '153', 'Vĩnh Đồng', 'Vinh Dong'),
('05035', 'WARD', '153', 'Kim Lập', 'Kim Lap'),
('05038', 'WARD', '153', 'Hợp Tiến', 'Hop Tien'),
('05065', 'WARD', '153', 'Kim Bôi', 'Kim Boi'),
('05068', 'WARD', '153', 'Nam Thượng', 'Nam Thuong'),
('05077', 'WARD', '153', 'Cuối Hạ', 'Cuoi Ha'),
('05080', 'WARD', '153', 'Sào Báy', 'Sao Bay'),
('05083', 'WARD', '153', 'Mi Hòa', 'Mi Hoa'),
('05086', 'WARD', '153', 'Nuông Dăm', 'Nuong Dam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 154 - Cao Phong
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05089', 'WARD', '154', 'Thị trấn Cao Phong', 'Thi tran Cao Phong'),
('05092', 'WARD', '154', 'Bình Thanh', 'Binh Thanh'),
('05095', 'WARD', '154', 'Thung Nai', 'Thung Nai'),
('05098', 'WARD', '154', 'Bắc Phong', 'Bac Phong'),
('05101', 'WARD', '154', 'Thu Phong', 'Thu Phong'),
('05104', 'WARD', '154', 'Hợp Phong', 'Hop Phong'),
('05110', 'WARD', '154', 'Tây Phong', 'Tay Phong'),
('05116', 'WARD', '154', 'Dũng Phong', 'Dung Phong'),
('05119', 'WARD', '154', 'Nam Phong', 'Nam Phong'),
('05125', 'WARD', '154', 'Thạch Yên', 'Thach Yen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 155 - Tân Lạc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05128', 'WARD', '155', 'Thị trấn Mãn Đức', 'Thi tran Man Duc'),
('05134', 'WARD', '155', 'Suối Hoa', 'Suoi Hoa'),
('05137', 'WARD', '155', 'Phú Vinh', 'Phu Vinh'),
('05140', 'WARD', '155', 'Phú Cường', 'Phu Cuong'),
('05143', 'WARD', '155', 'Mỹ Hòa', 'My Hoa'),
('05152', 'WARD', '155', 'Quyết Chiến', 'Quyet Chien'),
('05158', 'WARD', '155', 'Phong Phú', 'Phong Phu'),
('05164', 'WARD', '155', 'Tử Nê', 'Tu Ne'),
('05167', 'WARD', '155', 'Thanh Hối', 'Thanh Hoi'),
('05170', 'WARD', '155', 'Ngọc Mỹ', 'Ngoc My'),
('05173', 'WARD', '155', 'Đông Lai', 'Dong Lai'),
('05176', 'WARD', '155', 'Vân Sơn', 'Van Son'),
('05182', 'WARD', '155', 'Nhân Mỹ', 'Nhan My'),
('05191', 'WARD', '155', 'Lỗ Sơn', 'Lo Son'),
('05194', 'WARD', '155', 'Ngổ Luông', 'Ngo Luong'),
('05197', 'WARD', '155', 'Gia Mô', 'Gia Mo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 156 - Mai Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04882', 'WARD', '156', 'Tân Thành', 'Tan Thanh'),
('05200', 'WARD', '156', 'Thị trấn Mai Châu', 'Thi tran Mai Chau'),
('05206', 'WARD', '156', 'Sơn Thủy', 'Son Thuy'),
('05209', 'WARD', '156', 'Pà Cò', 'Pa Co'),
('05212', 'WARD', '156', 'Hang Kia', 'Hang Kia'),
('05221', 'WARD', '156', 'Đồng Tân', 'Dong Tan'),
('05224', 'WARD', '156', 'Cun Pheo', 'Cun Pheo'),
('05227', 'WARD', '156', 'Bao La', 'Bao La'),
('05233', 'WARD', '156', 'Tòng Đậu', 'Tong Dau'),
('05242', 'WARD', '156', 'Nà Phòn', 'Na Phon'),
('05245', 'WARD', '156', 'Săm Khóe', 'Sam Khoe'),
('05248', 'WARD', '156', 'Chiềng Châu', 'Chieng Chau'),
('05251', 'WARD', '156', 'Mai Hạ', 'Mai Ha'),
('05254', 'WARD', '156', 'Thành Sơn', 'Thanh Son'),
('05257', 'WARD', '156', 'Mai Hịch', 'Mai Hich'),
('05263', 'WARD', '156', 'Vạn Mai', 'Van Mai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 157 - Lạc Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05266', 'WARD', '157', 'Thị trấn Vụ Bản', 'Thi tran Vu Ban'),
('05269', 'WARD', '157', 'Quý Hòa', 'Quy Hoa'),
('05272', 'WARD', '157', 'Miền Đồi', 'Mien Doi'),
('05275', 'WARD', '157', 'Mỹ Thành', 'My Thanh'),
('05278', 'WARD', '157', 'Tuân Đạo', 'Tuan Dao'),
('05281', 'WARD', '157', 'Văn Nghĩa', 'Van Nghia'),
('05284', 'WARD', '157', 'Văn Sơn', 'Van Son'),
('05287', 'WARD', '157', 'Tân Lập', 'Tan Lap'),
('05290', 'WARD', '157', 'Nhân Nghĩa', 'Nhan Nghia'),
('05293', 'WARD', '157', 'Thượng Cốc', 'Thuong Coc'),
('05299', 'WARD', '157', 'Quyết Thắng', 'Quyet Thang'),
('05302', 'WARD', '157', 'Xuất Hóa', 'Xuat Hoa'),
('05305', 'WARD', '157', 'Yên Phú', 'Yen Phu'),
('05308', 'WARD', '157', 'Bình Hẻm', 'Binh Hem'),
('05320', 'WARD', '157', 'Định Cư', 'Dinh Cu'),
('05323', 'WARD', '157', 'Chí Đạo', 'Chi Dao'),
('05329', 'WARD', '157', 'Ngọc Sơn', 'Ngoc Son'),
('05332', 'WARD', '157', 'Hương Nhượng', 'Huong Nhuong'),
('05335', 'WARD', '157', 'Vũ Bình', 'Vu Binh'),
('05338', 'WARD', '157', 'Tự Do', 'Tu Do'),
('05341', 'WARD', '157', 'Yên Nghiệp', 'Yen Nghiep'),
('05344', 'WARD', '157', 'Tân Mỹ', 'Tan My'),
('05347', 'WARD', '157', 'Ân Nghĩa', 'An Nghia'),
('05350', 'WARD', '157', 'Ngọc Lâu', 'Ngoc Lau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 158 - Yên Thủy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05353', 'WARD', '158', 'Thị trấn Hàng Trạm', 'Thi tran Hang Tram'),
('05356', 'WARD', '158', 'Lạc Sỹ', 'Lac Sy'),
('05362', 'WARD', '158', 'Lạc Lương', 'Lac Luong'),
('05365', 'WARD', '158', 'Bảo Hiệu', 'Bao Hieu'),
('05368', 'WARD', '158', 'Đa Phúc', 'Da Phuc'),
('05371', 'WARD', '158', 'Hữu Lợi', 'Huu Loi'),
('05374', 'WARD', '158', 'Lạc Thịnh', 'Lac Thinh'),
('05380', 'WARD', '158', 'Đoàn Kết', 'Doan Ket'),
('05383', 'WARD', '158', 'Phú Lai', 'Phu Lai'),
('05386', 'WARD', '158', 'Yên Trị', 'Yen Tri'),
('05389', 'WARD', '158', 'Ngọc Lương', 'Ngoc Luong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 159 - Lạc Thủy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('04981', 'WARD', '159', 'Thị trấn Ba Hàng Đồi', 'Thi tran Ba Hang Doi'),
('05392', 'WARD', '159', 'Thị trấn Chi Nê', 'Thi tran Chi Ne'),
('05395', 'WARD', '159', 'Phú Nghĩa', 'Phu Nghia'),
('05398', 'WARD', '159', 'Phú Thành', 'Phu Thanh'),
('05404', 'WARD', '159', 'Hưng Thi', 'Hung Thi'),
('05413', 'WARD', '159', 'Khoan Dụ', 'Khoan Du'),
('05419', 'WARD', '159', 'Đồng Tâm', 'Dong Tam'),
('05422', 'WARD', '159', 'Yên Bồng', 'Yen Bong'),
('05425', 'WARD', '159', 'Thống Nhất', 'Thong Nhat'),
('05428', 'WARD', '159', 'An Bình', 'An Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 19 - Thái Nguyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('164', 'DISTRICT', '19', 'Thái Nguyên', 'Thanh pho Thai Nguyen'),
('165', 'DISTRICT', '19', 'Sông Công', 'Thanh pho Song Cong'),
('167', 'DISTRICT', '19', 'Định Hóa', 'Dinh Hoa'),
('168', 'DISTRICT', '19', 'Phú Lương', 'Phu Luong'),
('169', 'DISTRICT', '19', 'Đồng Hỷ', 'Dong Hy'),
('170', 'DISTRICT', '19', 'Võ Nhai', 'Vo Nhai'),
('171', 'DISTRICT', '19', 'Đại Từ', 'Dai Tu'),
('172', 'DISTRICT', '19', 'Phổ Yên', 'Thanh pho Pho Yen'),
('173', 'DISTRICT', '19', 'Phú Bình', 'Phu Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 164 - Thái Nguyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05431', 'WARD', '164', 'Quán Triều', 'Trieu'),
('05434', 'WARD', '164', 'Quang Vinh', 'Quang Vinh'),
('05437', 'WARD', '164', 'Túc Duyên', 'Tuc Duyen'),
('05440', 'WARD', '164', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('05443', 'WARD', '164', 'Trưng Vương', 'Trung Vuong'),
('05446', 'WARD', '164', 'Quang Trung', 'Quang Trung'),
('05449', 'WARD', '164', 'Phan Đình Phùng', 'Phan Dinh Phung'),
('05452', 'WARD', '164', 'Tân Thịnh', 'Tan Thinh'),
('05455', 'WARD', '164', 'Thịnh Đán', 'Thinh Dan'),
('05458', 'WARD', '164', 'Đồng Quang', 'Dong Quang'),
('05461', 'WARD', '164', 'Gia Sàng', 'Gia Sang'),
('05464', 'WARD', '164', 'Tân Lập', 'Tan Lap'),
('05467', 'WARD', '164', 'Cam Giá', 'Cam Gia'),
('05470', 'WARD', '164', 'Phú Xá', 'Phu Xa'),
('05473', 'WARD', '164', 'Hương Sơn', 'Huong Son'),
('05476', 'WARD', '164', 'Trung Thành', 'Trung Thanh'),
('05479', 'WARD', '164', 'Tân Thành', 'Tan Thanh'),
('05482', 'WARD', '164', 'Tân Long', 'Tan Long'),
('05485', 'WARD', '164', 'Phúc Hà', 'Phuc Ha'),
('05488', 'WARD', '164', 'Phúc Xuân', 'Phuc Xuan'),
('05491', 'WARD', '164', 'Quyết Thắng', 'Quyet Thang'),
('05494', 'WARD', '164', 'Phúc Trìu', 'Phuc Triu'),
('05497', 'WARD', '164', 'Thịnh Đức', 'Thinh Duc'),
('05500', 'WARD', '164', 'Tích Lương', 'Tich Luong'),
('05503', 'WARD', '164', 'Tân Cương', 'Tan Cuong'),
('05653', 'WARD', '164', 'Sơn Cẩm', 'Son Cam'),
('05659', 'WARD', '164', 'Chùa Hang', 'Chua Hang'),
('05695', 'WARD', '164', 'Cao Ngạn', 'Cao Ngan'),
('05701', 'WARD', '164', 'Linh Sơn', 'Linh Son'),
('05710', 'WARD', '164', 'Đồng Bẩm', 'Dong Bam'),
('05713', 'WARD', '164', 'Huống Thượng', 'Huong Thuong'),
('05914', 'WARD', '164', 'Đồng Liên', 'Dong Lien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 165 - Sông Công
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05506', 'WARD', '165', 'Lương Sơn', 'Luong Son'),
('05509', 'WARD', '165', 'Châu Sơn', 'Chau Son'),
('05512', 'WARD', '165', 'Mỏ Chè', 'Mo Che'),
('05515', 'WARD', '165', 'Cải Đan', 'Cai Dan'),
('05518', 'WARD', '165', 'Thắng Lợi', 'Thang Loi'),
('05521', 'WARD', '165', 'Phố Cò', 'Pho Co'),
('05527', 'WARD', '165', 'Tân Quang', 'Tan Quang'),
('05528', 'WARD', '165', 'Bách Quang', 'Bach Quang'),
('05530', 'WARD', '165', 'Bình Sơn', 'Binh Son'),
('05533', 'WARD', '165', 'Bá Xuyên', 'Ba Xuyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 167 - Định Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05539', 'WARD', '167', 'Linh Thông', 'Linh Thong'),
('05542', 'WARD', '167', 'Lam Vỹ', 'Lam Vy'),
('05545', 'WARD', '167', 'Quy Kỳ', 'Quy Ky'),
('05548', 'WARD', '167', 'Tân Thịnh', 'Tan Thinh'),
('05551', 'WARD', '167', 'Kim Phượng', 'Kim Phuong'),
('05554', 'WARD', '167', 'Bảo Linh', 'Bao Linh'),
('05560', 'WARD', '167', 'Phúc Chu', 'Phuc Chu'),
('05563', 'WARD', '167', 'Tân Dương', 'Tan Duong'),
('05566', 'WARD', '167', 'Phượng Tiến', 'Tien'),
('05569', 'WARD', '167', 'Thị trấn Chợ Chu', 'Thi tran Cho Chu'),
('05572', 'WARD', '167', 'Đồng Thịnh', 'Dong Thinh'),
('05575', 'WARD', '167', 'Định Biên', 'Dinh Bien'),
('05578', 'WARD', '167', 'Thanh Định', 'Thanh Dinh'),
('05581', 'WARD', '167', 'Trung Hội', 'Trung Hoi'),
('05584', 'WARD', '167', 'Trung Lương', 'Trung Luong'),
('05587', 'WARD', '167', 'Bình Yên', 'Binh Yen'),
('05590', 'WARD', '167', 'Điềm Mặc', 'Diem Mac'),
('05593', 'WARD', '167', 'Phú Tiến', 'Phu Tien'),
('05596', 'WARD', '167', 'Bộc Nhiêu', 'Boc Nhieu'),
('05599', 'WARD', '167', 'Sơn Phú', 'Son Phu'),
('05602', 'WARD', '167', 'Phú Đình', 'Phu Dinh'),
('05605', 'WARD', '167', 'Bình Thành', 'Binh Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 168 - Phú Lương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05611', 'WARD', '168', 'Thị trấn Đu', 'Thi tran Du'),
('05614', 'WARD', '168', 'Yên Ninh', 'Yen Ninh'),
('05617', 'WARD', '168', 'Yên Trạch', 'Yen Trach'),
('05620', 'WARD', '168', 'Yên Đổ', 'Yen Do'),
('05623', 'WARD', '168', 'Yên Lạc', 'Yen Lac'),
('05626', 'WARD', '168', 'Ôn Lương', 'On Luong'),
('05629', 'WARD', '168', 'Động Đạt', 'Dong Dat'),
('05632', 'WARD', '168', 'Phủ Lý', 'Phu Ly'),
('05635', 'WARD', '168', 'Phú Đô', 'Phu Do'),
('05638', 'WARD', '168', 'Hợp Thành', 'Hop Thanh'),
('05641', 'WARD', '168', 'Tức Tranh', 'Tuc Tranh'),
('05644', 'WARD', '168', 'Thị trấn Giang Tiên', 'Thi tran Giang Tien'),
('05647', 'WARD', '168', 'Vô Tranh', 'Vo Tranh'),
('05650', 'WARD', '168', 'Cổ Lũng', 'Co Lung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 169 - Đồng Hỷ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05656', 'WARD', '169', 'Thị trấn Sông Cầu', 'Thi tran Song Cau'),
('05662', 'WARD', '169', 'Thị trấn Trại Cau', 'Thi tran Trai Cau'),
('05665', 'WARD', '169', 'Văn Lăng', 'Van Lang'),
('05668', 'WARD', '169', 'Tân Long', 'Tan Long'),
('05671', 'WARD', '169', 'Hòa Bình', 'Hoa Binh'),
('05674', 'WARD', '169', 'Quang Sơn', 'Quang Son'),
('05677', 'WARD', '169', 'Minh Lập', 'Minh Lap'),
('05680', 'WARD', '169', 'Văn Hán', 'Van Han'),
('05683', 'WARD', '169', 'Hóa Trung', 'Hoa Trung'),
('05686', 'WARD', '169', 'Khe Mo', 'Khe Mo'),
('05689', 'WARD', '169', 'Cây Thị', 'Cay Thi'),
('05692', 'WARD', '169', 'Thị trấn Hóa Thượng', 'Thi tran Hoa Thuong'),
('05698', 'WARD', '169', 'Hợp Tiến', 'Hop Tien'),
('05707', 'WARD', '169', 'Nam Hòa', 'Nam Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 170 - Võ Nhai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05716', 'WARD', '170', 'Thị trấn Đình Cả', 'Thi tran Dinh Ca'),
('05719', 'WARD', '170', 'Sảng Mộc', 'Sang Moc'),
('05722', 'WARD', '170', 'Nghinh Tường', 'Nghinh Tuong'),
('05725', 'WARD', '170', 'Thần Xa', 'Than Xa'),
('05728', 'WARD', '170', 'Vũ Chấn', 'Vu Chan'),
('05731', 'WARD', '170', 'Thượng Nung', 'Thuong Nung'),
('05734', 'WARD', '170', 'Phú Thượng', 'Phu Thuong'),
('05737', 'WARD', '170', 'Cúc Đường', 'Cuc Duong'),
('05740', 'WARD', '170', 'La Hiên', 'La Hien'),
('05743', 'WARD', '170', 'Lâu Thượng', 'Lau Thuong'),
('05746', 'WARD', '170', 'Tràng Xá', 'Trang Xa'),
('05749', 'WARD', '170', 'Phương Giao', 'Giao'),
('05752', 'WARD', '170', 'Liên Minh', 'Lien Minh'),
('05755', 'WARD', '170', 'Dân Tiến', 'Dan Tien'),
('05758', 'WARD', '170', 'Bình Long', 'Binh Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 171 - Đại Từ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05761', 'WARD', '171', 'Thị trấn Hùng Sơn', 'Thi tran Hung Son'),
('05767', 'WARD', '171', 'Phúc Lương', 'Phuc Luong'),
('05770', 'WARD', '171', 'Minh Tiến', 'Minh Tien'),
('05773', 'WARD', '171', 'Yên Lãng', 'Yen Lang'),
('05776', 'WARD', '171', 'Đức Lương', 'Duc Luong'),
('05779', 'WARD', '171', 'Phú Cường', 'Phu Cuong'),
('05785', 'WARD', '171', 'Phú Lạc', 'Phu Lac'),
('05788', 'WARD', '171', 'Tân Linh', 'Tan Linh'),
('05791', 'WARD', '171', 'Phú Thịnh', 'Phu Thinh'),
('05794', 'WARD', '171', 'Phục Linh', 'Phuc Linh'),
('05797', 'WARD', '171', 'Phú Xuyên', 'Phu Xuyen'),
('05800', 'WARD', '171', 'Bản Ngoại', 'Ban Ngoai'),
('05803', 'WARD', '171', 'Tiên Hội', 'Tien Hoi'),
('05809', 'WARD', '171', 'Cù Vân', 'Cu Van'),
('05812', 'WARD', '171', 'Hà Thượng', 'Ha Thuong'),
('05815', 'WARD', '171', 'La Bằng', 'La Bang'),
('05818', 'WARD', '171', 'Hoàng Nông', 'Hoang Nong'),
('05821', 'WARD', '171', 'Khôi Kỳ', 'Khoi Ky'),
('05824', 'WARD', '171', 'An Khánh', 'An Khanh'),
('05827', 'WARD', '171', 'Tân Thái', 'Tan Thai'),
('05830', 'WARD', '171', 'Bình Thuận', 'Binh Thuan'),
('05833', 'WARD', '171', 'Lục Ba', 'Luc Ba'),
('05836', 'WARD', '171', 'Mỹ Yên', 'My Yen'),
('05842', 'WARD', '171', 'Văn Yên', 'Van Yen'),
('05845', 'WARD', '171', 'Vạn Phú', 'Van Phu'),
('05848', 'WARD', '171', 'Cát Nê', 'Cat Ne'),
('05851', 'WARD', '171', 'Thị trấn Quân Chu', 'Thi tran Chu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 172 - Phổ Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05854', 'WARD', '172', 'Bãi Bông', 'Bai Bong'),
('05857', 'WARD', '172', 'Bắc Sơn', 'Bac Son'),
('05860', 'WARD', '172', 'Ba Hàng', 'Ba Hang'),
('05863', 'WARD', '172', 'Phúc Tân', 'Phuc Tan'),
('05866', 'WARD', '172', 'Phúc Thuận', 'Phuc Thuan'),
('05869', 'WARD', '172', 'Hồng Tiến', 'Hong Tien'),
('05872', 'WARD', '172', 'Minh Đức', 'Minh Duc'),
('05875', 'WARD', '172', 'Đắc Sơn', 'Dac Son'),
('05878', 'WARD', '172', 'Đồng Tiến', 'Dong Tien'),
('05881', 'WARD', '172', 'Thành Công', 'Thanh Cong'),
('05884', 'WARD', '172', 'Tiên Phong', 'Tien Phong'),
('05887', 'WARD', '172', 'Vạn Phái', 'Van Phai'),
('05890', 'WARD', '172', 'Nam Tiến', 'Nam Tien'),
('05893', 'WARD', '172', 'Tân Hương', 'Tan Huong'),
('05896', 'WARD', '172', 'Đông Cao', 'Dong Cao'),
('05899', 'WARD', '172', 'Trung Thành', 'Trung Thanh'),
('05902', 'WARD', '172', 'Tân Phú', 'Tan Phu'),
('05905', 'WARD', '172', 'Thuận Thành', 'Thuan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 173 - Phú Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05908', 'WARD', '173', 'Thị trấn Hương Sơn', 'Thi tran Huong Son'),
('05911', 'WARD', '173', 'Bàn Đạt', 'Ban Dat'),
('05917', 'WARD', '173', 'Tân Khánh', 'Tan Khanh'),
('05920', 'WARD', '173', 'Tân Kim', 'Tan Kim'),
('05923', 'WARD', '173', 'Tân Thành', 'Tan Thanh'),
('05926', 'WARD', '173', 'Đào Xá', 'Dao Xa'),
('05929', 'WARD', '173', 'Bảo Lý', 'Bao Ly'),
('05932', 'WARD', '173', 'Thượng Đình', 'Thuong Dinh'),
('05935', 'WARD', '173', 'Tân Hòa', 'Tan Hoa'),
('05938', 'WARD', '173', 'Nhã Lộng', 'Nha Long'),
('05941', 'WARD', '173', 'Điềm Thụy', 'Diem Thuy'),
('05944', 'WARD', '173', 'Xuân Phương', 'Xuan Phuong'),
('05947', 'WARD', '173', 'Tân Đức', 'Tan Duc'),
('05950', 'WARD', '173', 'Úc Kỳ', 'Uc Ky'),
('05953', 'WARD', '173', 'Lương Phú', 'Luong Phu'),
('05956', 'WARD', '173', 'Nga My', 'Nga My'),
('05959', 'WARD', '173', 'Kha Sơn', 'Kha Son'),
('05962', 'WARD', '173', 'Thanh Ninh', 'Thanh Ninh'),
('05965', 'WARD', '173', 'Dương Thành', 'Duong Thanh'),
('05968', 'WARD', '173', 'Hà Châu', 'Ha Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 20 - Lạng Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('178', 'DISTRICT', '20', 'Lạng Sơn', 'Thanh pho Lang Son'),
('180', 'DISTRICT', '20', 'Tràng Định', 'Trang Dinh'),
('181', 'DISTRICT', '20', 'Bình Gia', 'Binh Gia'),
('182', 'DISTRICT', '20', 'Văn Lãng', 'Van Lang'),
('183', 'DISTRICT', '20', 'Cao Lộc', 'Cao Loc'),
('184', 'DISTRICT', '20', 'Văn Quan', 'Van Quan'),
('185', 'DISTRICT', '20', 'Bắc Sơn', 'Bac Son'),
('186', 'DISTRICT', '20', 'Hữu Lũng', 'Huu Lung'),
('187', 'DISTRICT', '20', 'Chi Lăng', 'Chi Lang'),
('188', 'DISTRICT', '20', 'Lộc Bình', 'Loc Binh'),
('189', 'DISTRICT', '20', 'Đình Lập', 'Dinh Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 178 - Lạng Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05971', 'WARD', '178', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('05974', 'WARD', '178', 'Tam Thanh', 'Tam Thanh'),
('05977', 'WARD', '178', 'Vĩnh Trại', 'Vinh Trai'),
('05980', 'WARD', '178', 'Đông Kinh', 'Dong Kinh'),
('05983', 'WARD', '178', 'Chi Lăng', 'Chi Lang'),
('05986', 'WARD', '178', 'Hoàng Đồng', 'Hoang Dong'),
('05989', 'WARD', '178', 'Quảng Lạc', 'Quang Lac'),
('05992', 'WARD', '178', 'Mai Pha', 'Mai Pha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 180 - Tràng Định
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('05998', 'WARD', '180', 'Khánh Long', 'Khanh Long'),
('06001', 'WARD', '180', 'Đoàn Kết', 'Doan Ket'),
('06004', 'WARD', '180', 'Quốc Khánh', 'Quoc Khanh'),
('06010', 'WARD', '180', 'Cao Minh', 'Cao Minh'),
('06013', 'WARD', '180', 'Chí Minh', 'Chi Minh'),
('06016', 'WARD', '180', 'Tri Phương', 'Tri Phuong'),
('06019', 'WARD', '180', 'Tân Tiến', 'Tan Tien'),
('06022', 'WARD', '180', 'Tân Yên', 'Tan Yen'),
('06025', 'WARD', '180', 'Đội Cấn', 'Doi Can'),
('06028', 'WARD', '180', 'Tân Minh', 'Tan Minh'),
('06031', 'WARD', '180', 'Kim Đồng', 'Kim Dong'),
('06034', 'WARD', '180', 'Chi Lăng', 'Chi Lang'),
('06037', 'WARD', '180', 'Trung Thành', 'Trung Thanh'),
('06040', 'WARD', '180', 'Thị trấn Thất Khê', 'Thi tran That Khe'),
('06043', 'WARD', '180', 'Đào Viên', 'Dao Vien'),
('06046', 'WARD', '180', 'Đề Thám', 'De Tham'),
('06049', 'WARD', '180', 'Kháng Chiến', 'Khang Chien'),
('06055', 'WARD', '180', 'Hùng Sơn', 'Hung Son'),
('06058', 'WARD', '180', 'Quốc Việt', 'Quoc Viet'),
('06061', 'WARD', '180', 'Hùng Việt', 'Hung Viet')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 181 - Bình Gia
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06067', 'WARD', '181', 'Hưng Đạo', 'Hung Dao'),
('06070', 'WARD', '181', 'Vĩnh Yên', 'Vinh Yen'),
('06073', 'WARD', '181', 'Hoa Thám', 'Hoa Tham'),
('06076', 'WARD', '181', 'Quý Hòa', 'Quy Hoa'),
('06079', 'WARD', '181', 'Hồng Phong', 'Hong Phong'),
('06082', 'WARD', '181', 'Yên Lỗ', 'Yen Lo'),
('06085', 'WARD', '181', 'Thiện Hòa', 'Thien Hoa'),
('06088', 'WARD', '181', 'Quang Trung', 'Quang Trung'),
('06091', 'WARD', '181', 'Thiện Thuật', 'Thien Thuat'),
('06094', 'WARD', '181', 'Minh Khai', 'Minh Khai'),
('06097', 'WARD', '181', 'Thiện Long', 'Thien Long'),
('06100', 'WARD', '181', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('06103', 'WARD', '181', 'Hòa Bình', 'Hoa Binh'),
('06106', 'WARD', '181', 'Mông Ân', 'Mong An'),
('06109', 'WARD', '181', 'Tân Hòa', 'Tan Hoa'),
('06112', 'WARD', '181', 'Thị trấn Bình Gia', 'Thi tran Binh Gia'),
('06115', 'WARD', '181', 'Hồng Thái', 'Hong Thai'),
('06118', 'WARD', '181', 'Bình La', 'Binh La'),
('06121', 'WARD', '181', 'Tân Văn', 'Tan Van')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 182 - Văn Lãng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06124', 'WARD', '182', 'Thị trấn Na Sầm', 'Thi tran Na Sam'),
('06127', 'WARD', '182', 'Trùng Khánh', 'Trung Khanh'),
('06133', 'WARD', '182', 'Bắc La', 'Bac La'),
('06136', 'WARD', '182', 'Thụy Hùng', 'Thuy Hung'),
('06139', 'WARD', '182', 'Bắc Hùng', 'Bac Hung'),
('06142', 'WARD', '182', 'Tân Tác', 'Tan Tac'),
('06148', 'WARD', '182', 'Thanh Long', 'Thanh Long'),
('06151', 'WARD', '182', 'Hội Hoan', 'Hoi Hoan'),
('06154', 'WARD', '182', 'Bắc Việt', 'Bac Viet'),
('06157', 'WARD', '182', 'Hoàng Việt', 'Hoang Viet'),
('06160', 'WARD', '182', 'Gia Miễn', 'Gia Mien'),
('06163', 'WARD', '182', 'Thành Hòa', 'Thanh Hoa'),
('06166', 'WARD', '182', 'Tân Thanh', 'Tan Thanh'),
('06172', 'WARD', '182', 'Tân Mỹ', 'Tan My'),
('06175', 'WARD', '182', 'Hồng Thái', 'Hong Thai'),
('06178', 'WARD', '182', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('06181', 'WARD', '182', 'Nhạc Kỳ', 'Nhac Ky')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 183 - Cao Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06184', 'WARD', '183', 'Thị trấn Đồng Đăng', 'Thi tran Dong Dang'),
('06187', 'WARD', '183', 'Thị trấn Cao Lộc', 'Thi tran Cao Loc'),
('06190', 'WARD', '183', 'Bảo Lâm', 'Bao Lam'),
('06193', 'WARD', '183', 'Thanh Lòa', 'Thanh Loa'),
('06196', 'WARD', '183', 'Cao Lâu', 'Cao Lau'),
('06199', 'WARD', '183', 'Thạch Đạn', 'Thach Dan'),
('06202', 'WARD', '183', 'Xuất Lễ', 'Xuat Le'),
('06205', 'WARD', '183', 'Hồng Phong', 'Hong Phong'),
('06208', 'WARD', '183', 'Thụy Hùng', 'Thuy Hung'),
('06211', 'WARD', '183', 'Lộc Yên', 'Loc Yen'),
('06214', 'WARD', '183', 'Phú Xá', 'Phu Xa'),
('06217', 'WARD', '183', 'Bình Trung', 'Binh Trung'),
('06220', 'WARD', '183', 'Hải Yến', 'Hai Yen'),
('06223', 'WARD', '183', 'Hòa Cư', 'Hoa Cu'),
('06226', 'WARD', '183', 'Hợp Thành', 'Hop Thanh'),
('06232', 'WARD', '183', 'Công Sơn', 'Cong Son'),
('06235', 'WARD', '183', 'Gia Cát', 'Gia Cat'),
('06238', 'WARD', '183', 'Mẫu Sơn', 'Mau Son'),
('06241', 'WARD', '183', 'Xuân Long', 'Xuan Long'),
('06244', 'WARD', '183', 'Tân Liên', 'Tan Lien'),
('06247', 'WARD', '183', 'Yên Trạch', 'Yen Trach'),
('06250', 'WARD', '183', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 184 - Văn Quan
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06253', 'WARD', '184', 'Thị trấn Văn Quan', 'Thi tran Van Quan'),
('06256', 'WARD', '184', 'Trấn Ninh', 'Tran Ninh'),
('06268', 'WARD', '184', 'Liên Hội', 'Lien Hoi'),
('06274', 'WARD', '184', 'Hòa Bình', 'Hoa Binh'),
('06277', 'WARD', '184', 'Tú Xuyên', 'Tu Xuyen'),
('06280', 'WARD', '184', 'Điềm He', 'Diem He'),
('06283', 'WARD', '184', 'An Sơn', 'An Son'),
('06286', 'WARD', '184', 'Khánh Khê', 'Khanh Khe'),
('06292', 'WARD', '184', 'Lương Năng', 'Luong Nang'),
('06298', 'WARD', '184', 'Bình Phúc', 'Binh Phuc'),
('06307', 'WARD', '184', 'Tân Đoàn', 'Tan Doan'),
('06313', 'WARD', '184', 'Tri Lễ', 'Tri Le'),
('06316', 'WARD', '184', 'Tràng Phái', 'Trang Phai'),
('06319', 'WARD', '184', 'Yên Phúc', 'Yen Phuc'),
('06322', 'WARD', '184', 'Hữu Lễ', 'Huu Le')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 185 - Bắc Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06325', 'WARD', '185', 'Thị trấn Bắc Sơn', 'Thi tran Bac Son'),
('06328', 'WARD', '185', 'Long Đống', 'Long Dong'),
('06331', 'WARD', '185', 'Vạn Thủy', 'Van Thuy'),
('06337', 'WARD', '185', 'Đồng ý', 'Dong y'),
('06340', 'WARD', '185', 'Tân Tri', 'Tan Tri'),
('06343', 'WARD', '185', 'Bắc Quỳnh', 'Bac Quynh'),
('06349', 'WARD', '185', 'Hưng Vũ', 'Hung Vu'),
('06352', 'WARD', '185', 'Tân Lập', 'Tan Lap'),
('06355', 'WARD', '185', 'Vũ Sơn', 'Vu Son'),
('06358', 'WARD', '185', 'Chiêu Vũ', 'Chieu Vu'),
('06361', 'WARD', '185', 'Tân Hương', 'Tan Huong'),
('06364', 'WARD', '185', 'Chiến Thắng', 'Chien Thang'),
('06367', 'WARD', '185', 'Vũ Lăng', 'Vu Lang'),
('06370', 'WARD', '185', 'Trấn Yên', 'Tran Yen'),
('06373', 'WARD', '185', 'Vũ Lễ', 'Vu Le'),
('06376', 'WARD', '185', 'Nhất Hòa', 'Nhat Hoa'),
('06379', 'WARD', '185', 'Tân Thành', 'Tan Thanh'),
('06382', 'WARD', '185', 'Nhất Tiến', 'Nhat Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 186 - Hữu Lũng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06385', 'WARD', '186', 'Thị trấn Hữu Lũng', 'Thi tran Huu Lung'),
('06388', 'WARD', '186', 'Hữu Liên', 'Huu Lien'),
('06391', 'WARD', '186', 'Yên Bình', 'Yen Binh'),
('06394', 'WARD', '186', 'Quyết Thắng', 'Quyet Thang'),
('06397', 'WARD', '186', 'Hòa Bình', 'Hoa Binh'),
('06400', 'WARD', '186', 'Yên Thịnh', 'Yen Thinh'),
('06403', 'WARD', '186', 'Yên Sơn', 'Yen Son'),
('06406', 'WARD', '186', 'Thiện Tân', 'Thien Tan'),
('06412', 'WARD', '186', 'Yên Vượng', 'Yen Vuong'),
('06415', 'WARD', '186', 'Minh Tiến', 'Minh Tien'),
('06418', 'WARD', '186', 'Nhật Tiến', 'Nhat Tien'),
('06421', 'WARD', '186', 'Thanh Sơn', 'Thanh Son'),
('06424', 'WARD', '186', 'Đồng Tân', 'Dong Tan'),
('06427', 'WARD', '186', 'Cai Kinh', 'Cai Kinh'),
('06430', 'WARD', '186', 'Hòa Lạc', 'Hoa Lac'),
('06433', 'WARD', '186', 'Vân Nham', 'Van Nham'),
('06436', 'WARD', '186', 'Đồng Tiến', 'Dong Tien'),
('06442', 'WARD', '186', 'Tân Thành', 'Tan Thanh'),
('06445', 'WARD', '186', 'Hòa Sơn', 'Hoa Son'),
('06448', 'WARD', '186', 'Minh Sơn', 'Minh Son'),
('06451', 'WARD', '186', 'Hồ Sơn', 'Ho Son'),
('06457', 'WARD', '186', 'Minh Hòa', 'Minh Hoa'),
('06460', 'WARD', '186', 'Hòa Thắng', 'Hoa Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 187 - Chi Lăng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06463', 'WARD', '187', 'Thị trấn Đồng Mỏ', 'Thi tran Dong Mo'),
('06466', 'WARD', '187', 'Thị trấn Chi Lăng', 'Thi tran Chi Lang'),
('06469', 'WARD', '187', 'Vân An', 'Van An'),
('06472', 'WARD', '187', 'Vân Thủy', 'Van Thuy'),
('06475', 'WARD', '187', 'Gia Lộc', 'Gia Loc'),
('06478', 'WARD', '187', 'Bắc Thủy', 'Bac Thuy'),
('06481', 'WARD', '187', 'Chiến Thắng', 'Chien Thang'),
('06484', 'WARD', '187', 'Mai Sao', 'Mai Sao'),
('06487', 'WARD', '187', 'Bằng Hữu', 'Bang Huu'),
('06490', 'WARD', '187', 'Thượng Cường', 'Thuong Cuong'),
('06493', 'WARD', '187', 'Bằng Mạc', 'Bang Mac'),
('06496', 'WARD', '187', 'Nhân Lý', 'Nhan Ly'),
('06499', 'WARD', '187', 'Lâm Sơn', 'Lam Son'),
('06502', 'WARD', '187', 'Liên Sơn', 'Lien Son'),
('06505', 'WARD', '187', 'Vạn Linh', 'Van Linh'),
('06508', 'WARD', '187', 'Hòa Bình', 'Hoa Binh'),
('06514', 'WARD', '187', 'Hữu Kiên', 'Huu Kien'),
('06517', 'WARD', '187', 'Sơn', 'Son'),
('06520', 'WARD', '187', 'Y Tịch', 'Y Tich'),
('06523', 'WARD', '187', 'Chi Lăng', 'Chi Lang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 188 - Lộc Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06526', 'WARD', '188', 'Thị trấn Na Dương', 'Thi tran Na Duong'),
('06529', 'WARD', '188', 'Thị trấn Lộc Bình', 'Thi tran Loc Binh'),
('06532', 'WARD', '188', 'Mẫu Sơn', 'Mau Son'),
('06541', 'WARD', '188', 'Yên Khoái', 'Yen Khoai'),
('06544', 'WARD', '188', 'Khánh Xuân', 'Khanh Xuan'),
('06547', 'WARD', '188', 'Tú Mịch', 'Tu Mich'),
('06550', 'WARD', '188', 'Hữu Khánh', 'Huu Khanh'),
('06553', 'WARD', '188', 'Đồng Bục', 'Dong Buc'),
('06559', 'WARD', '188', 'Tam Gia', 'Tam Gia'),
('06562', 'WARD', '188', 'Tú Đoạn', 'Tu Doan'),
('06565', 'WARD', '188', 'Khuất Xá', 'Khuat Xa'),
('06577', 'WARD', '188', 'Thống Nhất', 'Thong Nhat'),
('06589', 'WARD', '188', 'Sàn Viên', 'San Vien'),
('06592', 'WARD', '188', 'Đông Quan', 'Dong Quan'),
('06595', 'WARD', '188', 'Minh Hiệp', 'Minh Hiep'),
('06598', 'WARD', '188', 'Hữu Lân', 'Huu Lan'),
('06601', 'WARD', '188', 'Lợi Bác', 'Loi Bac'),
('06604', 'WARD', '188', 'Nam Quan', 'Nam Quan'),
('06607', 'WARD', '188', 'Xuân Dương', 'Xuan Duong'),
('06610', 'WARD', '188', 'Ái Quốc', 'Ai Quoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 189 - Đình Lập
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06613', 'WARD', '189', 'Thị trấn Đình Lập', 'Thi tran Dinh Lap'),
('06616', 'WARD', '189', 'Thị trấn NT Thái Bình', 'Thi tran NT Thai Binh'),
('06619', 'WARD', '189', 'Bắc Xa', 'Bac Xa'),
('06622', 'WARD', '189', 'Bính Xá', 'Binh Xa'),
('06625', 'WARD', '189', 'Kiên Mộc', 'Kien Moc'),
('06628', 'WARD', '189', 'Đình Lập', 'Dinh Lap'),
('06631', 'WARD', '189', 'Thái Bình', 'Thai Binh'),
('06634', 'WARD', '189', 'Cường Lợi', 'Cuong Loi'),
('06637', 'WARD', '189', 'Châu Sơn', 'Chau Son'),
('06640', 'WARD', '189', 'Lâm Ca', 'Lam Ca'),
('06643', 'WARD', '189', 'Đồng Thắng', 'Dong Thang'),
('06646', 'WARD', '189', 'Bắc Lãng', 'Bac Lang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 22 - Quảng Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('193', 'DISTRICT', '22', 'Hạ Long', 'Thanh pho Ha Long'),
('194', 'DISTRICT', '22', 'Móng Cái', 'Thanh pho Mong Cai'),
('195', 'DISTRICT', '22', 'Cẩm Phả', 'Thanh pho Cam Pha'),
('196', 'DISTRICT', '22', 'Uông Bí', 'Thanh pho Uong Bi'),
('198', 'DISTRICT', '22', 'Bình Liêu', 'Binh Lieu'),
('199', 'DISTRICT', '22', 'Tiên Yên', 'Tien Yen'),
('200', 'DISTRICT', '22', 'Đầm Hà', 'Dam Ha'),
('201', 'DISTRICT', '22', 'Hải Hà', 'Hai Ha'),
('202', 'DISTRICT', '22', 'Ba Chẽ', 'Ba Che'),
('203', 'DISTRICT', '22', 'Vân Đồn', 'Van Don'),
('205', 'DISTRICT', '22', 'Đông Triều', 'Thanh pho Dong Trieu'),
('206', 'DISTRICT', '22', 'Thị Quảng Yên', 'Thi Quang Yen'),
('207', 'DISTRICT', '22', 'Cô Tô', 'Co To')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 193 - Hạ Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06649', 'WARD', '193', 'Hà Khánh', 'Ha Khanh'),
('06652', 'WARD', '193', 'Hà Phong', 'Ha Phong'),
('06655', 'WARD', '193', 'Hà Khẩu', 'Ha Khau'),
('06658', 'WARD', '193', 'Cao Xanh', 'Cao Xanh'),
('06661', 'WARD', '193', 'Giếng Đáy', 'Gieng Day'),
('06664', 'WARD', '193', 'Hà Tu', 'Ha Tu'),
('06667', 'WARD', '193', 'Hà Trung', 'Ha Trung'),
('06670', 'WARD', '193', 'Hà Lầm', 'Ha Lam'),
('06673', 'WARD', '193', 'Bãi Cháy', 'Bai Chay'),
('06676', 'WARD', '193', 'Cao Thắng', 'Cao Thang'),
('06679', 'WARD', '193', 'Hùng Thắng', 'Hung Thang'),
('06685', 'WARD', '193', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('06688', 'WARD', '193', 'Hồng Hải', 'Hong Hai'),
('06691', 'WARD', '193', 'Hồng Gai', 'Hong Gai'),
('06694', 'WARD', '193', 'Bạch Đằng', 'Bach Dang'),
('06697', 'WARD', '193', 'Hồng Hà', 'Hong Ha'),
('06700', 'WARD', '193', 'Tuần Châu', 'Tuan Chau'),
('06703', 'WARD', '193', 'Việt Hưng', 'Viet Hung'),
('06706', 'WARD', '193', 'Đại Yên', 'Dai Yen'),
('07030', 'WARD', '193', 'Hoành Bồ', 'Hoanh Bo'),
('07033', 'WARD', '193', 'Kỳ Thượng', 'Ky Thuong'),
('07036', 'WARD', '193', 'Đồng Sơn', 'Dong Son'),
('07039', 'WARD', '193', 'Tân Dân', 'Tan Dan'),
('07042', 'WARD', '193', 'Đồng Lâm', 'Dong Lam'),
('07045', 'WARD', '193', 'Hòa Bình', 'Hoa Binh'),
('07048', 'WARD', '193', 'Vũ Oai', 'Vu Oai'),
('07051', 'WARD', '193', 'Dân Chủ', 'Dan Chu'),
('07054', 'WARD', '193', 'Quảng La', 'Quang La'),
('07057', 'WARD', '193', 'Bằng Cả', 'Bang Ca'),
('07060', 'WARD', '193', 'Thống Nhất', 'Thong Nhat'),
('07063', 'WARD', '193', 'Sơn Dương', 'Son Duong'),
('07066', 'WARD', '193', 'Lê Lợi', 'Le Loi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 194 - Móng Cái
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06709', 'WARD', '194', 'Ka Long', 'Ka Long'),
('06712', 'WARD', '194', 'Trần Phú', 'Tran Phu'),
('06715', 'WARD', '194', 'Ninh Dương', 'Ninh Duong'),
('06721', 'WARD', '194', 'Trà Cổ', 'Tra Co'),
('06724', 'WARD', '194', 'Hải Sơn', 'Hai Son'),
('06727', 'WARD', '194', 'Bắc Sơn', 'Bac Son'),
('06730', 'WARD', '194', 'Hải Đông', 'Hai Dong'),
('06733', 'WARD', '194', 'Hải Tiến', 'Hai Tien'),
('06736', 'WARD', '194', 'Hải Yên', 'Hai Yen'),
('06739', 'WARD', '194', 'Quảng Nghĩa', 'Quang Nghia'),
('06742', 'WARD', '194', 'Hải Hoà', 'Hai Hoa'),
('06745', 'WARD', '194', 'Hải Xuân', 'Hai Xuan'),
('06748', 'WARD', '194', 'Vạn Ninh', 'Van Ninh'),
('06751', 'WARD', '194', 'Bình Ngọc', 'Binh Ngoc'),
('06754', 'WARD', '194', 'Vĩnh Trung', 'Vinh Trung'),
('06757', 'WARD', '194', 'Vĩnh Thực', 'Vinh Thuc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 195 - Cẩm Phả
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06760', 'WARD', '195', 'Mông Dương', 'Mong Duong'),
('06763', 'WARD', '195', 'Cửa Ông', 'Cua Ong'),
('06766', 'WARD', '195', 'Cẩm Sơn', 'Cam Son'),
('06769', 'WARD', '195', 'Cẩm Đông', 'Cam Dong'),
('06772', 'WARD', '195', 'Cẩm Phú', 'Cam Phu'),
('06775', 'WARD', '195', 'Cẩm Tây', 'Cam Tay'),
('06778', 'WARD', '195', 'Quang Hanh', 'Quang Hanh'),
('06781', 'WARD', '195', 'Cẩm Thịnh', 'Cam Thinh'),
('06784', 'WARD', '195', 'Cẩm Thủy', 'Cam Thuy'),
('06787', 'WARD', '195', 'Cẩm Thạch', 'Cam Thach'),
('06790', 'WARD', '195', 'Cẩm Thành', 'Cam Thanh'),
('06793', 'WARD', '195', 'Cẩm Trung', 'Cam Trung'),
('06796', 'WARD', '195', 'Cẩm Bình', 'Cam Binh'),
('06799', 'WARD', '195', 'Hải Hòa', 'Hai Hoa'),
('06805', 'WARD', '195', 'Dương Huy', 'Duong Huy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 196 - Uông Bí
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06808', 'WARD', '196', 'Vàng Danh', 'Vang Danh'),
('06811', 'WARD', '196', 'Thanh Sơn', 'Thanh Son'),
('06814', 'WARD', '196', 'Bắc Sơn', 'Bac Son'),
('06817', 'WARD', '196', 'Quang Trung', 'Quang Trung'),
('06820', 'WARD', '196', 'Trưng Vương', 'Trung Vuong'),
('06823', 'WARD', '196', 'Nam Khê', 'Nam Khe'),
('06826', 'WARD', '196', 'Yên Thanh', 'Yen Thanh'),
('06829', 'WARD', '196', 'Thượng Yên Công', 'Thuong Yen Cong'),
('06832', 'WARD', '196', 'Phương Đông', 'Dong'),
('06835', 'WARD', '196', 'Phương Nam', 'Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 198 - Bình Liêu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06838', 'WARD', '198', 'Thị trấn Bình Liêu', 'Thi tran Binh Lieu'),
('06841', 'WARD', '198', 'Hoành Mô', 'Hoanh Mo'),
('06844', 'WARD', '198', 'Đồng Tâm', 'Dong Tam'),
('06847', 'WARD', '198', 'Đồng Văn', 'Dong Van'),
('06853', 'WARD', '198', 'Vô Ngại', 'Vo Ngai'),
('06856', 'WARD', '198', 'Lục Hồn', 'Luc Hon'),
('06859', 'WARD', '198', 'Húc Động', 'Huc Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 199 - Tiên Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06862', 'WARD', '199', 'Thị trấn Tiên Yên', 'Thi tran Tien Yen'),
('06865', 'WARD', '199', 'Hà Lâu', 'Ha Lau'),
('06868', 'WARD', '199', 'Đại Dực', 'Dai Duc'),
('06871', 'WARD', '199', 'Phong Dụ', 'Phong Du'),
('06874', 'WARD', '199', 'Điền Xá', 'Dien Xa'),
('06877', 'WARD', '199', 'Đông Ngũ', 'Dong Ngu'),
('06880', 'WARD', '199', 'Yên Than', 'Yen Than'),
('06883', 'WARD', '199', 'Đông Hải', 'Dong Hai'),
('06886', 'WARD', '199', 'Hải Lạng', 'Hai Lang'),
('06889', 'WARD', '199', 'Tiên Lãng', 'Tien Lang'),
('06892', 'WARD', '199', 'Đồng Rui', 'Dong Rui')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 200 - Đầm Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06895', 'WARD', '200', 'Thị trấn Đầm Hà', 'Thi tran Dam Ha'),
('06898', 'WARD', '200', 'Quảng Lâm', 'Quang Lam'),
('06901', 'WARD', '200', 'Quảng An', 'Quang An'),
('06904', 'WARD', '200', 'Tân Bình', 'Tan Binh'),
('06910', 'WARD', '200', 'Dực Yên', 'Duc Yen'),
('06913', 'WARD', '200', 'Quảng Tân', 'Quang Tan'),
('06916', 'WARD', '200', 'Đầm Hà', 'Dam Ha'),
('06917', 'WARD', '200', 'Tân Lập', 'Tan Lap'),
('06919', 'WARD', '200', 'Đại Bình', 'Dai Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 201 - Hải Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06922', 'WARD', '201', 'Thị trấn Quảng Hà', 'Thi tran Quang Ha'),
('06925', 'WARD', '201', 'Quảng Đức', 'Quang Duc'),
('06928', 'WARD', '201', 'Quảng Sơn', 'Quang Son'),
('06931', 'WARD', '201', 'Quảng Thành', 'Quang Thanh'),
('06937', 'WARD', '201', 'Quảng Thịnh', 'Quang Thinh'),
('06940', 'WARD', '201', 'Quảng Minh', 'Quang Minh'),
('06943', 'WARD', '201', 'Quảng Chính', 'Quang Chinh'),
('06946', 'WARD', '201', 'Quảng Long', 'Quang Long'),
('06949', 'WARD', '201', 'Đường Hoa', 'Duong Hoa'),
('06952', 'WARD', '201', 'Quảng Phong', 'Quang Phong'),
('06967', 'WARD', '201', 'Cái Chiên', 'Cai Chien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 202 - Ba Chẽ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06970', 'WARD', '202', 'Thị trấn Ba Chẽ', 'Thi tran Ba Che'),
('06973', 'WARD', '202', 'Thanh Sơn', 'Thanh Son'),
('06976', 'WARD', '202', 'Thanh Lâm', 'Thanh Lam'),
('06979', 'WARD', '202', 'Đạp Thanh', 'Dap Thanh'),
('06982', 'WARD', '202', 'Nam Sơn', 'Nam Son'),
('06985', 'WARD', '202', 'Lương Minh', 'Luong Minh'),
('06988', 'WARD', '202', 'Đồn Đạc', 'Don Dac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 203 - Vân Đồn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('06994', 'WARD', '203', 'Thị trấn Cái Rồng', 'Thi tran Cai Rong'),
('06997', 'WARD', '203', 'Đài Xuyên', 'Dai Xuyen'),
('07000', 'WARD', '203', 'Bình Dân', 'Binh Dan'),
('07003', 'WARD', '203', 'Vạn Yên', 'Van Yen'),
('07006', 'WARD', '203', 'Minh Châu', 'Minh Chau'),
('07009', 'WARD', '203', 'Đoàn Kết', 'Doan Ket'),
('07012', 'WARD', '203', 'Hạ Long', 'Ha Long'),
('07015', 'WARD', '203', 'Đông Xá', 'Dong Xa'),
('07018', 'WARD', '203', 'Bản Sen', 'Ban Sen'),
('07021', 'WARD', '203', 'Thắng Lợi', 'Thang Loi'),
('07024', 'WARD', '203', 'Lạn', 'Lan'),
('07027', 'WARD', '203', 'Ngọc Vừng', 'Ngoc Vung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 205 - Đông Triều
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07069', 'WARD', '205', 'Mạo Khê', 'Mao Khe'),
('07075', 'WARD', '205', 'An Sinh', 'An Sinh'),
('07078', 'WARD', '205', 'Tràng Lương', 'Trang Luong'),
('07081', 'WARD', '205', 'Bình Khê', 'Binh Khe'),
('07084', 'WARD', '205', 'Việt Dân', 'Viet Dan'),
('07090', 'WARD', '205', 'Bình Dương', 'Binh Duong'),
('07093', 'WARD', '205', 'Đức Chính', 'Duc Chinh'),
('07096', 'WARD', '205', 'Tràng An', 'Trang An'),
('07099', 'WARD', '205', 'Nguyễn Huệ', 'Nguyen Hue'),
('07102', 'WARD', '205', 'Thủy An', 'Thuy An'),
('07105', 'WARD', '205', 'Xuân Sơn', 'Xuan Son'),
('07108', 'WARD', '205', 'Hồng Thái Tây', 'Hong Thai Tay'),
('07111', 'WARD', '205', 'Hồng Thái Đông', 'Hong Thai Dong'),
('07114', 'WARD', '205', 'Hoàng Quế', 'Hoang Que'),
('07117', 'WARD', '205', 'Yên Thọ', 'Yen Tho'),
('07120', 'WARD', '205', 'Hồng Phong', 'Hong Phong'),
('07123', 'WARD', '205', 'Kim Sơn', 'Kim Son'),
('07126', 'WARD', '205', 'Hưng Đạo', 'Hung Dao'),
('07129', 'WARD', '205', 'Yên Đức', 'Yen Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 206 - Thị Quảng Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07132', 'WARD', '206', 'Quảng Yên', 'Quang Yen'),
('07135', 'WARD', '206', 'Đông Mai', 'Dong Mai'),
('07138', 'WARD', '206', 'Minh Thành', 'Minh Thanh'),
('07144', 'WARD', '206', 'Sông Khoai', 'Song Khoai'),
('07147', 'WARD', '206', 'Hiệp Hòa', 'Hiep Hoa'),
('07150', 'WARD', '206', 'Cộng Hòa', 'Cong Hoa'),
('07153', 'WARD', '206', 'Tiền An', 'Tien An'),
('07156', 'WARD', '206', 'Hoàng Tân', 'Hoang Tan'),
('07159', 'WARD', '206', 'Tân An', 'Tan An'),
('07162', 'WARD', '206', 'Yên Giang', 'Yen Giang'),
('07165', 'WARD', '206', 'Nam Hoà', 'Nam Hoa'),
('07168', 'WARD', '206', 'Hà An', 'Ha An'),
('07171', 'WARD', '206', 'Cẩm La', 'Cam La'),
('07174', 'WARD', '206', 'Phong Hải', 'Phong Hai'),
('07177', 'WARD', '206', 'Yên Hải', 'Yen Hai'),
('07180', 'WARD', '206', 'Liên Hòa', 'Lien Hoa'),
('07183', 'WARD', '206', 'Phong Cốc', 'Phong Coc'),
('07186', 'WARD', '206', 'Liên Vị', 'Lien Vi'),
('07189', 'WARD', '206', 'Tiền Phong', 'Tien Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 207 - Cô Tô
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07192', 'WARD', '207', 'Thị trấn Cô Tô', 'Thi tran Co To'),
('07195', 'WARD', '207', 'Đồng Tiến', 'Dong Tien'),
('07198', 'WARD', '207', 'Thanh Lân', 'Thanh Lan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 24 - Bắc Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('213', 'DISTRICT', '24', 'Bắc Giang', 'Thanh pho Bac Giang'),
('215', 'DISTRICT', '24', 'Yên Thế', 'Yen The'),
('216', 'DISTRICT', '24', 'Tân Yên', 'Tan Yen'),
('217', 'DISTRICT', '24', 'Lạng Giang', 'Lang Giang'),
('218', 'DISTRICT', '24', 'Lục Nam', 'Luc Nam'),
('219', 'DISTRICT', '24', 'Lục Ngạn', 'Luc Ngan'),
('220', 'DISTRICT', '24', 'Sơn Động', 'Son Dong'),
('222', 'DISTRICT', '24', 'Thị Việt Yên', 'Thi Viet Yen'),
('223', 'DISTRICT', '24', 'Hiệp Hòa', 'Hiep Hoa'),
('224', 'DISTRICT', '24', 'Thị Chũ', 'Thi Chu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 213 - Bắc Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07201', 'WARD', '213', 'Thọ Xương', 'Tho Xuong'),
('07207', 'WARD', '213', 'Ngô Quyền', 'Ngo Quyen'),
('07210', 'WARD', '213', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('07213', 'WARD', '213', 'Trần Phú', 'Tran Phu'),
('07216', 'WARD', '213', 'Mỹ Độ', 'My Do'),
('07222', 'WARD', '213', 'Song Mai', 'Song Mai'),
('07225', 'WARD', '213', 'Xương Giang', 'Xuong Giang'),
('07228', 'WARD', '213', 'Đa Mai', 'Da Mai'),
('07231', 'WARD', '213', 'Dĩnh Kế', 'Dinh Ke'),
('07441', 'WARD', '213', 'Dĩnh Trì', 'Dinh Tri'),
('07681', 'WARD', '213', 'Nham Biền', 'Nham Bien'),
('07682', 'WARD', '213', 'Tân An', 'Tan An'),
('07687', 'WARD', '213', 'Tân Mỹ', 'Tan My'),
('07690', 'WARD', '213', 'Hương Gián', 'Huong Gian'),
('07693', 'WARD', '213', 'Tân An', 'Tan An'),
('07696', 'WARD', '213', 'Đồng Sơn', 'Dong Son'),
('07699', 'WARD', '213', 'Tân Tiến', 'Tan Tien'),
('07702', 'WARD', '213', 'Quỳnh Sơn', 'Quynh Son'),
('07705', 'WARD', '213', 'Song Khê', 'Song Khe'),
('07708', 'WARD', '213', 'Nội Hoàng', 'Noi Hoang'),
('07711', 'WARD', '213', 'Tiền Phong', 'Tien Phong'),
('07714', 'WARD', '213', 'Xuân Phú', 'Xuan Phu'),
('07717', 'WARD', '213', 'Tân Liễu', 'Tan Lieu'),
('07720', 'WARD', '213', 'Trí Yên', 'Tri Yen'),
('07723', 'WARD', '213', 'Lãng Sơn', 'Lang Son'),
('07726', 'WARD', '213', 'Yên Lư', 'Yen Lu'),
('07729', 'WARD', '213', 'Tiến Dũng', 'Tien Dung'),
('07732', 'WARD', '213', 'Nham Sơn', 'Nham Son'),
('07735', 'WARD', '213', 'Đức Giang', 'Duc Giang'),
('07738', 'WARD', '213', 'Cảnh Thụy', 'Canh Thuy'),
('07741', 'WARD', '213', 'Tư Mại', 'Tu Mai'),
('07744', 'WARD', '213', 'Thắng Cương', 'Thang Cuong'),
('07747', 'WARD', '213', 'Đồng Việt', 'Dong Viet'),
('07750', 'WARD', '213', 'Đồng Phúc', 'Dong Phuc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 215 - Yên Thế
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07243', 'WARD', '215', 'Đồng Tiến', 'Dong Tien'),
('07246', 'WARD', '215', 'Canh Nậu', 'Canh Nau'),
('07249', 'WARD', '215', 'Xuân Lương', 'Xuan Luong'),
('07252', 'WARD', '215', 'Tam Tiến', 'Tam Tien'),
('07255', 'WARD', '215', 'Đồng Vương', 'Dong Vuong'),
('07258', 'WARD', '215', 'Đồng Hưu', 'Dong Huu'),
('07260', 'WARD', '215', 'Đồng Tâm', 'Dong Tam'),
('07261', 'WARD', '215', 'Tân Hiệp', 'Tan Hiep'),
('07264', 'WARD', '215', 'Tiến Thắng', 'Tien Thang'),
('07270', 'WARD', '215', 'Đồng Lạc', 'Dong Lac'),
('07273', 'WARD', '215', 'Đông Sơn', 'Dong Son'),
('07279', 'WARD', '215', 'Hương Vĩ', 'Huong Vi'),
('07282', 'WARD', '215', 'Đồng Kỳ', 'Dong Ky'),
('07285', 'WARD', '215', 'An Thượng', 'An Thuong'),
('07288', 'WARD', '215', 'Thị trấn Phồn Xương', 'Thi tran Phon Xuong'),
('07291', 'WARD', '215', 'Tân Sỏi', 'Tan Soi'),
('07294', 'WARD', '215', 'Thị trấn Bố Hạ', 'Thi tran Bo Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 216 - Tân Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07306', 'WARD', '216', 'Thị trấn Nhã Nam', 'Thi tran Nha Nam'),
('07309', 'WARD', '216', 'Tân Trung', 'Tan Trung'),
('07315', 'WARD', '216', 'Quang Trung', 'Quang Trung'),
('07321', 'WARD', '216', 'An Dương', 'An Duong'),
('07324', 'WARD', '216', 'Phúc Hòa', 'Phuc Hoa'),
('07327', 'WARD', '216', 'Liên Sơn', 'Lien Son'),
('07330', 'WARD', '216', 'Hợp Đức', 'Hop Duc'),
('07333', 'WARD', '216', 'Lam Sơn', 'Lam Son'),
('07336', 'WARD', '216', 'Cao Xá', 'Cao Xa'),
('07339', 'WARD', '216', 'Thị trấn Cao Thượng', 'Thi tran Cao Thuong'),
('07342', 'WARD', '216', 'Việt Ngọc', 'Viet Ngoc'),
('07345', 'WARD', '216', 'Song Vân', 'Song Van'),
('07348', 'WARD', '216', 'Ngọc Châu', 'Ngoc Chau'),
('07351', 'WARD', '216', 'Ngọc Vân', 'Ngoc Van'),
('07354', 'WARD', '216', 'Việt Lập', 'Viet Lap'),
('07357', 'WARD', '216', 'Liên Chung', 'Lien Chung'),
('07360', 'WARD', '216', 'Ngọc Thiện', 'Ngoc Thien'),
('07363', 'WARD', '216', 'Ngọc Lý', 'Ngoc Ly'),
('07366', 'WARD', '216', 'Quế Nham', 'Que Nham')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 217 - Lạng Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07375', 'WARD', '217', 'Thị trấn Vôi', 'Thi tran Voi'),
('07378', 'WARD', '217', 'Nghĩa Hòa', 'Nghia Hoa'),
('07381', 'WARD', '217', 'Nghĩa Hưng', 'Nghia Hung'),
('07384', 'WARD', '217', 'Quang Thịnh', 'Quang Thinh'),
('07387', 'WARD', '217', 'Hương Sơn', 'Huong Son'),
('07390', 'WARD', '217', 'Đào Mỹ', 'Dao My'),
('07393', 'WARD', '217', 'Tiên Lục', 'Tien Luc'),
('07396', 'WARD', '217', 'An Hà', 'An Ha'),
('07399', 'WARD', '217', 'Thị trấn Kép', 'Thi tran Kep'),
('07405', 'WARD', '217', 'Hương Lạc', 'Huong Lac'),
('07408', 'WARD', '217', 'Dương Đức', 'Duong Duc'),
('07411', 'WARD', '217', 'Tân Thanh', 'Tan Thanh'),
('07417', 'WARD', '217', 'Tân Hưng', 'Tan Hung'),
('07420', 'WARD', '217', 'Mỹ Thái', 'My Thai'),
('07426', 'WARD', '217', 'Xương Lâm', 'Xuong Lam'),
('07429', 'WARD', '217', 'Xuân Hương', 'Xuan Huong'),
('07432', 'WARD', '217', 'Tân Dĩnh', 'Tan Dinh'),
('07435', 'WARD', '217', 'Đại Lâm', 'Dai Lam'),
('07438', 'WARD', '217', 'Thái Đào', 'Thai Dao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 218 - Lục Nam
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07444', 'WARD', '218', 'Thị trấn Đồi Ngô', 'Thi tran Doi Ngo'),
('07450', 'WARD', '218', 'Đông Hưng', 'Dong Hung'),
('07453', 'WARD', '218', 'Đông Phú', 'Dong Phu'),
('07456', 'WARD', '218', 'Tam Dị', 'Tam Di'),
('07459', 'WARD', '218', 'Bảo Sơn', 'Bao Son'),
('07462', 'WARD', '218', 'Bảo Đài', 'Bao Dai'),
('07465', 'WARD', '218', 'Thanh Lâm', 'Thanh Lam'),
('07468', 'WARD', '218', 'Tiên Nha', 'Tien Nha'),
('07471', 'WARD', '218', 'Trường Giang', 'Truong Giang'),
('07477', 'WARD', '218', 'Thị trấn Phương Sơn', 'Thi tran Son'),
('07480', 'WARD', '218', 'Chu Điện', 'Chu Dien'),
('07483', 'WARD', '218', 'Cương Sơn', 'Cuong Son'),
('07486', 'WARD', '218', 'Nghĩa Phương', 'Nghia Phuong'),
('07489', 'WARD', '218', 'Vô Tranh', 'Vo Tranh'),
('07492', 'WARD', '218', 'Bình Sơn', 'Binh Son'),
('07495', 'WARD', '218', 'Lan Mẫu', 'Lan Mau'),
('07498', 'WARD', '218', 'Yên Sơn', 'Yen Son'),
('07501', 'WARD', '218', 'Khám Lạng', 'Kham Lang'),
('07504', 'WARD', '218', 'Huyền Sơn', 'Son'),
('07507', 'WARD', '218', 'Trường Sơn', 'Truong Son'),
('07510', 'WARD', '218', 'Lục Sơn', 'Luc Son'),
('07513', 'WARD', '218', 'Bắc Lũng', 'Bac Lung'),
('07519', 'WARD', '218', 'Cẩm Lý', 'Cam Ly'),
('07522', 'WARD', '218', 'Đan Hội', 'Dan Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 219 - Lục Ngạn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07528', 'WARD', '219', 'Cấm Sơn', 'Cam Son'),
('07531', 'WARD', '219', 'Tân Sơn', 'Tan Son'),
('07534', 'WARD', '219', 'Phong Minh', 'Phong Minh'),
('07537', 'WARD', '219', 'Phong Vân', 'Phong Van'),
('07540', 'WARD', '219', 'Lý', 'Ly'),
('07543', 'WARD', '219', 'Hộ Đáp', 'Ho Dap'),
('07546', 'WARD', '219', 'Sơn Hải', 'Son Hai'),
('07555', 'WARD', '219', 'Biên Sơn', 'Bien Son'),
('07564', 'WARD', '219', 'Kim Sơn', 'Kim Son'),
('07567', 'WARD', '219', 'Tân Hoa', 'Tan Hoa'),
('07570', 'WARD', '219', 'Giáp Sơn', 'Giap Son'),
('07573', 'WARD', '219', 'Thị trấn Biển Động', 'Thi tran Bien Dong'),
('07582', 'WARD', '219', 'Thị trấn Phì Điền', 'Thi tran Phi Dien'),
('07588', 'WARD', '219', 'Tân Quang', 'Tan Quang'),
('07591', 'WARD', '219', 'Đồng Cốc', 'Dong Coc'),
('07594', 'WARD', '219', 'Tân Lập', 'Tan Lap'),
('07597', 'WARD', '219', 'Phú Nhuận', 'Phu Nhuan'),
('07606', 'WARD', '219', 'Tân Mộc', 'Tan Moc'),
('07609', 'WARD', '219', 'Đèo Gia', 'Deo Gia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 220 - Sơn Động
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07615', 'WARD', '220', 'Thị trấn An Châu', 'Thi tran An Chau'),
('07616', 'WARD', '220', 'Thị trấn Tây Yên Tử', 'Thi tran Tay Yen Tu'),
('07621', 'WARD', '220', 'Vân Sơn', 'Van Son'),
('07624', 'WARD', '220', 'Hữu Sản', 'Huu San'),
('07627', 'WARD', '220', 'Đại Sơn', 'Dai Son'),
('07630', 'WARD', '220', 'Phúc Sơn', 'Phuc Son'),
('07636', 'WARD', '220', 'Giáo Liêm', 'Giao Liem'),
('07642', 'WARD', '220', 'Cẩm Đàn', 'Cam Dan'),
('07645', 'WARD', '220', 'An Lạc', 'An Lac'),
('07648', 'WARD', '220', 'Vĩnh An', 'Vinh An'),
('07651', 'WARD', '220', 'Yên Định', 'Yen Dinh'),
('07654', 'WARD', '220', 'Lệ Viễn', 'Le Vien'),
('07660', 'WARD', '220', 'An Bá', 'An Ba'),
('07663', 'WARD', '220', 'Tuấn Đạo', 'Tuan Dao'),
('07666', 'WARD', '220', 'Dương Hưu', 'Duong Huu'),
('07672', 'WARD', '220', 'Long Sơn', 'Long Son'),
('07678', 'WARD', '220', 'Thanh Luận', 'Thanh Luan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 222 - Thị Việt Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07759', 'WARD', '222', 'Thượng Lan', 'Thuong Lan'),
('07762', 'WARD', '222', 'Việt Tiến', 'Viet Tien'),
('07765', 'WARD', '222', 'Nghĩa Trung', 'Nghia Trung'),
('07768', 'WARD', '222', 'Minh Đức', 'Minh Duc'),
('07771', 'WARD', '222', 'Hương Mai', 'Huong Mai'),
('07774', 'WARD', '222', 'Tự Lạn', 'Tu Lan'),
('07777', 'WARD', '222', 'Bích Động', 'Bich Dong'),
('07780', 'WARD', '222', 'Trung Sơn', 'Trung Son'),
('07783', 'WARD', '222', 'Hồng Thái', 'Hong Thai'),
('07786', 'WARD', '222', 'Tiên Sơn', 'Tien Son'),
('07789', 'WARD', '222', 'Tăng Tiến', 'Tang Tien'),
('07792', 'WARD', '222', 'Quảng Minh', 'Quang Minh'),
('07795', 'WARD', '222', 'Nếnh', 'Nenh'),
('07798', 'WARD', '222', 'Ninh Sơn', 'Ninh Son'),
('07801', 'WARD', '222', 'Vân Trung', 'Van Trung'),
('07804', 'WARD', '222', 'Vân Hà', 'Van Ha'),
('07807', 'WARD', '222', 'Quang Châu', 'Quang Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 223 - Hiệp Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07816', 'WARD', '223', 'Đồng Tiến', 'Dong Tien'),
('07822', 'WARD', '223', 'Hoàng Vân', 'Hoang Van'),
('07825', 'WARD', '223', 'Toàn Thắng', 'Toan Thang'),
('07831', 'WARD', '223', 'Ngọc Sơn', 'Ngoc Son'),
('07840', 'WARD', '223', 'Thị trấn Thắng', 'Thi tran Thang'),
('07843', 'WARD', '223', 'Sơn Thịnh', 'Son Thinh'),
('07846', 'WARD', '223', 'Lương Phong', 'Luong Phong'),
('07849', 'WARD', '223', 'Hùng Thái', 'Hung Thai'),
('07855', 'WARD', '223', 'Thường Thắng', 'Thuong Thang'),
('07858', 'WARD', '223', 'Hợp Thịnh', 'Hop Thinh'),
('07861', 'WARD', '223', 'Danh Thắng', 'Danh Thang'),
('07864', 'WARD', '223', 'Mai Trung', 'Mai Trung'),
('07867', 'WARD', '223', 'Đoan Bái', 'Doan Bai'),
('07870', 'WARD', '223', 'Thị trấn Bắc Lý', 'Thi tran Bac Ly'),
('07873', 'WARD', '223', 'Xuân Cẩm', 'Xuan Cam'),
('07876', 'WARD', '223', 'Hương Lâm', 'Huong Lam'),
('07879', 'WARD', '223', 'Đông Lỗ', 'Dong Lo'),
('07882', 'WARD', '223', 'Châu Minh', 'Chau Minh'),
('07885', 'WARD', '223', 'Mai Đình', 'Mai Dinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 224 - Thị Chũ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07525', 'WARD', '224', 'Chũ', 'Chu'),
('07549', 'WARD', '224', 'Thanh Hải', 'Thanh Hai'),
('07552', 'WARD', '224', 'Kiên Lao', 'Kien Lao'),
('07558', 'WARD', '224', 'Kiên Thành', 'Kien Thanh'),
('07561', 'WARD', '224', 'Hồng Giang', 'Hong Giang'),
('07576', 'WARD', '224', 'Quý Sơn', 'Quy Son'),
('07579', 'WARD', '224', 'Trù Hựu', 'Tru Huu'),
('07600', 'WARD', '224', 'Mỹ An', 'My An'),
('07603', 'WARD', '224', 'Nam Dương', 'Nam Duong'),
('07612', 'WARD', '224', 'Phượng Sơn', 'Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 25 - Phú Thọ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('227', 'DISTRICT', '25', 'Việt Trì', 'Thanh pho Viet Tri'),
('228', 'DISTRICT', '25', 'Thị Phú Thọ', 'Thi Phu Tho'),
('230', 'DISTRICT', '25', 'Đoan Hùng', 'Doan Hung'),
('231', 'DISTRICT', '25', 'Hạ Hoà', 'Ha Hoa'),
('232', 'DISTRICT', '25', 'Thanh Ba', 'Thanh Ba'),
('233', 'DISTRICT', '25', 'Phù Ninh', 'Phu Ninh'),
('234', 'DISTRICT', '25', 'Yên Lập', 'Yen Lap'),
('235', 'DISTRICT', '25', 'Cẩm Khê', 'Cam Khe'),
('236', 'DISTRICT', '25', 'Tam Nông', 'Tam Nong'),
('237', 'DISTRICT', '25', 'Lâm Thao', 'Lam Thao'),
('238', 'DISTRICT', '25', 'Thanh Sơn', 'Thanh Son'),
('239', 'DISTRICT', '25', 'Thanh Thuỷ', 'Thanh Thuy'),
('240', 'DISTRICT', '25', 'Tân Sơn', 'Tan Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 227 - Việt Trì
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07888', 'WARD', '227', 'Dữu Lâu', 'Duu Lau'),
('07894', 'WARD', '227', 'Nông Trang', 'Nong Trang'),
('07897', 'WARD', '227', 'Tân Dân', 'Tan Dan'),
('07900', 'WARD', '227', 'Gia Cẩm', 'Gia Cam'),
('07903', 'WARD', '227', 'Tiên Cát', 'Tien Cat'),
('07906', 'WARD', '227', 'Thọ Sơn', 'Tho Son'),
('07909', 'WARD', '227', 'Thanh Miếu', 'Thanh Mieu'),
('07912', 'WARD', '227', 'Bạch Hạc', 'Bach Hac'),
('07918', 'WARD', '227', 'Vân Phú', 'Van Phu'),
('07921', 'WARD', '227', 'Phượng Lâu', 'Lau'),
('07924', 'WARD', '227', 'Thụy Vân', 'Thuy Van'),
('07927', 'WARD', '227', 'Minh Phương', 'Minh Phuong'),
('07930', 'WARD', '227', 'Trưng Vương', 'Trung Vuong'),
('07933', 'WARD', '227', 'Minh Nông', 'Minh Nong'),
('07936', 'WARD', '227', 'Sông Lô', 'Song Lo'),
('08281', 'WARD', '227', 'Kim Đức', 'Kim Duc'),
('08287', 'WARD', '227', 'Hùng Lô', 'Hung Lo'),
('08503', 'WARD', '227', 'Hy Cương', 'Hy Cuong'),
('08506', 'WARD', '227', 'Chu Hóa', 'Chu Hoa'),
('08515', 'WARD', '227', 'Thanh Đình', 'Thanh Dinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 228 - Thị Phú Thọ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07942', 'WARD', '228', 'Hùng Vương', 'Hung Vuong'),
('07945', 'WARD', '228', 'Phong Châu', 'Phong Chau'),
('07948', 'WARD', '228', 'Âu Cơ', 'Au Co'),
('07951', 'WARD', '228', 'Hà Lộc', 'Ha Loc'),
('07954', 'WARD', '228', 'Phú Hộ', 'Phu Ho'),
('07957', 'WARD', '228', 'Văn Lung', 'Van Lung'),
('07960', 'WARD', '228', 'Thanh Minh', 'Thanh Minh'),
('07963', 'WARD', '228', 'Hà Thạch', 'Ha Thach'),
('07966', 'WARD', '228', 'Thanh Vinh', 'Thanh Vinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 230 - Đoan Hùng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('07969', 'WARD', '230', 'Thị trấn Đoan Hùng', 'Thi tran Doan Hung'),
('07975', 'WARD', '230', 'Hùng Xuyên', 'Hung Xuyen'),
('07981', 'WARD', '230', 'Bằng Luân', 'Bang Luan'),
('07987', 'WARD', '230', 'Phú Lâm', 'Phu Lam'),
('07996', 'WARD', '230', 'Bằng Doãn', 'Bang Doan'),
('07999', 'WARD', '230', 'Chí Đám', 'Chi Dam'),
('08005', 'WARD', '230', 'Phúc Lai', 'Phuc Lai'),
('08008', 'WARD', '230', 'Ngọc Quan', 'Ngoc Quan'),
('08014', 'WARD', '230', 'Hợp Nhất', 'Hop Nhat'),
('08023', 'WARD', '230', 'Tây Cốc', 'Tay Coc'),
('08035', 'WARD', '230', 'Hùng Long', 'Hung Long'),
('08038', 'WARD', '230', 'Yên Kiện', 'Yen Kien'),
('08044', 'WARD', '230', 'Chân Mộng', 'Chan Mong'),
('08050', 'WARD', '230', 'Ca Đình', 'Ca Dinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 231 - Hạ Hoà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08053', 'WARD', '231', 'Thị trấn Hạ Hoà', 'Thi tran Ha Hoa'),
('08056', 'WARD', '231', 'Đại Phạm', 'Dai Pham'),
('08062', 'WARD', '231', 'Đan Thượng', 'Dan Thuong'),
('08065', 'WARD', '231', 'Hà Lương', 'Ha Luong'),
('08071', 'WARD', '231', 'Tứ Hiệp', 'Tu Hiep'),
('08080', 'WARD', '231', 'Hiền Lương', 'Hien Luong'),
('08089', 'WARD', '231', 'Phương Viên', 'Vien'),
('08092', 'WARD', '231', 'Gia Điền', 'Gia Dien'),
('08095', 'WARD', '231', 'Ấm Hạ', 'Am Ha'),
('08104', 'WARD', '231', 'Hương Xạ', 'Huong Xa'),
('08110', 'WARD', '231', 'Xuân Áng', 'Xuan Ang'),
('08113', 'WARD', '231', 'Yên Kỳ', 'Yen Ky'),
('08119', 'WARD', '231', 'Minh Hạc', 'Minh Hac'),
('08122', 'WARD', '231', 'Lang Sơn', 'Lang Son'),
('08125', 'WARD', '231', 'Bằng Giã', 'Bang Gia'),
('08128', 'WARD', '231', 'Yên Luật', 'Yen Luat'),
('08131', 'WARD', '231', 'Vô Tranh', 'Vo Tranh'),
('08134', 'WARD', '231', 'Văn Lang', 'Van Lang'),
('08140', 'WARD', '231', 'Minh Côi', 'Minh Coi'),
('08143', 'WARD', '231', 'Vĩnh Chân', 'Vinh Chan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 232 - Thanh Ba
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08152', 'WARD', '232', 'Thị trấn Thanh Ba', 'Thi tran Thanh Ba'),
('08156', 'WARD', '232', 'Vân Lĩnh', 'Van Linh'),
('08158', 'WARD', '232', 'Đông Lĩnh', 'Dong Linh'),
('08161', 'WARD', '232', 'Đại An', 'Dai An'),
('08164', 'WARD', '232', 'Hanh Cù', 'Hanh Cu'),
('08170', 'WARD', '232', 'Đồng Xuân', 'Dong Xuan'),
('08173', 'WARD', '232', 'Quảng Yên', 'Quang Yen'),
('08179', 'WARD', '232', 'Ninh Dân', 'Ninh Dan'),
('08194', 'WARD', '232', 'Võ Lao', 'Vo Lao'),
('08197', 'WARD', '232', 'Khải Xuân', 'Khai Xuan'),
('08200', 'WARD', '232', 'Mạn Lạn', 'Man Lan'),
('08203', 'WARD', '232', 'Hoàng Cương', 'Hoang Cuong'),
('08206', 'WARD', '232', 'Chí Tiên', 'Chi Tien'),
('08209', 'WARD', '232', 'Đông Thành', 'Dong Thanh'),
('08215', 'WARD', '232', 'Sơn Cương', 'Son Cuong'),
('08218', 'WARD', '232', 'Thanh Hà', 'Thanh Ha'),
('08221', 'WARD', '232', 'Đỗ Sơn', 'Do Son'),
('08224', 'WARD', '232', 'Đỗ Xuyên', 'Do Xuyen'),
('08227', 'WARD', '232', 'Lương Lỗ', 'Luong Lo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 233 - Phù Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08230', 'WARD', '233', 'Thị trấn Phong Châu', 'Thi tran Phong Chau'),
('08233', 'WARD', '233', 'Phú Mỹ', 'Phu My'),
('08234', 'WARD', '233', 'Lệ Mỹ', 'Le My'),
('08236', 'WARD', '233', 'Liên Hoa', 'Lien Hoa'),
('08239', 'WARD', '233', 'Trạm Thản', 'Tram Than'),
('08242', 'WARD', '233', 'Trị Quận', 'Tri Quan'),
('08245', 'WARD', '233', 'Trung Giáp', 'Trung Giap'),
('08248', 'WARD', '233', 'Tiên Phú', 'Tien Phu'),
('08251', 'WARD', '233', 'Hạ Giáp', 'Ha Giap'),
('08254', 'WARD', '233', 'Bảo Thanh', 'Bao Thanh'),
('08257', 'WARD', '233', 'Phú Lộc', 'Phu Loc'),
('08260', 'WARD', '233', 'Gia Thanh', 'Gia Thanh'),
('08263', 'WARD', '233', 'Tiên Du', 'Tien Du'),
('08266', 'WARD', '233', 'Phú Nham', 'Phu Nham'),
('08272', 'WARD', '233', 'An Đạo', 'An Dao'),
('08275', 'WARD', '233', 'Bình Phú', 'Binh Phu'),
('08278', 'WARD', '233', 'Phù Ninh', 'Phu Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 234 - Yên Lập
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08290', 'WARD', '234', 'Thị trấn Yên Lập', 'Thi tran Yen Lap'),
('08293', 'WARD', '234', 'Mỹ Lung', 'My Lung'),
('08296', 'WARD', '234', 'Mỹ Lương', 'My Luong'),
('08299', 'WARD', '234', 'Lương Sơn', 'Luong Son'),
('08302', 'WARD', '234', 'Xuân An', 'Xuan An'),
('08305', 'WARD', '234', 'Xuân Viên', 'Xuan Vien'),
('08308', 'WARD', '234', 'Xuân Thủy', 'Xuan Thuy'),
('08311', 'WARD', '234', 'Trung Sơn', 'Trung Son'),
('08314', 'WARD', '234', 'Hưng Long', 'Hung Long'),
('08317', 'WARD', '234', 'Nga Hoàng', 'Nga Hoang'),
('08320', 'WARD', '234', 'Đồng Lạc', 'Dong Lac'),
('08323', 'WARD', '234', 'Thượng Long', 'Thuong Long'),
('08326', 'WARD', '234', 'Đồng Thịnh', 'Dong Thinh'),
('08329', 'WARD', '234', 'Phúc Khánh', 'Phuc Khanh'),
('08332', 'WARD', '234', 'Minh Hòa', 'Minh Hoa'),
('08335', 'WARD', '234', 'Ngọc Lập', 'Ngoc Lap'),
('08338', 'WARD', '234', 'Ngọc Đồng', 'Ngoc Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 235 - Cẩm Khê
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08341', 'WARD', '235', 'Thị trấn Cẩm Khê', 'Thi tran Cam Khe'),
('08344', 'WARD', '235', 'Tiên Lương', 'Tien Luong'),
('08350', 'WARD', '235', 'Minh Thắng', 'Minh Thang'),
('08353', 'WARD', '235', 'Minh Tân', 'Minh Tan'),
('08356', 'WARD', '235', 'Phượng Vĩ', 'Vi'),
('08374', 'WARD', '235', 'Tùng Khê', 'Tung Khe'),
('08377', 'WARD', '235', 'Tam Sơn', 'Tam Son'),
('08380', 'WARD', '235', 'Văn Bán', 'Van Ban'),
('08389', 'WARD', '235', 'Phong Thịnh', 'Phong Thinh'),
('08398', 'WARD', '235', 'Phú Khê', 'Phu Khe'),
('08401', 'WARD', '235', 'Hương Lung', 'Huong Lung'),
('08413', 'WARD', '235', 'Nhật Tiến', 'Nhat Tien'),
('08416', 'WARD', '235', 'Hùng Việt', 'Hung Viet'),
('08422', 'WARD', '235', 'Yên Dưỡng', 'Yen Duong'),
('08428', 'WARD', '235', 'Điêu Lương', 'Dieu Luong'),
('08431', 'WARD', '235', 'Đồng Lương', 'Dong Luong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 236 - Tam Nông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08434', 'WARD', '236', 'Thị trấn Hưng Hoá', 'Thi tran Hung Hoa'),
('08440', 'WARD', '236', 'Hiền Quan', 'Hien Quan'),
('08443', 'WARD', '236', 'Bắc Sơn', 'Bac Son'),
('08446', 'WARD', '236', 'Thanh Uyên', 'Thanh Uyen'),
('08461', 'WARD', '236', 'Lam Sơn', 'Lam Son'),
('08467', 'WARD', '236', 'Vạn Xuân', 'Van Xuan'),
('08470', 'WARD', '236', 'Quang Húc', 'Quang Huc'),
('08473', 'WARD', '236', 'Hương Nộn', 'Huong Non'),
('08476', 'WARD', '236', 'Tề Lễ', 'Te Le'),
('08479', 'WARD', '236', 'Thọ Văn', 'Tho Van'),
('08482', 'WARD', '236', 'Dị Nậu', 'Di Nau'),
('08491', 'WARD', '236', 'Dân Quyền', 'Dan Quyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 237 - Lâm Thao
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08494', 'WARD', '237', 'Thị trấn Lâm Thao', 'Thi tran Lam Thao'),
('08497', 'WARD', '237', 'Tiên Kiên', 'Tien Kien'),
('08498', 'WARD', '237', 'Thị trấn Hùng Sơn', 'Thi tran Hung Son'),
('08500', 'WARD', '237', 'Xuân Lũng', 'Xuan Lung'),
('08509', 'WARD', '237', 'Xuân Huy', 'Xuan Huy'),
('08512', 'WARD', '237', 'Thạch Sơn', 'Thach Son'),
('08518', 'WARD', '237', 'Sơn Vi', 'Son Vi'),
('08521', 'WARD', '237', 'Phùng Nguyên', 'Phung Nguyen'),
('08527', 'WARD', '237', 'Cao Xá', 'Cao Xa'),
('08533', 'WARD', '237', 'Vĩnh Lại', 'Vinh Lai'),
('08536', 'WARD', '237', 'Tứ Xã', 'Tu Xa'),
('08539', 'WARD', '237', 'Bản Nguyên', 'Ban Nguyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 238 - Thanh Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08542', 'WARD', '238', 'Thị trấn Thanh Sơn', 'Thi tran Thanh Son'),
('08563', 'WARD', '238', 'Sơn Hùng', 'Son Hung'),
('08572', 'WARD', '238', 'Địch Quả', 'Dich Qua'),
('08575', 'WARD', '238', 'Giáp Lai', 'Giap Lai'),
('08581', 'WARD', '238', 'Thục Luyện', 'Thuc Luyen'),
('08584', 'WARD', '238', 'Võ Miếu', 'Vo Mieu'),
('08587', 'WARD', '238', 'Thạch Khoán', 'Thach Khoan'),
('08602', 'WARD', '238', 'Cự Thắng', 'Cu Thang'),
('08605', 'WARD', '238', 'Tất Thắng', 'Tat Thang'),
('08611', 'WARD', '238', 'Văn Miếu', 'Van Mieu'),
('08614', 'WARD', '238', 'Cự Đồng', 'Cu Dong'),
('08623', 'WARD', '238', 'Thắng Sơn', 'Thang Son'),
('08629', 'WARD', '238', 'Tân Minh', 'Tan Minh'),
('08632', 'WARD', '238', 'Hương Cần', 'Huong Can'),
('08635', 'WARD', '238', 'Khả Cửu', 'Kha Cuu'),
('08638', 'WARD', '238', 'Đông Cửu', 'Dong Cuu'),
('08641', 'WARD', '238', 'Tân Lập', 'Tan Lap'),
('08644', 'WARD', '238', 'Yên Lãng', 'Yen Lang'),
('08647', 'WARD', '238', 'Yên Lương', 'Yen Luong'),
('08650', 'WARD', '238', 'Thượng Cửu', 'Thuong Cuu'),
('08653', 'WARD', '238', 'Lương Nha', 'Luong Nha'),
('08656', 'WARD', '238', 'Yên Sơn', 'Yen Son'),
('08659', 'WARD', '238', 'Nhuệ', 'Nhue')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 239 - Thanh Thuỷ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08662', 'WARD', '239', 'Đào Xá', 'Dao Xa'),
('08665', 'WARD', '239', 'Thạch Đồng', 'Thach Dong'),
('08668', 'WARD', '239', 'Xuân Lộc', 'Xuan Loc'),
('08671', 'WARD', '239', 'Tân Phương', 'Tan Phuong'),
('08674', 'WARD', '239', 'Thị trấn Thanh Thủy', 'Thi tran Thanh Thuy'),
('08677', 'WARD', '239', 'Sơn Thủy', 'Son Thuy'),
('08680', 'WARD', '239', 'Bảo Yên', 'Bao Yen'),
('08683', 'WARD', '239', 'Đoan Hạ', 'Doan Ha'),
('08686', 'WARD', '239', 'Đồng Trung', 'Dong Trung'),
('08689', 'WARD', '239', 'Hoàng Xá', 'Hoang Xa'),
('08701', 'WARD', '239', 'Tu Vũ', 'Tu Vu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 240 - Tân Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08545', 'WARD', '240', 'Thu Cúc', 'Thu Cuc'),
('08548', 'WARD', '240', 'Thạch Kiệt', 'Thach Kiet'),
('08551', 'WARD', '240', 'Thu Ngạc', 'Thu Ngac'),
('08554', 'WARD', '240', 'Kiệt Sơn', 'Kiet Son'),
('08557', 'WARD', '240', 'Đồng Sơn', 'Dong Son'),
('08560', 'WARD', '240', 'Lai Đồng', 'Lai Dong'),
('08566', 'WARD', '240', 'Thị trấn Tân Phú', 'Thi tran Tan Phu'),
('08569', 'WARD', '240', 'Mỹ Thuận', 'My Thuan'),
('08578', 'WARD', '240', 'Tân Sơn', 'Tan Son'),
('08590', 'WARD', '240', 'Xuân Đài', 'Xuan Dai'),
('08593', 'WARD', '240', 'Minh Đài', 'Minh Dai'),
('08596', 'WARD', '240', 'Văn Luông', 'Van Luong'),
('08599', 'WARD', '240', 'Xuân Sơn', 'Xuan Son'),
('08608', 'WARD', '240', 'Long Cốc', 'Long Coc'),
('08617', 'WARD', '240', 'Kim Thượng', 'Kim Thuong'),
('08620', 'WARD', '240', 'Tam Thanh', 'Tam Thanh'),
('08626', 'WARD', '240', 'Vinh Tiền', 'Vinh Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 26 - Vĩnh Phúc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('243', 'DISTRICT', '26', 'Vĩnh Yên', 'Thanh pho Vinh Yen'),
('244', 'DISTRICT', '26', 'Phúc Yên', 'Thanh pho Phuc Yen'),
('246', 'DISTRICT', '26', 'Lập Thạch', 'Lap Thach'),
('247', 'DISTRICT', '26', 'Tam Dương', 'Tam Duong'),
('248', 'DISTRICT', '26', 'Tam Đảo', 'Tam Dao'),
('249', 'DISTRICT', '26', 'Bình Xuyên', 'Binh Xuyen'),
('251', 'DISTRICT', '26', 'Yên Lạc', 'Yen Lac'),
('252', 'DISTRICT', '26', 'Vĩnh Tường', 'Vinh Tuong'),
('253', 'DISTRICT', '26', 'Sông Lô', 'Song Lo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 243 - Vĩnh Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08707', 'WARD', '243', 'Tích Sơn', 'Tich Son'),
('08710', 'WARD', '243', 'Liên Bảo', 'Lien Bao'),
('08713', 'WARD', '243', 'Hội Hợp', 'Hoi Hop'),
('08716', 'WARD', '243', 'Đống Đa', 'Dong Da'),
('08719', 'WARD', '243', 'Ngô Quyền', 'Ngo Quyen'),
('08722', 'WARD', '243', 'Đồng Tâm', 'Dong Tam'),
('08725', 'WARD', '243', 'Định Trung', 'Dinh Trung'),
('08728', 'WARD', '243', 'Khai Quang', 'Khai Quang'),
('08731', 'WARD', '243', 'Thanh Trù', 'Thanh Tru')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 244 - Phúc Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08737', 'WARD', '244', 'Hùng Vương', 'Hung Vuong'),
('08740', 'WARD', '244', 'Hai Bà Trưng', 'Hai Ba Trung'),
('08743', 'WARD', '244', 'Phúc Thắng', 'Phuc Thang'),
('08746', 'WARD', '244', 'Xuân Hoà', 'Xuan Hoa'),
('08747', 'WARD', '244', 'Đồng Xuân', 'Dong Xuan'),
('08749', 'WARD', '244', 'Ngọc Thanh', 'Ngoc Thanh'),
('08752', 'WARD', '244', 'Cao Minh', 'Cao Minh'),
('08755', 'WARD', '244', 'Nam Viêm', 'Nam Viem'),
('08758', 'WARD', '244', 'Tiền Châu', 'Tien Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 246 - Lập Thạch
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08761', 'WARD', '246', 'Thị trấn Lập Thạch', 'Thi tran Lap Thach'),
('08764', 'WARD', '246', 'Quang Sơn', 'Quang Son'),
('08767', 'WARD', '246', 'Ngọc Mỹ', 'Ngoc My'),
('08770', 'WARD', '246', 'Hợp Lý', 'Hop Ly'),
('08785', 'WARD', '246', 'Bắc Bình', 'Bac Binh'),
('08788', 'WARD', '246', 'Thái Hòa', 'Thai Hoa'),
('08789', 'WARD', '246', 'Thị trấn Hoa Sơn', 'Thi tran Hoa Son'),
('08791', 'WARD', '246', 'Liễn Sơn', 'Lien Son'),
('08794', 'WARD', '246', 'Xuân Hòa', 'Xuan Hoa'),
('08797', 'WARD', '246', 'Vân Trục', 'Van Truc'),
('08812', 'WARD', '246', 'Liên Hòa', 'Lien Hoa'),
('08815', 'WARD', '246', 'Tử Du', 'Tu Du'),
('08833', 'WARD', '246', 'Bàn Giản', 'Ban Gian'),
('08836', 'WARD', '246', 'Xuân Lôi', 'Xuan Loi'),
('08839', 'WARD', '246', 'Đồng Ích', 'Dong Ich'),
('08842', 'WARD', '246', 'Tiên Lữ', 'Tien Lu'),
('08845', 'WARD', '246', 'Văn Quán', 'Van Quan'),
('08863', 'WARD', '246', 'Tây Sơn', 'Tay Son'),
('08866', 'WARD', '246', 'Sơn Đông', 'Son Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 247 - Tam Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08869', 'WARD', '247', 'Thị trấn Hợp Hòa', 'Thi tran Hop Hoa'),
('08872', 'WARD', '247', 'Hoàng Hoa', 'Hoang Hoa'),
('08875', 'WARD', '247', 'Đồng Tĩnh', 'Dong Tinh'),
('08878', 'WARD', '247', 'Thị trấn Kim Long', 'Thi tran Kim Long'),
('08881', 'WARD', '247', 'Hướng Đạo', 'Huong Dao'),
('08884', 'WARD', '247', 'Đạo Tú', 'Dao Tu'),
('08887', 'WARD', '247', 'An Hòa', 'An Hoa'),
('08890', 'WARD', '247', 'Thanh Vân', 'Thanh Van'),
('08893', 'WARD', '247', 'Duy Phiên', 'Duy Phien'),
('08896', 'WARD', '247', 'Hoàng Đan', 'Hoang Dan'),
('08899', 'WARD', '247', 'Hoàng Lâu', 'Hoang Lau'),
('08905', 'WARD', '247', 'Hội Thịnh', 'Hoi Thinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 248 - Tam Đảo
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08908', 'WARD', '248', 'Thị trấn Tam Đảo', 'Thi tran Tam Dao'),
('08911', 'WARD', '248', 'Thị trấn Hợp Châu', 'Thi tran Hop Chau'),
('08914', 'WARD', '248', 'Đạo Trù', 'Dao Tru'),
('08917', 'WARD', '248', 'Yên Dương', 'Yen Duong'),
('08920', 'WARD', '248', 'Bồ Lý', 'Bo Ly'),
('08923', 'WARD', '248', 'Thị trấn Đại Đình', 'Thi tran Dai Dinh'),
('08926', 'WARD', '248', 'Tam Quan', 'Tam Quan'),
('08929', 'WARD', '248', 'Hồ Sơn', 'Ho Son'),
('08932', 'WARD', '248', 'Minh Quang', 'Minh Quang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 249 - Bình Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08935', 'WARD', '249', 'Thị trấn Hương Canh', 'Thi tran Huong Canh'),
('08936', 'WARD', '249', 'Thị trấn Gia Khánh', 'Thi tran Gia Khanh'),
('08938', 'WARD', '249', 'Trung Mỹ', 'Trung My'),
('08944', 'WARD', '249', 'Thị trấn Bá Hiến', 'Thi tran Ba Hien'),
('08947', 'WARD', '249', 'Thiện Kế', 'Thien Ke'),
('08950', 'WARD', '249', 'Hương Sơn', 'Huong Son'),
('08953', 'WARD', '249', 'Tam Hợp', 'Tam Hop'),
('08956', 'WARD', '249', 'Quất Lưu', 'Quat Luu'),
('08959', 'WARD', '249', 'Sơn Lôi', 'Son Loi'),
('08962', 'WARD', '249', 'Thị trấn Đạo Đức', 'Thi tran Dao Duc'),
('08965', 'WARD', '249', 'Tân Phong', 'Tan Phong'),
('08968', 'WARD', '249', 'Thị trấn Thanh Lãng', 'Thi tran Thanh Lang'),
('08971', 'WARD', '249', 'Phú Xuân', 'Phu Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 251 - Yên Lạc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09025', 'WARD', '251', 'Thị trấn Yên Lạc', 'Thi tran Yen Lac'),
('09028', 'WARD', '251', 'Đồng Cương', 'Dong Cuong'),
('09031', 'WARD', '251', 'Đồng Văn', 'Dong Van'),
('09034', 'WARD', '251', 'Bình Định', 'Binh Dinh'),
('09037', 'WARD', '251', 'Trung Nguyên', 'Trung Nguyen'),
('09040', 'WARD', '251', 'Tề Lỗ', 'Te Lo'),
('09043', 'WARD', '251', 'Thị trấn Tam Hồng', 'Thi tran Tam Hong'),
('09046', 'WARD', '251', 'Yên Đồng', 'Yen Dong'),
('09049', 'WARD', '251', 'Văn Tiến', 'Van Tien'),
('09052', 'WARD', '251', 'Nguyệt Đức', 'Nguyet Duc'),
('09055', 'WARD', '251', 'Yên Phương', 'Yen Phuong'),
('09061', 'WARD', '251', 'Trung Kiên', 'Trung Kien'),
('09064', 'WARD', '251', 'Liên Châu', 'Lien Chau'),
('09067', 'WARD', '251', 'Đại Tự', 'Dai Tu'),
('09070', 'WARD', '251', 'Hồng Châu', 'Hong Chau'),
('09073', 'WARD', '251', 'Trung Hà', 'Trung Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 252 - Vĩnh Tường
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09076', 'WARD', '252', 'Thị trấn Vĩnh Tường', 'Thi tran Vinh Tuong'),
('09079', 'WARD', '252', 'Kim Xá', 'Kim Xa'),
('09082', 'WARD', '252', 'Yên Bình', 'Yen Binh'),
('09085', 'WARD', '252', 'Chấn Hưng', 'Chan Hung'),
('09088', 'WARD', '252', 'Nghĩa Hưng', 'Nghia Hung'),
('09091', 'WARD', '252', 'Yên Lập', 'Yen Lap'),
('09097', 'WARD', '252', 'Sao Đại Việt', 'Sao Dai Viet'),
('09100', 'WARD', '252', 'Đại Đồng', 'Dai Dong'),
('09106', 'WARD', '252', 'Lũng Hoà', 'Lung Hoa'),
('09112', 'WARD', '252', 'Thị trấn Thổ Tang', 'Thi tran Tho Tang'),
('09118', 'WARD', '252', 'Lương Điền', 'Luong Dien'),
('09124', 'WARD', '252', 'Tân Phú', 'Tan Phu'),
('09127', 'WARD', '252', 'Thượng Trưng', 'Thuong Trung'),
('09130', 'WARD', '252', 'Vũ Di', 'Vu Di'),
('09136', 'WARD', '252', 'Tuân Chính', 'Tuan Chinh'),
('09145', 'WARD', '252', 'Thị trấn Tứ Trưng', 'Thi tran Tu Trung'),
('09148', 'WARD', '252', 'Ngũ Kiên', 'Ngu Kien'),
('09151', 'WARD', '252', 'An Nhân', 'An Nhan'),
('09154', 'WARD', '252', 'Vĩnh Thịnh', 'Vinh Thinh'),
('09157', 'WARD', '252', 'Vĩnh Phú', 'Vinh Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 253 - Sông Lô
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('08773', 'WARD', '253', 'Lãng Công', 'Lang Cong'),
('08776', 'WARD', '253', 'Quang Yên', 'Quang Yen'),
('08782', 'WARD', '253', 'Hải Lựu', 'Hai Luu'),
('08800', 'WARD', '253', 'Đồng Quế', 'Dong Que'),
('08803', 'WARD', '253', 'Nhân Đạo', 'Nhan Dao'),
('08806', 'WARD', '253', 'Đôn Nhân', 'Don Nhan'),
('08809', 'WARD', '253', 'Phương Khoan', 'Khoan'),
('08818', 'WARD', '253', 'Tân Lập', 'Tan Lap'),
('08824', 'WARD', '253', 'Thị trấn Tam Sơn', 'Thi tran Tam Son'),
('08830', 'WARD', '253', 'Yên Thạch', 'Yen Thach'),
('08848', 'WARD', '253', 'Đồng Thịnh', 'Dong Thinh'),
('08851', 'WARD', '253', 'Tứ Yên', 'Tu Yen'),
('08854', 'WARD', '253', 'Đức Bác', 'Duc Bac'),
('08860', 'WARD', '253', 'Cao Phong', 'Cao Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 27 - Bắc Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('256', 'DISTRICT', '27', 'Bắc Ninh', 'Thanh pho Bac Ninh'),
('258', 'DISTRICT', '27', 'Yên Phong', 'Yen Phong'),
('259', 'DISTRICT', '27', 'Thị Quế Võ', 'Thi Que Vo'),
('260', 'DISTRICT', '27', 'Tiên Du', 'Tien Du'),
('261', 'DISTRICT', '27', 'Từ Sơn', 'Thanh pho Tu Son'),
('262', 'DISTRICT', '27', 'Thị Thuận Thành', 'Thi Thuan Thanh'),
('263', 'DISTRICT', '27', 'Gia Bình', 'Gia Binh'),
('264', 'DISTRICT', '27', 'Lương Tài', 'Luong Tai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 256 - Bắc Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09163', 'WARD', '256', 'Vũ Ninh', 'Vu Ninh'),
('09166', 'WARD', '256', 'Đáp Cầu', 'Dap Cau'),
('09169', 'WARD', '256', 'Thị Cầu', 'Thi Cau'),
('09172', 'WARD', '256', 'Kinh Bắc', 'Kinh Bac'),
('09181', 'WARD', '256', 'Đại Phúc', 'Dai Phuc'),
('09184', 'WARD', '256', 'Tiền Ninh Vệ', 'Tien Ninh Ve'),
('09187', 'WARD', '256', 'Suối Hoa', 'Suoi Hoa'),
('09190', 'WARD', '256', 'Võ Cường', 'Vo Cuong'),
('09214', 'WARD', '256', 'Hòa Long', 'Hoa Long'),
('09226', 'WARD', '256', 'Vạn An', 'Van An'),
('09235', 'WARD', '256', 'Khúc Xuyên', 'Khuc Xuyen'),
('09244', 'WARD', '256', 'Phong Khê', 'Phong Khe'),
('09256', 'WARD', '256', 'Kim Chân', 'Kim Chan'),
('09271', 'WARD', '256', 'Vân Dương', 'Van Duong'),
('09286', 'WARD', '256', 'Nam Sơn', 'Nam Son'),
('09325', 'WARD', '256', 'Khắc Niệm', 'Khac Niem'),
('09331', 'WARD', '256', 'Hạp Lĩnh', 'Hap Linh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 258 - Yên Phong
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09193', 'WARD', '258', 'Thị trấn Chờ', 'Thi tran Cho'),
('09196', 'WARD', '258', 'Dũng Liệt', 'Dung Liet'),
('09199', 'WARD', '258', 'Tam Đa', 'Tam Da'),
('09202', 'WARD', '258', 'Tam Giang', 'Tam Giang'),
('09205', 'WARD', '258', 'Yên Trung', 'Yen Trung'),
('09208', 'WARD', '258', 'Thụy Hòa', 'Thuy Hoa'),
('09211', 'WARD', '258', 'Hòa Tiến', 'Hoa Tien'),
('09217', 'WARD', '258', 'Đông Tiến', 'Dong Tien'),
('09220', 'WARD', '258', 'Yên Phụ', 'Yen Phu'),
('09223', 'WARD', '258', 'Trung Nghĩa', 'Trung Nghia'),
('09229', 'WARD', '258', 'Đông Phong', 'Dong Phong'),
('09232', 'WARD', '258', 'Long Châu', 'Long Chau'),
('09238', 'WARD', '258', 'Văn Môn', 'Van Mon'),
('09241', 'WARD', '258', 'Đông Thọ', 'Dong Tho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 259 - Thị Quế Võ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09247', 'WARD', '259', 'Phố Mới', 'Pho Moi'),
('09250', 'WARD', '259', 'Việt Thống', 'Viet Thong'),
('09253', 'WARD', '259', 'Đại Xuân', 'Dai Xuan'),
('09259', 'WARD', '259', 'Nhân Hòa', 'Nhan Hoa'),
('09262', 'WARD', '259', 'Bằng An', 'Bang An'),
('09265', 'WARD', '259', 'Phương Liễu', 'Lieu'),
('09268', 'WARD', '259', 'Quế Tân', 'Que Tan'),
('09274', 'WARD', '259', 'Phù Lương', 'Phu Luong'),
('09277', 'WARD', '259', 'Phù Lãng', 'Phu Lang'),
('09280', 'WARD', '259', 'Phượng Mao', 'Mao'),
('09283', 'WARD', '259', 'Việt Hùng', 'Viet Hung'),
('09289', 'WARD', '259', 'Ngọc Xá', 'Ngoc Xa'),
('09292', 'WARD', '259', 'Châu Phong', 'Chau Phong'),
('09295', 'WARD', '259', 'Bồng Lai', 'Bong Lai'),
('09298', 'WARD', '259', 'Cách Bi', 'Cach Bi'),
('09301', 'WARD', '259', 'Đào Viên', 'Dao Vien'),
('09304', 'WARD', '259', 'Yên Giả', 'Yen Gia'),
('09307', 'WARD', '259', 'Mộ Đạo', 'Mo Dao'),
('09310', 'WARD', '259', 'Đức Long', 'Duc Long'),
('09313', 'WARD', '259', 'Chi Lăng', 'Chi Lang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 260 - Tiên Du
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09319', 'WARD', '260', 'Thị trấn Lim', 'Thi tran Lim'),
('09322', 'WARD', '260', 'Phú Lâm', 'Phu Lam'),
('09328', 'WARD', '260', 'Nội Duệ', 'Noi Due'),
('09334', 'WARD', '260', 'Liên Bão', 'Lien Bao'),
('09337', 'WARD', '260', 'Hiên Vân', 'Hien Van'),
('09340', 'WARD', '260', 'Hoàn Sơn', 'Hoan Son'),
('09343', 'WARD', '260', 'Lạc Vệ', 'Lac Ve'),
('09346', 'WARD', '260', 'Việt Đoàn', 'Viet Doan'),
('09349', 'WARD', '260', 'Phật Tích', 'Phat Tich'),
('09352', 'WARD', '260', 'Tân Chi', 'Tan Chi'),
('09355', 'WARD', '260', 'Đại Đồng', 'Dai Dong'),
('09358', 'WARD', '260', 'Tri Phương', 'Tri Phuong'),
('09361', 'WARD', '260', 'Minh Đạo', 'Minh Dao'),
('09364', 'WARD', '260', 'Cảnh Hưng', 'Canh Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 261 - Từ Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09367', 'WARD', '261', 'Đông Ngàn', 'Dong Ngan'),
('09370', 'WARD', '261', 'Tam Sơn', 'Tam Son'),
('09373', 'WARD', '261', 'Hương Mạc', 'Huong Mac'),
('09376', 'WARD', '261', 'Tương Giang', 'Tuong Giang'),
('09379', 'WARD', '261', 'Phù Khê', 'Phu Khe'),
('09382', 'WARD', '261', 'Đồng Kỵ', 'Dong Ky'),
('09383', 'WARD', '261', 'Trang Hạ', 'Trang Ha'),
('09385', 'WARD', '261', 'Đồng Nguyên', 'Dong Nguyen'),
('09388', 'WARD', '261', 'Châu Khê', 'Chau Khe'),
('09391', 'WARD', '261', 'Tân Hồng', 'Tan Hong'),
('09394', 'WARD', '261', 'Đình Bảng', 'Dinh Bang'),
('09397', 'WARD', '261', 'Phù Chẩn', 'Phu Chan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 262 - Thị Thuận Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09400', 'WARD', '262', 'Hồ', 'Ho'),
('09403', 'WARD', '262', 'Hoài Thượng', 'Hoai Thuong'),
('09406', 'WARD', '262', 'Đại Đồng Thành', 'Dai Dong Thanh'),
('09409', 'WARD', '262', 'Mão Điền', 'Mao Dien'),
('09412', 'WARD', '262', 'Song Hồ', 'Song Ho'),
('09415', 'WARD', '262', 'Đình Tổ', 'Dinh To'),
('09418', 'WARD', '262', 'An Bình', 'An Binh'),
('09421', 'WARD', '262', 'Trí Quả', 'Tri Qua'),
('09424', 'WARD', '262', 'Gia Đông', 'Gia Dong'),
('09427', 'WARD', '262', 'Thanh Khương', 'Thanh Khuong'),
('09430', 'WARD', '262', 'Trạm Lộ', 'Tram Lo'),
('09433', 'WARD', '262', 'Xuân Lâm', 'Xuan Lam'),
('09436', 'WARD', '262', 'Hà Mãn', 'Ha Man'),
('09439', 'WARD', '262', 'Ngũ Thái', 'Ngu Thai'),
('09442', 'WARD', '262', 'Nguyệt Đức', 'Nguyet Duc'),
('09445', 'WARD', '262', 'Ninh Xá', 'Ninh Xa'),
('09448', 'WARD', '262', 'Nghĩa Đạo', 'Nghia Dao'),
('09451', 'WARD', '262', 'Song Liễu', 'Song Lieu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 263 - Gia Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09454', 'WARD', '263', 'Thị trấn Gia Bình', 'Thi tran Gia Binh'),
('09457', 'WARD', '263', 'Vạn Ninh', 'Van Ninh'),
('09460', 'WARD', '263', 'Thái Bảo', 'Thai Bao'),
('09463', 'WARD', '263', 'Giang Sơn', 'Giang Son'),
('09466', 'WARD', '263', 'Cao Đức', 'Cao Duc'),
('09469', 'WARD', '263', 'Đại Lai', 'Dai Lai'),
('09472', 'WARD', '263', 'Song Giang', 'Song Giang'),
('09475', 'WARD', '263', 'Bình Dương', 'Binh Duong'),
('09478', 'WARD', '263', 'Lãng Ngâm', 'Lang Ngam'),
('09481', 'WARD', '263', 'Thị trấn Nhân Thắng', 'Thi tran Nhan Thang'),
('09484', 'WARD', '263', 'Xuân Lai', 'Xuan Lai'),
('09487', 'WARD', '263', 'Đông Cứu', 'Dong Cuu'),
('09490', 'WARD', '263', 'Đại Bái', 'Dai Bai'),
('09493', 'WARD', '263', 'Quỳnh Phú', 'Quynh Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 264 - Lương Tài
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('09496', 'WARD', '264', 'Thị trấn Thứa', 'Thi tran Thua'),
('09499', 'WARD', '264', 'An Thịnh', 'An Thinh'),
('09502', 'WARD', '264', 'Trung Kênh', 'Trung Kenh'),
('09505', 'WARD', '264', 'Phú Hòa', 'Phu Hoa'),
('09508', 'WARD', '264', 'An Tập', 'An Tap'),
('09511', 'WARD', '264', 'Tân Lãng', 'Tan Lang'),
('09514', 'WARD', '264', 'Quảng Phú', 'Quang Phu'),
('09517', 'WARD', '264', 'Quang Minh', 'Quang Minh'),
('09523', 'WARD', '264', 'Trung Chính', 'Trung Chinh'),
('09529', 'WARD', '264', 'Bình Định', 'Binh Dinh'),
('09532', 'WARD', '264', 'Phú Lương', 'Phu Luong'),
('09535', 'WARD', '264', 'Lâm Thao', 'Lam Thao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 30 - Hải Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('288', 'DISTRICT', '30', 'Hải Dương', 'Thanh pho Hai Duong'),
('290', 'DISTRICT', '30', 'Chí Linh', 'Thanh pho Chi Linh'),
('291', 'DISTRICT', '30', 'Nam Sách', 'Nam Sach'),
('292', 'DISTRICT', '30', 'Thị Kinh Môn', 'Thi Kinh Mon'),
('293', 'DISTRICT', '30', 'Kim Thành', 'Kim Thanh'),
('294', 'DISTRICT', '30', 'Thanh Hà', 'Thanh Ha'),
('295', 'DISTRICT', '30', 'Cẩm Giàng', 'Cam Giang'),
('296', 'DISTRICT', '30', 'Bình Giang', 'Binh Giang'),
('297', 'DISTRICT', '30', 'Gia Lộc', 'Gia Loc'),
('298', 'DISTRICT', '30', 'Tứ Kỳ', 'Tu Ky'),
('299', 'DISTRICT', '30', 'Ninh Giang', 'Ninh Giang'),
('300', 'DISTRICT', '30', 'Thanh Miện', 'Thanh Mien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 288 - Hải Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10507', 'WARD', '288', 'Cẩm Thượng', 'Cam Thuong'),
('10510', 'WARD', '288', 'Bình Hàn', 'Binh Han'),
('10513', 'WARD', '288', 'Ngọc Châu', 'Ngoc Chau'),
('10514', 'WARD', '288', 'Nhị Châu', 'Nhi Chau'),
('10516', 'WARD', '288', 'Quang Trung', 'Quang Trung'),
('10519', 'WARD', '288', 'Nguyễn Trãi', 'Nguyen Trai'),
('10525', 'WARD', '288', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('10528', 'WARD', '288', 'Trần Phú', 'Tran Phu'),
('10531', 'WARD', '288', 'Thanh Bình', 'Thanh Binh'),
('10532', 'WARD', '288', 'Tân Bình', 'Tan Binh'),
('10534', 'WARD', '288', 'Lê Thanh Nghị', 'Le Thanh Nghi'),
('10537', 'WARD', '288', 'Hải Tân', 'Hai Tan'),
('10540', 'WARD', '288', 'Tứ Minh', 'Tu Minh'),
('10543', 'WARD', '288', 'Việt Hoà', 'Viet Hoa'),
('10660', 'WARD', '288', 'Ái Quốc', 'Ai Quoc'),
('10663', 'WARD', '288', 'An Thượng', 'An Thuong'),
('10672', 'WARD', '288', 'Nam Đồng', 'Nam Dong'),
('10822', 'WARD', '288', 'Quyết Thắng', 'Quyet Thang'),
('10837', 'WARD', '288', 'Tiền Tiến', 'Tien Tien'),
('11002', 'WARD', '288', 'Thạch Khôi', 'Thach Khoi'),
('11005', 'WARD', '288', 'Liên Hồng', 'Lien Hong'),
('11011', 'WARD', '288', 'Tân Hưng', 'Tan Hung'),
('11017', 'WARD', '288', 'Gia Xuyên', 'Gia Xuyen'),
('11077', 'WARD', '288', 'Ngọc Sơn', 'Ngoc Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 290 - Chí Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10546', 'WARD', '290', 'Phả Lại', 'Pha Lai'),
('10549', 'WARD', '290', 'Sao Đỏ', 'Sao Do'),
('10552', 'WARD', '290', 'Bến Tắm', 'Ben Tam'),
('10555', 'WARD', '290', 'Hoàng Hoa Thám', 'Hoang Hoa Tham'),
('10558', 'WARD', '290', 'Bắc An', 'Bac An'),
('10561', 'WARD', '290', 'Hưng Đạo', 'Hung Dao'),
('10564', 'WARD', '290', 'Lê Lợi', 'Le Loi'),
('10567', 'WARD', '290', 'Hoàng Tiến', 'Hoang Tien'),
('10570', 'WARD', '290', 'Cộng Hoà', 'Cong Hoa'),
('10573', 'WARD', '290', 'Hoàng Tân', 'Hoang Tan'),
('10576', 'WARD', '290', 'Cổ Thành', 'Co Thanh'),
('10579', 'WARD', '290', 'Văn An', 'Van An'),
('10582', 'WARD', '290', 'Chí Minh', 'Chi Minh'),
('10585', 'WARD', '290', 'Văn Đức', 'Van Duc'),
('10588', 'WARD', '290', 'Thái Học', 'Thai Hoc'),
('10591', 'WARD', '290', 'Nhân Huệ', 'Nhan Hue'),
('10594', 'WARD', '290', 'An Lạc', 'An Lac'),
('10600', 'WARD', '290', 'Đồng Lạc', 'Dong Lac'),
('10603', 'WARD', '290', 'Tân Dân', 'Tan Dan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 291 - Nam Sách
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10606', 'WARD', '291', 'Thị trấn Nam Sách', 'Thi tran Nam Sach'),
('10609', 'WARD', '291', 'Nam Hưng', 'Nam Hung'),
('10612', 'WARD', '291', 'Nam Tân', 'Nam Tan'),
('10615', 'WARD', '291', 'Hợp Tiến', 'Hop Tien'),
('10618', 'WARD', '291', 'Hiệp Cát', 'Hiep Cat'),
('10621', 'WARD', '291', 'Quốc Tuấn', 'Quoc Tuan'),
('10630', 'WARD', '291', 'An Bình', 'An Binh'),
('10633', 'WARD', '291', 'Trần Phú', 'Tran Phu'),
('10636', 'WARD', '291', 'An Sơn', 'An Son'),
('10639', 'WARD', '291', 'Cộng Hòa', 'Cong Hoa'),
('10642', 'WARD', '291', 'Thái Tân', 'Thai Tan'),
('10645', 'WARD', '291', 'An Phú', 'An Phu'),
('10654', 'WARD', '291', 'Hồng Phong', 'Hong Phong'),
('10657', 'WARD', '291', 'Đồng Lạc', 'Dong Lac'),
('10666', 'WARD', '291', 'Minh Tân', 'Minh Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 292 - Thị Kinh Môn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10675', 'WARD', '292', 'An Lưu', 'An Luu'),
('10678', 'WARD', '292', 'Bạch Đằng', 'Bach Dang'),
('10681', 'WARD', '292', 'Thất Hùng', 'That Hung'),
('10684', 'WARD', '292', 'Lê Ninh', 'Le Ninh'),
('10693', 'WARD', '292', 'Phạm Thái', 'Pham Thai'),
('10696', 'WARD', '292', 'Duy Tân', 'Duy Tan'),
('10699', 'WARD', '292', 'Tân Dân', 'Tan Dan'),
('10702', 'WARD', '292', 'Minh Tân', 'Minh Tan'),
('10705', 'WARD', '292', 'Quang Thành', 'Quang Thanh'),
('10708', 'WARD', '292', 'Hiệp Hòa', 'Hiep Hoa'),
('10714', 'WARD', '292', 'Phú Thứ', 'Phu Thu'),
('10717', 'WARD', '292', 'Thăng Long', 'Thang Long'),
('10720', 'WARD', '292', 'Lạc Long', 'Lac Long'),
('10723', 'WARD', '292', 'An Sinh', 'An Sinh'),
('10726', 'WARD', '292', 'Hiệp Sơn', 'Hiep Son'),
('10729', 'WARD', '292', 'Thượng Quận', 'Thuong Quan'),
('10732', 'WARD', '292', 'An Phụ', 'An Phu'),
('10735', 'WARD', '292', 'Hiệp An', 'Hiep An'),
('10738', 'WARD', '292', 'Long Xuyên', 'Long Xuyen'),
('10741', 'WARD', '292', 'Thái Thịnh', 'Thai Thinh'),
('10744', 'WARD', '292', 'Hiến Thành', 'Hien Thanh'),
('10747', 'WARD', '292', 'Minh Hòa', 'Minh Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 293 - Kim Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10750', 'WARD', '293', 'Thị trấn Phú Thái', 'Thi tran Phu Thai'),
('10756', 'WARD', '293', 'Lai Khê', 'Lai Khe'),
('10762', 'WARD', '293', 'Vũ Dũng', 'Vu Dung'),
('10768', 'WARD', '293', 'Tuấn Việt', 'Tuan Viet'),
('10771', 'WARD', '293', 'Kim Xuyên', 'Kim Xuyen'),
('10777', 'WARD', '293', 'Ngũ Phúc', 'Ngu Phuc'),
('10780', 'WARD', '293', 'Kim Anh', 'Kim Anh'),
('10783', 'WARD', '293', 'Kim Liên', 'Kim Lien'),
('10786', 'WARD', '293', 'Kim Tân', 'Kim Tan'),
('10792', 'WARD', '293', 'Kim Đính', 'Kim Dinh'),
('10798', 'WARD', '293', 'Hòa Bình', 'Hoa Binh'),
('10801', 'WARD', '293', 'Tam Kỳ', 'Tam Ky'),
('10804', 'WARD', '293', 'Đồng Cẩm', 'Dong Cam'),
('10810', 'WARD', '293', 'Đại Đức', 'Dai Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 294 - Thanh Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10813', 'WARD', '294', 'Thị trấn Thanh Hà', 'Thi tran Thanh Ha'),
('10816', 'WARD', '294', 'Hồng Lạc', 'Hong Lac'),
('10825', 'WARD', '294', 'Tân Việt', 'Tan Viet'),
('10828', 'WARD', '294', 'Cẩm Việt', 'Cam Viet'),
('10831', 'WARD', '294', 'Thanh An', 'Thanh An'),
('10834', 'WARD', '294', 'Thanh Lang', 'Thanh Lang'),
('10840', 'WARD', '294', 'Tân An', 'Tan An'),
('10843', 'WARD', '294', 'Liên Mạc', 'Lien Mac'),
('10846', 'WARD', '294', 'Thanh Hải', 'Thanh Hai'),
('10855', 'WARD', '294', 'Thanh Xuân', 'Thanh Xuan'),
('10861', 'WARD', '294', 'Thanh Tân', 'Thanh Tan'),
('10864', 'WARD', '294', 'An Phượng', 'An Phuong'),
('10867', 'WARD', '294', 'Thanh Sơn', 'Thanh Son'),
('10876', 'WARD', '294', 'Thanh Quang', 'Thanh Quang'),
('10879', 'WARD', '294', 'Thanh Hồng', 'Thanh Hong'),
('10882', 'WARD', '294', 'Vĩnh Cường', 'Vinh Cuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 295 - Cẩm Giàng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10888', 'WARD', '295', 'Thị trấn Cẩm Giang', 'Thi tran Cam Giang'),
('10891', 'WARD', '295', 'Thị trấn Lai Cách', 'Thi tran Lai Cach'),
('10894', 'WARD', '295', 'Cẩm Hưng', 'Cam Hung'),
('10897', 'WARD', '295', 'Cẩm Hoàng', 'Cam Hoang'),
('10900', 'WARD', '295', 'Cẩm Văn', 'Cam Van'),
('10903', 'WARD', '295', 'Ngọc Liên', 'Ngoc Lien'),
('10909', 'WARD', '295', 'Cẩm Vũ', 'Cam Vu'),
('10912', 'WARD', '295', 'Đức Chính', 'Duc Chinh'),
('10918', 'WARD', '295', 'Định Sơn', 'Dinh Son'),
('10924', 'WARD', '295', 'Lương Điền', 'Luong Dien'),
('10927', 'WARD', '295', 'Cao An', 'Cao An'),
('10930', 'WARD', '295', 'Tân Trường', 'Tan Truong'),
('10933', 'WARD', '295', 'Phúc Điền', 'Phuc Dien'),
('10939', 'WARD', '295', 'Cẩm Đông', 'Cam Dong'),
('10942', 'WARD', '295', 'Cẩm Đoài', 'Cam Doai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 296 - Bình Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10945', 'WARD', '296', 'Thị trấn Kẻ Sặt', 'Thi tran Ke Sat'),
('10951', 'WARD', '296', 'Vĩnh Hưng', 'Vinh Hung'),
('10954', 'WARD', '296', 'Hùng Thắng', 'Hung Thang'),
('10960', 'WARD', '296', 'Vĩnh Hồng', 'Vinh Hong'),
('10963', 'WARD', '296', 'Long Xuyên', 'Long Xuyen'),
('10966', 'WARD', '296', 'Tân Việt', 'Tan Viet'),
('10969', 'WARD', '296', 'Thúc Kháng', 'Thuc Khang'),
('10972', 'WARD', '296', 'Tân Hồng', 'Tan Hong'),
('10978', 'WARD', '296', 'Hồng Khê', 'Hong Khe'),
('10981', 'WARD', '296', 'Thái Minh', 'Thai Minh'),
('10984', 'WARD', '296', 'Cổ Bì', 'Co Bi'),
('10987', 'WARD', '296', 'Nhân Quyền', 'Nhan Quyen'),
('10990', 'WARD', '296', 'Thái Dương', 'Thai Duong'),
('10993', 'WARD', '296', 'Thái Hòa', 'Thai Hoa'),
('10996', 'WARD', '296', 'Bình Xuyên', 'Binh Xuyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 297 - Gia Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('10999', 'WARD', '297', 'Thị trấn Gia Lộc', 'Thi tran Gia Loc'),
('11008', 'WARD', '297', 'Thống Nhất', 'Thong Nhat'),
('11020', 'WARD', '297', 'Yết Kiêu', 'Yet Kieu'),
('11035', 'WARD', '297', 'Gia Phúc', 'Gia Phuc'),
('11038', 'WARD', '297', 'Gia Tiến', 'Gia Tien'),
('11041', 'WARD', '297', 'Lê Lợi', 'Le Loi'),
('11044', 'WARD', '297', 'Toàn Thắng', 'Toan Thang'),
('11047', 'WARD', '297', 'Hoàng Diệu', 'Hoang Dieu'),
('11050', 'WARD', '297', 'Hồng Hưng', 'Hong Hung'),
('11053', 'WARD', '297', 'Phạm Trấn', 'Pham Tran'),
('11056', 'WARD', '297', 'Đoàn Thượng', 'Doan Thuong'),
('11059', 'WARD', '297', 'Thống Kênh', 'Thong Kenh'),
('11065', 'WARD', '297', 'Nhật Quang', 'Nhat Quang'),
('11071', 'WARD', '297', 'Quang Đức', 'Quang Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 298 - Tứ Kỳ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11074', 'WARD', '298', 'Thị trấn Tứ Kỳ', 'Thi tran Tu Ky'),
('11083', 'WARD', '298', 'Đại Sơn', 'Dai Son'),
('11086', 'WARD', '298', 'Hưng Đạo', 'Hung Dao'),
('11092', 'WARD', '298', 'Bình Lăng', 'Binh Lang'),
('11095', 'WARD', '298', 'Chí Minh', 'Chi Minh'),
('11098', 'WARD', '298', 'Kỳ Sơn', 'Ky Son'),
('11101', 'WARD', '298', 'Quang Phục', 'Quang Phuc'),
('11113', 'WARD', '298', 'Tân Kỳ', 'Tan Ky'),
('11116', 'WARD', '298', 'Quang Khải', 'Quang Khai'),
('11119', 'WARD', '298', 'Đại Hợp', 'Dai Hop'),
('11122', 'WARD', '298', 'Dân An', 'Dan An'),
('11125', 'WARD', '298', 'An Thanh', 'An Thanh'),
('11128', 'WARD', '298', 'Minh Đức', 'Minh Duc'),
('11131', 'WARD', '298', 'Văn Tố', 'Van To'),
('11134', 'WARD', '298', 'Quang Trung', 'Quang Trung'),
('11140', 'WARD', '298', 'Lạc Phượng', 'Lac Phuong'),
('11143', 'WARD', '298', 'Tiên Động', 'Tien Dong'),
('11146', 'WARD', '298', 'Nguyên Giáp', 'Nguyen Giap'),
('11149', 'WARD', '298', 'Hà Kỳ', 'Ha Ky'),
('11152', 'WARD', '298', 'Hà Thanh', 'Ha Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 299 - Ninh Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11161', 'WARD', '299', 'Ứng Hoè', 'Ung Hoe'),
('11164', 'WARD', '299', 'Nghĩa An', 'Nghia An'),
('11167', 'WARD', '299', 'Đức Phúc', 'Duc Phuc'),
('11173', 'WARD', '299', 'An Đức', 'An Duc'),
('11179', 'WARD', '299', 'Tân Hương', 'Tan Huong'),
('11185', 'WARD', '299', 'Vĩnh Hòa', 'Vinh Hoa'),
('11188', 'WARD', '299', 'Bình Xuyên', 'Binh Xuyen'),
('11197', 'WARD', '299', 'Tân Phong', 'Tan Phong'),
('11203', 'WARD', '299', 'Thị trấn Ninh Giang', 'Thi tran Ninh Giang'),
('11206', 'WARD', '299', 'Tân Quang', 'Tan Quang'),
('11215', 'WARD', '299', 'Hồng Dụ', 'Hong Du'),
('11218', 'WARD', '299', 'Văn Hội', 'Van Hoi'),
('11224', 'WARD', '299', 'Hồng Phong', 'Hong Phong'),
('11227', 'WARD', '299', 'Hiệp Lực', 'Hiep Luc'),
('11230', 'WARD', '299', 'Kiến Phúc', 'Kien Phuc'),
('11233', 'WARD', '299', 'Hưng Long', 'Hung Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 300 - Thanh Miện
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11239', 'WARD', '300', 'Thị trấn Thanh Miện', 'Thi tran Thanh Mien'),
('11242', 'WARD', '300', 'Thanh Tùng', 'Thanh Tung'),
('11245', 'WARD', '300', 'Phạm Kha', 'Pham Kha'),
('11248', 'WARD', '300', 'Ngô Quyền', 'Ngo Quyen'),
('11251', 'WARD', '300', 'Đoàn Tùng', 'Doan Tung'),
('11254', 'WARD', '300', 'Hồng Quang', 'Hong Quang'),
('11257', 'WARD', '300', 'Tân Trào', 'Tan Trao'),
('11260', 'WARD', '300', 'Lam Sơn', 'Lam Son'),
('11263', 'WARD', '300', 'Đoàn Kết', 'Doan Ket'),
('11266', 'WARD', '300', 'Lê Hồng', 'Le Hong'),
('11269', 'WARD', '300', 'Tứ Cường', 'Tu Cuong'),
('11275', 'WARD', '300', 'Ngũ Hùng', 'Ngu Hung'),
('11278', 'WARD', '300', 'Cao Thắng', 'Cao Thang'),
('11281', 'WARD', '300', 'Chi Lăng Bắc', 'Chi Lang Bac'),
('11284', 'WARD', '300', 'Chi Lăng Nam', 'Chi Lang Nam'),
('11287', 'WARD', '300', 'Thanh Giang', 'Thanh Giang'),
('11293', 'WARD', '300', 'Hồng Phong', 'Hong Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 31 - Hải Phòng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('303', 'DISTRICT', '31', 'Hồng Bàng', 'Hong Bang'),
('304', 'DISTRICT', '31', 'Ngô Quyền', 'Ngo Quyen'),
('305', 'DISTRICT', '31', 'Lê Chân', 'Le Chan'),
('306', 'DISTRICT', '31', 'Hải An', 'Hai An'),
('307', 'DISTRICT', '31', 'Kiến An', 'Kien An'),
('308', 'DISTRICT', '31', 'Đồ Sơn', 'Do Son'),
('309', 'DISTRICT', '31', 'Dương Kinh', 'Duong Kinh'),
('311', 'DISTRICT', '31', 'Thuỷ Nguyên', 'Thanh pho Thuy Nguyen'),
('312', 'DISTRICT', '31', 'An Dương', 'An Duong'),
('313', 'DISTRICT', '31', 'An Lão', 'An Lao'),
('314', 'DISTRICT', '31', 'Kiến Thuỵ', 'Kien Thuy'),
('315', 'DISTRICT', '31', 'Tiên Lãng', 'Tien Lang'),
('316', 'DISTRICT', '31', 'Vĩnh Bảo', 'Vinh Bao'),
('317', 'DISTRICT', '31', 'Cát Hải', 'Cat Hai'),
('318', 'DISTRICT', '31', 'Bạch Long Vĩ', 'Bach Long Vi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 303 - Hồng Bàng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11296', 'WARD', '303', 'Quán Toan', 'Toan'),
('11299', 'WARD', '303', 'Hùng Vương', 'Hung Vuong'),
('11302', 'WARD', '303', 'Sở Dầu', 'So Dau'),
('11305', 'WARD', '303', 'Thượng Lý', 'Thuong Ly'),
('11311', 'WARD', '303', 'Minh Khai', 'Minh Khai'),
('11320', 'WARD', '303', 'Hoàng Văn Thụ', 'Hoang Van Thu'),
('11323', 'WARD', '303', 'Phan Bội Châu', 'Phan Boi Chau'),
('11587', 'WARD', '303', 'Đại Bản', 'Dai Ban'),
('11599', 'WARD', '303', 'An Hưng', 'An Hung'),
('11602', 'WARD', '303', 'An Hồng', 'An Hong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 304 - Ngô Quyền
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11329', 'WARD', '304', 'Máy Chai', 'May Chai'),
('11335', 'WARD', '304', 'Vạn Mỹ', 'Van My'),
('11338', 'WARD', '304', 'Cầu Tre', 'Cau Tre'),
('11341', 'WARD', '304', 'Gia Viên', 'Gia Vien'),
('11344', 'WARD', '304', 'Cầu Đất', 'Cau Dat'),
('11350', 'WARD', '304', 'Đông Khê', 'Dong Khe'),
('11359', 'WARD', '304', 'Đằng Giang', 'Dang Giang'),
('11365', 'WARD', '304', 'Lạch Tray', 'Lach Tray')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 305 - Lê Chân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11371', 'WARD', '305', 'An Biên', 'An Bien'),
('11383', 'WARD', '305', 'Trần Nguyên Hãn', 'Tran Nguyen Han'),
('11395', 'WARD', '305', 'Hàng Kênh', 'Hang Kenh'),
('11401', 'WARD', '305', 'An Dương', 'An Duong'),
('11404', 'WARD', '305', 'Dư Hàng Kênh', 'Du Hang Kenh'),
('11405', 'WARD', '305', 'Kênh Dương', 'Kenh Duong'),
('11407', 'WARD', '305', 'Vĩnh Niệm', 'Vinh Niem')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 306 - Hải An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11410', 'WARD', '306', 'Đông Hải 1', 'Dong Hai 1'),
('11411', 'WARD', '306', 'Đông Hải 2', 'Dong Hai 2'),
('11413', 'WARD', '306', 'Đằng Lâm', 'Dang Lam'),
('11414', 'WARD', '306', 'Thành Tô', 'Thanh To'),
('11416', 'WARD', '306', 'Đằng Hải', 'Dang Hai'),
('11419', 'WARD', '306', 'Nam Hải', 'Nam Hai'),
('11422', 'WARD', '306', 'Cát Bi', 'Cat Bi'),
('11425', 'WARD', '306', 'Tràng Cát', 'Trang Cat')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 307 - Kiến An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11431', 'WARD', '307', 'Đồng Hoà', 'Dong Hoa'),
('11434', 'WARD', '307', 'Bắc Sơn', 'Bac Son'),
('11437', 'WARD', '307', 'Nam Sơn', 'Nam Son'),
('11440', 'WARD', '307', 'Ngọc Sơn', 'Ngoc Son'),
('11443', 'WARD', '307', 'Trần Thành Ngọ', 'Tran Thanh Ngo'),
('11446', 'WARD', '307', 'Văn Đẩu', 'Van Dau'),
('11449', 'WARD', '307', 'Bắc Hà', 'Bac Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 308 - Đồ Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11455', 'WARD', '308', 'Ngọc Xuyên', 'Ngoc Xuyen'),
('11458', 'WARD', '308', 'Hải Sơn', 'Hai Son'),
('11461', 'WARD', '308', 'Vạn Hương', 'Van Huong'),
('11465', 'WARD', '308', 'Minh Đức', 'Minh Duc'),
('11467', 'WARD', '308', 'Bàng La', 'Bang La'),
('11737', 'WARD', '308', 'Hợp Đức', 'Hop Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 309 - Dương Kinh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11683', 'WARD', '309', 'Đa Phúc', 'Da Phuc'),
('11686', 'WARD', '309', 'Hưng Đạo', 'Hung Dao'),
('11689', 'WARD', '309', 'Anh Dũng', 'Anh Dung'),
('11692', 'WARD', '309', 'Hải Thành', 'Hai Thanh'),
('11707', 'WARD', '309', 'Hoà Nghĩa', 'Hoa Nghia'),
('11740', 'WARD', '309', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 311 - Thuỷ Nguyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11473', 'WARD', '311', 'Minh Đức', 'Minh Duc'),
('11485', 'WARD', '311', 'Liên Xuân', 'Lien Xuan'),
('11488', 'WARD', '311', 'Lưu Kiếm', 'Luu Kiem'),
('11500', 'WARD', '311', 'Bạch Đằng', 'Bach Dang'),
('11503', 'WARD', '311', 'Ninh Sơn', 'Ninh Son'),
('11506', 'WARD', '311', 'Quảng Thanh', 'Quang Thanh'),
('11512', 'WARD', '311', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('11518', 'WARD', '311', 'Quang Trung', 'Quang Trung'),
('11521', 'WARD', '311', 'Lê Hồng Phong', 'Le Hong Phong'),
('11527', 'WARD', '311', 'Hoà Bình', 'Hoa Binh'),
('11530', 'WARD', '311', 'Thủy Hà', 'Thuy Ha'),
('11533', 'WARD', '311', 'An Lư', 'An Lu'),
('11539', 'WARD', '311', 'Phạm Ngũ Lão', 'Pham Ngu Lao'),
('11542', 'WARD', '311', 'Nam Triệu Giang', 'Nam Trieu Giang'),
('11545', 'WARD', '311', 'Tam Hưng', 'Tam Hung'),
('11551', 'WARD', '311', 'Lập Lễ', 'Lap Le'),
('11557', 'WARD', '311', 'Thiên Hương', 'Thien Huong'),
('11560', 'WARD', '311', 'Thuỷ Đường', 'Thuy Duong'),
('11569', 'WARD', '311', 'Hoàng Lâm', 'Hoang Lam'),
('11572', 'WARD', '311', 'Hoa Động', 'Hoa Dong'),
('11578', 'WARD', '311', 'Dương Quan', 'Duong Quan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 312 - An Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11581', 'WARD', '312', 'Lê Lợi', 'Le Loi'),
('11584', 'WARD', '312', 'Lê Thiện', 'Le Thien'),
('11590', 'WARD', '312', 'An Hoà', 'An Hoa'),
('11593', 'WARD', '312', 'Hồng Phong', 'Hong Phong'),
('11596', 'WARD', '312', 'Tân Tiến', 'Tan Tien'),
('11608', 'WARD', '312', 'Nam Sơn', 'Nam Son'),
('11614', 'WARD', '312', 'An Hải', 'An Hai'),
('11617', 'WARD', '312', 'Đồng Thái', 'Dong Thai'),
('11623', 'WARD', '312', 'An Đồng', 'An Dong'),
('11626', 'WARD', '312', 'Hồng Thái', 'Hong Thai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 313 - An Lão
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11629', 'WARD', '313', 'Thị trấn An Lão', 'Thi tran An Lao'),
('11632', 'WARD', '313', 'Bát Trang', 'Bat Trang'),
('11635', 'WARD', '313', 'Trường Thọ', 'Truong Tho'),
('11638', 'WARD', '313', 'Trường Thành', 'Truong Thanh'),
('11641', 'WARD', '313', 'An Tiến', 'An Tien'),
('11644', 'WARD', '313', 'Quang Hưng', 'Quang Hung'),
('11647', 'WARD', '313', 'Quang Trung', 'Quang Trung'),
('11650', 'WARD', '313', 'Quốc Tuấn', 'Quoc Tuan'),
('11653', 'WARD', '313', 'An Thắng', 'An Thang'),
('11656', 'WARD', '313', 'Thị trấn Trường Sơn', 'Thi tran Truong Son'),
('11659', 'WARD', '313', 'Tân Dân', 'Tan Dan'),
('11662', 'WARD', '313', 'Thái Sơn', 'Thai Son'),
('11665', 'WARD', '313', 'Tân Viên', 'Tan Vien'),
('11668', 'WARD', '313', 'Mỹ Đức', 'My Duc'),
('11671', 'WARD', '313', 'Chiến Thắng', 'Chien Thang'),
('11674', 'WARD', '313', 'An Thọ', 'An Tho'),
('11677', 'WARD', '313', 'An Thái', 'An Thai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 314 - Kiến Thuỵ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11680', 'WARD', '314', 'Thị trấn Núi Đối', 'Thi tran Nui Doi'),
('11695', 'WARD', '314', 'Đông Phương', 'Dong Phuong'),
('11698', 'WARD', '314', 'Thuận Thiên', 'Thuan Thien'),
('11701', 'WARD', '314', 'Hữu Bằng', 'Huu Bang'),
('11704', 'WARD', '314', 'Đại Đồng', 'Dai Dong'),
('11710', 'WARD', '314', 'Ngũ Phúc', 'Ngu Phuc'),
('11713', 'WARD', '314', 'Kiến Quốc', 'Kien Quoc'),
('11716', 'WARD', '314', 'Du Lễ', 'Du Le'),
('11722', 'WARD', '314', 'Thanh Sơn', 'Thanh Son'),
('11725', 'WARD', '314', 'Minh Tân', 'Minh Tan'),
('11728', 'WARD', '314', 'Kiến Hưng', 'Kien Hung'),
('11734', 'WARD', '314', 'Tân Phong', 'Tan Phong'),
('11743', 'WARD', '314', 'Tân Trào', 'Tan Trao'),
('11746', 'WARD', '314', 'Đoàn Xá', 'Doan Xa'),
('11749', 'WARD', '314', 'Tú Sơn', 'Tu Son'),
('11752', 'WARD', '314', 'Đại Hợp', 'Dai Hop')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 315 - Tiên Lãng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11755', 'WARD', '315', 'Thị trấn Tiên Lãng', 'Thi tran Tien Lang'),
('11758', 'WARD', '315', 'Đại Thắng', 'Dai Thang'),
('11761', 'WARD', '315', 'Tiên Cường', 'Tien Cuong'),
('11764', 'WARD', '315', 'Tự Cường', 'Tu Cuong'),
('11770', 'WARD', '315', 'Quyết Tiến', 'Quyet Tien'),
('11773', 'WARD', '315', 'Khởi Nghĩa', 'Khoi Nghia'),
('11776', 'WARD', '315', 'Tiên Thanh', 'Tien Thanh'),
('11779', 'WARD', '315', 'Cấp Tiến', 'Cap Tien'),
('11782', 'WARD', '315', 'Kiến Thiết', 'Kien Thiet'),
('11785', 'WARD', '315', 'Đoàn Lập', 'Doan Lap'),
('11791', 'WARD', '315', 'Tân Minh', 'Tan Minh'),
('11797', 'WARD', '315', 'Tiên Thắng', 'Tien Thang'),
('11800', 'WARD', '315', 'Tiên Minh', 'Tien Minh'),
('11803', 'WARD', '315', 'Bắc Hưng', 'Bac Hung'),
('11806', 'WARD', '315', 'Nam Hưng', 'Nam Hung'),
('11809', 'WARD', '315', 'Hùng Thắng', 'Hung Thang'),
('11812', 'WARD', '315', 'Tây Hưng', 'Tay Hung'),
('11815', 'WARD', '315', 'Đông Hưng', 'Dong Hung'),
('11821', 'WARD', '315', 'Vinh Quang', 'Vinh Quang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 316 - Vĩnh Bảo
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11824', 'WARD', '316', 'Thị trấn Vĩnh Bảo', 'Thi tran Vinh Bao'),
('11827', 'WARD', '316', 'Dũng Tiến', 'Dung Tien'),
('11830', 'WARD', '316', 'Giang Biên', 'Giang Bien'),
('11833', 'WARD', '316', 'Thắng Thuỷ', 'Thang Thuy'),
('11836', 'WARD', '316', 'Trung Lập', 'Trung Lap'),
('11839', 'WARD', '316', 'Việt Tiến', 'Viet Tien'),
('11842', 'WARD', '316', 'Vĩnh An', 'Vinh An'),
('11848', 'WARD', '316', 'Vĩnh Hoà', 'Vinh Hoa'),
('11851', 'WARD', '316', 'Hùng Tiến', 'Hung Tien'),
('11857', 'WARD', '316', 'Tân Hưng', 'Tan Hung'),
('11860', 'WARD', '316', 'Tân Liên', 'Tan Lien'),
('11866', 'WARD', '316', 'Vĩnh Hưng', 'Vinh Hung'),
('11875', 'WARD', '316', 'Vĩnh Hải', 'Vinh Hai'),
('11881', 'WARD', '316', 'Liên Am', 'Lien Am'),
('11884', 'WARD', '316', 'Lý Học', 'Ly Hoc'),
('11887', 'WARD', '316', 'Tam Cường', 'Tam Cuong'),
('11890', 'WARD', '316', 'Hoà Bình', 'Hoa Binh'),
('11893', 'WARD', '316', 'Tiền Phong', 'Tien Phong'),
('11902', 'WARD', '316', 'Cao Minh', 'Cao Minh'),
('11911', 'WARD', '316', 'Trấn Dương', 'Tran Duong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 317 - Cát Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11914', 'WARD', '317', 'Thị trấn Cát Bà', 'Thi tran Cat Ba'),
('11917', 'WARD', '317', 'Thị trấn Cát Hải', 'Thi tran Cat Hai'),
('11920', 'WARD', '317', 'Nghĩa Lộ', 'Nghia Lo'),
('11923', 'WARD', '317', 'Đồng Bài', 'Dong Bai'),
('11926', 'WARD', '317', 'Hoàng Châu', 'Hoang Chau'),
('11929', 'WARD', '317', 'Văn Phong', 'Van Phong'),
('11932', 'WARD', '317', 'Phù Long', 'Phu Long'),
('11935', 'WARD', '317', 'Gia Luận', 'Gia Luan'),
('11938', 'WARD', '317', 'Hiền Hào', 'Hien Hao'),
('11941', 'WARD', '317', 'Trân Châu', 'Tran Chau'),
('11944', 'WARD', '317', 'Việt Hải', 'Viet Hai'),
('11947', 'WARD', '317', 'Xuân Đám', 'Xuan Dam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 33 - Hưng Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('323', 'DISTRICT', '33', 'Hưng Yên', 'Thanh pho Hung Yen'),
('325', 'DISTRICT', '33', 'Văn Lâm', 'Van Lam'),
('326', 'DISTRICT', '33', 'Văn Giang', 'Van Giang'),
('327', 'DISTRICT', '33', 'Yên Mỹ', 'Yen My'),
('328', 'DISTRICT', '33', 'Thị Mỹ Hào', 'Thi My Hao'),
('329', 'DISTRICT', '33', 'Ân Thi', 'An Thi'),
('330', 'DISTRICT', '33', 'Khoái Châu', 'Khoai Chau'),
('331', 'DISTRICT', '33', 'Kim Động', 'Kim Dong'),
('332', 'DISTRICT', '33', 'Tiên Lữ', 'Tien Lu'),
('333', 'DISTRICT', '33', 'Phù Cừ', 'Phu Cu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 323 - Hưng Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11950', 'WARD', '323', 'Lam Sơn', 'Lam Son'),
('11953', 'WARD', '323', 'Hiến Nam', 'Hien Nam'),
('11956', 'WARD', '323', 'An Tảo', 'An Tao'),
('11959', 'WARD', '323', 'Lê Lợi', 'Le Loi'),
('11962', 'WARD', '323', 'Minh Khai', 'Minh Khai'),
('11968', 'WARD', '323', 'Hồng Châu', 'Hong Chau'),
('11971', 'WARD', '323', 'Trung Nghĩa', 'Trung Nghia'),
('11974', 'WARD', '323', 'Liên Phương', 'Lien Phuong'),
('11977', 'WARD', '323', 'Phương Nam', 'Nam'),
('11980', 'WARD', '323', 'Quảng Châu', 'Quang Chau'),
('11983', 'WARD', '323', 'Bảo Khê', 'Bao Khe'),
('12331', 'WARD', '323', 'Phú Cường', 'Phu Cuong'),
('12334', 'WARD', '323', 'Hùng Cường', 'Hung Cuong'),
('12385', 'WARD', '323', 'Tân Hưng', 'Tan Hung'),
('12388', 'WARD', '323', 'Hoàng Hanh', 'Hoang Hanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 325 - Văn Lâm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('11986', 'WARD', '325', 'Thị trấn Như Quỳnh', 'Thi tran Nhu Quynh'),
('11989', 'WARD', '325', 'Lạc Đạo', 'Lac Dao'),
('11992', 'WARD', '325', 'Chỉ Đạo', 'Chi Dao'),
('11995', 'WARD', '325', 'Đại Đồng', 'Dai Dong'),
('11998', 'WARD', '325', 'Việt Hưng', 'Viet Hung'),
('12001', 'WARD', '325', 'Tân Quang', 'Tan Quang'),
('12004', 'WARD', '325', 'Đình Dù', 'Dinh Du'),
('12007', 'WARD', '325', 'Minh Hải', 'Minh Hai'),
('12010', 'WARD', '325', 'Lương Tài', 'Luong Tai'),
('12013', 'WARD', '325', 'Trưng Trắc', 'Trung Trac'),
('12016', 'WARD', '325', 'Lạc Hồng', 'Lac Hong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 326 - Văn Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12019', 'WARD', '326', 'Thị trấn Văn Giang', 'Thi tran Van Giang'),
('12022', 'WARD', '326', 'Xuân Quan', 'Xuan Quan'),
('12025', 'WARD', '326', 'Cửu Cao', 'Cuu Cao'),
('12028', 'WARD', '326', 'Phụng Công', 'Phung Cong'),
('12031', 'WARD', '326', 'Nghĩa Trụ', 'Nghia Tru'),
('12034', 'WARD', '326', 'Long Hưng', 'Long Hung'),
('12037', 'WARD', '326', 'Vĩnh Khúc', 'Vinh Khuc'),
('12040', 'WARD', '326', 'Liên Nghĩa', 'Lien Nghia'),
('12043', 'WARD', '326', 'Tân Tiến', 'Tan Tien'),
('12046', 'WARD', '326', 'Thắng Lợi', 'Thang Loi'),
('12049', 'WARD', '326', 'Mễ Sở', 'Me So')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 327 - Yên Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12052', 'WARD', '327', 'Thị trấn Yên Mỹ', 'Thi tran Yen My'),
('12055', 'WARD', '327', 'Nguyễn Văn Linh', 'Nguyen Van Linh'),
('12061', 'WARD', '327', 'Đồng Than', 'Dong Than'),
('12064', 'WARD', '327', 'Ngọc Long', 'Ngoc Long'),
('12067', 'WARD', '327', 'Liêu Xá', 'Lieu Xa'),
('12070', 'WARD', '327', 'Hoàn Long', 'Hoan Long'),
('12073', 'WARD', '327', 'Tân Lập', 'Tan Lap'),
('12076', 'WARD', '327', 'Thanh Long', 'Thanh Long'),
('12079', 'WARD', '327', 'Yên Phú', 'Yen Phu'),
('12085', 'WARD', '327', 'Trung Hòa', 'Trung Hoa'),
('12091', 'WARD', '327', 'Việt Yên', 'Viet Yen'),
('12100', 'WARD', '327', 'Tân Minh', 'Tan Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 328 - Thị Mỹ Hào
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12103', 'WARD', '328', 'Bần Yên Nhân', 'Ban Yen Nhan'),
('12106', 'WARD', '328', 'Phan Đình Phùng', 'Phan Dinh Phung'),
('12109', 'WARD', '328', 'Cẩm Xá', 'Cam Xa'),
('12112', 'WARD', '328', 'Dương Quang', 'Duong Quang'),
('12115', 'WARD', '328', 'Hòa Phong', 'Hoa Phong'),
('12118', 'WARD', '328', 'Nhân Hòa', 'Nhan Hoa'),
('12121', 'WARD', '328', 'Dị Sử', 'Di Su'),
('12124', 'WARD', '328', 'Bạch Sam', 'Bach Sam'),
('12127', 'WARD', '328', 'Minh Đức', 'Minh Duc'),
('12130', 'WARD', '328', 'Phùng Chí Kiên', 'Phung Chi Kien'),
('12133', 'WARD', '328', 'Xuân Dục', 'Xuan Duc'),
('12136', 'WARD', '328', 'Ngọc Lâm', 'Ngoc Lam'),
('12139', 'WARD', '328', 'Hưng Long', 'Hung Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 329 - Ân Thi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12142', 'WARD', '329', 'Thị trấn Ân Thi', 'Thi tran An Thi'),
('12145', 'WARD', '329', 'Phù Ủng', 'Phu Ung'),
('12148', 'WARD', '329', 'Bắc Sơn', 'Bac Son'),
('12151', 'WARD', '329', 'Bãi Sậy', 'Bai Say'),
('12154', 'WARD', '329', 'Đào Dương', 'Dao Duong'),
('12157', 'WARD', '329', 'Quang Vinh', 'Quang Vinh'),
('12160', 'WARD', '329', 'Vân Du', 'Van Du'),
('12166', 'WARD', '329', 'Xuân Trúc', 'Xuan Truc'),
('12169', 'WARD', '329', 'Hoàng Hoa Thám', 'Hoang Hoa Tham'),
('12172', 'WARD', '329', 'Quảng Lãng', 'Quang Lang'),
('12175', 'WARD', '329', 'Đa Lộc', 'Da Loc'),
('12178', 'WARD', '329', 'Đặng Lễ', 'Dang Le'),
('12181', 'WARD', '329', 'Cẩm Ninh', 'Cam Ninh'),
('12184', 'WARD', '329', 'Nguyễn Trãi', 'Nguyen Trai'),
('12190', 'WARD', '329', 'Hồ Tùng Mậu', 'Ho Tung Mau'),
('12193', 'WARD', '329', 'Tiền Phong', 'Tien Phong'),
('12196', 'WARD', '329', 'Hồng Quang', 'Hong Quang'),
('12202', 'WARD', '329', 'Hạ Lễ', 'Ha Le')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 330 - Khoái Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12205', 'WARD', '330', 'Thị trấn Khoái Châu', 'Thi tran Khoai Chau'),
('12208', 'WARD', '330', 'Đông Tảo', 'Dong Tao'),
('12211', 'WARD', '330', 'Bình Minh', 'Binh Minh'),
('12214', 'WARD', '330', 'Phạm Hồng Thái', 'Pham Hong Thai'),
('12220', 'WARD', '330', 'Ông Đình', 'Ong Dinh'),
('12223', 'WARD', '330', 'Tân Dân', 'Tan Dan'),
('12226', 'WARD', '330', 'Tứ Dân', 'Tu Dan'),
('12229', 'WARD', '330', 'An Vĩ', 'An Vi'),
('12232', 'WARD', '330', 'Đông Kết', 'Dong Ket'),
('12238', 'WARD', '330', 'Dân Tiến', 'Dan Tien'),
('12244', 'WARD', '330', 'Đồng Tiến', 'Dong Tien'),
('12247', 'WARD', '330', 'Tân Châu', 'Tan Chau'),
('12250', 'WARD', '330', 'Liên Khê', 'Lien Khe'),
('12253', 'WARD', '330', 'Phùng Hưng', 'Phung Hung'),
('12256', 'WARD', '330', 'Việt Hòa', 'Viet Hoa'),
('12259', 'WARD', '330', 'Đông Ninh', 'Dong Ninh'),
('12262', 'WARD', '330', 'Đại Tập', 'Dai Tap'),
('12265', 'WARD', '330', 'Chí Minh', 'Chi Minh'),
('12271', 'WARD', '330', 'Thuần Hưng', 'Thuan Hung'),
('12274', 'WARD', '330', 'Nguyễn Huệ', 'Nguyen Hue')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 331 - Kim Động
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12280', 'WARD', '331', 'Thị trấn Lương Bằng', 'Thi tran Luong Bang'),
('12283', 'WARD', '331', 'Nghĩa Dân', 'Nghia Dan'),
('12286', 'WARD', '331', 'Toàn Thắng', 'Toan Thang'),
('12289', 'WARD', '331', 'Vĩnh Xá', 'Vinh Xa'),
('12292', 'WARD', '331', 'Phạm Ngũ Lão', 'Pham Ngu Lao'),
('12295', 'WARD', '331', 'Phú Thọ', 'Phu Tho'),
('12298', 'WARD', '331', 'Đồng Thanh', 'Dong Thanh'),
('12301', 'WARD', '331', 'Song Mai', 'Song Mai'),
('12304', 'WARD', '331', 'Chính Nghĩa', 'Chinh Nghia'),
('12313', 'WARD', '331', 'Mai Động', 'Mai Dong'),
('12316', 'WARD', '331', 'Đức Hợp', 'Duc Hop'),
('12319', 'WARD', '331', 'Hùng An', 'Hung An'),
('12322', 'WARD', '331', 'Ngọc Thanh', 'Ngoc Thanh'),
('12325', 'WARD', '331', 'Diên Hồng', 'Dien Hong'),
('12328', 'WARD', '331', 'Hiệp Cường', 'Hiep Cuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 332 - Tiên Lữ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12337', 'WARD', '332', 'Thị trấn Vương', 'Thi tran Vuong'),
('12340', 'WARD', '332', 'Hưng Đạo', 'Hung Dao'),
('12346', 'WARD', '332', 'Nhật Tân', 'Nhat Tan'),
('12352', 'WARD', '332', 'Lệ Xá', 'Le Xa'),
('12355', 'WARD', '332', 'An Viên', 'An Vien'),
('12361', 'WARD', '332', 'Trung Dũng', 'Trung Dung'),
('12364', 'WARD', '332', 'Hải Thắng', 'Hai Thang'),
('12367', 'WARD', '332', 'Thủ Sỹ', 'Thu Sy'),
('12370', 'WARD', '332', 'Thiện Phiến', 'Thien Phien'),
('12373', 'WARD', '332', 'Thụy Lôi', 'Thuy Loi'),
('12376', 'WARD', '332', 'Cương Chính', 'Cuong Chinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 333 - Phù Cừ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12391', 'WARD', '333', 'Thị trấn Trần Cao', 'Thi tran Tran Cao'),
('12394', 'WARD', '333', 'Minh Tân', 'Minh Tan'),
('12397', 'WARD', '333', 'Phan Sào Nam', 'Phan Sao Nam'),
('12400', 'WARD', '333', 'Quang Hưng', 'Quang Hung'),
('12403', 'WARD', '333', 'Minh Hoàng', 'Minh Hoang'),
('12406', 'WARD', '333', 'Đoàn Đào', 'Doan Dao'),
('12409', 'WARD', '333', 'Tống Phan', 'Tong Phan'),
('12412', 'WARD', '333', 'Đình Cao', 'Dinh Cao'),
('12415', 'WARD', '333', 'Nhật Quang', 'Nhat Quang'),
('12421', 'WARD', '333', 'Tam Đa', 'Tam Da'),
('12424', 'WARD', '333', 'Tiên Tiến', 'Tien Tien'),
('12427', 'WARD', '333', 'Nguyên Hòa', 'Nguyen Hoa'),
('12430', 'WARD', '333', 'Tống Trân', 'Tong Tran')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 34 - Thái Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('336', 'DISTRICT', '34', 'Thái Bình', 'Thanh pho Thai Binh'),
('338', 'DISTRICT', '34', 'Quỳnh Phụ', 'Quynh Phu'),
('339', 'DISTRICT', '34', 'Hưng Hà', 'Hung Ha'),
('340', 'DISTRICT', '34', 'Đông Hưng', 'Dong Hung'),
('341', 'DISTRICT', '34', 'Thái Thụy', 'Thai Thuy'),
('342', 'DISTRICT', '34', 'Tiền Hải', 'Tien Hai'),
('343', 'DISTRICT', '34', 'Kiến Xương', 'Kien Xuong'),
('344', 'DISTRICT', '34', 'Vũ Thư', 'Vu Thu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 336 - Thái Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12433', 'WARD', '336', 'Lê Hồng Phong', 'Le Hong Phong'),
('12436', 'WARD', '336', 'Bồ Xuyên', 'Bo Xuyen'),
('12439', 'WARD', '336', 'Đề Thám', 'De Tham'),
('12442', 'WARD', '336', 'Kỳ Bá', 'Ky Ba'),
('12445', 'WARD', '336', 'Quang Trung', 'Quang Trung'),
('12448', 'WARD', '336', 'Phú Khánh', 'Phu Khanh'),
('12451', 'WARD', '336', 'Tiền Phong', 'Tien Phong'),
('12452', 'WARD', '336', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('12454', 'WARD', '336', 'Trần Lãm', 'Tran Lam'),
('12457', 'WARD', '336', 'Đông Hòa', 'Dong Hoa'),
('12460', 'WARD', '336', 'Hoàng Diệu', 'Hoang Dieu'),
('12463', 'WARD', '336', 'Phú Xuân', 'Phu Xuan'),
('12466', 'WARD', '336', 'Vũ Phúc', 'Vu Phuc'),
('12469', 'WARD', '336', 'Vũ Chính', 'Vu Chinh'),
('12817', 'WARD', '336', 'Đông Mỹ', 'Dong My'),
('12820', 'WARD', '336', 'Đông Thọ', 'Dong Tho'),
('13084', 'WARD', '336', 'Vũ Đông', 'Vu Dong'),
('13108', 'WARD', '336', 'Vũ Lạc', 'Vu Lac'),
('13225', 'WARD', '336', 'Tân Bình', 'Tan Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 338 - Quỳnh Phụ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12472', 'WARD', '338', 'Thị trấn Quỳnh Côi', 'Thi tran Quynh Coi'),
('12475', 'WARD', '338', 'An Khê', 'An Khe'),
('12478', 'WARD', '338', 'An Đồng', 'An Dong'),
('12481', 'WARD', '338', 'Quỳnh Hoa', 'Quynh Hoa'),
('12484', 'WARD', '338', 'Quỳnh Lâm', 'Quynh Lam'),
('12487', 'WARD', '338', 'Quỳnh Thọ', 'Quynh Tho'),
('12490', 'WARD', '338', 'An Hiệp', 'An Hiep'),
('12493', 'WARD', '338', 'Quỳnh Hoàng', 'Quynh Hoang'),
('12496', 'WARD', '338', 'Quỳnh Giao', 'Quynh Giao'),
('12499', 'WARD', '338', 'An Thái', 'An Thai'),
('12502', 'WARD', '338', 'An Cầu', 'An Cau'),
('12505', 'WARD', '338', 'Quỳnh Hồng', 'Quynh Hong'),
('12508', 'WARD', '338', 'Quỳnh Khê', 'Quynh Khe'),
('12511', 'WARD', '338', 'Quỳnh Minh', 'Quynh Minh'),
('12514', 'WARD', '338', 'An Ninh', 'An Ninh'),
('12517', 'WARD', '338', 'Quỳnh Ngọc', 'Quynh Ngoc'),
('12520', 'WARD', '338', 'Quỳnh Hải', 'Quynh Hai'),
('12523', 'WARD', '338', 'Thị trấn An Bài', 'Thi tran An Bai'),
('12526', 'WARD', '338', 'An Ấp', 'An Ap'),
('12529', 'WARD', '338', 'Quỳnh Hội', 'Quynh Hoi'),
('12532', 'WARD', '338', 'Châu Sơn', 'Chau Son'),
('12535', 'WARD', '338', 'Quỳnh Mỹ', 'Quynh My'),
('12538', 'WARD', '338', 'An Quí', 'An Qui'),
('12541', 'WARD', '338', 'An Thanh', 'An Thanh'),
('12547', 'WARD', '338', 'An Vũ', 'An Vu'),
('12550', 'WARD', '338', 'An Lễ', 'An Le'),
('12553', 'WARD', '338', 'Quỳnh Hưng', 'Quynh Hung'),
('12559', 'WARD', '338', 'An Mỹ', 'An My'),
('12562', 'WARD', '338', 'Quỳnh Nguyên', 'Quynh Nguyen'),
('12565', 'WARD', '338', 'An Vinh', 'An Vinh'),
('12571', 'WARD', '338', 'An Dục', 'An Duc'),
('12574', 'WARD', '338', 'Đông Hải', 'Dong Hai'),
('12577', 'WARD', '338', 'Trang Bảo Xá', 'Trang Bao Xa'),
('12580', 'WARD', '338', 'An Tràng', 'An Trang'),
('12583', 'WARD', '338', 'Đồng Tiến', 'Dong Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 339 - Hưng Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12586', 'WARD', '339', 'Thị trấn Hưng Hà', 'Thi tran Hung Ha'),
('12589', 'WARD', '339', 'Quang Trung', 'Quang Trung'),
('12592', 'WARD', '339', 'Tân Lễ', 'Tan Le'),
('12595', 'WARD', '339', 'Cộng Hòa', 'Cong Hoa'),
('12601', 'WARD', '339', 'Canh Tân', 'Canh Tan'),
('12604', 'WARD', '339', 'Hòa Tiến', 'Hoa Tien'),
('12610', 'WARD', '339', 'Tân Tiến', 'Tan Tien'),
('12613', 'WARD', '339', 'Thị trấn Hưng Nhân', 'Thi tran Hung Nhan'),
('12616', 'WARD', '339', 'Đoan Hùng', 'Doan Hung'),
('12619', 'WARD', '339', 'Duyên Hải', 'Duyen Hai'),
('12622', 'WARD', '339', 'Tân Hòa', 'Tan Hoa'),
('12625', 'WARD', '339', 'Văn Cẩm', 'Van Cam'),
('12628', 'WARD', '339', 'Bắc Sơn', 'Bac Son'),
('12631', 'WARD', '339', 'Đông Đô', 'Dong Do'),
('12634', 'WARD', '339', 'Phúc Khánh', 'Phuc Khanh'),
('12637', 'WARD', '339', 'Liên Hiệp', 'Lien Hiep'),
('12640', 'WARD', '339', 'Tây Đô', 'Tay Do'),
('12643', 'WARD', '339', 'Thống Nhất', 'Thong Nhat'),
('12646', 'WARD', '339', 'Tiến Đức', 'Tien Duc'),
('12649', 'WARD', '339', 'Thái Hưng', 'Thai Hung'),
('12652', 'WARD', '339', 'Thái Phương', 'Thai Phuong'),
('12655', 'WARD', '339', 'Hòa Bình', 'Hoa Binh'),
('12656', 'WARD', '339', 'Chi Lăng', 'Chi Lang'),
('12658', 'WARD', '339', 'Minh Khai', 'Minh Khai'),
('12661', 'WARD', '339', 'Hồng An', 'Hong An'),
('12664', 'WARD', '339', 'Kim Chung', 'Kim Chung'),
('12667', 'WARD', '339', 'Hồng Lĩnh', 'Hong Linh'),
('12670', 'WARD', '339', 'Minh Tân', 'Minh Tan'),
('12673', 'WARD', '339', 'Văn Lang', 'Van Lang'),
('12676', 'WARD', '339', 'Độc Lập', 'Doc Lap'),
('12679', 'WARD', '339', 'Chí Hòa', 'Chi Hoa'),
('12682', 'WARD', '339', 'Minh Hòa', 'Minh Hoa'),
('12685', 'WARD', '339', 'Hồng Minh', 'Hong Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 340 - Đông Hưng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12688', 'WARD', '340', 'Thị trấn Đông Hưng', 'Thi tran Dong Hung'),
('12694', 'WARD', '340', 'Đông Phương', 'Dong Phuong'),
('12700', 'WARD', '340', 'Liên An Đô', 'Lien An Do'),
('12703', 'WARD', '340', 'Đông Sơn', 'Dong Son'),
('12706', 'WARD', '340', 'Đông Cường', 'Dong Cuong'),
('12709', 'WARD', '340', 'Phú Lương', 'Phu Luong'),
('12712', 'WARD', '340', 'Mê Linh', 'Me Linh'),
('12715', 'WARD', '340', 'Lô Giang', 'Lo Giang'),
('12718', 'WARD', '340', 'Đông La', 'Dong La'),
('12721', 'WARD', '340', 'Minh Tân', 'Minh Tan'),
('12724', 'WARD', '340', 'Đông Xá', 'Dong Xa'),
('12730', 'WARD', '340', 'Nguyên Xá', 'Nguyen Xa'),
('12736', 'WARD', '340', 'Phong Dương Tiến', 'Phong Duong Tien'),
('12739', 'WARD', '340', 'Hồng Việt', 'Hong Viet'),
('12745', 'WARD', '340', 'Hà Giang', 'Ha Giang'),
('12748', 'WARD', '340', 'Đông Kinh', 'Dong Kinh'),
('12751', 'WARD', '340', 'Đông Hợp', 'Dong Hop'),
('12754', 'WARD', '340', 'Thăng Long', 'Thang Long'),
('12757', 'WARD', '340', 'Đông Các', 'Dong Cac'),
('12760', 'WARD', '340', 'Phú Châu', 'Phu Chau'),
('12763', 'WARD', '340', 'Liên Hoa', 'Lien Hoa'),
('12769', 'WARD', '340', 'Đông Tân', 'Dong Tan'),
('12772', 'WARD', '340', 'Đông Vinh', 'Dong Vinh'),
('12775', 'WARD', '340', 'Xuân Quang Động', 'Xuan Quang Dong'),
('12778', 'WARD', '340', 'Hồng Bạch', 'Hong Bach'),
('12784', 'WARD', '340', 'Trọng Quan', 'Trong Quan'),
('12790', 'WARD', '340', 'Hồng Giang', 'Hong Giang'),
('12793', 'WARD', '340', 'Đông Quan', 'Dong Quan'),
('12802', 'WARD', '340', 'Đông Á', 'Dong A'),
('12808', 'WARD', '340', 'Đông Hoàng', 'Dong Hoang'),
('12811', 'WARD', '340', 'Đông Dương', 'Dong Duong'),
('12823', 'WARD', '340', 'Minh Phú', 'Minh Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 341 - Thái Thụy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12826', 'WARD', '341', 'Thị trấn Diêm Điền', 'Thi tran Diem Dien'),
('12832', 'WARD', '341', 'Thụy Trường', 'Thuy Truong'),
('12841', 'WARD', '341', 'Hồng Dũng', 'Hong Dung'),
('12844', 'WARD', '341', 'Thụy Quỳnh', 'Thuy Quynh'),
('12847', 'WARD', '341', 'An Tân', 'An Tan'),
('12850', 'WARD', '341', 'Thụy Ninh', 'Thuy Ninh'),
('12853', 'WARD', '341', 'Thụy Hưng', 'Thuy Hung'),
('12856', 'WARD', '341', 'Thụy Việt', 'Thuy Viet'),
('12859', 'WARD', '341', 'Thụy Văn', 'Thuy Van'),
('12862', 'WARD', '341', 'Thụy Xuân', 'Thuy Xuan'),
('12865', 'WARD', '341', 'Dương Phúc', 'Duong Phuc'),
('12868', 'WARD', '341', 'Thụy Trình', 'Thuy Trinh'),
('12871', 'WARD', '341', 'Thụy Bình', 'Thuy Binh'),
('12874', 'WARD', '341', 'Thụy Chính', 'Thuy Chinh'),
('12877', 'WARD', '341', 'Thụy Dân', 'Thuy Dan'),
('12880', 'WARD', '341', 'Thụy Hải', 'Thuy Hai'),
('12889', 'WARD', '341', 'Thụy Liên', 'Thuy Lien'),
('12892', 'WARD', '341', 'Thụy Duyên', 'Thuy Duyen'),
('12898', 'WARD', '341', 'Thụy Thanh', 'Thuy Thanh'),
('12901', 'WARD', '341', 'Thụy Sơn', 'Thuy Son'),
('12904', 'WARD', '341', 'Thụy Phong', 'Thuy Phong'),
('12907', 'WARD', '341', 'Thái Thượng', 'Thai Thuong'),
('12910', 'WARD', '341', 'Thái Nguyên', 'Thai Nguyen'),
('12916', 'WARD', '341', 'Dương Hồng Thủy', 'Duong Hong Thuy'),
('12919', 'WARD', '341', 'Thái Giang', 'Thai Giang'),
('12922', 'WARD', '341', 'Hòa An', 'Hoa An'),
('12925', 'WARD', '341', 'Sơn Hà', 'Son Ha'),
('12934', 'WARD', '341', 'Thái Phúc', 'Thai Phuc'),
('12937', 'WARD', '341', 'Thái Hưng', 'Thai Hung'),
('12940', 'WARD', '341', 'Thái Đô', 'Thai Do'),
('12943', 'WARD', '341', 'Thái Xuyên', 'Thai Xuyen'),
('12949', 'WARD', '341', 'Mỹ Lộc', 'My Loc'),
('12958', 'WARD', '341', 'Tân Học', 'Tan Hoc'),
('12961', 'WARD', '341', 'Thái Thịnh', 'Thai Thinh'),
('12964', 'WARD', '341', 'Thuần Thành', 'Thuan Thanh'),
('12967', 'WARD', '341', 'Thái Thọ', 'Thai Tho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 342 - Tiền Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('12970', 'WARD', '342', 'Thị trấn Tiền Hải', 'Thi tran Tien Hai'),
('12976', 'WARD', '342', 'Đông Trà', 'Dong Tra'),
('12979', 'WARD', '342', 'Đông Long', 'Dong Long'),
('12985', 'WARD', '342', 'Vũ Lăng', 'Vu Lang'),
('12988', 'WARD', '342', 'Đông Xuyên', 'Dong Xuyen'),
('12991', 'WARD', '342', 'Tây Lương', 'Tay Luong'),
('12994', 'WARD', '342', 'Tây Ninh', 'Tay Ninh'),
('12997', 'WARD', '342', 'Đông Quang', 'Dong Quang'),
('13000', 'WARD', '342', 'Đông Hoàng', 'Dong Hoang'),
('13003', 'WARD', '342', 'Đông Minh', 'Dong Minh'),
('13012', 'WARD', '342', 'An Ninh', 'An Ninh'),
('13018', 'WARD', '342', 'Đông Cơ', 'Dong Co'),
('13021', 'WARD', '342', 'Tây Giang', 'Tay Giang'),
('13024', 'WARD', '342', 'Đông Lâm', 'Dong Lam'),
('13027', 'WARD', '342', 'Phương Công', 'Cong'),
('13030', 'WARD', '342', 'Ái Quốc', 'Ai Quoc'),
('13036', 'WARD', '342', 'Nam Cường', 'Nam Cuong'),
('13039', 'WARD', '342', 'Vân Trường', 'Van Truong'),
('13045', 'WARD', '342', 'Nam Chính', 'Nam Chinh'),
('13048', 'WARD', '342', 'Bắc Hải', 'Bac Hai'),
('13051', 'WARD', '342', 'Nam Thịnh', 'Nam Thinh'),
('13054', 'WARD', '342', 'Nam Hà', 'Nam Ha'),
('13057', 'WARD', '342', 'Nam Tiến', 'Nam Tien'),
('13060', 'WARD', '342', 'Nam Trung', 'Nam Trung'),
('13063', 'WARD', '342', 'Nam Hồng', 'Nam Hong'),
('13066', 'WARD', '342', 'Nam Hưng', 'Nam Hung'),
('13069', 'WARD', '342', 'Nam Hải', 'Nam Hai'),
('13072', 'WARD', '342', 'Nam Phú', 'Nam Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 343 - Kiến Xương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13075', 'WARD', '343', 'Thị trấn Kiến Xương', 'Thi tran Kien Xuong'),
('13078', 'WARD', '343', 'Trà Giang', 'Tra Giang'),
('13081', 'WARD', '343', 'Quốc Tuấn', 'Quoc Tuan'),
('13087', 'WARD', '343', 'An Bình', 'An Binh'),
('13090', 'WARD', '343', 'Tây Sơn', 'Tay Son'),
('13093', 'WARD', '343', 'Hồng Thái', 'Hong Thai'),
('13096', 'WARD', '343', 'Bình Nguyên', 'Binh Nguyen'),
('13102', 'WARD', '343', 'Lê Lợi', 'Le Loi'),
('13111', 'WARD', '343', 'Vũ Lễ', 'Vu Le'),
('13114', 'WARD', '343', 'Thanh Tân', 'Thanh Tan'),
('13120', 'WARD', '343', 'Thống Nhất', 'Thong Nhat'),
('13126', 'WARD', '343', 'Vũ Ninh', 'Vu Ninh'),
('13129', 'WARD', '343', 'Vũ An', 'Vu An'),
('13132', 'WARD', '343', 'Quang Lịch', 'Quang Lich'),
('13135', 'WARD', '343', 'Hòa Bình', 'Hoa Binh'),
('13138', 'WARD', '343', 'Bình Minh', 'Binh Minh'),
('13141', 'WARD', '343', 'Vũ Quí', 'Vu Qui'),
('13144', 'WARD', '343', 'Quang Bình', 'Quang Binh'),
('13150', 'WARD', '343', 'Vũ Trung', 'Vu Trung'),
('13156', 'WARD', '343', 'Vũ Công', 'Vu Cong'),
('13159', 'WARD', '343', 'Hồng Vũ', 'Hong Vu'),
('13162', 'WARD', '343', 'Quang Minh', 'Quang Minh'),
('13165', 'WARD', '343', 'Quang Trung', 'Quang Trung'),
('13171', 'WARD', '343', 'Minh Quang', 'Minh Quang'),
('13177', 'WARD', '343', 'Minh Tân', 'Minh Tan'),
('13180', 'WARD', '343', 'Nam Bình', 'Nam Binh'),
('13183', 'WARD', '343', 'Bình Thanh', 'Binh Thanh'),
('13186', 'WARD', '343', 'Bình Định', 'Binh Dinh'),
('13189', 'WARD', '343', 'Hồng Tiến', 'Hong Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 344 - Vũ Thư
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13192', 'WARD', '344', 'Thị trấn Vũ Thư', 'Thi tran Vu Thu'),
('13195', 'WARD', '344', 'Hồng Lý', 'Hong Ly'),
('13198', 'WARD', '344', 'Đồng Thanh', 'Dong Thanh'),
('13201', 'WARD', '344', 'Xuân Hòa', 'Xuan Hoa'),
('13204', 'WARD', '344', 'Hiệp Hòa', 'Hiep Hoa'),
('13207', 'WARD', '344', 'Phúc Thành', 'Phuc Thanh'),
('13210', 'WARD', '344', 'Tân Phong', 'Tan Phong'),
('13213', 'WARD', '344', 'Song Lãng', 'Song Lang'),
('13216', 'WARD', '344', 'Tân Hòa', 'Tan Hoa'),
('13219', 'WARD', '344', 'Việt Hùng', 'Viet Hung'),
('13222', 'WARD', '344', 'Minh Lãng', 'Minh Lang'),
('13228', 'WARD', '344', 'Minh Khai', 'Minh Khai'),
('13231', 'WARD', '344', 'Dũng Nghĩa', 'Dung Nghia'),
('13234', 'WARD', '344', 'Minh Quang', 'Minh Quang'),
('13237', 'WARD', '344', 'Tam Quang', 'Tam Quang'),
('13240', 'WARD', '344', 'Tân Lập', 'Tan Lap'),
('13243', 'WARD', '344', 'Bách Thuận', 'Bach Thuan'),
('13246', 'WARD', '344', 'Tự Tân', 'Tu Tan'),
('13249', 'WARD', '344', 'Song An', 'Song An'),
('13252', 'WARD', '344', 'Trung An', 'Trung An'),
('13255', 'WARD', '344', 'Vũ Hội', 'Vu Hoi'),
('13258', 'WARD', '344', 'Hòa Bình', 'Hoa Binh'),
('13261', 'WARD', '344', 'Nguyên Xá', 'Nguyen Xa'),
('13264', 'WARD', '344', 'Việt Thuận', 'Viet Thuan'),
('13267', 'WARD', '344', 'Vũ Vinh', 'Vu Vinh'),
('13270', 'WARD', '344', 'Vũ Đoài', 'Vu Doai'),
('13273', 'WARD', '344', 'Vũ Tiến', 'Vu Tien'),
('13276', 'WARD', '344', 'Vũ Vân', 'Vu Van'),
('13279', 'WARD', '344', 'Duy Nhất', 'Duy Nhat'),
('13282', 'WARD', '344', 'Hồng Phong', 'Hong Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 35 - Hà Nam
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('347', 'DISTRICT', '35', 'Phủ Lý', 'Thanh pho Phu Ly'),
('349', 'DISTRICT', '35', 'Thị Duy Tiên', 'Thi Duy Tien'),
('350', 'DISTRICT', '35', 'Thị Kim Bảng', 'Thi Kim Bang'),
('351', 'DISTRICT', '35', 'Thanh Liêm', 'Thanh Liem'),
('352', 'DISTRICT', '35', 'Bình Lục', 'Binh Luc'),
('353', 'DISTRICT', '35', 'Lý Nhân', 'Ly Nhan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 347 - Phủ Lý
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13285', 'WARD', '347', 'Quang Trung', 'Quang Trung'),
('13291', 'WARD', '347', 'Lê Hồng Phong', 'Le Hong Phong'),
('13294', 'WARD', '347', 'Châu Cầu', 'Chau Cau'),
('13303', 'WARD', '347', 'Lam Hạ', 'Lam Ha'),
('13306', 'WARD', '347', 'Phù Vân', 'Phu Van'),
('13309', 'WARD', '347', 'Liêm Chính', 'Liem Chinh'),
('13315', 'WARD', '347', 'Thanh Châu', 'Thanh Chau'),
('13318', 'WARD', '347', 'Châu Sơn', 'Chau Son'),
('13366', 'WARD', '347', 'Tân Hiệp', 'Tan Hiep'),
('13426', 'WARD', '347', 'Kim Bình', 'Kim Binh'),
('13444', 'WARD', '347', 'Tân Liêm', 'Tan Liem'),
('13459', 'WARD', '347', 'Thanh Tuyền', 'Thanh Tuyen'),
('13507', 'WARD', '347', 'Đinh Xá', 'Dinh Xa'),
('13513', 'WARD', '347', 'Trịnh Xá', 'Trinh Xa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 349 - Thị Duy Tiên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13321', 'WARD', '349', 'Đồng Văn', 'Dong Van'),
('13324', 'WARD', '349', 'Hòa Mạc', 'Hoa Mac'),
('13327', 'WARD', '349', 'Mộc Hoàn', 'Moc Hoan'),
('13330', 'WARD', '349', 'Châu Giang', 'Chau Giang'),
('13333', 'WARD', '349', 'Bạch Thượng', 'Bach Thuong'),
('13336', 'WARD', '349', 'Duy Minh', 'Duy Minh'),
('13342', 'WARD', '349', 'Duy Hải', 'Duy Hai'),
('13345', 'WARD', '349', 'Chuyên Ngoại', 'CNgoai'),
('13348', 'WARD', '349', 'Yên Bắc', 'Yen Bac'),
('13351', 'WARD', '349', 'Trác Văn', 'Trac Van'),
('13354', 'WARD', '349', 'Tiên Nội', 'Tien Noi'),
('13357', 'WARD', '349', 'Hoàng Đông', 'Hoang Dong'),
('13360', 'WARD', '349', 'Yên Nam', 'Yen Nam'),
('13363', 'WARD', '349', 'Tiên Ngoại', 'Tien Ngoai'),
('13369', 'WARD', '349', 'Tiên Sơn', 'Tien Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 350 - Thị Kim Bảng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13384', 'WARD', '350', 'Quế', 'Que'),
('13387', 'WARD', '350', 'Nguyễn Úy', 'Nguyen Uy'),
('13390', 'WARD', '350', 'Đại Cương', 'Dai Cuong'),
('13393', 'WARD', '350', 'Lê Hồ', 'Le Ho'),
('13396', 'WARD', '350', 'Tượng Lĩnh', 'Tuong Linh'),
('13402', 'WARD', '350', 'Tân Tựu', 'Tan Tuu'),
('13405', 'WARD', '350', 'Đồng Hóa', 'Dong Hoa'),
('13408', 'WARD', '350', 'Hoàng Tây', 'Hoang Tay'),
('13411', 'WARD', '350', 'Tân Sơn', 'Tan Son'),
('13414', 'WARD', '350', 'Thụy Lôi', 'Thuy Loi'),
('13417', 'WARD', '350', 'Văn Xá', 'Van Xa'),
('13420', 'WARD', '350', 'Khả Phong', 'Kha Phong'),
('13423', 'WARD', '350', 'Ngọc Sơn', 'Ngoc Son'),
('13429', 'WARD', '350', 'Ba Sao', 'Ba Sao'),
('13432', 'WARD', '350', 'Liên Sơn', 'Lien Son'),
('13435', 'WARD', '350', 'Thi Sơn', 'Thi Son'),
('13438', 'WARD', '350', 'Thanh Sơn', 'Thanh Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 351 - Thanh Liêm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13441', 'WARD', '351', 'Thị trấn Kiện Khê', 'Thi tran Kien Khe'),
('13450', 'WARD', '351', 'Liêm Phong', 'Liem Phong'),
('13453', 'WARD', '351', 'Thanh Hà', 'Thanh Ha'),
('13456', 'WARD', '351', 'Liêm Cần', 'Liem Can'),
('13465', 'WARD', '351', 'Liêm Thuận', 'Liem Thuan'),
('13468', 'WARD', '351', 'Thanh Thủy', 'Thanh Thuy'),
('13471', 'WARD', '351', 'Thanh Phong', 'Thanh Phong'),
('13474', 'WARD', '351', 'Thị trấn Tân Thanh', 'Thi tran Tan Thanh'),
('13477', 'WARD', '351', 'Thanh Tân', 'Thanh Tan'),
('13480', 'WARD', '351', 'Liêm Túc', 'Liem Tuc'),
('13483', 'WARD', '351', 'Liêm Sơn', 'Liem Son'),
('13486', 'WARD', '351', 'Thanh Hương', 'Thanh Huong'),
('13489', 'WARD', '351', 'Thanh Nghị', 'Thanh Nghi'),
('13492', 'WARD', '351', 'Thanh Tâm', 'Thanh Tam'),
('13495', 'WARD', '351', 'Thanh Nguyên', 'Thanh Nguyen'),
('13498', 'WARD', '351', 'Thanh Hải', 'Thanh Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 352 - Bình Lục
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13501', 'WARD', '352', 'Thị trấn Bình Mỹ', 'Thi tran Binh My'),
('13504', 'WARD', '352', 'Bình Nghĩa', 'Binh Nghia'),
('13510', 'WARD', '352', 'Tràng An', 'Trang An'),
('13516', 'WARD', '352', 'Đồng Du', 'Dong Du'),
('13519', 'WARD', '352', 'Ngọc Lũ', 'Ngoc Lu'),
('13525', 'WARD', '352', 'Đồn Xá', 'Don Xa'),
('13528', 'WARD', '352', 'An Ninh', 'An Ninh'),
('13531', 'WARD', '352', 'Bồ Đề', 'Bo De'),
('13540', 'WARD', '352', 'Bình An', 'Binh An'),
('13543', 'WARD', '352', 'Vũ Bản', 'Vu Ban'),
('13546', 'WARD', '352', 'Trung Lương', 'Trung Luong'),
('13552', 'WARD', '352', 'An Đổ', 'An Do'),
('13555', 'WARD', '352', 'La Sơn', 'La Son'),
('13558', 'WARD', '352', 'Tiêu Động', 'Tieu Dong'),
('13561', 'WARD', '352', 'An Lão', 'An Lao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 353 - Lý Nhân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13567', 'WARD', '353', 'Hợp Lý', 'Hop Ly'),
('13570', 'WARD', '353', 'Nguyên Lý', 'Nguyen Ly'),
('13573', 'WARD', '353', 'Chính Lý', 'Chinh Ly'),
('13576', 'WARD', '353', 'Chân Lý', 'Chan Ly'),
('13579', 'WARD', '353', 'Đạo Lý', 'Dao Ly'),
('13582', 'WARD', '353', 'Công Lý', 'Cong Ly'),
('13585', 'WARD', '353', 'Văn Lý', 'Van Ly'),
('13588', 'WARD', '353', 'Bắc Lý', 'Bac Ly'),
('13591', 'WARD', '353', 'Đức Lý', 'Duc Ly'),
('13594', 'WARD', '353', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('13597', 'WARD', '353', 'Thị trấn Vĩnh Trụ', 'Thi tran Vinh Tru'),
('13600', 'WARD', '353', 'Nhân Thịnh', 'Nhan Thinh'),
('13606', 'WARD', '353', 'Nhân Khang', 'Nhan Khang'),
('13609', 'WARD', '353', 'Nhân Mỹ', 'Nhan My'),
('13612', 'WARD', '353', 'Nhân Nghĩa', 'Nhan Nghia'),
('13615', 'WARD', '353', 'Nhân Chính', 'Nhan Chinh'),
('13618', 'WARD', '353', 'Nhân Bình', 'Nhan Binh'),
('13621', 'WARD', '353', 'Phú Phúc', 'Phu Phuc'),
('13624', 'WARD', '353', 'Xuân Khê', 'Xuan Khe'),
('13627', 'WARD', '353', 'Tiến Thắng', 'Tien Thang'),
('13630', 'WARD', '353', 'Hòa Hậu', 'Hoa Hau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 36 - Nam Định
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('356', 'DISTRICT', '36', 'Nam Định', 'Thanh pho Nam Dinh'),
('359', 'DISTRICT', '36', 'Vụ Bản', 'Vu Ban'),
('360', 'DISTRICT', '36', 'Ý Yên', 'Y Yen'),
('361', 'DISTRICT', '36', 'Nghĩa Hưng', 'Nghia Hung'),
('362', 'DISTRICT', '36', 'Nam Trực', 'Nam Truc'),
('363', 'DISTRICT', '36', 'Trực Ninh', 'Truc Ninh'),
('364', 'DISTRICT', '36', 'Xuân Trường', 'Xuan Truong'),
('365', 'DISTRICT', '36', 'Giao Thủy', 'Giao Thuy'),
('366', 'DISTRICT', '36', 'Hải Hậu', 'Hai Hau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 356 - Nam Định
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13636', 'WARD', '356', 'Vị Xuyên', 'Vi Xuyen'),
('13657', 'WARD', '356', 'Trường Thi', 'Truong Thi'),
('13666', 'WARD', '356', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('13669', 'WARD', '356', 'Cửa Bắc', 'Cua Bac'),
('13678', 'WARD', '356', 'Năng Tĩnh', 'Nang Tinh'),
('13681', 'WARD', '356', 'Quang Trung', 'Quang Trung'),
('13684', 'WARD', '356', 'Lộc Hạ', 'Loc Ha'),
('13687', 'WARD', '356', 'Lộc Vượng', 'Loc Vuong'),
('13690', 'WARD', '356', 'Cửa Nam', 'Cua Nam'),
('13693', 'WARD', '356', 'Lộc Hòa', 'Loc Hoa'),
('13696', 'WARD', '356', 'Nam Phong', 'Nam Phong'),
('13699', 'WARD', '356', 'Mỹ Xá', 'My Xa'),
('13705', 'WARD', '356', 'Nam Vân', 'Nam Van'),
('13708', 'WARD', '356', 'Hưng Lộc', 'Hung Loc'),
('13711', 'WARD', '356', 'Mỹ Hà', 'My Ha'),
('13717', 'WARD', '356', 'Mỹ Thắng', 'My Thang'),
('13720', 'WARD', '356', 'Mỹ Trung', 'My Trung'),
('13723', 'WARD', '356', 'Mỹ Tân', 'My Tan'),
('13726', 'WARD', '356', 'Mỹ Phúc', 'My Phuc'),
('13732', 'WARD', '356', 'Mỹ Thuận', 'My Thuan'),
('13735', 'WARD', '356', 'Mỹ Lộc', 'My Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 359 - Vụ Bản
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13741', 'WARD', '359', 'Thị trấn Gôi', 'Thi tran Goi'),
('13747', 'WARD', '359', 'Hiển Khánh', 'Hien Khanh'),
('13750', 'WARD', '359', 'Minh Tân', 'Minh Tan'),
('13753', 'WARD', '359', 'Hợp Hưng', 'Hop Hung'),
('13756', 'WARD', '359', 'Đại An', 'Dai An'),
('13762', 'WARD', '359', 'Cộng Hòa', 'Cong Hoa'),
('13765', 'WARD', '359', 'Trung Thành', 'Trung Thanh'),
('13768', 'WARD', '359', 'Quang Trung', 'Quang Trung'),
('13777', 'WARD', '359', 'Thành Lợi', 'Thanh Loi'),
('13780', 'WARD', '359', 'Kim Thái', 'Kim Thai'),
('13783', 'WARD', '359', 'Liên Minh', 'Lien Minh'),
('13786', 'WARD', '359', 'Đại Thắng', 'Dai Thang'),
('13789', 'WARD', '359', 'Tam Thanh', 'Tam Thanh'),
('13792', 'WARD', '359', 'Vĩnh Hào', 'Vinh Hao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 360 - Ý Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13795', 'WARD', '360', 'Thị trấn Lâm', 'Thi tran Lam'),
('13801', 'WARD', '360', 'Trung Nghĩa', 'Trung Nghia'),
('13807', 'WARD', '360', 'Tân Minh', 'Tan Minh'),
('13810', 'WARD', '360', 'Yên Thọ', 'Yen Tho'),
('13819', 'WARD', '360', 'Phú Hưng', 'Phu Hung'),
('13822', 'WARD', '360', 'Yên Chính', 'Yen Chinh'),
('13825', 'WARD', '360', 'Yên Bình', 'Yen Binh'),
('13831', 'WARD', '360', 'Yên Mỹ', 'Yen My'),
('13834', 'WARD', '360', 'Yên Dương', 'Yen Duong'),
('13843', 'WARD', '360', 'Yên Khánh', 'Yen Khanh'),
('13846', 'WARD', '360', 'Yên Phong', 'Yen Phong'),
('13849', 'WARD', '360', 'Yên Ninh', 'Yen Ninh'),
('13852', 'WARD', '360', 'Yên Lương', 'Yen Luong'),
('13861', 'WARD', '360', 'Yên Tiến', 'Yen Tien'),
('13864', 'WARD', '360', 'Yên Thắng', 'Yen Thang'),
('13867', 'WARD', '360', 'Yên Phúc', 'Yen Phuc'),
('13870', 'WARD', '360', 'Yên Cường', 'Yen Cuong'),
('13873', 'WARD', '360', 'Yên Lộc', 'Yen Loc'),
('13876', 'WARD', '360', 'Hồng Quang', 'Hong Quang'),
('13879', 'WARD', '360', 'Yên Đồng', 'Yen Dong'),
('13882', 'WARD', '360', 'Yên Khang', 'Yen Khang'),
('13885', 'WARD', '360', 'Yên Nhân', 'Yen Nhan'),
('13888', 'WARD', '360', 'Yên Trị', 'Yen Tri')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 361 - Nghĩa Hưng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13891', 'WARD', '361', 'Thị trấn Liễu Đề', 'Thi tran Lieu De'),
('13894', 'WARD', '361', 'Thị trấn Rạng Đông', 'Thi tran Rang Dong'),
('13900', 'WARD', '361', 'Đồng Thịnh', 'Dong Thinh'),
('13906', 'WARD', '361', 'Nghĩa Thái', 'Nghia Thai'),
('13909', 'WARD', '361', 'Hoàng Nam', 'Hoang Nam'),
('13912', 'WARD', '361', 'Nghĩa Châu', 'Nghia Chau'),
('13915', 'WARD', '361', 'Nghĩa Trung', 'Nghia Trung'),
('13918', 'WARD', '361', 'Nghĩa Sơn', 'Nghia Son'),
('13921', 'WARD', '361', 'Nghĩa Lạc', 'Nghia Lac'),
('13924', 'WARD', '361', 'Nghĩa Hồng', 'Nghia Hong'),
('13927', 'WARD', '361', 'Nghĩa Phong', 'Nghia Phong'),
('13930', 'WARD', '361', 'Nghĩa Phú', 'Nghia Phu'),
('13939', 'WARD', '361', 'Thị trấn Quỹ Nhất', 'Thi tran Quy Nhat'),
('13942', 'WARD', '361', 'Nghĩa Hùng', 'Nghia Hung'),
('13945', 'WARD', '361', 'Nghĩa Lâm', 'Nghia Lam'),
('13948', 'WARD', '361', 'Nghĩa Thành', 'Nghia Thanh'),
('13951', 'WARD', '361', 'Phúc Thắng', 'Phuc Thang'),
('13954', 'WARD', '361', 'Nghĩa Lợi', 'Nghia Loi'),
('13957', 'WARD', '361', 'Nghĩa Hải', 'Nghia Hai'),
('13963', 'WARD', '361', 'Nam Điền', 'Nam Dien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 362 - Nam Trực
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('13966', 'WARD', '362', 'Thị trấn Nam Giang', 'Thi tran Nam Giang'),
('13972', 'WARD', '362', 'Nam Điền', 'Nam Dien'),
('13975', 'WARD', '362', 'Nghĩa An', 'Nghia An'),
('13978', 'WARD', '362', 'Nam Thắng', 'Nam Thang'),
('13984', 'WARD', '362', 'Hồng Quang', 'Hong Quang'),
('13987', 'WARD', '362', 'Tân Thịnh', 'Tan Thinh'),
('13990', 'WARD', '362', 'Nam Cường', 'Nam Cuong'),
('13993', 'WARD', '362', 'Nam Hồng', 'Nam Hong'),
('13996', 'WARD', '362', 'Nam Hùng', 'Nam Hung'),
('13999', 'WARD', '362', 'Nam Hoa', 'Nam Hoa'),
('14002', 'WARD', '362', 'Nam Dương', 'Nam Duong'),
('14005', 'WARD', '362', 'Nam Thanh', 'Nam Thanh'),
('14008', 'WARD', '362', 'Nam Lợi', 'Nam Loi'),
('14011', 'WARD', '362', 'Bình Minh', 'Binh Minh'),
('14014', 'WARD', '362', 'Đồng Sơn', 'Dong Son'),
('14017', 'WARD', '362', 'Nam Tiến', 'Nam Tien'),
('14020', 'WARD', '362', 'Nam Hải', 'Nam Hai'),
('14023', 'WARD', '362', 'Nam Thái', 'Nam Thai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 363 - Trực Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14026', 'WARD', '363', 'Thị trấn Cổ Lễ', 'Thi tran Co Le'),
('14029', 'WARD', '363', 'Phương Định', 'Dinh'),
('14032', 'WARD', '363', 'Trực Chính', 'Truc Chinh'),
('14035', 'WARD', '363', 'Trung Đông', 'Trung Dong'),
('14038', 'WARD', '363', 'Liêm Hải', 'Liem Hai'),
('14041', 'WARD', '363', 'Trực Tuấn', 'Truc Tuan'),
('14044', 'WARD', '363', 'Việt Hùng', 'Viet Hung'),
('14047', 'WARD', '363', 'Trực Đạo', 'Truc Dao'),
('14050', 'WARD', '363', 'Trực Hưng', 'Truc Hung'),
('14053', 'WARD', '363', 'Trực Nội', 'Truc Noi'),
('14056', 'WARD', '363', 'Thị trấn Cát Thành', 'Thi tran Cat Thanh'),
('14059', 'WARD', '363', 'Trực Thanh', 'Truc Thanh'),
('14062', 'WARD', '363', 'Trực Khang', 'Truc Khang'),
('14065', 'WARD', '363', 'Trực Thuận', 'Truc Thuan'),
('14068', 'WARD', '363', 'Trực Mỹ', 'Truc My'),
('14071', 'WARD', '363', 'Trực Đại', 'Truc Dai'),
('14074', 'WARD', '363', 'Trực Cường', 'Truc Cuong'),
('14077', 'WARD', '363', 'Thị trấn Ninh Cường', 'Thi tran Ninh Cuong'),
('14080', 'WARD', '363', 'Trực Thái', 'Truc Thai'),
('14083', 'WARD', '363', 'Trực Hùng', 'Truc Hung'),
('14086', 'WARD', '363', 'Trực Thắng', 'Truc Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 364 - Xuân Trường
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14089', 'WARD', '364', 'Thị trấn Xuân Trường', 'Thi tran Xuan Truong'),
('14092', 'WARD', '364', 'Xuân Châu', 'Xuan Chau'),
('14095', 'WARD', '364', 'Xuân Hồng', 'Xuan Hong'),
('14098', 'WARD', '364', 'Xuân Thành', 'Xuan Thanh'),
('14101', 'WARD', '364', 'Xuân Thượng', 'Xuan Thuong'),
('14104', 'WARD', '364', 'Xuân Giang', 'Xuan Giang'),
('14110', 'WARD', '364', 'Xuân Tân', 'Xuan Tan'),
('14116', 'WARD', '364', 'Xuân Ngọc', 'Xuan Ngoc'),
('14122', 'WARD', '364', 'Trà Lũ', 'Tra Lu'),
('14125', 'WARD', '364', 'Thọ Nghiệp', 'Tho Nghiep'),
('14128', 'WARD', '364', 'Xuân Phú', 'Xuan Phu'),
('14134', 'WARD', '364', 'Xuân Vinh', 'Xuan Vinh'),
('14143', 'WARD', '364', 'Xuân Ninh', 'Xuan Ninh'),
('14146', 'WARD', '364', 'Xuân Phúc', 'Xuan Phuc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 365 - Giao Thủy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14152', 'WARD', '365', 'Thị trấn Quất Lâm', 'Thi tran Quat Lam'),
('14155', 'WARD', '365', 'Giao Hương', 'Giao Huong'),
('14158', 'WARD', '365', 'Hồng Thuận', 'Hong Thuan'),
('14161', 'WARD', '365', 'Giao Thiện', 'Giao Thien'),
('14164', 'WARD', '365', 'Giao Thanh', 'Giao Thanh'),
('14167', 'WARD', '365', 'Thị trấn Giao Thủy', 'Thi tran Giao Thuy'),
('14170', 'WARD', '365', 'Bình Hòa', 'Binh Hoa'),
('14176', 'WARD', '365', 'Giao Hà', 'Giao Ha'),
('14179', 'WARD', '365', 'Giao Nhân', 'Giao Nhan'),
('14182', 'WARD', '365', 'Giao An', 'Giao An'),
('14185', 'WARD', '365', 'Giao Lạc', 'Giao Lac'),
('14188', 'WARD', '365', 'Giao Châu', 'Giao Chau'),
('14191', 'WARD', '365', 'Giao Tân', 'Giao Tan'),
('14194', 'WARD', '365', 'Giao Yến', 'Giao Yen'),
('14197', 'WARD', '365', 'Giao Xuân', 'Giao Xuan'),
('14200', 'WARD', '365', 'Giao Thịnh', 'Giao Thinh'),
('14203', 'WARD', '365', 'Giao Hải', 'Giao Hai'),
('14206', 'WARD', '365', 'Bạch Long', 'Bach Long'),
('14209', 'WARD', '365', 'Giao Long', 'Giao Long'),
('14212', 'WARD', '365', 'Giao Phong', 'Giao Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 366 - Hải Hậu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14215', 'WARD', '366', 'Thị trấn Yên Định', 'Thi tran Yen Dinh'),
('14218', 'WARD', '366', 'Thị trấn Cồn', 'Thi tran Con'),
('14221', 'WARD', '366', 'Thị trấn Thịnh Long', 'Thi tran Thinh Long'),
('14224', 'WARD', '366', 'Hải Nam', 'Hai Nam'),
('14227', 'WARD', '366', 'Hải Trung', 'Hai Trung'),
('14233', 'WARD', '366', 'Hải Minh', 'Hai Minh'),
('14236', 'WARD', '366', 'Hải Anh', 'Hai Anh'),
('14248', 'WARD', '366', 'Hải Hưng', 'Hai Hung'),
('14254', 'WARD', '366', 'Hải Long', 'Hai Long'),
('14260', 'WARD', '366', 'Hải Đường', 'Hai Duong'),
('14263', 'WARD', '366', 'Hải Lộc', 'Hai Loc'),
('14266', 'WARD', '366', 'Hải Quang', 'Hai Quang'),
('14269', 'WARD', '366', 'Hải Đông', 'Hai Dong'),
('14272', 'WARD', '366', 'Hải Sơn', 'Hai Son'),
('14275', 'WARD', '366', 'Hải Tân', 'Hai Tan'),
('14281', 'WARD', '366', 'Hải Phong', 'Hai Phong'),
('14284', 'WARD', '366', 'Hải An', 'Hai An'),
('14287', 'WARD', '366', 'Hải Tây', 'Hai Tay'),
('14293', 'WARD', '366', 'Hải Phú', 'Hai Phu'),
('14296', 'WARD', '366', 'Hải Giang', 'Hai Giang'),
('14302', 'WARD', '366', 'Hải Ninh', 'Hai Ninh'),
('14308', 'WARD', '366', 'Hải Xuân', 'Hai Xuan'),
('14311', 'WARD', '366', 'Hải Châu', 'Hai Chau'),
('14317', 'WARD', '366', 'Hải Hòa', 'Hai Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 37 - Ninh Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('370', 'DISTRICT', '37', 'Tam Điệp', 'Thanh pho Tam Diep'),
('372', 'DISTRICT', '37', 'Nho Quan', 'Nho Quan'),
('373', 'DISTRICT', '37', 'Gia Viễn', 'Gia Vien'),
('374', 'DISTRICT', '37', 'Hoa Lư', 'Thanh pho Hoa Lu'),
('375', 'DISTRICT', '37', 'Yên Khánh', 'Yen Khanh'),
('376', 'DISTRICT', '37', 'Kim Sơn', 'Kim Son'),
('377', 'DISTRICT', '37', 'Yên Mô', 'Yen Mo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 370 - Tam Điệp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14362', 'WARD', '370', 'Bắc Sơn', 'Bac Son'),
('14365', 'WARD', '370', 'Trung Sơn', 'Trung Son'),
('14368', 'WARD', '370', 'Nam Sơn', 'Nam Son'),
('14369', 'WARD', '370', 'Tây Sơn', 'Tay Son'),
('14371', 'WARD', '370', 'Yên Sơn', 'Yen Son'),
('14374', 'WARD', '370', 'Yên Bình', 'Yen Binh'),
('14375', 'WARD', '370', 'Tân Bình', 'Tan Binh'),
('14377', 'WARD', '370', 'Quang Sơn', 'Quang Son'),
('14380', 'WARD', '370', 'Đông Sơn', 'Dong Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 372 - Nho Quan
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14386', 'WARD', '372', 'Xích Thổ', 'Xich Tho'),
('14389', 'WARD', '372', 'Gia Lâm', 'Gia Lam'),
('14392', 'WARD', '372', 'Gia Sơn', 'Gia Son'),
('14395', 'WARD', '372', 'Thạch Bình', 'Thach Binh'),
('14398', 'WARD', '372', 'Gia Thủy', 'Gia Thuy'),
('14401', 'WARD', '372', 'Gia Tường', 'Gia Tuong'),
('14404', 'WARD', '372', 'Cúc Phương', 'Cuc Phuong'),
('14407', 'WARD', '372', 'Phú Sơn', 'Phu Son'),
('14410', 'WARD', '372', 'Đức Long', 'Duc Long'),
('14413', 'WARD', '372', 'Lạc Vân', 'Lac Van'),
('14416', 'WARD', '372', 'Đồng Phong', 'Dong Phong'),
('14419', 'WARD', '372', 'Yên Quang', 'Yen Quang'),
('14425', 'WARD', '372', 'Thượng Hòa', 'Thuong Hoa'),
('14428', 'WARD', '372', 'Thị trấn Nho Quan', 'Thi tran Nho Quan'),
('14431', 'WARD', '372', 'Văn Phương', 'Van Phuong'),
('14434', 'WARD', '372', 'Thanh Sơn', 'Thanh Son'),
('14437', 'WARD', '372', 'Phúc Sơn', 'Phuc Son'),
('14443', 'WARD', '372', 'Văn Phú', 'Van Phu'),
('14446', 'WARD', '372', 'Phú Lộc', 'Phu Loc'),
('14449', 'WARD', '372', 'Kỳ Phú', 'Ky Phu'),
('14452', 'WARD', '372', 'Quỳnh Lưu', 'Quynh Luu'),
('14458', 'WARD', '372', 'Phú Long', 'Phu Long'),
('14461', 'WARD', '372', 'Quảng Lạc', 'Quang Lac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 373 - Gia Viễn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14464', 'WARD', '373', 'Thị trấn Thịnh Vượng', 'Thi tran Thinh Vuong'),
('14467', 'WARD', '373', 'Gia Hòa', 'Gia Hoa'),
('14470', 'WARD', '373', 'Gia Hưng', 'Gia Hung'),
('14473', 'WARD', '373', 'Liên Sơn', 'Lien Son'),
('14476', 'WARD', '373', 'Gia Thanh', 'Gia Thanh'),
('14479', 'WARD', '373', 'Gia Vân', 'Gia Van'),
('14482', 'WARD', '373', 'Gia Phú', 'Gia Phu'),
('14485', 'WARD', '373', 'Gia Xuân', 'Gia Xuan'),
('14488', 'WARD', '373', 'Gia Lập', 'Gia Lap'),
('14494', 'WARD', '373', 'Gia Trấn', 'Gia Tran'),
('14500', 'WARD', '373', 'Gia Phương', 'Gia Phuong'),
('14503', 'WARD', '373', 'Gia Tân', 'Gia Tan'),
('14506', 'WARD', '373', 'Tiến Thắng', 'Tien Thang'),
('14509', 'WARD', '373', 'Gia Trung', 'Gia Trung'),
('14512', 'WARD', '373', 'Gia Minh', 'Gia Minh'),
('14515', 'WARD', '373', 'Gia Lạc', 'Gia Lac'),
('14521', 'WARD', '373', 'Gia Sinh', 'Gia Sinh'),
('14524', 'WARD', '373', 'Gia Phong', 'Gia Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 374 - Hoa Lư
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14320', 'WARD', '374', 'Đông Thành', 'Dong Thanh'),
('14323', 'WARD', '374', 'Tân Thành', 'Tan Thanh'),
('14329', 'WARD', '374', 'Vân Giang', 'Van Giang'),
('14332', 'WARD', '374', 'Bích Đào', 'Bich Dao'),
('14338', 'WARD', '374', 'Nam Bình', 'Nam Binh'),
('14341', 'WARD', '374', 'Nam Thành', 'Nam Thanh'),
('14344', 'WARD', '374', 'Ninh Khánh', 'Ninh Khanh'),
('14347', 'WARD', '374', 'Ninh Nhất', 'Ninh Nhat'),
('14350', 'WARD', '374', 'Ninh Tiến', 'Ninh Tien'),
('14353', 'WARD', '374', 'Ninh Phúc', 'Ninh Phuc'),
('14356', 'WARD', '374', 'Ninh Sơn', 'Ninh Son'),
('14359', 'WARD', '374', 'Ninh Phong', 'Ninh Phong'),
('14527', 'WARD', '374', 'Ninh Mỹ', 'Ninh My'),
('14530', 'WARD', '374', 'Ninh Giang', 'Ninh Giang'),
('14533', 'WARD', '374', 'Trường Yên', 'Truong Yen'),
('14536', 'WARD', '374', 'Ninh Khang', 'Ninh Khang'),
('14542', 'WARD', '374', 'Ninh Hòa', 'Ninh Hoa'),
('14551', 'WARD', '374', 'Ninh Hải', 'Ninh Hai'),
('14554', 'WARD', '374', 'Ninh Vân', 'Ninh Van'),
('14557', 'WARD', '374', 'Ninh An', 'Ninh An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 375 - Yên Khánh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14560', 'WARD', '375', 'Thị trấn Yên Ninh', 'Thi tran Yen Ninh'),
('14563', 'WARD', '375', 'Khánh Thiện', 'Khanh Thien'),
('14566', 'WARD', '375', 'Khánh Phú', 'Khanh Phu'),
('14569', 'WARD', '375', 'Khánh Hòa', 'Khanh Hoa'),
('14572', 'WARD', '375', 'Khánh Lợi', 'Khanh Loi'),
('14575', 'WARD', '375', 'Khánh An', 'Khanh An'),
('14578', 'WARD', '375', 'Khánh Cường', 'Khanh Cuong'),
('14581', 'WARD', '375', 'Khánh Cư', 'Khanh Cu'),
('14587', 'WARD', '375', 'Khánh Hải', 'Khanh Hai'),
('14590', 'WARD', '375', 'Khánh Trung', 'Khanh Trung'),
('14593', 'WARD', '375', 'Khánh Mậu', 'Khanh Mau'),
('14596', 'WARD', '375', 'Khánh Vân', 'Khanh Van'),
('14599', 'WARD', '375', 'Khánh Hội', 'Khanh Hoi'),
('14602', 'WARD', '375', 'Khánh Công', 'Khanh Cong'),
('14608', 'WARD', '375', 'Khánh Thành', 'Khanh Thanh'),
('14611', 'WARD', '375', 'Khánh Nhạc', 'Khanh Nhac'),
('14614', 'WARD', '375', 'Khánh Thủy', 'Khanh Thuy'),
('14617', 'WARD', '375', 'Khánh Hồng', 'Khanh Hong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 376 - Kim Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14620', 'WARD', '376', 'Thị trấn Phát Diệm', 'Thi tran Phat Diem'),
('14623', 'WARD', '376', 'Thị trấn Bình Minh', 'Thi tran Binh Minh'),
('14629', 'WARD', '376', 'Hồi Ninh', 'Hoi Ninh'),
('14632', 'WARD', '376', 'Xuân Chính', 'Xuan Chinh'),
('14635', 'WARD', '376', 'Kim Định', 'Kim Dinh'),
('14638', 'WARD', '376', 'Ân Hòa', 'An Hoa'),
('14641', 'WARD', '376', 'Hùng Tiến', 'Hung Tien'),
('14647', 'WARD', '376', 'Quang Thiện', 'Quang Thien'),
('14650', 'WARD', '376', 'Như Hòa', 'Nhu Hoa'),
('14653', 'WARD', '376', 'Chất Bình', 'Chat Binh'),
('14656', 'WARD', '376', 'Đồng Hướng', 'Dong Huong'),
('14659', 'WARD', '376', 'Kim Chính', 'Kim Chinh'),
('14662', 'WARD', '376', 'Thượng Kiệm', 'Thuong Kiem'),
('14668', 'WARD', '376', 'Tân Thành', 'Tan Thanh'),
('14671', 'WARD', '376', 'Yên Lộc', 'Yen Loc'),
('14674', 'WARD', '376', 'Lai Thành', 'Lai Thanh'),
('14677', 'WARD', '376', 'Định Hóa', 'Dinh Hoa'),
('14680', 'WARD', '376', 'Văn Hải', 'Van Hai'),
('14683', 'WARD', '376', 'Kim Tân', 'Kim Tan'),
('14686', 'WARD', '376', 'Kim Mỹ', 'Kim My'),
('14689', 'WARD', '376', 'Cồn Thoi', 'Con Thoi'),
('14695', 'WARD', '376', 'Kim Trung', 'Kim Trung'),
('14698', 'WARD', '376', 'Kim Đông', 'Kim Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 377 - Yên Mô
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14701', 'WARD', '377', 'Thị trấn Yên Thịnh', 'Thi tran Yen Thinh'),
('14704', 'WARD', '377', 'Khánh Thượng', 'Khanh Thuong'),
('14707', 'WARD', '377', 'Khánh Dương', 'Khanh Duong'),
('14719', 'WARD', '377', 'Yên Phong', 'Yen Phong'),
('14722', 'WARD', '377', 'Yên Hòa', 'Yen Hoa'),
('14725', 'WARD', '377', 'Yên Thắng', 'Yen Thang'),
('14728', 'WARD', '377', 'Yên Từ', 'Yen Tu'),
('14734', 'WARD', '377', 'Yên Thành', 'Yen Thanh'),
('14737', 'WARD', '377', 'Yên Nhân', 'Yen Nhan'),
('14740', 'WARD', '377', 'Yên Mỹ', 'Yen My'),
('14743', 'WARD', '377', 'Yên Mạc', 'Yen Mac'),
('14746', 'WARD', '377', 'Yên Đồng', 'Yen Dong'),
('14749', 'WARD', '377', 'Yên Thái', 'Yen Thai'),
('14752', 'WARD', '377', 'Yên Lâm', 'Yen Lam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 38 - Thanh Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('380', 'DISTRICT', '38', 'Thanh Hóa', 'Thanh pho Thanh Hoa'),
('381', 'DISTRICT', '38', 'Thị Bỉm Sơn', 'Thi Bim Son'),
('382', 'DISTRICT', '38', 'Sầm Sơn', 'Thanh pho Sam Son'),
('384', 'DISTRICT', '38', 'Mường Lát', 'Muong Lat'),
('385', 'DISTRICT', '38', 'Hóa', 'Hoa'),
('386', 'DISTRICT', '38', 'Bá Thước', 'Ba Thuoc'),
('387', 'DISTRICT', '38', 'Sơn', 'Son'),
('388', 'DISTRICT', '38', 'Lang Chánh', 'Lang Chanh'),
('389', 'DISTRICT', '38', 'Ngọc Lặc', 'Ngoc Lac'),
('390', 'DISTRICT', '38', 'Cẩm Thủy', 'Cam Thuy'),
('391', 'DISTRICT', '38', 'Thạch Thành', 'Thach Thanh'),
('392', 'DISTRICT', '38', 'Hà Trung', 'Ha Trung'),
('393', 'DISTRICT', '38', 'Vĩnh Lộc', 'Vinh Loc'),
('394', 'DISTRICT', '38', 'Yên Định', 'Yen Dinh'),
('395', 'DISTRICT', '38', 'Thọ Xuân', 'Tho Xuan'),
('396', 'DISTRICT', '38', 'Thường Xuân', 'Thuong Xuan'),
('397', 'DISTRICT', '38', 'Triệu Sơn', 'Trieu Son'),
('398', 'DISTRICT', '38', 'Thiệu Hóa', 'Thieu Hoa'),
('399', 'DISTRICT', '38', 'Hoằng Hóa', 'Hoang Hoa'),
('400', 'DISTRICT', '38', 'Hậu Lộc', 'Hau Loc'),
('401', 'DISTRICT', '38', 'Nga Sơn', 'Nga Son'),
('402', 'DISTRICT', '38', 'Như Xuân', 'Nhu Xuan'),
('403', 'DISTRICT', '38', 'Như Thanh', 'Nhu Thanh'),
('404', 'DISTRICT', '38', 'Nông Cống', 'Nong Cong'),
('406', 'DISTRICT', '38', 'Quảng Xương', 'Quang Xuong'),
('407', 'DISTRICT', '38', 'Thị Nghi Sơn', 'Thi Nghi Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 380 - Thanh Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14755', 'WARD', '380', 'Hàm Rồng', 'Ham Rong'),
('14758', 'WARD', '380', 'Đông Thọ', 'Dong Tho'),
('14761', 'WARD', '380', 'Nam Ngạn', 'Nam Ngan'),
('14764', 'WARD', '380', 'Trường Thi', 'Truong Thi'),
('14767', 'WARD', '380', 'Điện Biên', 'Dien Bien'),
('14770', 'WARD', '380', 'Phú Sơn', 'Phu Son'),
('14773', 'WARD', '380', 'Lam Sơn', 'Lam Son'),
('14776', 'WARD', '380', 'Ba Đình', 'Ba Dinh'),
('14779', 'WARD', '380', 'Ngọc Trạo', 'Ngoc Trao'),
('14782', 'WARD', '380', 'Đông Vệ', 'Dong Ve'),
('14785', 'WARD', '380', 'Đông Sơn', 'Dong Son'),
('14791', 'WARD', '380', 'Đông Cương', 'Dong Cuong'),
('14794', 'WARD', '380', 'Đông Hương', 'Dong Huong'),
('14797', 'WARD', '380', 'Đông Hải', 'Dong Hai'),
('14800', 'WARD', '380', 'Quảng Hưng', 'Quang Hung'),
('14803', 'WARD', '380', 'Quảng Thắng', 'Quang Thang'),
('14806', 'WARD', '380', 'Quảng Thành', 'Quang Thanh'),
('15850', 'WARD', '380', 'Thiệu Vân', 'Thieu Van'),
('15856', 'WARD', '380', 'Thiệu Khánh', 'Thieu Khanh'),
('15859', 'WARD', '380', 'Thiệu Dương', 'Thieu Duong'),
('15913', 'WARD', '380', 'Tào Xuyên', 'Tao Xuyen'),
('15922', 'WARD', '380', 'Long Anh', 'Long Anh'),
('15925', 'WARD', '380', 'Hoằng Quang', 'Hoang Quang'),
('15970', 'WARD', '380', 'Hoằng Đại', 'Hoang Dai'),
('16378', 'WARD', '380', 'Rừng Thông', 'Rung Thong'),
('16381', 'WARD', '380', 'Đông Hoàng', 'Dong Hoang'),
('16384', 'WARD', '380', 'Đông Ninh', 'Dong Ninh'),
('16387', 'WARD', '380', 'Đông Khê', 'Dong Khe'),
('16390', 'WARD', '380', 'Đông Hòa', 'Dong Hoa'),
('16393', 'WARD', '380', 'Đông Yên', 'Dong Yen'),
('16396', 'WARD', '380', 'Đông Lĩnh', 'Dong Linh'),
('16399', 'WARD', '380', 'Đông Minh', 'Dong Minh'),
('16402', 'WARD', '380', 'Đông Thanh', 'Dong Thanh'),
('16405', 'WARD', '380', 'Đông Tiến', 'Dong Tien'),
('16408', 'WARD', '380', 'Đông Khê', 'Dong Khe'),
('16411', 'WARD', '380', 'Đông Xuân', 'Dong Xuan'),
('16414', 'WARD', '380', 'Đông Thịnh', 'Dong Thinh'),
('16417', 'WARD', '380', 'Đông Văn', 'Dong Van'),
('16420', 'WARD', '380', 'Đông Phú', 'Dong Phu'),
('16423', 'WARD', '380', 'Đông Nam', 'Dong Nam'),
('16426', 'WARD', '380', 'Đông Quang', 'Dong Quang'),
('16429', 'WARD', '380', 'Đông Vinh', 'Dong Vinh'),
('16432', 'WARD', '380', 'Đông Tân', 'Dong Tan'),
('16435', 'WARD', '380', 'An Hưng', 'An Hung'),
('16441', 'WARD', '380', 'Quảng Thịnh', 'Quang Thinh'),
('16459', 'WARD', '380', 'Quảng Đông', 'Quang Dong'),
('16507', 'WARD', '380', 'Quảng Cát', 'Quang Cat'),
('16522', 'WARD', '380', 'Quảng Phú', 'Quang Phu'),
('16525', 'WARD', '380', 'Quảng Tâm', 'Quang Tam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 381 - Thị Bỉm Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14809', 'WARD', '381', 'Bắc Sơn', 'Bac Son'),
('14812', 'WARD', '381', 'Ba Đình', 'Ba Dinh'),
('14815', 'WARD', '381', 'Lam Sơn', 'Lam Son'),
('14818', 'WARD', '381', 'Ngọc Trạo', 'Ngoc Trao'),
('14821', 'WARD', '381', 'Đông Sơn', 'Dong Son'),
('14823', 'WARD', '381', 'Phú Sơn', 'Phu Son'),
('14824', 'WARD', '381', 'Quang Trung', 'Quang Trung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 382 - Sầm Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14830', 'WARD', '382', 'Trung Sơn', 'Trung Son'),
('14833', 'WARD', '382', 'Bắc Sơn', 'Bac Son'),
('14836', 'WARD', '382', 'Trường Sơn', 'Truong Son'),
('14839', 'WARD', '382', 'Quảng Cư', 'Quang Cu'),
('14842', 'WARD', '382', 'Quảng Tiến', 'Quang Tien'),
('16513', 'WARD', '382', 'Quảng Minh', 'Quang Minh'),
('16516', 'WARD', '382', 'Đại Hùng', 'Dai Hung'),
('16528', 'WARD', '382', 'Quảng Thọ', 'Quang Tho'),
('16531', 'WARD', '382', 'Quảng Châu', 'Quang Chau'),
('16534', 'WARD', '382', 'Quảng Vinh', 'Quang Vinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 384 - Mường Lát
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14845', 'WARD', '384', 'Thị trấn Mường Lát', 'Thi tran Muong Lat'),
('14848', 'WARD', '384', 'Tam Chung', 'Tam Chung'),
('14854', 'WARD', '384', 'Mường Lý', 'Muong Ly'),
('14857', 'WARD', '384', 'Trung Lý', 'Trung Ly'),
('14860', 'WARD', '384', 'Quang Chiểu', 'Quang Chieu'),
('14863', 'WARD', '384', 'Pù Nhi', 'Pu Nhi'),
('14864', 'WARD', '384', 'Nhi Sơn', 'Nhi Son'),
('14866', 'WARD', '384', 'Mường Chanh', 'Muong Chanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 385 - Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14869', 'WARD', '385', 'Thị trấn Hồi Xuân', 'Thi tran Hoi Xuan'),
('14872', 'WARD', '385', 'Thành Sơn', 'Thanh Son'),
('14875', 'WARD', '385', 'Trung Sơn', 'Trung Son'),
('14878', 'WARD', '385', 'Phú Thanh', 'Phu Thanh'),
('14881', 'WARD', '385', 'Trung Thành', 'Trung Thanh'),
('14884', 'WARD', '385', 'Phú Lệ', 'Phu Le'),
('14887', 'WARD', '385', 'Phú Sơn', 'Phu Son'),
('14890', 'WARD', '385', 'Phú Xuân', 'Phu Xuan'),
('14896', 'WARD', '385', 'Hiền Chung', 'Hien Chung'),
('14899', 'WARD', '385', 'Hiền Kiệt', 'Hien Kiet'),
('14902', 'WARD', '385', 'Nam Tiến', 'Nam Tien'),
('14908', 'WARD', '385', 'Thiên Phủ', 'Thien Phu'),
('14911', 'WARD', '385', 'Phú Nghiêm', 'Phu Nghiem'),
('14914', 'WARD', '385', 'Nam Xuân', 'Nam Xuan'),
('14917', 'WARD', '385', 'Nam Động', 'Nam Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 386 - Bá Thước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14923', 'WARD', '386', 'Thị trấn Cành Nàng', 'Thi tran Canh Nang'),
('14926', 'WARD', '386', 'Điền Thượng', 'Dien Thuong'),
('14929', 'WARD', '386', 'Điền Hạ', 'Dien Ha'),
('14932', 'WARD', '386', 'Điền Quang', 'Dien Quang'),
('14935', 'WARD', '386', 'Điền Trung', 'Dien Trung'),
('14938', 'WARD', '386', 'Thành Sơn', 'Thanh Son'),
('14941', 'WARD', '386', 'Lương Ngoại', 'Luong Ngoai'),
('14944', 'WARD', '386', 'Ái Thượng', 'Ai Thuong'),
('14947', 'WARD', '386', 'Lương Nội', 'Luong Noi'),
('14950', 'WARD', '386', 'Điền Lư', 'Dien Lu'),
('14953', 'WARD', '386', 'Lương Trung', 'Luong Trung'),
('14956', 'WARD', '386', 'Lũng Niêm', 'Lung Niem'),
('14959', 'WARD', '386', 'Lũng Cao', 'Lung Cao'),
('14962', 'WARD', '386', 'Hạ Trung', 'Ha Trung'),
('14965', 'WARD', '386', 'Cổ Lũng', 'Co Lung'),
('14968', 'WARD', '386', 'Thành Lâm', 'Thanh Lam'),
('14971', 'WARD', '386', 'Ban Công', 'Ban Cong'),
('14974', 'WARD', '386', 'Kỳ Tân', 'Ky Tan'),
('14977', 'WARD', '386', 'Văn Nho', 'Van Nho'),
('14980', 'WARD', '386', 'Thiết Ống', 'Thiet Ong'),
('14986', 'WARD', '386', 'Thiết Kế', 'Thiet Ke')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 387 - Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('14995', 'WARD', '387', 'Trung Xuân', 'Trung Xuan'),
('14998', 'WARD', '387', 'Trung Thượng', 'Trung Thuong'),
('14999', 'WARD', '387', 'Trung Tiến', 'Trung Tien'),
('15001', 'WARD', '387', 'Trung Hạ', 'Trung Ha'),
('15004', 'WARD', '387', 'Sơn Hà', 'Son Ha'),
('15007', 'WARD', '387', 'Tam Thanh', 'Tam Thanh'),
('15010', 'WARD', '387', 'Sơn Thủy', 'Son Thuy'),
('15013', 'WARD', '387', 'Na Mèo', 'Na Meo'),
('15016', 'WARD', '387', 'Thị trấn Sơn Lư', 'Thi tran Son Lu'),
('15019', 'WARD', '387', 'Tam Lư', 'Tam Lu'),
('15022', 'WARD', '387', 'Sơn Điện', 'Son Dien'),
('15025', 'WARD', '387', 'Mường Mìn', 'Muong Min')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 388 - Lang Chánh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15031', 'WARD', '388', 'Yên Khương', 'Yen Khuong'),
('15034', 'WARD', '388', 'Yên Thắng', 'Yen Thang'),
('15037', 'WARD', '388', 'Trí Nang', 'Tri Nang'),
('15040', 'WARD', '388', 'Giao An', 'Giao An'),
('15043', 'WARD', '388', 'Giao Thiện', 'Giao Thien'),
('15046', 'WARD', '388', 'Tân Phúc', 'Tan Phuc'),
('15049', 'WARD', '388', 'Tam Văn', 'Tam Van'),
('15052', 'WARD', '388', 'Lâm Phú', 'Lam Phu'),
('15055', 'WARD', '388', 'Thị trấn Lang Chánh', 'Thi tran Lang Chanh'),
('15058', 'WARD', '388', 'Đồng Lương', 'Dong Luong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 389 - Ngọc Lặc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15061', 'WARD', '389', 'Thị trấn Ngọc Lặc', 'Thi tran Ngoc Lac'),
('15064', 'WARD', '389', 'Lam Sơn', 'Lam Son'),
('15067', 'WARD', '389', 'Mỹ Tân', 'My Tan'),
('15070', 'WARD', '389', 'Thúy Sơn', 'Thuy Son'),
('15073', 'WARD', '389', 'Thạch Lập', 'Thach Lap'),
('15076', 'WARD', '389', 'Vân Âm', 'Van Am'),
('15079', 'WARD', '389', 'Cao Ngọc', 'Cao Ngoc'),
('15085', 'WARD', '389', 'Quang Trung', 'Quang Trung'),
('15088', 'WARD', '389', 'Đồng Thịnh', 'Dong Thinh'),
('15091', 'WARD', '389', 'Ngọc Liên', 'Ngoc Lien'),
('15094', 'WARD', '389', 'Ngọc Sơn', 'Ngoc Son'),
('15097', 'WARD', '389', 'Lộc Thịnh', 'Loc Thinh'),
('15100', 'WARD', '389', 'Cao Thịnh', 'Cao Thinh'),
('15103', 'WARD', '389', 'Ngọc Trung', 'Ngoc Trung'),
('15106', 'WARD', '389', 'Phùng Giáo', 'Phung Giao'),
('15109', 'WARD', '389', 'Phùng Minh', 'Phung Minh'),
('15112', 'WARD', '389', 'Phúc Thịnh', 'Phuc Thinh'),
('15115', 'WARD', '389', 'Nguyệt Ấn', 'Nguyet An'),
('15118', 'WARD', '389', 'Kiên Thọ', 'Kien Tho'),
('15121', 'WARD', '389', 'Minh Tiến', 'Minh Tien'),
('15124', 'WARD', '389', 'Minh Sơn', 'Minh Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 390 - Cẩm Thủy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15127', 'WARD', '390', 'Thị trấn Phong Sơn', 'Thi tran Phong Son'),
('15133', 'WARD', '390', 'Cẩm Thành', 'Cam Thanh'),
('15136', 'WARD', '390', 'Cẩm Quý', 'Cam Quy'),
('15139', 'WARD', '390', 'Cẩm Lương', 'Cam Luong'),
('15142', 'WARD', '390', 'Cẩm Thạch', 'Cam Thach'),
('15145', 'WARD', '390', 'Cẩm Liên', 'Cam Lien'),
('15148', 'WARD', '390', 'Cẩm Giang', 'Cam Giang'),
('15151', 'WARD', '390', 'Cẩm Bình', 'Cam Binh'),
('15154', 'WARD', '390', 'Cẩm Tú', 'Cam Tu'),
('15160', 'WARD', '390', 'Cẩm Châu', 'Cam Chau'),
('15163', 'WARD', '390', 'Cẩm Tâm', 'Cam Tam'),
('15169', 'WARD', '390', 'Cẩm Ngọc', 'Cam Ngoc'),
('15172', 'WARD', '390', 'Cẩm Long', 'Cam Long'),
('15175', 'WARD', '390', 'Cẩm Yên', 'Cam Yen'),
('15178', 'WARD', '390', 'Cẩm Tân', 'Cam Tan'),
('15181', 'WARD', '390', 'Cẩm Phú', 'Cam Phu'),
('15184', 'WARD', '390', 'Cẩm Vân', 'Cam Van')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 391 - Thạch Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15187', 'WARD', '391', 'Thị trấn Kim Tân', 'Thi tran Kim Tan'),
('15190', 'WARD', '391', 'Thị trấn Vân Du', 'Thi tran Van Du'),
('15196', 'WARD', '391', 'Thạch Lâm', 'Thach Lam'),
('15199', 'WARD', '391', 'Thạch Quảng', 'Thach Quang'),
('15202', 'WARD', '391', 'Thạch Tượng', 'Thach Tuong'),
('15205', 'WARD', '391', 'Thạch Cẩm', 'Thach Cam'),
('15208', 'WARD', '391', 'Thạch Sơn', 'Thach Son'),
('15211', 'WARD', '391', 'Thạch Bình', 'Thach Binh'),
('15214', 'WARD', '391', 'Thạch Định', 'Thach Dinh'),
('15220', 'WARD', '391', 'Thạch Long', 'Thach Long'),
('15223', 'WARD', '391', 'Thành Mỹ', 'Thanh My'),
('15226', 'WARD', '391', 'Thành Yên', 'Thanh Yen'),
('15229', 'WARD', '391', 'Thành Vinh', 'Thanh Vinh'),
('15232', 'WARD', '391', 'Thành Minh', 'Thanh Minh'),
('15235', 'WARD', '391', 'Thành Công', 'Thanh Cong'),
('15238', 'WARD', '391', 'Thành Tân', 'Thanh Tan'),
('15241', 'WARD', '391', 'Thành Trực', 'Thanh Truc'),
('15247', 'WARD', '391', 'Thành Tâm', 'Thanh Tam'),
('15250', 'WARD', '391', 'Thành An', 'Thanh An'),
('15253', 'WARD', '391', 'Thành Thọ', 'Thanh Tho'),
('15256', 'WARD', '391', 'Thành Tiến', 'Thanh Tien'),
('15259', 'WARD', '391', 'Thành Long', 'Thanh Long'),
('15265', 'WARD', '391', 'Thành Hưng', 'Thanh Hung'),
('15268', 'WARD', '391', 'Ngọc Trạo', 'Ngoc Trao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 392 - Hà Trung
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15271', 'WARD', '392', 'Thị trấn Hà Trung', 'Thi tran Ha Trung'),
('15274', 'WARD', '392', 'Thị trấn Hà Long', 'Thi tran Ha Long'),
('15277', 'WARD', '392', 'Hà Vinh', 'Ha Vinh'),
('15280', 'WARD', '392', 'Hà Bắc', 'Ha Bac'),
('15283', 'WARD', '392', 'Hoạt Giang', 'Hoat Giang'),
('15286', 'WARD', '392', 'Yên Dương', 'Yen Duong'),
('15292', 'WARD', '392', 'Hà Giang', 'Ha Giang'),
('15298', 'WARD', '392', 'Lĩnh Toại', 'Linh Toai'),
('15304', 'WARD', '392', 'Hà Ngọc', 'Ha Ngoc'),
('15307', 'WARD', '392', 'Yến Sơn', 'Yen Son'),
('15313', 'WARD', '392', 'Hà Sơn', 'Ha Son'),
('15316', 'WARD', '392', 'Thị trấn Hà Lĩnh', 'Thi tran Ha Linh'),
('15319', 'WARD', '392', 'Hà Đông', 'Ha Dong'),
('15322', 'WARD', '392', 'Hà Tân', 'Ha Tan'),
('15325', 'WARD', '392', 'Hà Tiến', 'Ha Tien'),
('15328', 'WARD', '392', 'Hà Bình', 'Ha Binh'),
('15331', 'WARD', '392', 'Thái Lai', 'Thai Lai'),
('15334', 'WARD', '392', 'Hà Châu', 'Ha Chau'),
('15343', 'WARD', '392', 'Hà Hải', 'Ha Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 393 - Vĩnh Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15349', 'WARD', '393', 'Thị trấn Vĩnh Lộc', 'Thi tran Vinh Loc'),
('15352', 'WARD', '393', 'Vĩnh Quang', 'Vinh Quang'),
('15355', 'WARD', '393', 'Vĩnh Yên', 'Vinh Yen'),
('15358', 'WARD', '393', 'Vĩnh Tiến', 'Vinh Tien'),
('15361', 'WARD', '393', 'Vĩnh Long', 'Vinh Long'),
('15364', 'WARD', '393', 'Vĩnh Phúc', 'Vinh Phuc'),
('15367', 'WARD', '393', 'Vĩnh Hưng', 'Vinh Hung'),
('15376', 'WARD', '393', 'Vĩnh Hòa', 'Vinh Hoa'),
('15379', 'WARD', '393', 'Vĩnh Hùng', 'Vinh Hung'),
('15382', 'WARD', '393', 'Minh Tân', 'Minh Tan'),
('15385', 'WARD', '393', 'Ninh Khang', 'Ninh Khang'),
('15388', 'WARD', '393', 'Vĩnh Thịnh', 'Vinh Thinh'),
('15391', 'WARD', '393', 'Vĩnh An', 'Vinh An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 394 - Yên Định
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15397', 'WARD', '394', 'Thị trấn Thống Nhất', 'Thi tran Thong Nhat'),
('15403', 'WARD', '394', 'Thị trấn Yên Lâm', 'Thi tran Yen Lam'),
('15406', 'WARD', '394', 'Yên Tâm', 'Yen Tam'),
('15409', 'WARD', '394', 'Yên Phú', 'Yen Phu'),
('15412', 'WARD', '394', 'Thị trấn Quý Lộc', 'Thi tran Quy Loc'),
('15415', 'WARD', '394', 'Yên Thọ', 'Yen Tho'),
('15418', 'WARD', '394', 'Yên Trung', 'Yen Trung'),
('15421', 'WARD', '394', 'Yên Trường', 'Yen Truong'),
('15427', 'WARD', '394', 'Yên Phong', 'Yen Phong'),
('15430', 'WARD', '394', 'Yên Thái', 'Yen Thai'),
('15433', 'WARD', '394', 'Yên Hùng', 'Yen Hung'),
('15436', 'WARD', '394', 'Yên Thịnh', 'Yen Thinh'),
('15442', 'WARD', '394', 'Yên Ninh', 'Yen Ninh'),
('15445', 'WARD', '394', 'Định Tăng', 'Dinh Tang'),
('15448', 'WARD', '394', 'Định Hòa', 'Dinh Hoa'),
('15451', 'WARD', '394', 'Định Thành', 'Dinh Thanh'),
('15454', 'WARD', '394', 'Định Công', 'Dinh Cong'),
('15457', 'WARD', '394', 'Định Tân', 'Dinh Tan'),
('15460', 'WARD', '394', 'Định Tiến', 'Dinh Tien'),
('15463', 'WARD', '394', 'Định Long', 'Dinh Long'),
('15466', 'WARD', '394', 'Định Liên', 'Dinh Lien'),
('15469', 'WARD', '394', 'Thị trấn Quán Lào', 'Thi tran Lao'),
('15472', 'WARD', '394', 'Định Hưng', 'Dinh Hung'),
('15475', 'WARD', '394', 'Định Hải', 'Dinh Hai'),
('15478', 'WARD', '394', 'Định Bình', 'Dinh Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 395 - Thọ Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15493', 'WARD', '395', 'Xuân Hồng', 'Xuan Hong'),
('15499', 'WARD', '395', 'Thị trấn Thọ Xuân', 'Thi tran Tho Xuan'),
('15502', 'WARD', '395', 'Bắc Lương', 'Bac Luong'),
('15505', 'WARD', '395', 'Nam Giang', 'Nam Giang'),
('15508', 'WARD', '395', 'Xuân Phong', 'Xuan Phong'),
('15511', 'WARD', '395', 'Thọ Lộc', 'Tho Loc'),
('15514', 'WARD', '395', 'Xuân Trường', 'Xuan Truong'),
('15517', 'WARD', '395', 'Xuân Hòa', 'Xuan Hoa'),
('15520', 'WARD', '395', 'Thọ Hải', 'Tho Hai'),
('15523', 'WARD', '395', 'Tây Hồ', 'Tay Ho'),
('15526', 'WARD', '395', 'Xuân Giang', 'Xuan Giang'),
('15532', 'WARD', '395', 'Xuân Sinh', 'Xuan Sinh'),
('15535', 'WARD', '395', 'Xuân Hưng', 'Xuan Hung'),
('15538', 'WARD', '395', 'Thọ Diên', 'Tho Dien'),
('15541', 'WARD', '395', 'Thọ Lâm', 'Tho Lam'),
('15544', 'WARD', '395', 'Thọ Xương', 'Tho Xuong'),
('15547', 'WARD', '395', 'Xuân Bái', 'Xuan Bai'),
('15550', 'WARD', '395', 'Xuân Phú', 'Xuan Phu'),
('15553', 'WARD', '395', 'Thị trấn Sao Vàng', 'Thi tran Sao Vang'),
('15556', 'WARD', '395', 'Thị trấn Lam Sơn', 'Thi tran Lam Son'),
('15559', 'WARD', '395', 'Xuân Thiên', 'Xuan Thien'),
('15565', 'WARD', '395', 'Thuận Minh', 'Thuan Minh'),
('15568', 'WARD', '395', 'Thọ Lập', 'Tho Lap'),
('15571', 'WARD', '395', 'Quảng Phú', 'Quang Phu'),
('15574', 'WARD', '395', 'Xuân Tín', 'Xuan Tin'),
('15577', 'WARD', '395', 'Phú Xuân', 'Phu Xuan'),
('15583', 'WARD', '395', 'Xuân Lai', 'Xuan Lai'),
('15586', 'WARD', '395', 'Xuân Lập', 'Xuan Lap'),
('15592', 'WARD', '395', 'Xuân Minh', 'Xuan Minh'),
('15598', 'WARD', '395', 'Trường Xuân', 'Truong Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 396 - Thường Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15607', 'WARD', '396', 'Bát Mọt', 'Bat Mot'),
('15610', 'WARD', '396', 'Yên Nhân', 'Yen Nhan'),
('15619', 'WARD', '396', 'Xuân Lẹ', 'Xuan Le'),
('15622', 'WARD', '396', 'Vạn Xuân', 'Van Xuan'),
('15628', 'WARD', '396', 'Lương Sơn', 'Luong Son'),
('15631', 'WARD', '396', 'Xuân Cao', 'Xuan Cao'),
('15634', 'WARD', '396', 'Luận Thành', 'Luan Thanh'),
('15637', 'WARD', '396', 'Luận Khê', 'Luan Khe'),
('15640', 'WARD', '396', 'Xuân Thắng', 'Xuan Thang'),
('15643', 'WARD', '396', 'Xuân Lộc', 'Xuan Loc'),
('15646', 'WARD', '396', 'Thị trấn Thường Xuân', 'Thi tran Thuong Xuan'),
('15649', 'WARD', '396', 'Xuân Dương', 'Xuan Duong'),
('15652', 'WARD', '396', 'Thọ Thanh', 'Tho Thanh'),
('15655', 'WARD', '396', 'Ngọc Phụng', 'Ngoc Phung'),
('15658', 'WARD', '396', 'Xuân Chinh', 'Xuan Chinh'),
('15661', 'WARD', '396', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 397 - Triệu Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15664', 'WARD', '397', 'Thị trấn Triệu Sơn', 'Thi tran Trieu Son'),
('15667', 'WARD', '397', 'Thọ Sơn', 'Tho Son'),
('15670', 'WARD', '397', 'Thọ Bình', 'Tho Binh'),
('15673', 'WARD', '397', 'Thọ Tiến', 'Tho Tien'),
('15676', 'WARD', '397', 'Hợp Lý', 'Hop Ly'),
('15679', 'WARD', '397', 'Hợp Tiến', 'Hop Tien'),
('15682', 'WARD', '397', 'Hợp Thành', 'Hop Thanh'),
('15685', 'WARD', '397', 'Triệu Thành', 'Trieu Thanh'),
('15688', 'WARD', '397', 'Hợp Thắng', 'Hop Thang'),
('15691', 'WARD', '397', 'Minh Sơn', 'Minh Son'),
('15700', 'WARD', '397', 'Dân Lực', 'Dan Luc'),
('15703', 'WARD', '397', 'Dân Lý', 'Dan Ly'),
('15706', 'WARD', '397', 'Dân Quyền', 'Dan Quyen'),
('15709', 'WARD', '397', 'An Nông', 'An Nong'),
('15712', 'WARD', '397', 'Văn Sơn', 'Van Son'),
('15715', 'WARD', '397', 'Thái Hòa', 'Thai Hoa'),
('15718', 'WARD', '397', 'Thị trấn Nưa', 'Thi tran Nua'),
('15721', 'WARD', '397', 'Đồng Lợi', 'Dong Loi'),
('15724', 'WARD', '397', 'Đồng Tiến', 'Dong Tien'),
('15727', 'WARD', '397', 'Đồng Thắng', 'Dong Thang'),
('15730', 'WARD', '397', 'Tiến Nông', 'Tien Nong'),
('15733', 'WARD', '397', 'Khuyến Nông', 'KNong'),
('15736', 'WARD', '397', 'Xuân Lộc', 'Xuan Loc'),
('15742', 'WARD', '397', 'Thọ Dân', 'Tho Dan'),
('15745', 'WARD', '397', 'Xuân Thọ', 'Xuan Tho'),
('15748', 'WARD', '397', 'Thọ Tân', 'Tho Tan'),
('15751', 'WARD', '397', 'Thọ Ngọc', 'Tho Ngoc'),
('15754', 'WARD', '397', 'Thọ Cường', 'Tho Cuong'),
('15760', 'WARD', '397', 'Thọ Phú', 'Tho Phu'),
('15763', 'WARD', '397', 'Thọ Thế', 'Tho The'),
('15766', 'WARD', '397', 'Nông Trường', 'Nong Truong'),
('15769', 'WARD', '397', 'Bình Sơn', 'Binh Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 398 - Thiệu Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15772', 'WARD', '398', 'Thị trấn Thiệu Hóa', 'Thi tran Thieu Hoa'),
('15775', 'WARD', '398', 'Thiệu Ngọc', 'Thieu Ngoc'),
('15778', 'WARD', '398', 'Thiệu Vũ', 'Thieu Vu'),
('15781', 'WARD', '398', 'Thiệu Phúc', 'Thieu Phuc'),
('15784', 'WARD', '398', 'Thiệu Tiến', 'Thieu Tien'),
('15787', 'WARD', '398', 'Thiệu Công', 'Thieu Cong'),
('15793', 'WARD', '398', 'Thiệu Long', 'Thieu Long'),
('15796', 'WARD', '398', 'Thiệu Giang', 'Thieu Giang'),
('15799', 'WARD', '398', 'Thiệu Duy', 'Thieu Duy'),
('15802', 'WARD', '398', 'Thiệu Nguyên', 'Thieu Nguyen'),
('15805', 'WARD', '398', 'Thiệu Hợp', 'Thieu Hop'),
('15808', 'WARD', '398', 'Thiệu Thịnh', 'Thieu Thinh'),
('15811', 'WARD', '398', 'Thiệu Quang', 'Thieu Quang'),
('15814', 'WARD', '398', 'Thiệu Thành', 'Thieu Thanh'),
('15817', 'WARD', '398', 'Thiệu Toán', 'Thieu Toan'),
('15820', 'WARD', '398', 'Thiệu Chính', 'Thieu Chinh'),
('15823', 'WARD', '398', 'Thiệu Hòa', 'Thieu Hoa'),
('15829', 'WARD', '398', 'Thị trấn Hậu Hiền', 'Thi tran Hau Hien'),
('15832', 'WARD', '398', 'Thiệu Viên', 'Thieu Vien'),
('15835', 'WARD', '398', 'Thiệu Lý', 'Thieu Ly'),
('15838', 'WARD', '398', 'Thiệu Vận', 'Thieu Van'),
('15841', 'WARD', '398', 'Thiệu Trung', 'Thieu Trung'),
('15847', 'WARD', '398', 'Tân Châu', 'Tan Chau'),
('15853', 'WARD', '398', 'Thiệu Giao', 'Thieu Giao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 399 - Hoằng Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('15865', 'WARD', '399', 'Thị trấn Bút Sơn', 'Thi tran But Son'),
('15877', 'WARD', '399', 'Hoằng Xuân', 'Hoang Xuan'),
('15880', 'WARD', '399', 'Hoằng Giang', 'Hoang Giang'),
('15883', 'WARD', '399', 'Hoằng Phú', 'Hoang Phu'),
('15886', 'WARD', '399', 'Hoằng Quỳ', 'Hoang Quy'),
('15889', 'WARD', '399', 'Hoằng Kim', 'Hoang Kim'),
('15892', 'WARD', '399', 'Hoằng Trung', 'Hoang Trung'),
('15895', 'WARD', '399', 'Hoằng Trinh', 'Hoang Trinh'),
('15901', 'WARD', '399', 'Hoằng Sơn', 'Hoang Son'),
('15907', 'WARD', '399', 'Hoằng Cát', 'Hoang Cat'),
('15910', 'WARD', '399', 'Hoằng Xuyên', 'Hoang Xuyen'),
('15916', 'WARD', '399', 'Hoằng Quý', 'Hoang Quy'),
('15919', 'WARD', '399', 'Hoằng Hợp', 'Hoang Hop'),
('15928', 'WARD', '399', 'Hoằng Đức', 'Hoang Duc'),
('15937', 'WARD', '399', 'Hoằng Hà', 'Hoang Ha'),
('15940', 'WARD', '399', 'Hoằng Đạt', 'Hoang Dat'),
('15946', 'WARD', '399', 'Hoằng Đạo', 'Hoang Dao'),
('15949', 'WARD', '399', 'Hoằng Thắng', 'Hoang Thang'),
('15952', 'WARD', '399', 'Hoằng Đồng', 'Hoang Dong'),
('15955', 'WARD', '399', 'Hoằng Thái', 'Hoang Thai'),
('15958', 'WARD', '399', 'Hoằng Thịnh', 'Hoang Thinh'),
('15961', 'WARD', '399', 'Hoằng Thành', 'Hoang Thanh'),
('15964', 'WARD', '399', 'Hoằng Lộc', 'Hoang Loc'),
('15967', 'WARD', '399', 'Hoằng Trạch', 'Hoang Trach'),
('15973', 'WARD', '399', 'Hoằng Phong', 'Hoang Phong'),
('15976', 'WARD', '399', 'Hoằng Lưu', 'Hoang Luu'),
('15979', 'WARD', '399', 'Hoằng Châu', 'Hoang Chau'),
('15982', 'WARD', '399', 'Hoằng Tân', 'Hoang Tan'),
('15985', 'WARD', '399', 'Hoằng Yến', 'Hoang Yen'),
('15988', 'WARD', '399', 'Hoằng Tiến', 'Hoang Tien'),
('15991', 'WARD', '399', 'Hoằng Hải', 'Hoang Hai'),
('15994', 'WARD', '399', 'Hoằng Ngọc', 'Hoang Ngoc'),
('15997', 'WARD', '399', 'Hoằng Đông', 'Hoang Dong'),
('16000', 'WARD', '399', 'Hoằng Thanh', 'Hoang Thanh'),
('16003', 'WARD', '399', 'Hoằng Phụ', 'Hoang Phu'),
('16006', 'WARD', '399', 'Hoằng Trường', 'Hoang Truong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 400 - Hậu Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16012', 'WARD', '400', 'Thị trấn Hậu Lộc', 'Thi tran Hau Loc'),
('16015', 'WARD', '400', 'Đồng Lộc', 'Dong Loc'),
('16018', 'WARD', '400', 'Đại Lộc', 'Dai Loc'),
('16021', 'WARD', '400', 'Triệu Lộc', 'Trieu Loc'),
('16027', 'WARD', '400', 'Tiến Lộc', 'Tien Loc'),
('16030', 'WARD', '400', 'Lộc Sơn', 'Loc Son'),
('16033', 'WARD', '400', 'Cầu Lộc', 'Cau Loc'),
('16036', 'WARD', '400', 'Thành Lộc', 'Thanh Loc'),
('16042', 'WARD', '400', 'Tuy Lộc', 'Tuy Loc'),
('16045', 'WARD', '400', 'Mỹ Lộc', 'My Loc'),
('16048', 'WARD', '400', 'Thuần Lộc', 'Thuan Loc'),
('16057', 'WARD', '400', 'Xuân Lộc', 'Xuan Loc'),
('16063', 'WARD', '400', 'Hoa Lộc', 'Hoa Loc'),
('16066', 'WARD', '400', 'Liên Lộc', 'Lien Loc'),
('16069', 'WARD', '400', 'Quang Lộc', 'Quang Loc'),
('16072', 'WARD', '400', 'Phú Lộc', 'Phu Loc'),
('16075', 'WARD', '400', 'Hòa Lộc', 'Hoa Loc'),
('16078', 'WARD', '400', 'Minh Lộc', 'Minh Loc'),
('16081', 'WARD', '400', 'Hưng Lộc', 'Hung Loc'),
('16084', 'WARD', '400', 'Hải Lộc', 'Hai Loc'),
('16087', 'WARD', '400', 'Đa Lộc', 'Da Loc'),
('16090', 'WARD', '400', 'Ngư Lộc', 'Ngu Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 401 - Nga Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16093', 'WARD', '401', 'Thị trấn Nga Sơn', 'Thi tran Nga Son'),
('16096', 'WARD', '401', 'Ba Đình', 'Ba Dinh'),
('16099', 'WARD', '401', 'Nga Vịnh', 'Nga Vinh'),
('16102', 'WARD', '401', 'Nga Văn', 'Nga Van'),
('16105', 'WARD', '401', 'Nga Thiện', 'Nga Thien'),
('16108', 'WARD', '401', 'Nga Tiến', 'Nga Tien'),
('16114', 'WARD', '401', 'Nga Phượng', 'Nga Phuong'),
('16120', 'WARD', '401', 'Nga Hiệp', 'Nga Hiep'),
('16123', 'WARD', '401', 'Nga Thanh', 'Nga Thanh'),
('16132', 'WARD', '401', 'Nga Yên', 'Nga Yen'),
('16135', 'WARD', '401', 'Nga Giáp', 'Nga Giap'),
('16138', 'WARD', '401', 'Nga Hải', 'Nga Hai'),
('16141', 'WARD', '401', 'Nga Thành', 'Nga Thanh'),
('16144', 'WARD', '401', 'Nga An', 'Nga An'),
('16147', 'WARD', '401', 'Nga Phú', 'Nga Phu'),
('16150', 'WARD', '401', 'Nga Điền', 'Nga Dien'),
('16153', 'WARD', '401', 'Nga Tân', 'Nga Tan'),
('16156', 'WARD', '401', 'Nga Thủy', 'Nga Thuy'),
('16159', 'WARD', '401', 'Nga Liên', 'Nga Lien'),
('16162', 'WARD', '401', 'Nga Thái', 'Nga Thai'),
('16165', 'WARD', '401', 'Nga Thạch', 'Nga Thach'),
('16168', 'WARD', '401', 'Nga Thắng', 'Nga Thang'),
('16171', 'WARD', '401', 'Nga Trường', 'Nga Truong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 402 - Như Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16174', 'WARD', '402', 'Thị trấn Yên Cát', 'Thi tran Yen Cat'),
('16177', 'WARD', '402', 'Bãi Trành', 'Bai Tranh'),
('16180', 'WARD', '402', 'Xuân Hòa', 'Xuan Hoa'),
('16183', 'WARD', '402', 'Xuân Bình', 'Xuan Binh'),
('16186', 'WARD', '402', 'Hóa Quỳ', 'Hoa Quy'),
('16195', 'WARD', '402', 'Cát Vân', 'Cat Van'),
('16198', 'WARD', '402', 'Cát Tân', 'Cat Tan'),
('16201', 'WARD', '402', 'Tân Bình', 'Tan Binh'),
('16204', 'WARD', '402', 'Bình Lương', 'Binh Luong'),
('16207', 'WARD', '402', 'Thanh Quân', 'Thanh Quan'),
('16210', 'WARD', '402', 'Thanh Xuân', 'Thanh Xuan'),
('16213', 'WARD', '402', 'Thanh Hòa', 'Thanh Hoa'),
('16216', 'WARD', '402', 'Thanh Phong', 'Thanh Phong'),
('16219', 'WARD', '402', 'Thanh Lâm', 'Thanh Lam'),
('16222', 'WARD', '402', 'Thanh Sơn', 'Thanh Son'),
('16225', 'WARD', '402', 'Thượng Ninh', 'Thuong Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 403 - Như Thanh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16228', 'WARD', '403', 'Thị trấn Bến Sung', 'Thi tran Ben Sung'),
('16231', 'WARD', '403', 'Cán Khê', 'Can Khe'),
('16234', 'WARD', '403', 'Xuân Du', 'Xuan Du'),
('16240', 'WARD', '403', 'Phượng Nghi', 'Nghi'),
('16243', 'WARD', '403', 'Mậu Lâm', 'Mau Lam'),
('16246', 'WARD', '403', 'Xuân Khang', 'Xuan Khang'),
('16249', 'WARD', '403', 'Phú Nhuận', 'Phu Nhuan'),
('16252', 'WARD', '403', 'Hải Long', 'Hai Long'),
('16258', 'WARD', '403', 'Xuân Thái', 'Xuan Thai'),
('16261', 'WARD', '403', 'Xuân Phúc', 'Xuan Phuc'),
('16264', 'WARD', '403', 'Yên Thọ', 'Yen Tho'),
('16267', 'WARD', '403', 'Yên Lạc', 'Yen Lac'),
('16273', 'WARD', '403', 'Thanh Tân', 'Thanh Tan'),
('16276', 'WARD', '403', 'Thanh Kỳ', 'Thanh Ky')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 404 - Nông Cống
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16279', 'WARD', '404', 'Thị trấn Nông Cống', 'Thi tran Nong Cong'),
('16282', 'WARD', '404', 'Tân Phúc', 'Tan Phuc'),
('16285', 'WARD', '404', 'Tân Thọ', 'Tan Tho'),
('16288', 'WARD', '404', 'Hoàng Sơn', 'Hoang Son'),
('16291', 'WARD', '404', 'Tân Khang', 'Tan Khang'),
('16294', 'WARD', '404', 'Hoàng Giang', 'Hoang Giang'),
('16297', 'WARD', '404', 'Trung Chính', 'Trung Chinh'),
('16303', 'WARD', '404', 'Trung Thành', 'Trung Thanh'),
('16309', 'WARD', '404', 'Tế Thắng', 'Te Thang'),
('16315', 'WARD', '404', 'Tế Lợi', 'Te Loi'),
('16318', 'WARD', '404', 'Tế Nông', 'Te Nong'),
('16321', 'WARD', '404', 'Minh Nghĩa', 'Minh Nghia'),
('16324', 'WARD', '404', 'Minh Khôi', 'Minh Khoi'),
('16327', 'WARD', '404', 'Vạn Hòa', 'Van Hoa'),
('16330', 'WARD', '404', 'Trường Trung', 'Truong Trung'),
('16333', 'WARD', '404', 'Vạn Thắng', 'Van Thang'),
('16336', 'WARD', '404', 'Trường Giang', 'Truong Giang'),
('16339', 'WARD', '404', 'Vạn Thiện', 'Van Thien'),
('16342', 'WARD', '404', 'Thăng Long', 'Thang Long'),
('16345', 'WARD', '404', 'Trường Minh', 'Truong Minh'),
('16348', 'WARD', '404', 'Trường Sơn', 'Truong Son'),
('16351', 'WARD', '404', 'Thăng Bình', 'Thang Binh'),
('16354', 'WARD', '404', 'Công Liêm', 'Cong Liem'),
('16357', 'WARD', '404', 'Tượng Văn', 'Tuong Van'),
('16360', 'WARD', '404', 'Thăng Thọ', 'Thang Tho'),
('16363', 'WARD', '404', 'Tượng Lĩnh', 'Tuong Linh'),
('16366', 'WARD', '404', 'Tượng Sơn', 'Tuong Son'),
('16369', 'WARD', '404', 'Công Chính', 'Cong Chinh'),
('16375', 'WARD', '404', 'Yên Mỹ', 'Yen My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 406 - Quảng Xương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16438', 'WARD', '406', 'Thị trấn Tân Phong', 'Thi tran Tan Phong'),
('16447', 'WARD', '406', 'Quảng Trạch', 'Quang Trach'),
('16453', 'WARD', '406', 'Quảng Đức', 'Quang Duc'),
('16456', 'WARD', '406', 'Quảng Định', 'Quang Dinh'),
('16462', 'WARD', '406', 'Quảng Nhân', 'Quang Nhan'),
('16465', 'WARD', '406', 'Quảng Ninh', 'Quang Ninh'),
('16468', 'WARD', '406', 'Quảng Bình', 'Quang Binh'),
('16471', 'WARD', '406', 'Quảng Hợp', 'Quang Hop'),
('16474', 'WARD', '406', 'Quảng Văn', 'Quang Van'),
('16477', 'WARD', '406', 'Quảng Long', 'Quang Long'),
('16480', 'WARD', '406', 'Quảng Yên', 'Quang Yen'),
('16483', 'WARD', '406', 'Quảng Hòa', 'Quang Hoa'),
('16489', 'WARD', '406', 'Quảng Khê', 'Quang Khe'),
('16492', 'WARD', '406', 'Quảng Trung', 'Quang Trung'),
('16495', 'WARD', '406', 'Quảng Chính', 'Quang Chinh'),
('16498', 'WARD', '406', 'Quảng Ngọc', 'Quang Ngoc'),
('16501', 'WARD', '406', 'Quảng Trường', 'Quang Truong'),
('16510', 'WARD', '406', 'Quảng Phúc', 'Quang Phuc'),
('16519', 'WARD', '406', 'Quảng Giao', 'Quang Giao'),
('16540', 'WARD', '406', 'Quảng Hải', 'Quang Hai'),
('16543', 'WARD', '406', 'Quảng Lưu', 'Quang Luu'),
('16546', 'WARD', '406', 'Quảng Lộc', 'Quang Loc'),
('16549', 'WARD', '406', 'Tiên Trang', 'Tien Trang'),
('16552', 'WARD', '406', 'Quảng Nham', 'Quang Nham'),
('16555', 'WARD', '406', 'Quảng Thạch', 'Quang Thach'),
('16558', 'WARD', '406', 'Quảng Thái', 'Quang Thai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 407 - Thị Nghi Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16561', 'WARD', '407', 'Hải Hòa', 'Hai Hoa'),
('16564', 'WARD', '407', 'Hải Châu', 'Hai Chau'),
('16567', 'WARD', '407', 'Thanh Thủy', 'Thanh Thuy'),
('16570', 'WARD', '407', 'Thanh Sơn', 'Thanh Son'),
('16576', 'WARD', '407', 'Hải Ninh', 'Hai Ninh'),
('16579', 'WARD', '407', 'Anh Sơn', 'Anh Son'),
('16582', 'WARD', '407', 'Ngọc Lĩnh', 'Ngoc Linh'),
('16585', 'WARD', '407', 'Hải An', 'Hai An'),
('16591', 'WARD', '407', 'Các Sơn', 'Cac Son'),
('16594', 'WARD', '407', 'Tân Dân', 'Tan Dan'),
('16597', 'WARD', '407', 'Hải Lĩnh', 'Hai Linh'),
('16600', 'WARD', '407', 'Định Hải', 'Dinh Hai'),
('16603', 'WARD', '407', 'Phú Sơn', 'Phu Son'),
('16606', 'WARD', '407', 'Ninh Hải', 'Ninh Hai'),
('16609', 'WARD', '407', 'Nguyên Bình', 'Nguyen Binh'),
('16612', 'WARD', '407', 'Hải Nhân', 'Hai Nhan'),
('16618', 'WARD', '407', 'Bình Minh', 'Binh Minh'),
('16621', 'WARD', '407', 'Hải Thanh', 'Hai Thanh'),
('16624', 'WARD', '407', 'Phú Lâm', 'Phu Lam'),
('16627', 'WARD', '407', 'Xuân Lâm', 'Xuan Lam'),
('16630', 'WARD', '407', 'Trúc Lâm', 'Truc Lam'),
('16633', 'WARD', '407', 'Hải Bình', 'Hai Binh'),
('16636', 'WARD', '407', 'Tân Trường', 'Tan Truong'),
('16639', 'WARD', '407', 'Tùng Lâm', 'Tung Lam'),
('16642', 'WARD', '407', 'Tĩnh Hải', 'Hai'),
('16645', 'WARD', '407', 'Mai Lâm', 'Mai Lam'),
('16648', 'WARD', '407', 'Trường Lâm', 'Truong Lam'),
('16654', 'WARD', '407', 'Hải Thượng', 'Hai Thuong'),
('16657', 'WARD', '407', 'Nghi Sơn', 'Nghi Son'),
('16660', 'WARD', '407', 'Hải Hà', 'Hai Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 40 - Nghệ An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('412', 'DISTRICT', '40', 'Vinh', 'Thanh pho Vinh'),
('414', 'DISTRICT', '40', 'Thị Thái Hoà', 'Thi Thai Hoa'),
('415', 'DISTRICT', '40', 'Quế Phong', 'Que Phong'),
('416', 'DISTRICT', '40', 'Quỳ Châu', 'Quy Chau'),
('417', 'DISTRICT', '40', 'Kỳ Sơn', 'Ky Son'),
('418', 'DISTRICT', '40', 'Tương Dương', 'Tuong Duong'),
('419', 'DISTRICT', '40', 'Nghĩa Đàn', 'Nghia Dan'),
('420', 'DISTRICT', '40', 'Quỳ Hợp', 'Quy Hop'),
('421', 'DISTRICT', '40', 'Quỳnh Lưu', 'Quynh Luu'),
('422', 'DISTRICT', '40', 'Con Cuông', 'Con Cuong'),
('423', 'DISTRICT', '40', 'Tân Kỳ', 'Tan Ky'),
('424', 'DISTRICT', '40', 'Anh Sơn', 'Anh Son'),
('425', 'DISTRICT', '40', 'Diễn Châu', 'Dien Chau'),
('426', 'DISTRICT', '40', 'Yên Thành', 'Yen Thanh'),
('427', 'DISTRICT', '40', 'Đô Lương', 'Do Luong'),
('428', 'DISTRICT', '40', 'Thanh Chương', 'Thanh Chuong'),
('429', 'DISTRICT', '40', 'Nghi Lộc', 'Nghi Loc'),
('430', 'DISTRICT', '40', 'Nam Đàn', 'Nam Dan'),
('431', 'DISTRICT', '40', 'Hưng Nguyên', 'Hung Nguyen'),
('432', 'DISTRICT', '40', 'Thị Hoàng Mai', 'Thi Hoang Mai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 412 - Vinh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16663', 'WARD', '412', 'Đông Vĩnh', 'Dong Vinh'),
('16666', 'WARD', '412', 'Hà Huy Tập', 'Ha Huy Tap'),
('16669', 'WARD', '412', 'Lê Lợi', 'Le Loi'),
('16670', 'WARD', '412', 'Quán Bàu', 'Bau'),
('16672', 'WARD', '412', 'Hưng Bình', 'Hung Binh'),
('16673', 'WARD', '412', 'Hưng Phúc', 'Hung Phuc'),
('16675', 'WARD', '412', 'Hưng Dũng', 'Hung Dung'),
('16678', 'WARD', '412', 'Cửa Nam', 'Cua Nam'),
('16681', 'WARD', '412', 'Quang Trung', 'Quang Trung'),
('16690', 'WARD', '412', 'Trường Thi', 'Truong Thi'),
('16693', 'WARD', '412', 'Bến Thủy', 'Ben Thuy'),
('16699', 'WARD', '412', 'Trung Đô', 'Trung Do'),
('16702', 'WARD', '412', 'Nghi Phú', 'Nghi Phu'),
('16705', 'WARD', '412', 'Hưng Đông', 'Hung Dong'),
('16708', 'WARD', '412', 'Hưng Lộc', 'Hung Loc'),
('16711', 'WARD', '412', 'Hưng Hòa', 'Hung Hoa'),
('16714', 'WARD', '412', 'Vinh Tân', 'Vinh Tan'),
('16717', 'WARD', '412', 'Nghi Thuỷ', 'Nghi Thuy'),
('16720', 'WARD', '412', 'Nghi Tân', 'Nghi Tan'),
('16723', 'WARD', '412', 'Thu Thuỷ', 'Thu Thuy'),
('16726', 'WARD', '412', 'Nghi Hòa', 'Nghi Hoa'),
('16729', 'WARD', '412', 'Nghi Hải', 'Nghi Hai'),
('16732', 'WARD', '412', 'Nghi Hương', 'Nghi Huong'),
('16735', 'WARD', '412', 'Nghi Thu', 'Nghi Thu'),
('17902', 'WARD', '412', 'Nghi Phong', 'Nghi Phong'),
('17905', 'WARD', '412', 'Nghi Xuân', 'Nghi Xuan'),
('17908', 'WARD', '412', 'Nghi Liên', 'Nghi Lien'),
('17914', 'WARD', '412', 'Nghi Ân', 'Nghi An'),
('17917', 'WARD', '412', 'Phúc Thọ', 'Phuc Tho'),
('17920', 'WARD', '412', 'Nghi Kim', 'Nghi Kim'),
('17923', 'WARD', '412', 'Nghi Đức', 'Nghi Duc'),
('17926', 'WARD', '412', 'Nghi Thái', 'Nghi Thai'),
('18013', 'WARD', '412', 'Hưng Chính', 'Hung Chinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 414 - Thị Thái Hoà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16939', 'WARD', '414', 'Hoà Hiếu', 'Hoa Hieu'),
('16993', 'WARD', '414', 'Quang Phong', 'Quang Phong'),
('16994', 'WARD', '414', 'Quang Tiến', 'Quang Tien'),
('17003', 'WARD', '414', 'Long Sơn', 'Long Son'),
('17005', 'WARD', '414', 'Nghĩa Tiến', 'Nghia Tien'),
('17008', 'WARD', '414', 'Nghĩa Mỹ', 'Nghia My'),
('17011', 'WARD', '414', 'Tây Hiếu', 'Tay Hieu'),
('17014', 'WARD', '414', 'Nghĩa Thuận', 'Nghia Thuan'),
('17017', 'WARD', '414', 'Đông Hiếu', 'Dong Hieu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 415 - Quế Phong
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16738', 'WARD', '415', 'Thị trấn Kim Sơn', 'Thi tran Kim Son'),
('16741', 'WARD', '415', 'Thông Thụ', 'Thong Thu'),
('16744', 'WARD', '415', 'Đồng Văn', 'Dong Van'),
('16747', 'WARD', '415', 'Hạnh Dịch', 'Hanh Dich'),
('16750', 'WARD', '415', 'Tiền Phong', 'Tien Phong'),
('16753', 'WARD', '415', 'Nậm Giải', 'Nam Giai'),
('16756', 'WARD', '415', 'Tri Lễ', 'Tri Le'),
('16759', 'WARD', '415', 'Châu Kim', 'Chau Kim'),
('16763', 'WARD', '415', 'Mường Nọc', 'Muong Noc'),
('16765', 'WARD', '415', 'Châu Thôn', 'Chau Thon'),
('16768', 'WARD', '415', 'Nậm Nhoóng', 'Nam Nhoong'),
('16771', 'WARD', '415', 'Quang Phong', 'Quang Phong'),
('16774', 'WARD', '415', 'Căm Muộn', 'Cam Muon')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 416 - Quỳ Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16777', 'WARD', '416', 'Thị trấn Tân Lạc', 'Thi tran Tan Lac'),
('16780', 'WARD', '416', 'Châu Bính', 'Chau Binh'),
('16783', 'WARD', '416', 'Châu Thuận', 'Chau Thuan'),
('16786', 'WARD', '416', 'Châu Hội', 'Chau Hoi'),
('16789', 'WARD', '416', 'Châu Nga', 'Chau Nga'),
('16792', 'WARD', '416', 'Châu Tiến', 'Chau Tien'),
('16795', 'WARD', '416', 'Châu Hạnh', 'Chau Hanh'),
('16798', 'WARD', '416', 'Châu Thắng', 'Chau Thang'),
('16801', 'WARD', '416', 'Châu Phong', 'Chau Phong'),
('16804', 'WARD', '416', 'Châu Bình', 'Chau Binh'),
('16807', 'WARD', '416', 'Châu Hoàn', 'Chau Hoan'),
('16810', 'WARD', '416', 'Diên Lãm', 'Dien Lam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 417 - Kỳ Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16813', 'WARD', '417', 'Thị trấn Mường Xén', 'Thi tran Muong Xen'),
('16816', 'WARD', '417', 'Mỹ Lý', 'My Ly'),
('16819', 'WARD', '417', 'Bắc Lý', 'Bac Ly'),
('16822', 'WARD', '417', 'Keng Đu', 'Keng Du'),
('16825', 'WARD', '417', 'Đoọc Mạy', 'Dooc May'),
('16828', 'WARD', '417', 'Huồi Tụ', 'Huoi Tu'),
('16831', 'WARD', '417', 'Mường Lống', 'Muong Long'),
('16834', 'WARD', '417', 'Na Loi', 'Na Loi'),
('16837', 'WARD', '417', 'Nậm Cắn', 'Nam Can'),
('16840', 'WARD', '417', 'Bảo Nam', 'Bao Nam'),
('16843', 'WARD', '417', 'Phà Đánh', 'Pha Danh'),
('16846', 'WARD', '417', 'Bảo Thắng', 'Bao Thang'),
('16849', 'WARD', '417', 'Hữu Lập', 'Huu Lap'),
('16852', 'WARD', '417', 'Tà Cạ', 'Ta Ca'),
('16855', 'WARD', '417', 'Chiêu Lưu', 'Chieu Luu'),
('16858', 'WARD', '417', 'Mường Típ', 'Muong Tip'),
('16861', 'WARD', '417', 'Hữu Kiệm', 'Huu Kiem'),
('16864', 'WARD', '417', 'Tây Sơn', 'Tay Son'),
('16867', 'WARD', '417', 'Mường Ải', 'Muong Ai'),
('16870', 'WARD', '417', 'Na Ngoi', 'Na Ngoi'),
('16873', 'WARD', '417', 'Nậm Càn', 'Nam Can')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 418 - Tương Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16876', 'WARD', '418', 'Thị trấn Thạch Giám', 'Thi tran Thach Giam'),
('16879', 'WARD', '418', 'Mai Sơn', 'Mai Son'),
('16882', 'WARD', '418', 'Nhôn Mai', 'Nhon Mai'),
('16885', 'WARD', '418', 'Hữu Khuông', 'Huu Khuong'),
('16900', 'WARD', '418', 'Yên Tĩnh', 'Yen Tinh'),
('16903', 'WARD', '418', 'Nga My', 'Nga My'),
('16904', 'WARD', '418', 'Xiêng My', 'Xieng My'),
('16906', 'WARD', '418', 'Lưỡng Minh', 'Luong Minh'),
('16909', 'WARD', '418', 'Yên Hòa', 'Yen Hoa'),
('16912', 'WARD', '418', 'Yên Na', 'Yen Na'),
('16915', 'WARD', '418', 'Lưu Kiền', 'Luu Kien'),
('16921', 'WARD', '418', 'Xá Lượng', 'Luong'),
('16924', 'WARD', '418', 'Tam Thái', 'Tam Thai'),
('16927', 'WARD', '418', 'Tam Đình', 'Tam Dinh'),
('16930', 'WARD', '418', 'Yên Thắng', 'Yen Thang'),
('16933', 'WARD', '418', 'Tam Quang', 'Tam Quang'),
('16936', 'WARD', '418', 'Tam Hợp', 'Tam Hop')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 419 - Nghĩa Đàn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('16941', 'WARD', '419', 'Thị trấn Nghĩa Đàn', 'Thi tran Nghia Dan'),
('16942', 'WARD', '419', 'Nghĩa Mai', 'Nghia Mai'),
('16945', 'WARD', '419', 'Nghĩa Yên', 'Nghia Yen'),
('16948', 'WARD', '419', 'Nghĩa Lạc', 'Nghia Lac'),
('16951', 'WARD', '419', 'Nghĩa Lâm', 'Nghia Lam'),
('16954', 'WARD', '419', 'Nghĩa Sơn', 'Nghia Son'),
('16957', 'WARD', '419', 'Nghĩa Lợi', 'Nghia Loi'),
('16960', 'WARD', '419', 'Nghĩa Bình', 'Nghia Binh'),
('16966', 'WARD', '419', 'Nghĩa Minh', 'Nghia Minh'),
('16969', 'WARD', '419', 'Nghĩa Thọ', 'Nghia Tho'),
('16972', 'WARD', '419', 'Nghĩa Hưng', 'Nghia Hung'),
('16975', 'WARD', '419', 'Nghĩa Hồng', 'Nghia Hong'),
('16981', 'WARD', '419', 'Nghĩa Trung', 'Nghia Trung'),
('16984', 'WARD', '419', 'Nghĩa Hội', 'Nghia Hoi'),
('16987', 'WARD', '419', 'Nghĩa Thành', 'Nghia Thanh'),
('17020', 'WARD', '419', 'Nghĩa Đức', 'Nghia Duc'),
('17023', 'WARD', '419', 'Nghĩa An', 'Nghia An'),
('17026', 'WARD', '419', 'Nghĩa Long', 'Nghia Long'),
('17029', 'WARD', '419', 'Nghĩa Lộc', 'Nghia Loc'),
('17032', 'WARD', '419', 'Nghĩa Khánh', 'Nghia Khanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 420 - Quỳ Hợp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17035', 'WARD', '420', 'Thị trấn Quỳ Hợp', 'Thi tran Quy Hop'),
('17038', 'WARD', '420', 'Yên Hợp', 'Yen Hop'),
('17041', 'WARD', '420', 'Châu Tiến', 'Chau Tien'),
('17044', 'WARD', '420', 'Châu Hồng', 'Chau Hong'),
('17047', 'WARD', '420', 'Đồng Hợp', 'Dong Hop'),
('17050', 'WARD', '420', 'Châu Thành', 'Chau Thanh'),
('17053', 'WARD', '420', 'Liên Hợp', 'Lien Hop'),
('17056', 'WARD', '420', 'Châu Lộc', 'Chau Loc'),
('17059', 'WARD', '420', 'Tam Hợp', 'Tam Hop'),
('17062', 'WARD', '420', 'Châu Cường', 'Chau Cuong'),
('17065', 'WARD', '420', 'Châu Quang', 'Chau Quang'),
('17068', 'WARD', '420', 'Thọ Hợp', 'Tho Hop'),
('17071', 'WARD', '420', 'Minh Hợp', 'Minh Hop'),
('17074', 'WARD', '420', 'Nghĩa Xuân', 'Nghia Xuan'),
('17077', 'WARD', '420', 'Châu Thái', 'Chau Thai'),
('17080', 'WARD', '420', 'Châu Đình', 'Chau Dinh'),
('17083', 'WARD', '420', 'Văn Lợi', 'Van Loi'),
('17086', 'WARD', '420', 'Nam Sơn', 'Nam Son'),
('17089', 'WARD', '420', 'Châu Lý', 'Chau Ly'),
('17092', 'WARD', '420', 'Hạ Sơn', 'Ha Son'),
('17095', 'WARD', '420', 'Bắc Sơn', 'Bac Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 421 - Quỳnh Lưu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17101', 'WARD', '421', 'Quỳnh Thắng', 'Quynh Thang'),
('17119', 'WARD', '421', 'Quỳnh Tân', 'Quynh Tan'),
('17122', 'WARD', '421', 'Quỳnh Châu', 'Quynh Chau'),
('17140', 'WARD', '421', 'Tân Sơn', 'Tan Son'),
('17143', 'WARD', '421', 'Quỳnh Văn', 'Quynh Van'),
('17146', 'WARD', '421', 'Ngọc Sơn', 'Ngoc Son'),
('17149', 'WARD', '421', 'Quỳnh Tam', 'Quynh Tam'),
('17152', 'WARD', '421', 'Quỳnh Sơn', 'Quynh Son'),
('17155', 'WARD', '421', 'Quỳnh Thạch', 'Quynh Thach'),
('17158', 'WARD', '421', 'Quỳnh Bảng', 'Quynh Bang'),
('17164', 'WARD', '421', 'Quỳnh Thanh', 'Quynh Thanh'),
('17167', 'WARD', '421', 'Quỳnh Hậu', 'Quynh Hau'),
('17170', 'WARD', '421', 'Quỳnh Lâm', 'Quynh Lam'),
('17173', 'WARD', '421', 'Quỳnh Đôi', 'Quynh Doi'),
('17176', 'WARD', '421', 'Minh Lương', 'Minh Luong'),
('17179', 'WARD', '421', 'Thị trấn Cầu Giát', 'Thi tran Cau Giat'),
('17182', 'WARD', '421', 'Quỳnh Yên', 'Quynh Yen'),
('17185', 'WARD', '421', 'Bình Sơn', 'Binh Son'),
('17191', 'WARD', '421', 'Quỳnh Diễn', 'Quynh Dien'),
('17197', 'WARD', '421', 'Quỳnh Giang', 'Quynh Giang'),
('17206', 'WARD', '421', 'An Hòa', 'An Hoa'),
('17209', 'WARD', '421', 'Phú Nghĩa', 'Phu Nghia'),
('17212', 'WARD', '421', 'Văn Hải', 'Van Hai'),
('17218', 'WARD', '421', 'Thuận Long', 'Thuan Long'),
('17224', 'WARD', '421', 'Tân Thắng', 'Tan Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 422 - Con Cuông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17230', 'WARD', '422', 'Bình Chuẩn', 'Binh Chuan'),
('17233', 'WARD', '422', 'Lạng Khê', 'Lang Khe'),
('17236', 'WARD', '422', 'Cam Lâm', 'Cam Lam'),
('17239', 'WARD', '422', 'Thạch Ngàn', 'Thach Ngan'),
('17242', 'WARD', '422', 'Đôn Phục', 'Don Phuc'),
('17245', 'WARD', '422', 'Mậu Đức', 'Mau Duc'),
('17248', 'WARD', '422', 'Châu Khê', 'Chau Khe'),
('17251', 'WARD', '422', 'Chi Khê', 'Chi Khe'),
('17254', 'WARD', '422', 'Thị trấn Trà Lân', 'Thi tran Tra Lan'),
('17257', 'WARD', '422', 'Yên Khê', 'Yen Khe'),
('17260', 'WARD', '422', 'Lục Dạ', 'Luc Da'),
('17263', 'WARD', '422', 'Môn Sơn', 'Mon Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 423 - Tân Kỳ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17266', 'WARD', '423', 'Thị trấn Tân Kỳ', 'Thi tran Tan Ky'),
('17269', 'WARD', '423', 'Tân Hợp', 'Tan Hop'),
('17272', 'WARD', '423', 'Tân Phú', 'Tan Phu'),
('17275', 'WARD', '423', 'Tân Xuân', 'Tan Xuan'),
('17278', 'WARD', '423', 'Giai Xuân', 'Giai Xuan'),
('17281', 'WARD', '423', 'Bình Hợp', 'Binh Hop'),
('17284', 'WARD', '423', 'Nghĩa Đồng', 'Nghia Dong'),
('17287', 'WARD', '423', 'Đồng Văn', 'Dong Van'),
('17290', 'WARD', '423', 'Nghĩa Thái', 'Nghia Thai'),
('17296', 'WARD', '423', 'Hoàn Long', 'Hoan Long'),
('17299', 'WARD', '423', 'Nghĩa Phúc', 'Nghia Phuc'),
('17302', 'WARD', '423', 'Tiên Kỳ', 'Tien Ky'),
('17305', 'WARD', '423', 'Tân An', 'Tan An'),
('17308', 'WARD', '423', 'Nghĩa Dũng', 'Nghia Dung'),
('17314', 'WARD', '423', 'Kỳ Sơn', 'Ky Son'),
('17317', 'WARD', '423', 'Hương Sơn', 'Huong Son'),
('17320', 'WARD', '423', 'Kỳ Tân', 'Ky Tan'),
('17323', 'WARD', '423', 'Phú Sơn', 'Phu Son'),
('17325', 'WARD', '423', 'Tân Hương', 'Tan Huong'),
('17326', 'WARD', '423', 'Nghĩa Hành', 'Nghia Hanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 424 - Anh Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17329', 'WARD', '424', 'Thị trấn Kim Nhan', 'Thi tran Kim Nhan'),
('17332', 'WARD', '424', 'Thọ Sơn', 'Tho Son'),
('17335', 'WARD', '424', 'Thành Sơn', 'Thanh Son'),
('17338', 'WARD', '424', 'Bình Sơn', 'Binh Son'),
('17344', 'WARD', '424', 'Tam Đỉnh', 'Tam Dinh'),
('17347', 'WARD', '424', 'Hùng Sơn', 'Hung Son'),
('17350', 'WARD', '424', 'Cẩm Sơn', 'Cam Son'),
('17353', 'WARD', '424', 'Đức Sơn', 'Duc Son'),
('17356', 'WARD', '424', 'Tường Sơn', 'Tuong Son'),
('17357', 'WARD', '424', 'Hoa Sơn', 'Hoa Son'),
('17359', 'WARD', '424', 'Tào Sơn', 'Tao Son'),
('17362', 'WARD', '424', 'Vĩnh Sơn', 'Vinh Son'),
('17365', 'WARD', '424', 'Lạng Sơn', 'Lang Son'),
('17368', 'WARD', '424', 'Hội Sơn', 'Hoi Son'),
('17374', 'WARD', '424', 'Phúc Sơn', 'Phuc Son'),
('17377', 'WARD', '424', 'Long Sơn', 'Long Son'),
('17380', 'WARD', '424', 'Khai Sơn', 'Khai Son'),
('17383', 'WARD', '424', 'Lĩnh Sơn', 'Linh Son'),
('17386', 'WARD', '424', 'Cao Sơn', 'Cao Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 425 - Diễn Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17392', 'WARD', '425', 'Diễn Lâm', 'Dien Lam'),
('17395', 'WARD', '425', 'Diễn Đoài', 'Dien Doai'),
('17398', 'WARD', '425', 'Diễn Trường', 'Dien Truong'),
('17401', 'WARD', '425', 'Diễn Yên', 'Dien Yen'),
('17404', 'WARD', '425', 'Diễn Hoàng', 'Dien Hoang'),
('17410', 'WARD', '425', 'Diễn Mỹ', 'Dien My'),
('17413', 'WARD', '425', 'Diễn Hồng', 'Dien Hong'),
('17416', 'WARD', '425', 'Diễn Phong', 'Dien Phong'),
('17419', 'WARD', '425', 'Hùng Hải', 'Hung Hai'),
('17425', 'WARD', '425', 'Diễn Liên', 'Dien Lien'),
('17428', 'WARD', '425', 'Diễn Vạn', 'Dien Van'),
('17431', 'WARD', '425', 'Diễn Kim', 'Dien Kim'),
('17434', 'WARD', '425', 'Diễn Kỷ', 'Dien Ky'),
('17437', 'WARD', '425', 'Xuân Tháp', 'Xuan Thap'),
('17440', 'WARD', '425', 'Diễn Thái', 'Dien Thai'),
('17443', 'WARD', '425', 'Diễn Đồng', 'Dien Dong'),
('17449', 'WARD', '425', 'Hạnh Quảng', 'Hanh Quang'),
('17452', 'WARD', '425', 'Ngọc Bích', 'Ngoc Bich'),
('17458', 'WARD', '425', 'Diễn Nguyên', 'Dien Nguyen'),
('17461', 'WARD', '425', 'Diễn Hoa', 'Dien Hoa'),
('17464', 'WARD', '425', 'Thị trấn Diễn Thành', 'Thi tran Dien Thanh'),
('17467', 'WARD', '425', 'Diễn Phúc', 'Dien Phuc'),
('17476', 'WARD', '425', 'Diễn Cát', 'Dien Cat'),
('17479', 'WARD', '425', 'Diễn Thịnh', 'Dien Thinh'),
('17482', 'WARD', '425', 'Diễn Tân', 'Dien Tan'),
('17485', 'WARD', '425', 'Minh Châu', 'Minh Chau'),
('17488', 'WARD', '425', 'Diễn Thọ', 'Dien Tho'),
('17491', 'WARD', '425', 'Diễn Lợi', 'Dien Loi'),
('17494', 'WARD', '425', 'Diễn Lộc', 'Dien Loc'),
('17497', 'WARD', '425', 'Diễn Trung', 'Dien Trung'),
('17500', 'WARD', '425', 'Diễn An', 'Dien An'),
('17503', 'WARD', '425', 'Diễn Phú', 'Dien Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 426 - Yên Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17506', 'WARD', '426', 'Thị trấn Hoa Thành', 'Thi tran Hoa Thanh'),
('17509', 'WARD', '426', 'Mã Thành', 'Ma Thanh'),
('17510', 'WARD', '426', 'Tiến Thành', 'Tien Thanh'),
('17512', 'WARD', '426', 'Lăng Thành', 'Lang Thanh'),
('17515', 'WARD', '426', 'Tân Thành', 'Tan Thanh'),
('17518', 'WARD', '426', 'Đức Thành', 'Duc Thanh'),
('17521', 'WARD', '426', 'Kim Thành', 'Kim Thanh'),
('17524', 'WARD', '426', 'Hậu Thành', 'Hau Thanh'),
('17527', 'WARD', '426', 'Đô Thành', 'Do Thanh'),
('17530', 'WARD', '426', 'Thọ Thành', 'Tho Thanh'),
('17533', 'WARD', '426', 'Quang Thành', 'Quang Thanh'),
('17536', 'WARD', '426', 'Tây Thành', 'Tay Thanh'),
('17539', 'WARD', '426', 'Phúc Thành', 'Phuc Thanh'),
('17542', 'WARD', '426', 'Phú Thành', 'Phu Thanh'),
('17545', 'WARD', '426', 'Đồng Thành', 'Dong Thanh'),
('17554', 'WARD', '426', 'Tăng Thành', 'Tang Thanh'),
('17557', 'WARD', '426', 'Văn Thành', 'Van Thanh'),
('17560', 'WARD', '426', 'Thịnh Thành', 'Thinh Thanh'),
('17566', 'WARD', '426', 'Xuân Thành', 'Xuan Thanh'),
('17569', 'WARD', '426', 'Bắc Thành', 'Bac Thanh'),
('17572', 'WARD', '426', 'Đông Thành', 'Dong Thanh'),
('17575', 'WARD', '426', 'Trung Thành', 'Trung Thanh'),
('17578', 'WARD', '426', 'Long Thành', 'Long Thanh'),
('17581', 'WARD', '426', 'Minh Thành', 'Minh Thanh'),
('17584', 'WARD', '426', 'Nam Thành', 'Nam Thanh'),
('17587', 'WARD', '426', 'Vĩnh Thành', 'Vinh Thanh'),
('17596', 'WARD', '426', 'Viên Thành', 'Vien Thanh'),
('17602', 'WARD', '426', 'Liên Thành', 'Lien Thanh'),
('17605', 'WARD', '426', 'Bảo Thành', 'Bao Thanh'),
('17608', 'WARD', '426', 'Mỹ Thành', 'My Thanh'),
('17611', 'WARD', '426', 'Vân Tụ', 'Van Tu'),
('17614', 'WARD', '426', 'Sơn Thành', 'Son Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 427 - Đô Lương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17617', 'WARD', '427', 'Thị trấn Đô Lương', 'Thi tran Do Luong'),
('17619', 'WARD', '427', 'Giang Sơn Đông', 'Giang Son Dong'),
('17620', 'WARD', '427', 'Giang Sơn Tây', 'Giang Son Tay'),
('17623', 'WARD', '427', 'Bạch Ngọc', 'Bach Ngoc'),
('17626', 'WARD', '427', 'Bồi Sơn', 'Boi Son'),
('17629', 'WARD', '427', 'Hồng Sơn', 'Hong Son'),
('17632', 'WARD', '427', 'Bài Sơn', 'Bai Son'),
('17638', 'WARD', '427', 'Bắc Sơn', 'Bac Son'),
('17641', 'WARD', '427', 'Tràng Sơn', 'Trang Son'),
('17644', 'WARD', '427', 'Thượng Sơn', 'Thuong Son'),
('17647', 'WARD', '427', 'Hòa Sơn', 'Hoa Son'),
('17650', 'WARD', '427', 'Đặng Sơn', 'Dang Son'),
('17653', 'WARD', '427', 'Đông Sơn', 'Dong Son'),
('17656', 'WARD', '427', 'Nam Sơn', 'Nam Son'),
('17659', 'WARD', '427', 'Lưu Sơn', 'Luu Son'),
('17662', 'WARD', '427', 'Yên Sơn', 'Yen Son'),
('17665', 'WARD', '427', 'Văn Sơn', 'Van Son'),
('17668', 'WARD', '427', 'Đà Sơn', 'Da Son'),
('17671', 'WARD', '427', 'Lạc Sơn', 'Lac Son'),
('17674', 'WARD', '427', 'Tân Sơn', 'Tan Son'),
('17677', 'WARD', '427', 'Thái Sơn', 'Thai Son'),
('17680', 'WARD', '427', 'Quang Sơn', 'Quang Son'),
('17683', 'WARD', '427', 'Thịnh Sơn', 'Thinh Son'),
('17686', 'WARD', '427', 'Trung Sơn', 'Trung Son'),
('17689', 'WARD', '427', 'Xuân Sơn', 'Xuan Son'),
('17692', 'WARD', '427', 'Minh Sơn', 'Minh Son'),
('17695', 'WARD', '427', 'Thuận Sơn', 'Thuan Son'),
('17698', 'WARD', '427', 'Nhân Sơn', 'Nhan Son'),
('17701', 'WARD', '427', 'Hiến Sơn', 'Hien Son'),
('17704', 'WARD', '427', 'Mỹ Sơn', 'My Son'),
('17707', 'WARD', '427', 'Trù Sơn', 'Tru Son'),
('17710', 'WARD', '427', 'Đại Sơn', 'Dai Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 428 - Thanh Chương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17713', 'WARD', '428', 'Thị trấn Dùng', 'Thi tran Dung'),
('17716', 'WARD', '428', 'Cát Văn', 'Cat Van'),
('17719', 'WARD', '428', 'Minh Sơn', 'Minh Son'),
('17722', 'WARD', '428', 'Hạnh Lâm', 'Hanh Lam'),
('17723', 'WARD', '428', 'Thanh Sơn', 'Thanh Son'),
('17728', 'WARD', '428', 'Phong Thịnh', 'Phong Thinh'),
('17731', 'WARD', '428', 'Thanh Phong', 'Thanh Phong'),
('17734', 'WARD', '428', 'Thanh Mỹ', 'Thanh My'),
('17737', 'WARD', '428', 'Thanh Tiên', 'Thanh Tien'),
('17743', 'WARD', '428', 'Thanh Liên', 'Thanh Lien'),
('17749', 'WARD', '428', 'Đại Đồng', 'Dai Dong'),
('17755', 'WARD', '428', 'Thanh Ngọc', 'Thanh Ngoc'),
('17758', 'WARD', '428', 'Thanh Hương', 'Thanh Huong'),
('17759', 'WARD', '428', 'Ngọc Lâm', 'Ngoc Lam'),
('17764', 'WARD', '428', 'Đồng Văn', 'Dong Van'),
('17767', 'WARD', '428', 'Ngọc Sơn', 'Ngoc Son'),
('17770', 'WARD', '428', 'Thanh Thịnh', 'Thanh Thinh'),
('17773', 'WARD', '428', 'Thanh An', 'Thanh An'),
('17776', 'WARD', '428', 'Thanh Quả', 'Thanh Qua'),
('17779', 'WARD', '428', 'Xuân Dương', 'Xuan Duong'),
('17785', 'WARD', '428', 'Minh Tiến', 'Minh Tien'),
('17791', 'WARD', '428', 'Kim Bảng', 'Kim Bang'),
('17797', 'WARD', '428', 'Thanh Thủy', 'Thanh Thuy'),
('17806', 'WARD', '428', 'Thanh Hà', 'Thanh Ha'),
('17812', 'WARD', '428', 'Thanh Tùng', 'Thanh Tung'),
('17815', 'WARD', '428', 'Thanh Lâm', 'Thanh Lam'),
('17818', 'WARD', '428', 'Mai Giang', 'Mai Giang'),
('17821', 'WARD', '428', 'Thanh Xuân', 'Thanh Xuan'),
('17824', 'WARD', '428', 'Thanh Đức', 'Thanh Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 429 - Nghi Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17827', 'WARD', '429', 'Thị trấn Quán Hành', 'Thi tran Hanh'),
('17830', 'WARD', '429', 'Nghi Văn', 'Nghi Van'),
('17833', 'WARD', '429', 'Nghi Yên', 'Nghi Yen'),
('17836', 'WARD', '429', 'Nghi Tiến', 'Nghi Tien'),
('17839', 'WARD', '429', 'Nghi Hưng', 'Nghi Hung'),
('17842', 'WARD', '429', 'Nghi Đồng', 'Nghi Dong'),
('17845', 'WARD', '429', 'Nghi Thiết', 'Nghi Thiet'),
('17848', 'WARD', '429', 'Nghi Lâm', 'Nghi Lam'),
('17851', 'WARD', '429', 'Nghi Quang', 'Nghi Quang'),
('17854', 'WARD', '429', 'Nghi Kiều', 'Nghi Kieu'),
('17857', 'WARD', '429', 'Nghi Mỹ', 'Nghi My'),
('17860', 'WARD', '429', 'Nghi Phương', 'Nghi Phuong'),
('17863', 'WARD', '429', 'Nghi Thuận', 'Nghi Thuan'),
('17866', 'WARD', '429', 'Nghi Long', 'Nghi Long'),
('17869', 'WARD', '429', 'Nghi Xá', 'Nghi Xa'),
('17878', 'WARD', '429', 'Khánh Hợp', 'Khanh Hop'),
('17884', 'WARD', '429', 'Nghi Công Bắc', 'Nghi Cong Bac'),
('17887', 'WARD', '429', 'Nghi Công Nam', 'Nghi Cong Nam'),
('17890', 'WARD', '429', 'Nghi Thạch', 'Nghi Thach'),
('17893', 'WARD', '429', 'Nghi Trung', 'Nghi Trung'),
('17896', 'WARD', '429', 'Thịnh Trường', 'Thinh Truong'),
('17899', 'WARD', '429', 'Diên Hoa', 'Dien Hoa'),
('17911', 'WARD', '429', 'Nghi Vạn', 'Nghi Van')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 430 - Nam Đàn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17932', 'WARD', '430', 'Nam Hưng', 'Nam Hung'),
('17935', 'WARD', '430', 'Nghĩa Thái', 'Nghia Thai'),
('17938', 'WARD', '430', 'Nam Thanh', 'Nam Thanh'),
('17941', 'WARD', '430', 'Nam Anh', 'Nam Anh'),
('17944', 'WARD', '430', 'Nam Xuân', 'Nam Xuan'),
('17950', 'WARD', '430', 'Thị trấn Nam Đàn', 'Thi tran Nam Dan'),
('17953', 'WARD', '430', 'Nam Lĩnh', 'Nam Linh'),
('17956', 'WARD', '430', 'Nam Giang', 'Nam Giang'),
('17959', 'WARD', '430', 'Xuân Hòa', 'Xuan Hoa'),
('17962', 'WARD', '430', 'Hùng Tiến', 'Hung Tien'),
('17968', 'WARD', '430', 'Thượng Tân Lộc', 'Thuong Tan Loc'),
('17971', 'WARD', '430', 'Kim Liên', 'Kim Lien'),
('17980', 'WARD', '430', 'Xuân Hồng', 'Xuan Hong'),
('17983', 'WARD', '430', 'Nam Cát', 'Nam Cat'),
('17986', 'WARD', '430', 'Khánh Sơn', 'Khanh Son'),
('17989', 'WARD', '430', 'Trung Phúc Cường', 'Trung Phuc Cuong'),
('17998', 'WARD', '430', 'Nam Kim', 'Nam Kim')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 431 - Hưng Nguyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18001', 'WARD', '431', 'Thị trấn Hưng Nguyên', 'Thi tran Hung Nguyen'),
('18004', 'WARD', '431', 'Hưng Trung', 'Hung Trung'),
('18007', 'WARD', '431', 'Hưng Yên', 'Hung Yen'),
('18008', 'WARD', '431', 'Hưng Yên Bắc', 'Hung Yen Bac'),
('18010', 'WARD', '431', 'Hưng Tây', 'Hung Tay'),
('18016', 'WARD', '431', 'Hưng Đạo', 'Hung Dao'),
('18022', 'WARD', '431', 'Thịnh Mỹ', 'Thinh My'),
('18025', 'WARD', '431', 'Hưng Lĩnh', 'Hung Linh'),
('18028', 'WARD', '431', 'Thông Tân', 'Thong Tan'),
('18037', 'WARD', '431', 'Hưng Nghĩa', 'Hung Nghia'),
('18040', 'WARD', '431', 'Phúc Lợi', 'Phuc Loi'),
('18043', 'WARD', '431', 'Long Xá', 'Long Xa'),
('18052', 'WARD', '431', 'Châu Nhân', 'Chau Nhan'),
('18055', 'WARD', '431', 'Xuân Lam', 'Xuan Lam'),
('18064', 'WARD', '431', 'Hưng Thành', 'Hung Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 432 - Thị Hoàng Mai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('17104', 'WARD', '432', 'Quỳnh Vinh', 'Quynh Vinh'),
('17107', 'WARD', '432', 'Quỳnh Lộc', 'Quynh Loc'),
('17110', 'WARD', '432', 'Quỳnh Thiện', 'Quynh Thien'),
('17113', 'WARD', '432', 'Quỳnh Lập', 'Quynh Lap'),
('17116', 'WARD', '432', 'Quỳnh Trang', 'Quynh Trang'),
('17125', 'WARD', '432', 'Mai Hùng', 'Mai Hung'),
('17128', 'WARD', '432', 'Quỳnh Dị', 'Quynh Di'),
('17131', 'WARD', '432', 'Quỳnh Xuân', 'Quynh Xuan'),
('17134', 'WARD', '432', 'Quỳnh Phương', 'Quynh Phuong'),
('17137', 'WARD', '432', 'Quỳnh Liên', 'Quynh Lien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 42 - Hà Tĩnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('436', 'DISTRICT', '42', 'Hà Tĩnh', 'Thanh pho Ha Tinh'),
('437', 'DISTRICT', '42', 'Thị Hồng Lĩnh', 'Thi Hong Linh'),
('439', 'DISTRICT', '42', 'Hương Sơn', 'Huong Son'),
('440', 'DISTRICT', '42', 'Đức Thọ', 'Duc Tho'),
('441', 'DISTRICT', '42', 'Vũ Quang', 'Vu Quang'),
('442', 'DISTRICT', '42', 'Nghi Xuân', 'Nghi Xuan'),
('443', 'DISTRICT', '42', 'Can Lộc', 'Can Loc'),
('444', 'DISTRICT', '42', 'Hương Khê', 'Huong Khe'),
('445', 'DISTRICT', '42', 'Thạch Hà', 'Thach Ha'),
('446', 'DISTRICT', '42', 'Cẩm Xuyên', 'Cam Xuyen'),
('447', 'DISTRICT', '42', 'Kỳ Anh', 'Ky Anh'),
('449', 'DISTRICT', '42', 'Thị Kỳ Anh', 'Thi Ky Anh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 436 - Hà Tĩnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18073', 'WARD', '436', 'Nam Hà', 'Nam Ha'),
('18077', 'WARD', '436', 'Bắc Hà', 'Bac Ha'),
('18079', 'WARD', '436', 'Tân Giang', 'Tan Giang'),
('18082', 'WARD', '436', 'Đại Nài', 'Dai Nai'),
('18085', 'WARD', '436', 'Hà Huy Tập', 'Ha Huy Tap'),
('18088', 'WARD', '436', 'Thạch Trung', 'Thach Trung'),
('18091', 'WARD', '436', 'Thạch Quý', 'Thach Quy'),
('18094', 'WARD', '436', 'Trần Phú', 'Tran Phu'),
('18097', 'WARD', '436', 'Văn Yên', 'Van Yen'),
('18100', 'WARD', '436', 'Thạch Hạ', 'Thach Ha'),
('18103', 'WARD', '436', 'Đồng Môn', 'Dong Mon'),
('18109', 'WARD', '436', 'Thạch Hưng', 'Thach Hung'),
('18112', 'WARD', '436', 'Thạch Bình', 'Thach Binh'),
('18571', 'WARD', '436', 'Thạch Hải', 'Thach Hai'),
('18595', 'WARD', '436', 'Đỉnh Bàn', 'Dinh Ban'),
('18598', 'WARD', '436', 'Hộ Độ', 'Ho Do'),
('18604', 'WARD', '436', 'Thạch Khê', 'Thach Khe'),
('18619', 'WARD', '436', 'Thạch Trị', 'Thach Tri'),
('18622', 'WARD', '436', 'Thạch Lạc', 'Thach Lac'),
('18628', 'WARD', '436', 'Tượng Sơn', 'Tuong Son'),
('18631', 'WARD', '436', 'Thạch Văn', 'Thach Van'),
('18637', 'WARD', '436', 'Thạch Thắng', 'Thach Thang'),
('18643', 'WARD', '436', 'Thạch Đài', 'Thach Dai'),
('18649', 'WARD', '436', 'Thạch Hội', 'Thach Hoi'),
('18652', 'WARD', '436', 'Tân Lâm Hương', 'Tan Lam Huong'),
('18685', 'WARD', '436', 'Cẩm Bình', 'Cam Binh'),
('18691', 'WARD', '436', 'Cẩm Vịnh', 'Cam Vinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 437 - Thị Hồng Lĩnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18115', 'WARD', '437', 'Bắc Hồng', 'Bac Hong'),
('18118', 'WARD', '437', 'Nam Hồng', 'Nam Hong'),
('18121', 'WARD', '437', 'Trung Lương', 'Trung Luong'),
('18124', 'WARD', '437', 'Đức Thuận', 'Duc Thuan'),
('18127', 'WARD', '437', 'Đậu Liêu', 'Dau Lieu'),
('18130', 'WARD', '437', 'Thuận Lộc', 'Thuan Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 439 - Hương Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18133', 'WARD', '439', 'Thị trấn Phố Châu', 'Thi tran Pho Chau'),
('18136', 'WARD', '439', 'Thị trấn Tây Sơn', 'Thi tran Tay Son'),
('18139', 'WARD', '439', 'Sơn Hồng', 'Son Hong'),
('18142', 'WARD', '439', 'Sơn Tiến', 'Son Tien'),
('18145', 'WARD', '439', 'Sơn Lâm', 'Son Lam'),
('18148', 'WARD', '439', 'Sơn Lễ', 'Son Le'),
('18157', 'WARD', '439', 'Sơn Giang', 'Son Giang'),
('18160', 'WARD', '439', 'Sơn Lĩnh', 'Son Linh'),
('18163', 'WARD', '439', 'An Hòa Thịnh', 'An Hoa Thinh'),
('18172', 'WARD', '439', 'Sơn Tây', 'Son Tay'),
('18175', 'WARD', '439', 'Sơn Ninh', 'Son Ninh'),
('18178', 'WARD', '439', 'Châu Bình', 'Chau Binh'),
('18181', 'WARD', '439', 'Tân Mỹ Hà', 'Tan My Ha'),
('18184', 'WARD', '439', 'Quang Diệm', 'Quang Diem'),
('18187', 'WARD', '439', 'Sơn Trung', 'Son Trung'),
('18190', 'WARD', '439', 'Sơn Bằng', 'Son Bang'),
('18196', 'WARD', '439', 'Sơn Kim 1', 'Son Kim 1'),
('18199', 'WARD', '439', 'Sơn Kim 2', 'Son Kim 2'),
('18202', 'WARD', '439', 'Mỹ Long', 'My Long'),
('18211', 'WARD', '439', 'Kim Hoa', 'Kim Hoa'),
('18217', 'WARD', '439', 'Sơn Phú', 'Son Phu'),
('18223', 'WARD', '439', 'Hàm Trường', 'Ham Truong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 440 - Đức Thọ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18229', 'WARD', '440', 'Thị trấn Đức Thọ', 'Thi tran Duc Tho'),
('18235', 'WARD', '440', 'Quang Vĩnh', 'Quang Vinh'),
('18241', 'WARD', '440', 'Tùng Châu', 'Tung Chau'),
('18244', 'WARD', '440', 'Trường Sơn', 'Truong Son'),
('18247', 'WARD', '440', 'Liên Minh', 'Lien Minh'),
('18253', 'WARD', '440', 'Yên Hồ', 'Yen Ho'),
('18259', 'WARD', '440', 'Tùng Ảnh', 'Tung Anh'),
('18262', 'WARD', '440', 'Bùi La Nhân', 'Bui La Nhan'),
('18274', 'WARD', '440', 'Thanh Bình Thịnh', 'Thanh Binh Thinh'),
('18277', 'WARD', '440', 'Lâm Trung Thủy', 'Lam Trung Thuy'),
('18280', 'WARD', '440', 'Hòa Lạc', 'Hoa Lac'),
('18283', 'WARD', '440', 'Tân Dân', 'Tan Dan'),
('18298', 'WARD', '440', 'An Dũng', 'An Dung'),
('18304', 'WARD', '440', 'Đức Đồng', 'Duc Dong'),
('18307', 'WARD', '440', 'Đức Lạng', 'Duc Lang'),
('18310', 'WARD', '440', 'Tân Hương', 'Tan Huong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 441 - Vũ Quang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18313', 'WARD', '441', 'Thị trấn Vũ Quang', 'Thi tran Vu Quang'),
('18316', 'WARD', '441', 'Ân Phú', 'An Phu'),
('18319', 'WARD', '441', 'Đức Giang', 'Duc Giang'),
('18322', 'WARD', '441', 'Đức Lĩnh', 'Duc Linh'),
('18325', 'WARD', '441', 'Thọ Điền', 'Tho Dien'),
('18328', 'WARD', '441', 'Đức Hương', 'Duc Huong'),
('18331', 'WARD', '441', 'Đức Bồng', 'Duc Bong'),
('18334', 'WARD', '441', 'Đức Liên', 'Duc Lien'),
('18340', 'WARD', '441', 'Hương Minh', 'Huong Minh'),
('18343', 'WARD', '441', 'Quang Thọ', 'Quang Tho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 442 - Nghi Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18352', 'WARD', '442', 'Thị trấn Xuân An', 'Thi tran Xuan An'),
('18355', 'WARD', '442', 'Xuân Hội', 'Xuan Hoi'),
('18358', 'WARD', '442', 'Đan Trường', 'Dan Truong'),
('18364', 'WARD', '442', 'Xuân Phổ', 'Xuan Pho'),
('18367', 'WARD', '442', 'Xuân Hải', 'Xuan Hai'),
('18370', 'WARD', '442', 'Xuân Giang', 'Xuan Giang'),
('18373', 'WARD', '442', 'Thị trấn Tiên Điền', 'Thi tran Tien Dien'),
('18376', 'WARD', '442', 'Xuân Yên', 'Xuan Yen'),
('18379', 'WARD', '442', 'Xuân Mỹ', 'Xuan My'),
('18382', 'WARD', '442', 'Xuân Thành', 'Xuan Thanh'),
('18385', 'WARD', '442', 'Xuân Viên', 'Xuan Vien'),
('18388', 'WARD', '442', 'Xuân Hồng', 'Xuan Hong'),
('18391', 'WARD', '442', 'Cỗ Đạm', 'Co Dam'),
('18394', 'WARD', '442', 'Xuân Liên', 'Xuan Lien'),
('18397', 'WARD', '442', 'Xuân Lĩnh', 'Xuan Linh'),
('18400', 'WARD', '442', 'Xuân Lam', 'Xuan Lam'),
('18403', 'WARD', '442', 'Cương Gián', 'Cuong Gian')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 443 - Can Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18406', 'WARD', '443', 'Thị trấn Nghèn', 'Thi tran Nghen'),
('18415', 'WARD', '443', 'Thiên Lộc', 'Thien Loc'),
('18418', 'WARD', '443', 'Thuần Thiện', 'Thuan Thien'),
('18427', 'WARD', '443', 'Vượng Lộc', 'Vuong Loc'),
('18433', 'WARD', '443', 'Thanh Lộc', 'Thanh Loc'),
('18436', 'WARD', '443', 'Kim Song Trường', 'Kim Song Truong'),
('18439', 'WARD', '443', 'Thường Nga', 'Thuong Nga'),
('18445', 'WARD', '443', 'Tùng Lộc', 'Tung Loc'),
('18454', 'WARD', '443', 'Phú Lộc', 'Phu Loc'),
('18463', 'WARD', '443', 'Gia Hanh', 'Gia Hanh'),
('18466', 'WARD', '443', 'Khánh Vĩnh Yên', 'Khanh Vinh Yen'),
('18475', 'WARD', '443', 'Xuân Lộc', 'Xuan Loc'),
('18478', 'WARD', '443', 'Thượng Lộc', 'Thuong Loc'),
('18481', 'WARD', '443', 'Quang Lộc', 'Quang Loc'),
('18484', 'WARD', '443', 'Thị trấn Đồng Lộc', 'Thi tran Dong Loc'),
('18487', 'WARD', '443', 'Mỹ Lộc', 'My Loc'),
('18490', 'WARD', '443', 'Sơn Lộc', 'Son Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 444 - Hương Khê
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18496', 'WARD', '444', 'Thị trấn Hương Khê', 'Thi tran Huong Khe'),
('18499', 'WARD', '444', 'Điền Mỹ', 'Dien My'),
('18502', 'WARD', '444', 'Hà Linh', 'Ha Linh'),
('18505', 'WARD', '444', 'Hương Thủy', 'Huong Thuy'),
('18508', 'WARD', '444', 'Hòa Hải', 'Hoa Hai'),
('18514', 'WARD', '444', 'Phúc Đồng', 'Phuc Dong'),
('18517', 'WARD', '444', 'Hương Giang', 'Huong Giang'),
('18520', 'WARD', '444', 'Lộc Yên', 'Loc Yen'),
('18523', 'WARD', '444', 'Hương Bình', 'Huong Binh'),
('18526', 'WARD', '444', 'Hương Long', 'Huong Long'),
('18529', 'WARD', '444', 'Phú Gia', 'Phu Gia'),
('18532', 'WARD', '444', 'Gia Phố', 'Gia Pho'),
('18538', 'WARD', '444', 'Hương Đô', 'Huong Do'),
('18541', 'WARD', '444', 'Hương Vĩnh', 'Huong Vinh'),
('18544', 'WARD', '444', 'Hương Xuân', 'Huong Xuan'),
('18547', 'WARD', '444', 'Phúc Trạch', 'Phuc Trach'),
('18550', 'WARD', '444', 'Hương Trà', 'Huong Tra'),
('18553', 'WARD', '444', 'Hương Trạch', 'Huong Trach'),
('18556', 'WARD', '444', 'Hương Lâm', 'Huong Lam'),
('18559', 'WARD', '444', 'Hương Liên', 'Huong Lien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 445 - Thạch Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18409', 'WARD', '445', 'Tân Lộc', 'Tan Loc'),
('18412', 'WARD', '445', 'Hồng Lộc', 'Hong Loc'),
('18421', 'WARD', '445', 'Thịnh Lộc', 'Thinh Loc'),
('18430', 'WARD', '445', 'Bình An', 'Binh An'),
('18448', 'WARD', '445', 'Bình Lộc', 'Binh Loc'),
('18457', 'WARD', '445', 'Ích Hậu', 'Ich Hau'),
('18493', 'WARD', '445', 'Phù Lưu', 'Phu Luu'),
('18562', 'WARD', '445', 'Thị trấn Thạch Hà', 'Thi tran Thach Ha'),
('18565', 'WARD', '445', 'Ngọc Sơn', 'Ngoc Son'),
('18568', 'WARD', '445', 'Thị trấn Lộc Hà', 'Thi tran Loc Ha'),
('18577', 'WARD', '445', 'Thạch Mỹ', 'Thach My'),
('18580', 'WARD', '445', 'Thạch Kim', 'Thach Kim'),
('18583', 'WARD', '445', 'Thạch Châu', 'Thach Chau'),
('18586', 'WARD', '445', 'Thạch Kênh', 'Thach Kenh'),
('18589', 'WARD', '445', 'Thạch Sơn', 'Thach Son'),
('18592', 'WARD', '445', 'Thạch Liên', 'Thach Lien'),
('18601', 'WARD', '445', 'Việt Tiến', 'Viet Tien'),
('18607', 'WARD', '445', 'Thạch Long', 'Thach Long'),
('18625', 'WARD', '445', 'Thạch Ngọc', 'Thach Ngoc'),
('18634', 'WARD', '445', 'Lưu Vĩnh Sơn', 'Luu Vinh Son'),
('18658', 'WARD', '445', 'Thạch Xuân', 'Thach Xuan'),
('18667', 'WARD', '445', 'Nam Điền', 'Nam Dien'),
('18670', 'WARD', '445', 'Mai Phụ', 'Mai Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 446 - Cẩm Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18673', 'WARD', '446', 'Thị trấn Cẩm Xuyên', 'Thi tran Cam Xuyen'),
('18676', 'WARD', '446', 'Thị trấn Thiên Cầm', 'Thi tran Thien Cam'),
('18679', 'WARD', '446', 'Yên Hòa', 'Yen Hoa'),
('18682', 'WARD', '446', 'Cẩm Dương', 'Cam Duong'),
('18694', 'WARD', '446', 'Cẩm Thành', 'Cam Thanh'),
('18697', 'WARD', '446', 'Cẩm Quang', 'Cam Quang'),
('18706', 'WARD', '446', 'Cẩm Thạch', 'Cam Thach'),
('18709', 'WARD', '446', 'Cẩm Nhượng', 'Cam Nhuong'),
('18712', 'WARD', '446', 'Nam Phúc Thăng', 'Nam Phuc Thang'),
('18715', 'WARD', '446', 'Cẩm Duệ', 'Cam Due'),
('18721', 'WARD', '446', 'Cẩm Lĩnh', 'Cam Linh'),
('18724', 'WARD', '446', 'Cẩm Quan', 'Cam Quan'),
('18727', 'WARD', '446', 'Cẩm Hà', 'Cam Ha'),
('18730', 'WARD', '446', 'Cẩm Lộc', 'Cam Loc'),
('18733', 'WARD', '446', 'Cẩm Hưng', 'Cam Hung'),
('18736', 'WARD', '446', 'Cẩm Thịnh', 'Cam Thinh'),
('18739', 'WARD', '446', 'Cẩm Mỹ', 'Cam My'),
('18742', 'WARD', '446', 'Cẩm Trung', 'Cam Trung'),
('18745', 'WARD', '446', 'Cẩm Sơn', 'Cam Son'),
('18748', 'WARD', '446', 'Cẩm Lạc', 'Cam Lac'),
('18751', 'WARD', '446', 'Cẩm Minh', 'Cam Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 447 - Kỳ Anh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18757', 'WARD', '447', 'Kỳ Xuân', 'Ky Xuan'),
('18760', 'WARD', '447', 'Kỳ Bắc', 'Ky Bac'),
('18763', 'WARD', '447', 'Kỳ Phú', 'Ky Phu'),
('18766', 'WARD', '447', 'Kỳ Phong', 'Ky Phong'),
('18769', 'WARD', '447', 'Kỳ Tiến', 'Ky Tien'),
('18772', 'WARD', '447', 'Kỳ Giang', 'Ky Giang'),
('18775', 'WARD', '447', 'Thị trấn Kỳ Đồng', 'Thi tran Ky Dong'),
('18778', 'WARD', '447', 'Kỳ Khang', 'Ky Khang'),
('18784', 'WARD', '447', 'Kỳ Văn', 'Ky Van'),
('18787', 'WARD', '447', 'Kỳ Trung', 'Ky Trung'),
('18790', 'WARD', '447', 'Kỳ Thọ', 'Ky Tho'),
('18793', 'WARD', '447', 'Kỳ Tây', 'Ky Tay'),
('18799', 'WARD', '447', 'Kỳ Thượng', 'Ky Thuong'),
('18802', 'WARD', '447', 'Kỳ Hải', 'Ky Hai'),
('18805', 'WARD', '447', 'Kỳ Thư', 'Ky Thu'),
('18811', 'WARD', '447', 'Kỳ Châu', 'Ky Chau'),
('18814', 'WARD', '447', 'Kỳ Tân', 'Ky Tan'),
('18838', 'WARD', '447', 'Lâm Hợp', 'Lam Hop'),
('18844', 'WARD', '447', 'Kỳ Sơn', 'Ky Son'),
('18850', 'WARD', '447', 'Kỳ Lạc', 'Ky Lac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 449 - Thị Kỳ Anh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18754', 'WARD', '449', 'Hưng Trí', 'Hung Tri'),
('18781', 'WARD', '449', 'Kỳ Ninh', 'Ky Ninh'),
('18796', 'WARD', '449', 'Kỳ Lợi', 'Ky Loi'),
('18808', 'WARD', '449', 'Kỳ Hà', 'Ky Ha'),
('18820', 'WARD', '449', 'Kỳ Trinh', 'Ky Trinh'),
('18823', 'WARD', '449', 'Kỳ Thịnh', 'Ky Thinh'),
('18829', 'WARD', '449', 'Kỳ Hoa', 'Ky Hoa'),
('18832', 'WARD', '449', 'Kỳ Phương', 'Ky Phuong'),
('18835', 'WARD', '449', 'Kỳ Long', 'Ky Long'),
('18841', 'WARD', '449', 'Kỳ Liên', 'Ky Lien'),
('18847', 'WARD', '449', 'Kỳ Nam', 'Ky Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 44 - Quảng Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('450', 'DISTRICT', '44', 'Đồng Hới', 'Thanh Pho Dong Hoi'),
('452', 'DISTRICT', '44', 'Minh Hóa', 'Minh Hoa'),
('453', 'DISTRICT', '44', 'Tuyên Hóa', 'Tuyen Hoa'),
('454', 'DISTRICT', '44', 'Quảng Trạch', 'Quang Trach'),
('455', 'DISTRICT', '44', 'Bố Trạch', 'Bo Trach'),
('456', 'DISTRICT', '44', 'Quảng Ninh', 'Quang Ninh'),
('457', 'DISTRICT', '44', 'Lệ Thủy', 'Le Thuy'),
('458', 'DISTRICT', '44', 'Thị Ba Đồn', 'Thi Ba Don')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 450 - Đồng Hới
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18853', 'WARD', '450', 'Hải Thành', 'Hai Thanh'),
('18856', 'WARD', '450', 'Đồng Phú', 'Dong Phu'),
('18859', 'WARD', '450', 'Bắc Lý', 'Bac Ly'),
('18865', 'WARD', '450', 'Nam Lý', 'Nam Ly'),
('18868', 'WARD', '450', 'Đồng Hải', 'Dong Hai'),
('18871', 'WARD', '450', 'Đồng Sơn', 'Dong Son'),
('18874', 'WARD', '450', 'Phú Hải', 'Phu Hai'),
('18877', 'WARD', '450', 'Bắc Nghĩa', 'Bac Nghia'),
('18880', 'WARD', '450', 'Đức Ninh Đông', 'Duc Ninh Dong'),
('18883', 'WARD', '450', 'Quang Phú', 'Quang Phu'),
('18886', 'WARD', '450', 'Lộc Ninh', 'Loc Ninh'),
('18889', 'WARD', '450', 'Bảo Ninh', 'Bao Ninh'),
('18892', 'WARD', '450', 'Nghĩa Ninh', 'Nghia Ninh'),
('18895', 'WARD', '450', 'Thuận Đức', 'Thuan Duc'),
('18898', 'WARD', '450', 'Đức Ninh', 'Duc Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 452 - Minh Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18901', 'WARD', '452', 'Thị trấn Quy Đạt', 'Thi tran Quy Dat'),
('18904', 'WARD', '452', 'Dân Hóa', 'Dan Hoa'),
('18907', 'WARD', '452', 'Trọng Hóa', 'Trong Hoa'),
('18913', 'WARD', '452', 'Hồng Hóa', 'Hong Hoa'),
('18919', 'WARD', '452', 'Tân Thành', 'Tan Thanh'),
('18922', 'WARD', '452', 'Hóa Hợp', 'Hoa Hop'),
('18925', 'WARD', '452', 'Xuân Hóa', 'Xuan Hoa'),
('18928', 'WARD', '452', 'Yên Hóa', 'Yen Hoa'),
('18931', 'WARD', '452', 'Minh Hóa', 'Minh Hoa'),
('18934', 'WARD', '452', 'Tân Hóa', 'Tan Hoa'),
('18937', 'WARD', '452', 'Hóa Sơn', 'Hoa Son'),
('18943', 'WARD', '452', 'Trung Hóa', 'Trung Hoa'),
('18946', 'WARD', '452', 'Thượng Hóa', 'Thuong Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 453 - Tuyên Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('18949', 'WARD', '453', 'Thị trấn Đồng Lê', 'Thi tran Dong Le'),
('18952', 'WARD', '453', 'Hương Hóa', 'Huong Hoa'),
('18955', 'WARD', '453', 'Kim Hóa', 'Kim Hoa'),
('18958', 'WARD', '453', 'Thanh Hóa', 'Thanh Hoa'),
('18961', 'WARD', '453', 'Thanh Thạch', 'Thanh Thach'),
('18964', 'WARD', '453', 'Thuận Hóa', 'Thuan Hoa'),
('18967', 'WARD', '453', 'Lâm Hóa', 'Lam Hoa'),
('18970', 'WARD', '453', 'Lê Hóa', 'Le Hoa'),
('18973', 'WARD', '453', 'Sơn Hóa', 'Son Hoa'),
('18976', 'WARD', '453', 'Đồng Hóa', 'Dong Hoa'),
('18979', 'WARD', '453', 'Ngư Hóa', 'Ngu Hoa'),
('18985', 'WARD', '453', 'Thạch Hóa', 'Thach Hoa'),
('18988', 'WARD', '453', 'Đức Hóa', 'Duc Hoa'),
('18991', 'WARD', '453', 'Phong Hóa', 'Phong Hoa'),
('18994', 'WARD', '453', 'Mai Hóa', 'Mai Hoa'),
('18997', 'WARD', '453', 'Tiến Hóa', 'Tien Hoa'),
('19000', 'WARD', '453', 'Châu Hóa', 'Chau Hoa'),
('19003', 'WARD', '453', 'Cao Quảng', 'Cao Quang'),
('19006', 'WARD', '453', 'Văn Hóa', 'Van Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 454 - Quảng Trạch
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19012', 'WARD', '454', 'Quảng Hợp', 'Quang Hop'),
('19015', 'WARD', '454', 'Quảng Kim', 'Quang Kim'),
('19018', 'WARD', '454', 'Quảng Đông', 'Quang Dong'),
('19021', 'WARD', '454', 'Quảng Phú', 'Quang Phu'),
('19024', 'WARD', '454', 'Quảng Châu', 'Quang Chau'),
('19027', 'WARD', '454', 'Quảng Thạch', 'Quang Thach'),
('19030', 'WARD', '454', 'Quảng Lưu', 'Quang Luu'),
('19033', 'WARD', '454', 'Quảng Tùng', 'Quang Tung'),
('19036', 'WARD', '454', 'Cảnh Dương', 'Canh Duong'),
('19039', 'WARD', '454', 'Quảng Tiến', 'Quang Tien'),
('19042', 'WARD', '454', 'Quảng Hưng', 'Quang Hung'),
('19045', 'WARD', '454', 'Quảng Xuân', 'Quang Xuan'),
('19051', 'WARD', '454', 'Liên Trường', 'Lien Truong'),
('19057', 'WARD', '454', 'Quảng Phương', 'Quang Phuong'),
('19063', 'WARD', '454', 'Phù Cảnh', 'Phu Canh'),
('19072', 'WARD', '454', 'Quảng Thanh', 'Quang Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 455 - Bố Trạch
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19111', 'WARD', '455', 'Thị trấn Hoàn Lão', 'Thi tran Hoan Lao'),
('19114', 'WARD', '455', 'Thị trấn NT Việt Trung', 'Thi tran NT Viet Trung'),
('19117', 'WARD', '455', 'Xuân Trạch', 'Xuan Trach'),
('19123', 'WARD', '455', 'Hạ Mỹ', 'Ha My'),
('19126', 'WARD', '455', 'Bắc Trạch', 'Bac Trach'),
('19129', 'WARD', '455', 'Lâm Trạch', 'Lam Trach'),
('19132', 'WARD', '455', 'Thanh Trạch', 'Thanh Trach'),
('19135', 'WARD', '455', 'Liên Trạch', 'Lien Trach'),
('19138', 'WARD', '455', 'Phúc Trạch', 'Phuc Trach'),
('19141', 'WARD', '455', 'Cự Nẫm', 'Cu Nam'),
('19144', 'WARD', '455', 'Hải Phú', 'Hai Phu'),
('19147', 'WARD', '455', 'Thượng Trạch', 'Thuong Trach'),
('19150', 'WARD', '455', 'Sơn Lộc', 'Son Loc'),
('19156', 'WARD', '455', 'Hưng Trạch', 'Hung Trach'),
('19159', 'WARD', '455', 'Đồng Trạch', 'Dong Trach'),
('19162', 'WARD', '455', 'Đức Trạch', 'Duc Trach'),
('19165', 'WARD', '455', 'Thị trấn Phong Nha', 'Thi tran Phong Nha'),
('19168', 'WARD', '455', 'Vạn Trạch', 'Van Trach'),
('19174', 'WARD', '455', 'Phú Định', 'Phu Dinh'),
('19177', 'WARD', '455', 'Trung Trạch', 'Trung Trach'),
('19180', 'WARD', '455', 'Tây Trạch', 'Tay Trach'),
('19183', 'WARD', '455', 'Hòa Trạch', 'Hoa Trach'),
('19186', 'WARD', '455', 'Đại Trạch', 'Dai Trach'),
('19189', 'WARD', '455', 'Nhân Trạch', 'Nhan Trach'),
('19192', 'WARD', '455', 'Tân Trạch', 'Tan Trach'),
('19198', 'WARD', '455', 'Lý Nam', 'Ly Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 456 - Quảng Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19204', 'WARD', '456', 'Trường Sơn', 'Truong Son'),
('19207', 'WARD', '456', 'Thị trấn Quán Hàu', 'Thi tran Hau'),
('19210', 'WARD', '456', 'Vĩnh Ninh', 'Vinh Ninh'),
('19213', 'WARD', '456', 'Võ Ninh', 'Vo Ninh'),
('19216', 'WARD', '456', 'Hải Ninh', 'Hai Ninh'),
('19219', 'WARD', '456', 'Hàm Ninh', 'Ham Ninh'),
('19222', 'WARD', '456', 'Duy Ninh', 'Duy Ninh'),
('19225', 'WARD', '456', 'Gia Ninh', 'Gia Ninh'),
('19228', 'WARD', '456', 'Trường Xuân', 'Truong Xuan'),
('19231', 'WARD', '456', 'Hiền Ninh', 'Hien Ninh'),
('19234', 'WARD', '456', 'Tân Ninh', 'Tan Ninh'),
('19237', 'WARD', '456', 'Xuân Ninh', 'Xuan Ninh'),
('19240', 'WARD', '456', 'An Ninh', 'An Ninh'),
('19243', 'WARD', '456', 'Vạn Ninh', 'Van Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 457 - Lệ Thủy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19246', 'WARD', '457', 'Thị trấn NT Lệ Ninh', 'Thi tran NT Le Ninh'),
('19249', 'WARD', '457', 'Thị trấn Kiến Giang', 'Thi tran Kien Giang'),
('19252', 'WARD', '457', 'Hồng Thủy', 'Hong Thuy'),
('19255', 'WARD', '457', 'Ngư Thủy Bắc', 'Ngu Thuy Bac'),
('19258', 'WARD', '457', 'Hoa Thủy', 'Hoa Thuy'),
('19261', 'WARD', '457', 'Thanh Thủy', 'Thanh Thuy'),
('19264', 'WARD', '457', 'An Thủy', 'An Thuy'),
('19267', 'WARD', '457', 'Phong Thủy', 'Phong Thuy'),
('19270', 'WARD', '457', 'Cam Thủy', 'Cam Thuy'),
('19273', 'WARD', '457', 'Ngân Thủy', 'Ngan Thuy'),
('19276', 'WARD', '457', 'Sơn Thủy', 'Son Thuy'),
('19279', 'WARD', '457', 'Lộc Thủy', 'Loc Thuy'),
('19285', 'WARD', '457', 'Liên Thủy', 'Lien Thuy'),
('19288', 'WARD', '457', 'Hưng Thủy', 'Hung Thuy'),
('19291', 'WARD', '457', 'Dương Thủy', 'Duong Thuy'),
('19294', 'WARD', '457', 'Tân Thủy', 'Tan Thuy'),
('19297', 'WARD', '457', 'Phú Thủy', 'Phu Thuy'),
('19300', 'WARD', '457', 'Xuân Thủy', 'Xuan Thuy'),
('19303', 'WARD', '457', 'Mỹ Thủy', 'My Thuy'),
('19306', 'WARD', '457', 'Ngư Thủy', 'Ngu Thuy'),
('19309', 'WARD', '457', 'Mai Thủy', 'Mai Thuy'),
('19312', 'WARD', '457', 'Sen Thủy', 'Sen Thuy'),
('19315', 'WARD', '457', 'Thái Thủy', 'Thai Thuy'),
('19318', 'WARD', '457', 'Kim Thủy', 'Kim Thuy'),
('19321', 'WARD', '457', 'Trường Thủy', 'Truong Thuy'),
('19327', 'WARD', '457', 'Lâm Thủy', 'Lam Thuy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 458 - Thị Ba Đồn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19009', 'WARD', '458', 'Ba Đồn', 'Ba Don'),
('19060', 'WARD', '458', 'Quảng Long', 'Quang Long'),
('19066', 'WARD', '458', 'Quảng Thọ', 'Quang Tho'),
('19069', 'WARD', '458', 'Quảng Tiên', 'Quang Tien'),
('19075', 'WARD', '458', 'Quảng Trung', 'Quang Trung'),
('19078', 'WARD', '458', 'Quảng Phong', 'Quang Phong'),
('19081', 'WARD', '458', 'Quảng Thuận', 'Quang Thuan'),
('19084', 'WARD', '458', 'Quảng Tân', 'Quang Tan'),
('19087', 'WARD', '458', 'Quảng Hải', 'Quang Hai'),
('19090', 'WARD', '458', 'Quảng Sơn', 'Quang Son'),
('19093', 'WARD', '458', 'Quảng Lộc', 'Quang Loc'),
('19096', 'WARD', '458', 'Quảng Thủy', 'Quang Thuy'),
('19099', 'WARD', '458', 'Quảng Văn', 'Quang Van'),
('19102', 'WARD', '458', 'Quảng Phúc', 'Quang Phuc'),
('19105', 'WARD', '458', 'Quảng Hòa', 'Quang Hoa'),
('19108', 'WARD', '458', 'Quảng Minh', 'Quang Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 45 - Quảng Trị
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('461', 'DISTRICT', '45', 'Đông Hà', 'Thanh pho Dong Ha'),
('462', 'DISTRICT', '45', 'Thị Quảng Trị', 'Thi Quang Tri'),
('464', 'DISTRICT', '45', 'Vĩnh Linh', 'Vinh Linh'),
('465', 'DISTRICT', '45', 'Hướng Hóa', 'Huong Hoa'),
('466', 'DISTRICT', '45', 'Gio Linh', 'Gio Linh'),
('467', 'DISTRICT', '45', 'Đa Krông', 'Da Krong'),
('468', 'DISTRICT', '45', 'Cam Lộ', 'Cam Lo'),
('469', 'DISTRICT', '45', 'Triệu Phong', 'Trieu Phong'),
('470', 'DISTRICT', '45', 'Hải Lăng', 'Hai Lang'),
('471', 'DISTRICT', '45', 'Cồn Cỏ', 'Con Co')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 461 - Đông Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19330', 'WARD', '461', 'Đông Giang', 'Dong Giang'),
('19333', 'WARD', '461', 'Phường 1', 'Ward 1'),
('19336', 'WARD', '461', 'Đông Lễ', 'Dong Le'),
('19339', 'WARD', '461', 'Đông Thanh', 'Dong Thanh'),
('19342', 'WARD', '461', 'Phường 2', 'Ward 2'),
('19345', 'WARD', '461', 'Phường 4', 'Ward 4'),
('19348', 'WARD', '461', 'Phường 5', 'Ward 5'),
('19351', 'WARD', '461', 'Đông Lương', 'Dong Luong'),
('19354', 'WARD', '461', 'Phường 3', 'Ward 3')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 462 - Thị Quảng Trị
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19357', 'WARD', '462', 'Phường 1', 'Ward 1'),
('19358', 'WARD', '462', 'An Đôn', 'An Don'),
('19360', 'WARD', '462', 'Phường 2', 'Ward 2'),
('19361', 'WARD', '462', 'Phường 3', 'Ward 3'),
('19705', 'WARD', '462', 'Hải Lệ', 'Hai Le')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 464 - Vĩnh Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19363', 'WARD', '464', 'Thị trấn Hồ Xá', 'Thi tran Ho Xa'),
('19366', 'WARD', '464', 'Thị trấn Bến Quan', 'Thi tran Ben Quan'),
('19369', 'WARD', '464', 'Vĩnh Thái', 'Vinh Thai'),
('19372', 'WARD', '464', 'Vĩnh Tú', 'Vinh Tu'),
('19375', 'WARD', '464', 'Vĩnh Chấp', 'Vinh Chap'),
('19378', 'WARD', '464', 'Trung Nam', 'Trung Nam'),
('19384', 'WARD', '464', 'Kim Thạch', 'Kim Thach'),
('19387', 'WARD', '464', 'Vĩnh Long', 'Vinh Long'),
('19393', 'WARD', '464', 'Vĩnh Khê', 'Vinh Khe'),
('19396', 'WARD', '464', 'Vĩnh Hòa', 'Vinh Hoa'),
('19402', 'WARD', '464', 'Vĩnh Thủy', 'Vinh Thuy'),
('19405', 'WARD', '464', 'Vĩnh Lâm', 'Vinh Lam'),
('19408', 'WARD', '464', 'Hiền Thành', 'Hien Thanh'),
('19414', 'WARD', '464', 'Thị trấn Cửa Tùng', 'Thi tran Cua Tung'),
('19417', 'WARD', '464', 'Vĩnh Hà', 'Vinh Ha'),
('19420', 'WARD', '464', 'Vĩnh Sơn', 'Vinh Son'),
('19423', 'WARD', '464', 'Vĩnh Giang', 'Vinh Giang'),
('19426', 'WARD', '464', 'Vĩnh Ô', 'Vinh O')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 465 - Hướng Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19429', 'WARD', '465', 'Thị trấn Khe Sanh', 'Thi tran Khe Sanh'),
('19432', 'WARD', '465', 'Thị trấn Lao Bảo', 'Thi tran Lao Bao'),
('19435', 'WARD', '465', 'Hướng Lập', 'Huong Lap'),
('19438', 'WARD', '465', 'Hướng Việt', 'Huong Viet'),
('19441', 'WARD', '465', 'Hướng Phùng', 'Huong Phung'),
('19444', 'WARD', '465', 'Hướng Sơn', 'Huong Son'),
('19447', 'WARD', '465', 'Hướng Linh', 'Huong Linh'),
('19450', 'WARD', '465', 'Tân Hợp', 'Tan Hop'),
('19453', 'WARD', '465', 'Hướng Tân', 'Huong Tan'),
('19456', 'WARD', '465', 'Tân Thành', 'Tan Thanh'),
('19459', 'WARD', '465', 'Tân Long', 'Tan Long'),
('19462', 'WARD', '465', 'Tân Lập', 'Tan Lap'),
('19465', 'WARD', '465', 'Tân Liên', 'Tan Lien'),
('19468', 'WARD', '465', 'Húc', 'Huc'),
('19471', 'WARD', '465', 'Thuận', 'Thuan'),
('19474', 'WARD', '465', 'Hướng Lộc', 'Huong Loc'),
('19477', 'WARD', '465', 'Ba Tầng', 'Ba Tang'),
('19480', 'WARD', '465', 'Thanh', 'Thanh'),
('19483', 'WARD', '465', 'A Dơi', 'A Doi'),
('19489', 'WARD', '465', 'Lìa', 'Lia'),
('19492', 'WARD', '465', 'Xy', 'Xy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 466 - Gio Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19495', 'WARD', '466', 'Thị trấn Gio Linh', 'Thi tran Gio Linh'),
('19496', 'WARD', '466', 'Thị trấn Cửa Việt', 'Thi tran Cua Viet'),
('19498', 'WARD', '466', 'Trung Giang', 'Trung Giang'),
('19501', 'WARD', '466', 'Trung Hải', 'Trung Hai'),
('19504', 'WARD', '466', 'Trung Sơn', 'Trung Son'),
('19507', 'WARD', '466', 'Phong Bình', 'Phong Binh'),
('19510', 'WARD', '466', 'Gio Mỹ', 'Gio My'),
('19519', 'WARD', '466', 'Gio Hải', 'Gio Hai'),
('19522', 'WARD', '466', 'Gio An', 'Gio An'),
('19534', 'WARD', '466', 'Linh Trường', 'Linh Truong'),
('19537', 'WARD', '466', 'Gio Sơn', 'Gio Son'),
('19543', 'WARD', '466', 'Gio Mai', 'Gio Mai'),
('19546', 'WARD', '466', 'Hải Thái', 'Hai Thai'),
('19552', 'WARD', '466', 'Gio Quang', 'Gio Quang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 467 - Đa Krông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19555', 'WARD', '467', 'Thị trấn Krông Klang', 'Thi tran Krong Klang'),
('19558', 'WARD', '467', 'Mò Ó', 'Mo O'),
('19561', 'WARD', '467', 'Hướng Hiệp', 'Huong Hiep'),
('19564', 'WARD', '467', 'Đa Krông', 'Da Krong'),
('19567', 'WARD', '467', 'Triệu Nguyên', 'Trieu Nguyen'),
('19570', 'WARD', '467', 'Ba Lòng', 'Ba Long'),
('19576', 'WARD', '467', 'Ba Nang', 'Ba Nang'),
('19579', 'WARD', '467', 'Tà Long', 'Ta Long'),
('19582', 'WARD', '467', 'Húc Nghì', 'Huc Nghi'),
('19585', 'WARD', '467', 'A Vao', 'A Vao'),
('19588', 'WARD', '467', 'Tà Rụt', 'Ta Rut'),
('19591', 'WARD', '467', 'A Bung', 'A Bung'),
('19594', 'WARD', '467', 'A Ngo', 'A Ngo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 468 - Cam Lộ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19597', 'WARD', '468', 'Thị trấn Cam Lộ', 'Thi tran Cam Lo'),
('19600', 'WARD', '468', 'Cam Tuyền', 'Cam Tuyen'),
('19603', 'WARD', '468', 'Thanh An', 'Thanh An'),
('19606', 'WARD', '468', 'Cam Thủy', 'Cam Thuy'),
('19612', 'WARD', '468', 'Cam Thành', 'Cam Thanh'),
('19615', 'WARD', '468', 'Cam Hiếu', 'Cam Hieu'),
('19618', 'WARD', '468', 'Cam Chính', 'Cam Chinh'),
('19621', 'WARD', '468', 'Cam Nghĩa', 'Cam Nghia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 469 - Triệu Phong
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19624', 'WARD', '469', 'Thị trấn Ái Tử', 'Thi tran Ai Tu'),
('19627', 'WARD', '469', 'Triệu Tân', 'Trieu Tan'),
('19633', 'WARD', '469', 'Triệu Phước', 'Trieu Phuoc'),
('19636', 'WARD', '469', 'Triệu Độ', 'Trieu Do'),
('19639', 'WARD', '469', 'Triệu Trạch', 'Trieu Trach'),
('19642', 'WARD', '469', 'Triệu Thuận', 'Trieu Thuan'),
('19645', 'WARD', '469', 'Triệu Đại', 'Trieu Dai'),
('19648', 'WARD', '469', 'Triệu Hòa', 'Trieu Hoa'),
('19654', 'WARD', '469', 'Triệu Cơ', 'Trieu Co'),
('19657', 'WARD', '469', 'Triệu Long', 'Trieu Long'),
('19660', 'WARD', '469', 'Triệu Tài', 'Trieu Tai'),
('19666', 'WARD', '469', 'Triệu Trung', 'Trieu Trung'),
('19669', 'WARD', '469', 'Triệu Ái', 'Trieu Ai'),
('19672', 'WARD', '469', 'Triệu Thượng', 'Trieu Thuong'),
('19675', 'WARD', '469', 'Triệu Giang', 'Trieu Giang'),
('19678', 'WARD', '469', 'Triệu Thành', 'Trieu Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 470 - Hải Lăng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19681', 'WARD', '470', 'Thị trấn Diên Sanh', 'Thi tran Dien Sanh'),
('19684', 'WARD', '470', 'Hải An', 'Hai An'),
('19687', 'WARD', '470', 'Hải Bình', 'Hai Binh'),
('19693', 'WARD', '470', 'Hải Quy', 'Hai Quy'),
('19699', 'WARD', '470', 'Hải Hưng', 'Hai Hung'),
('19702', 'WARD', '470', 'Hải Phú', 'Hai Phu'),
('19708', 'WARD', '470', 'Hải Thượng', 'Hai Thuong'),
('19711', 'WARD', '470', 'Hải Dương', 'Hai Duong'),
('19714', 'WARD', '470', 'Hải Định', 'Hai Dinh'),
('19717', 'WARD', '470', 'Hải Lâm', 'Hai Lam'),
('19726', 'WARD', '470', 'Hải Phong', 'Hai Phong'),
('19729', 'WARD', '470', 'Hải Trường', 'Hai Truong'),
('19735', 'WARD', '470', 'Hải Sơn', 'Hai Son'),
('19738', 'WARD', '470', 'Hải Chánh', 'Hai Chanh'),
('19741', 'WARD', '470', 'Hải Khê', 'Hai Khe')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 46 - Huế
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('474', 'DISTRICT', '46', 'Thuận Hóa', 'Thuan Hoa'),
('475', 'DISTRICT', '46', 'Phú Xuân', 'Phu Xuan'),
('476', 'DISTRICT', '46', 'Thị Phong Điền', 'Thi Phong Dien'),
('477', 'DISTRICT', '46', 'Quảng Điền', 'Quang Dien'),
('478', 'DISTRICT', '46', 'Phú Vang', 'Phu Vang'),
('479', 'DISTRICT', '46', 'Thị Hương Thủy', 'Thi Huong Thuy'),
('480', 'DISTRICT', '46', 'Thị Hương Trà', 'Thi Huong Tra'),
('481', 'DISTRICT', '46', 'A Lưới', 'A Luoi'),
('482', 'DISTRICT', '46', 'Phú Lộc', 'Phu Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 474 - Thuận Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19777', 'WARD', '474', 'Vỹ Dạ', 'Vy Da'),
('19780', 'WARD', '474', 'Đúc', 'Duc'),
('19783', 'WARD', '474', 'Vĩnh Ninh', 'Vinh Ninh'),
('19786', 'WARD', '474', 'Phú Hội', 'Phu Hoi'),
('19789', 'WARD', '474', 'Phú Nhuận', 'Phu Nhuan'),
('19792', 'WARD', '474', 'Xuân Phú', 'Xuan Phu'),
('19795', 'WARD', '474', 'Trường An', 'Truong An'),
('19798', 'WARD', '474', 'Phước Vĩnh', 'Phuoc Vinh'),
('19801', 'WARD', '474', 'An Cựu', 'An Cuu'),
('19807', 'WARD', '474', 'Thuỷ Biều', 'Thuy Bieu'),
('19813', 'WARD', '474', 'Thuỷ Xuân', 'Thuy Xuan'),
('19815', 'WARD', '474', 'An Đông', 'An Dong'),
('19816', 'WARD', '474', 'An Tây', 'An Tay'),
('19900', 'WARD', '474', 'Thuận An', 'Thuan An'),
('19909', 'WARD', '474', 'Dương Nỗ', 'Duong No'),
('19930', 'WARD', '474', 'Phú Thượng', 'Phu Thuong'),
('19963', 'WARD', '474', 'Thủy Vân', 'Thuy Van'),
('19981', 'WARD', '474', 'Thủy Bằng', 'Thuy Bang'),
('20002', 'WARD', '474', 'Hương Phong', 'Huong Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 475 - Phú Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19750', 'WARD', '475', 'Tây Lộc', 'Tay Loc'),
('19753', 'WARD', '475', 'Thuận Lộc', 'Thuan Loc'),
('19756', 'WARD', '475', 'Gia Hội', 'Gia Hoi'),
('19759', 'WARD', '475', 'Phú Hậu', 'Phu Hau'),
('19762', 'WARD', '475', 'Thuận Hòa', 'Thuan Hoa'),
('19768', 'WARD', '475', 'Đông Ba', 'Dong Ba'),
('19774', 'WARD', '475', 'Kim Long', 'Kim Long'),
('19803', 'WARD', '475', 'An Hòa', 'An Hoa'),
('19804', 'WARD', '475', 'Hương Sơ', 'Huong So'),
('19810', 'WARD', '475', 'Hương Long', 'Huong Long'),
('20014', 'WARD', '475', 'Hương Vinh', 'Huong Vinh'),
('20023', 'WARD', '475', 'Hương An', 'Huong An'),
('20029', 'WARD', '475', 'Long Hồ', 'Long Ho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 476 - Thị Phong Điền
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19819', 'WARD', '476', 'Phong Thu', 'Phong Thu'),
('19825', 'WARD', '476', 'Phong Thạnh', 'Phong Thanh'),
('19828', 'WARD', '476', 'Phong Phú', 'Phong Phu'),
('19831', 'WARD', '476', 'Phong Bình', 'Phong Binh'),
('19837', 'WARD', '476', 'Phong Chương', 'Phong Chuong'),
('19843', 'WARD', '476', 'Phong Hải', 'Phong Hai'),
('19846', 'WARD', '476', 'Phong Hòa', 'Phong Hoa'),
('19852', 'WARD', '476', 'Phong Hiền', 'Phong Hien'),
('19855', 'WARD', '476', 'Phong Mỹ', 'Phong My'),
('19858', 'WARD', '476', 'Phong An', 'Phong An'),
('19861', 'WARD', '476', 'Phong Xuân', 'Phong Xuan'),
('19864', 'WARD', '476', 'Phong Sơn', 'Phong Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 477 - Quảng Điền
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19867', 'WARD', '477', 'Thị trấn Sịa', 'Thi tran Sia'),
('19870', 'WARD', '477', 'Quảng Thái', 'Quang Thai'),
('19873', 'WARD', '477', 'Quảng Ngạn', 'Quang Ngan'),
('19876', 'WARD', '477', 'Quảng Lợi', 'Quang Loi'),
('19879', 'WARD', '477', 'Quảng Công', 'Quang Cong'),
('19882', 'WARD', '477', 'Quảng Phước', 'Quang Phuoc'),
('19885', 'WARD', '477', 'Quảng Vinh', 'Quang Vinh'),
('19888', 'WARD', '477', 'Quảng An', 'Quang An'),
('19891', 'WARD', '477', 'Quảng Thành', 'Quang Thanh'),
('19894', 'WARD', '477', 'Quảng Thọ', 'Quang Tho'),
('19897', 'WARD', '477', 'Quảng Phú', 'Quang Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 478 - Phú Vang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19903', 'WARD', '478', 'Phú Thuận', 'Phu Thuan'),
('19912', 'WARD', '478', 'Phú An', 'Phu An'),
('19915', 'WARD', '478', 'Phú Hải', 'Phu Hai'),
('19918', 'WARD', '478', 'Phú Xuân', 'Phu Xuan'),
('19921', 'WARD', '478', 'Phú Diên', 'Phu Dien'),
('19927', 'WARD', '478', 'Phú Mỹ', 'Phu My'),
('19933', 'WARD', '478', 'Phú Hồ', 'Phu Ho'),
('19936', 'WARD', '478', 'Vinh Xuân', 'Vinh Xuan'),
('19939', 'WARD', '478', 'Phú Lương', 'Phu Luong'),
('19942', 'WARD', '478', 'Thị trấn Phú Đa', 'Thi tran Phu Da'),
('19945', 'WARD', '478', 'Vinh Thanh', 'Vinh Thanh'),
('19948', 'WARD', '478', 'Vinh An', 'Vinh An'),
('19954', 'WARD', '478', 'Phú Gia', 'Phu Gia'),
('19957', 'WARD', '478', 'Vinh Hà', 'Vinh Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 479 - Thị Hương Thủy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19960', 'WARD', '479', 'Phú Bài', 'Phu Bai'),
('19966', 'WARD', '479', 'Thủy Thanh', 'Thuy Thanh'),
('19969', 'WARD', '479', 'Thủy Dương', 'Thuy Duong'),
('19972', 'WARD', '479', 'Thủy Phương', 'Thuy Phuong'),
('19975', 'WARD', '479', 'Thủy Châu', 'Thuy Chau'),
('19978', 'WARD', '479', 'Thủy Lương', 'Thuy Luong'),
('19984', 'WARD', '479', 'Thủy Tân', 'Thuy Tan'),
('19987', 'WARD', '479', 'Thủy Phù', 'Thuy Phu'),
('19990', 'WARD', '479', 'Phú Sơn', 'Phu Son'),
('19993', 'WARD', '479', 'Dương Hòa', 'Duong Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 480 - Thị Hương Trà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('19996', 'WARD', '480', 'Tứ Hạ', 'Tu Ha'),
('20005', 'WARD', '480', 'Hương Toàn', 'Huong Toan'),
('20008', 'WARD', '480', 'Hương Vân', 'Huong Van'),
('20011', 'WARD', '480', 'Hương Văn', 'Huong Van'),
('20017', 'WARD', '480', 'Hương Xuân', 'Huong Xuan'),
('20020', 'WARD', '480', 'Hương Chữ', 'Huong Chu'),
('20026', 'WARD', '480', 'Hương Bình', 'Huong Binh'),
('20035', 'WARD', '480', 'Bình Tiến', 'Binh Tien'),
('20041', 'WARD', '480', 'Bình Thành', 'Binh Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 481 - A Lưới
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20044', 'WARD', '481', 'Thị trấn A Lưới', 'Thi tran A Luoi'),
('20047', 'WARD', '481', 'Hồng Vân', 'Hong Van'),
('20050', 'WARD', '481', 'Hồng Hạ', 'Hong Ha'),
('20053', 'WARD', '481', 'Hồng Kim', 'Hong Kim'),
('20056', 'WARD', '481', 'Trung Sơn', 'Trung Son'),
('20059', 'WARD', '481', 'Hương Nguyên', 'Huong Nguyen'),
('20065', 'WARD', '481', 'Hồng Bắc', 'Hong Bac'),
('20068', 'WARD', '481', 'A Ngo', 'A Ngo'),
('20071', 'WARD', '481', 'Sơn Thủy', 'Son Thuy'),
('20074', 'WARD', '481', 'Phú Vinh', 'Phu Vinh'),
('20080', 'WARD', '481', 'Hương Phong', 'Huong Phong'),
('20083', 'WARD', '481', 'Quảng Nhâm', 'Quang Nham'),
('20086', 'WARD', '481', 'Hồng Thượng', 'Hong Thuong'),
('20089', 'WARD', '481', 'Hồng Thái', 'Hong Thai'),
('20095', 'WARD', '481', 'A Roàng', 'A Roang'),
('20098', 'WARD', '481', 'Đông Sơn', 'Dong Son'),
('20101', 'WARD', '481', 'Lâm Đớt', 'Lam Dot'),
('20104', 'WARD', '481', 'Hồng Thủy', 'Hong Thuy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 482 - Phú Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20107', 'WARD', '482', 'Thị trấn Phú Lộc', 'Thi tran Phu Loc'),
('20110', 'WARD', '482', 'Thị trấn Lăng Cô', 'Thi tran Lang Co'),
('20113', 'WARD', '482', 'Vinh Mỹ', 'Vinh My'),
('20116', 'WARD', '482', 'Vinh Hưng', 'Vinh Hung'),
('20122', 'WARD', '482', 'Giang Hải', 'Giang Hai'),
('20125', 'WARD', '482', 'Vinh Hiền', 'Vinh Hien'),
('20128', 'WARD', '482', 'Lộc Bổn', 'Loc Bon'),
('20131', 'WARD', '482', 'Thị trấn Lộc Sơn', 'Thi tran Loc Son'),
('20134', 'WARD', '482', 'Lộc Bình', 'Loc Binh'),
('20137', 'WARD', '482', 'Lộc Vĩnh', 'Loc Vinh'),
('20140', 'WARD', '482', 'Lộc An', 'Loc An'),
('20143', 'WARD', '482', 'Lộc Điền', 'Loc Dien'),
('20146', 'WARD', '482', 'Lộc Thủy', 'Loc Thuy'),
('20149', 'WARD', '482', 'Lộc Trì', 'Loc Tri'),
('20152', 'WARD', '482', 'Lộc Tiến', 'Loc Tien'),
('20155', 'WARD', '482', 'Lộc Hòa', 'Loc Hoa'),
('20158', 'WARD', '482', 'Xuân Lộc', 'Xuan Loc'),
('20161', 'WARD', '482', 'Thị trấn Khe Tre', 'Thi tran Khe Tre'),
('20164', 'WARD', '482', 'Hương Phú', 'Huong Phu'),
('20167', 'WARD', '482', 'Hương Sơn', 'Huong Son'),
('20170', 'WARD', '482', 'Hương Lộc', 'Huong Loc'),
('20173', 'WARD', '482', 'Thượng Quảng', 'Thuong Quang'),
('20176', 'WARD', '482', 'Hương Hòa', 'Huong Hoa'),
('20179', 'WARD', '482', 'Hương Xuân', 'Huong Xuan'),
('20182', 'WARD', '482', 'Hương Hữu', 'Huong Huu'),
('20185', 'WARD', '482', 'Thượng Lộ', 'Thuong Lo'),
('20188', 'WARD', '482', 'Thượng Long', 'Thuong Long'),
('20191', 'WARD', '482', 'Thượng Nhật', 'Thuong Nhat')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 48 - Đà Nẵng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('490', 'DISTRICT', '48', 'Liên Chiểu', 'Lien Chieu'),
('491', 'DISTRICT', '48', 'Thanh Khê', 'Thanh Khe'),
('492', 'DISTRICT', '48', 'Hải Châu', 'Hai Chau'),
('493', 'DISTRICT', '48', 'Sơn Trà', 'Son Tra'),
('494', 'DISTRICT', '48', 'Ngũ Hành Sơn', 'Ngu Hanh Son'),
('495', 'DISTRICT', '48', 'Cẩm Lệ', 'Cam Le'),
('497', 'DISTRICT', '48', 'Hòa Vang', 'Hoa Vang'),
('498', 'DISTRICT', '48', 'Hoàng Sa', 'Hoang Sa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 490 - Liên Chiểu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20194', 'WARD', '490', 'Hòa Hiệp Bắc', 'Hoa Hiep Bac'),
('20195', 'WARD', '490', 'Hòa Hiệp Nam', 'Hoa Hiep Nam'),
('20197', 'WARD', '490', 'Hòa Khánh Bắc', 'Hoa Khanh Bac'),
('20198', 'WARD', '490', 'Hòa Khánh Nam', 'Hoa Khanh Nam'),
('20200', 'WARD', '490', 'Hòa Minh', 'Hoa Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 491 - Thanh Khê
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20206', 'WARD', '491', 'Thanh Khê Tây', 'Thanh Khe Tay'),
('20207', 'WARD', '491', 'Thanh Khê Đông', 'Thanh Khe Dong'),
('20209', 'WARD', '491', 'Xuân Hà', 'Xuan Ha'),
('20215', 'WARD', '491', 'Chính Gián', 'Chinh Gian'),
('20218', 'WARD', '491', 'Thạc Gián', 'Thac Gian'),
('20224', 'WARD', '491', 'An Khê', 'An Khe')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 492 - Hải Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20227', 'WARD', '492', 'Thanh Bình', 'Thanh Binh'),
('20230', 'WARD', '492', 'Thuận Phước', 'Thuan Phuoc'),
('20233', 'WARD', '492', 'Thạch Thang', 'Thach Thang'),
('20236', 'WARD', '492', 'Hải Châu', 'Hai Chau'),
('20242', 'WARD', '492', 'Phước Ninh', 'Phuoc Ninh'),
('20245', 'WARD', '492', 'Hòa Thuận Tây', 'Hoa Thuan Tay'),
('20254', 'WARD', '492', 'Bình Thuận', 'Binh Thuan'),
('20257', 'WARD', '492', 'Hòa Cường Bắc', 'Hoa Cuong Bac'),
('20258', 'WARD', '492', 'Hòa Cường Nam', 'Hoa Cuong Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 493 - Sơn Trà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20263', 'WARD', '493', 'Thọ Quang', 'Tho Quang'),
('20266', 'WARD', '493', 'Nại Hiên Đông', 'Nai Hien Dong'),
('20269', 'WARD', '493', 'Mân Thái', 'Man Thai'),
('20272', 'WARD', '493', 'An Hải Bắc', 'An Hai Bac'),
('20275', 'WARD', '493', 'Phước Mỹ', 'Phuoc My'),
('20278', 'WARD', '493', 'An Hải Nam', 'An Hai Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 494 - Ngũ Hành Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20284', 'WARD', '494', 'Mỹ An', 'My An'),
('20285', 'WARD', '494', 'Khuê Mỹ', 'Khue My'),
('20287', 'WARD', '494', 'Hoà Quý', 'Hoa Quy'),
('20290', 'WARD', '494', 'Hoà Hải', 'Hoa Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 495 - Cẩm Lệ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20260', 'WARD', '495', 'Khuê Trung', 'Khue Trung'),
('20305', 'WARD', '495', 'Hòa Phát', 'Hoa Phat'),
('20306', 'WARD', '495', 'Hòa An', 'Hoa An'),
('20311', 'WARD', '495', 'Hòa Thọ Tây', 'Hoa Tho Tay'),
('20312', 'WARD', '495', 'Hòa Thọ Đông', 'Hoa Tho Dong'),
('20314', 'WARD', '495', 'Hòa Xuân', 'Hoa Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 497 - Hòa Vang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20293', 'WARD', '497', 'Hòa Bắc', 'Hoa Bac'),
('20296', 'WARD', '497', 'Hòa Liên', 'Hoa Lien'),
('20299', 'WARD', '497', 'Hòa Ninh', 'Hoa Ninh'),
('20302', 'WARD', '497', 'Hòa Sơn', 'Hoa Son'),
('20308', 'WARD', '497', 'Hòa Nhơn', 'Hoa Nhon'),
('20317', 'WARD', '497', 'Hòa Phú', 'Hoa Phu'),
('20320', 'WARD', '497', 'Hòa Phong', 'Hoa Phong'),
('20323', 'WARD', '497', 'Hòa Châu', 'Hoa Chau'),
('20326', 'WARD', '497', 'Hòa Tiến', 'Hoa Tien'),
('20329', 'WARD', '497', 'Hòa Phước', 'Hoa Phuoc'),
('20332', 'WARD', '497', 'Hòa Khương', 'Hoa Khuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 49 - Quảng Nam
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('502', 'DISTRICT', '49', 'Tam Kỳ', 'Thanh pho Tam Ky'),
('503', 'DISTRICT', '49', 'Hội An', 'Thanh pho Hoi An'),
('504', 'DISTRICT', '49', 'Tây Giang', 'Tay Giang'),
('505', 'DISTRICT', '49', 'Đông Giang', 'Dong Giang'),
('506', 'DISTRICT', '49', 'Đại Lộc', 'Dai Loc'),
('507', 'DISTRICT', '49', 'Thị Điện Bàn', 'Thi Dien Ban'),
('508', 'DISTRICT', '49', 'Duy Xuyên', 'Duy Xuyen'),
('509', 'DISTRICT', '49', 'Quế Sơn', 'Que Son'),
('510', 'DISTRICT', '49', 'Nam Giang', 'Nam Giang'),
('511', 'DISTRICT', '49', 'Phước Sơn', 'Phuoc Son'),
('512', 'DISTRICT', '49', 'Hiệp Đức', 'Hiep Duc'),
('513', 'DISTRICT', '49', 'Thăng Bình', 'Thang Binh'),
('514', 'DISTRICT', '49', 'Tiên Phước', 'Tien Phuoc'),
('515', 'DISTRICT', '49', 'Bắc Trà My', 'Bac Tra My'),
('516', 'DISTRICT', '49', 'Nam Trà My', 'Nam Tra My'),
('517', 'DISTRICT', '49', 'Núi Thành', 'Nui Thanh'),
('518', 'DISTRICT', '49', 'Phú Ninh', 'Phu Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 502 - Tam Kỳ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20335', 'WARD', '502', 'Tân Thạnh', 'Tan Thanh'),
('20341', 'WARD', '502', 'An Mỹ', 'An My'),
('20344', 'WARD', '502', 'Hòa Hương', 'Hoa Huong'),
('20347', 'WARD', '502', 'An Xuân', 'An Xuan'),
('20350', 'WARD', '502', 'An Sơn', 'An Son'),
('20353', 'WARD', '502', 'Trường Xuân', 'Truong Xuan'),
('20356', 'WARD', '502', 'An Phú', 'An Phu'),
('20359', 'WARD', '502', 'Tam Thanh', 'Tam Thanh'),
('20362', 'WARD', '502', 'Tam Thăng', 'Tam Thang'),
('20371', 'WARD', '502', 'Tam Phú', 'Tam Phu'),
('20375', 'WARD', '502', 'Hoà Thuận', 'Hoa Thuan'),
('20389', 'WARD', '502', 'Tam Ngọc', 'Tam Ngoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 503 - Hội An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20398', 'WARD', '503', 'Minh An', 'Minh An'),
('20401', 'WARD', '503', 'Tân An', 'Tan An'),
('20404', 'WARD', '503', 'Cẩm Phô', 'Cam Pho'),
('20407', 'WARD', '503', 'Thanh Hà', 'Thanh Ha'),
('20410', 'WARD', '503', 'Sơn Phong', 'Son Phong'),
('20413', 'WARD', '503', 'Cẩm Châu', 'Cam Chau'),
('20416', 'WARD', '503', 'Cửa Đại', 'Cua Dai'),
('20419', 'WARD', '503', 'Cẩm An', 'Cam An'),
('20422', 'WARD', '503', 'Cẩm Hà', 'Cam Ha'),
('20425', 'WARD', '503', 'Cẩm Kim', 'Cam Kim'),
('20428', 'WARD', '503', 'Cẩm Nam', 'Cam Nam'),
('20431', 'WARD', '503', 'Cẩm Thanh', 'Cam Thanh'),
('20434', 'WARD', '503', 'Tân Hiệp', 'Tan Hiep')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 504 - Tây Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20437', 'WARD', '504', 'Ch''ơm', 'Ch''om'),
('20440', 'WARD', '504', 'Ga Ri', 'Ga Ri'),
('20443', 'WARD', '504', 'A Xan', 'A Xan'),
('20446', 'WARD', '504', 'Tr''Hy', 'Tr''Hy'),
('20449', 'WARD', '504', 'Lăng', 'Lang'),
('20452', 'WARD', '504', 'A Nông', 'A Nong'),
('20455', 'WARD', '504', 'A Tiêng', 'A Tieng'),
('20458', 'WARD', '504', 'Bha Lê', 'Bha Le'),
('20461', 'WARD', '504', 'A Vương', 'A Vuong'),
('20464', 'WARD', '504', 'Dang', 'Dang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 505 - Đông Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20467', 'WARD', '505', 'Thị trấn P Rao', 'Thi tran P Rao'),
('20470', 'WARD', '505', 'Tà Lu', 'Ta Lu'),
('20473', 'WARD', '505', 'Sông Kôn', 'Song Kon'),
('20476', 'WARD', '505', 'Jơ Ngây', 'Jo Ngay'),
('20479', 'WARD', '505', 'A Ting', 'A Ting'),
('20482', 'WARD', '505', 'Tư', 'Tu'),
('20485', 'WARD', '505', 'Ba', 'Ba'),
('20488', 'WARD', '505', 'A Rooi', 'A Rooi'),
('20491', 'WARD', '505', 'Za Hung', 'Za Hung'),
('20494', 'WARD', '505', 'Mà Cooi', 'Ma Cooi'),
('20497', 'WARD', '505', 'Ka Dăng', 'Ka Dang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 506 - Đại Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20500', 'WARD', '506', 'Thị trấn Ái Nghĩa', 'Thi tran Ai Nghia'),
('20503', 'WARD', '506', 'Đại Sơn', 'Dai Son'),
('20506', 'WARD', '506', 'Đại Lãnh', 'Dai Lanh'),
('20509', 'WARD', '506', 'Đại Hưng', 'Dai Hung'),
('20512', 'WARD', '506', 'Đại Hồng', 'Dai Hong'),
('20515', 'WARD', '506', 'Đại Đồng', 'Dai Dong'),
('20518', 'WARD', '506', 'Đại Quang', 'Dai Quang'),
('20521', 'WARD', '506', 'Đại Nghĩa', 'Dai Nghia'),
('20524', 'WARD', '506', 'Đại Hiệp', 'Dai Hiep'),
('20527', 'WARD', '506', 'Đại Thạnh', 'Dai Thanh'),
('20530', 'WARD', '506', 'Đại Chánh', 'Dai Chanh'),
('20533', 'WARD', '506', 'Đại Tân', 'Dai Tan'),
('20536', 'WARD', '506', 'Đại Phong', 'Dai Phong'),
('20539', 'WARD', '506', 'Đại Minh', 'Dai Minh'),
('20542', 'WARD', '506', 'Đại Thắng', 'Dai Thang'),
('20545', 'WARD', '506', 'Đại Cường', 'Dai Cuong'),
('20547', 'WARD', '506', 'Đại An', 'Dai An'),
('20548', 'WARD', '506', 'Đại Hòa', 'Dai Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 507 - Thị Điện Bàn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20551', 'WARD', '507', 'Vĩnh Điện', 'Vinh Dien'),
('20554', 'WARD', '507', 'Điện Tiến', 'Dien Tien'),
('20557', 'WARD', '507', 'Điện Hòa', 'Dien Hoa'),
('20560', 'WARD', '507', 'Điện Thắng Bắc', 'Dien Thang Bac'),
('20561', 'WARD', '507', 'Điện Thắng Trung', 'Dien Thang Trung'),
('20562', 'WARD', '507', 'Điện Thắng Nam', 'Dien Thang Nam'),
('20563', 'WARD', '507', 'Điện Ngọc', 'Dien Ngoc'),
('20566', 'WARD', '507', 'Điện Hồng', 'Dien Hong'),
('20569', 'WARD', '507', 'Điện Thọ', 'Dien Tho'),
('20572', 'WARD', '507', 'Điện Phước', 'Dien Phuoc'),
('20575', 'WARD', '507', 'Điện An', 'Dien An'),
('20578', 'WARD', '507', 'Điện Nam Bắc', 'Dien Nam Bac'),
('20579', 'WARD', '507', 'Điện Nam Trung', 'Dien Nam Trung'),
('20580', 'WARD', '507', 'Điện Nam Đông', 'Dien Nam Dong'),
('20581', 'WARD', '507', 'Điện Dương', 'Dien Duong'),
('20584', 'WARD', '507', 'Điện Quang', 'Dien Quang'),
('20587', 'WARD', '507', 'Điện Trung', 'Dien Trung'),
('20590', 'WARD', '507', 'Điện Phong', 'Dien Phong'),
('20593', 'WARD', '507', 'Điện Minh', 'Dien Minh'),
('20596', 'WARD', '507', 'Điện Phương', 'Dien Phuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 508 - Duy Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20599', 'WARD', '508', 'Thị trấn Nam Phước', 'Thi tran Nam Phuoc'),
('20605', 'WARD', '508', 'Duy Phú', 'Duy Phu'),
('20608', 'WARD', '508', 'Duy Tân', 'Duy Tan'),
('20611', 'WARD', '508', 'Duy Hòa', 'Duy Hoa'),
('20614', 'WARD', '508', 'Duy Châu', 'Duy Chau'),
('20617', 'WARD', '508', 'Duy Trinh', 'Duy Trinh'),
('20620', 'WARD', '508', 'Duy Sơn', 'Duy Son'),
('20623', 'WARD', '508', 'Duy Trung', 'Duy Trung'),
('20626', 'WARD', '508', 'Duy Phước', 'Duy Phuoc'),
('20629', 'WARD', '508', 'Duy Thành', 'Duy Thanh'),
('20632', 'WARD', '508', 'Duy Vinh', 'Duy Vinh'),
('20635', 'WARD', '508', 'Duy Nghĩa', 'Duy Nghia'),
('20638', 'WARD', '508', 'Duy Hải', 'Duy Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 509 - Quế Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20641', 'WARD', '509', 'Thị trấn Đông Phú', 'Thi tran Dong Phu'),
('20644', 'WARD', '509', 'Quế Xuân 1', 'Que Xuan 1'),
('20647', 'WARD', '509', 'Quế Xuân 2', 'Que Xuan 2'),
('20650', 'WARD', '509', 'Quế Phú', 'Que Phu'),
('20651', 'WARD', '509', 'Thị trấn Hương An', 'Thi tran Huong An'),
('20656', 'WARD', '509', 'Thị trấn Trung Phước', 'Thi tran Trung Phuoc'),
('20659', 'WARD', '509', 'Quế Hiệp', 'Que Hiep'),
('20662', 'WARD', '509', 'Quế Thuận', 'Que Thuan'),
('20665', 'WARD', '509', 'Quế Mỹ', 'Que My'),
('20668', 'WARD', '509', 'Ninh Phước', 'Ninh Phuoc'),
('20669', 'WARD', '509', 'Phước Ninh', 'Phuoc Ninh'),
('20671', 'WARD', '509', 'Quế Lộc', 'Que Loc'),
('20674', 'WARD', '509', 'Quế Phước', 'Que Phuoc'),
('20677', 'WARD', '509', 'Quế Long', 'Que Long'),
('20680', 'WARD', '509', 'Quế Châu', 'Que Chau'),
('20683', 'WARD', '509', 'Quế Phong', 'Que Phong'),
('20686', 'WARD', '509', 'Quế An', 'Que An'),
('20689', 'WARD', '509', 'Quế Minh', 'Que Minh'),
('20692', 'WARD', '509', 'Quế Lâm', 'Que Lam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 510 - Nam Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20695', 'WARD', '510', 'Thị trấn Thạnh Mỹ', 'Thi tran Thanh My'),
('20698', 'WARD', '510', 'Laêê', 'Laee'),
('20699', 'WARD', '510', 'Chơ Chun', 'Cho Chun'),
('20701', 'WARD', '510', 'Zuôich', 'Zuoich'),
('20702', 'WARD', '510', 'Tà Pơơ', 'Ta Poo'),
('20704', 'WARD', '510', 'La Dêê', 'La Dee'),
('20705', 'WARD', '510', 'Đắc Tôi', 'Dac Toi'),
('20707', 'WARD', '510', 'Chà Vàl', 'Cha Val'),
('20710', 'WARD', '510', 'Tà Bhinh', 'Ta Bhinh'),
('20713', 'WARD', '510', 'Cà Dy', 'Ca Dy'),
('20716', 'WARD', '510', 'Đắc Pre', 'Dac Pre'),
('20719', 'WARD', '510', 'Đắc Pring', 'Dac Pring')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 511 - Phước Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20722', 'WARD', '511', 'Thị trấn Khâm Đức', 'Thi tran Kham Duc'),
('20725', 'WARD', '511', 'Phước Xuân', 'Phuoc Xuan'),
('20728', 'WARD', '511', 'Phước Hiệp', 'Phuoc Hiep'),
('20729', 'WARD', '511', 'Phước Hoà', 'Phuoc Hoa'),
('20731', 'WARD', '511', 'Phước Đức', 'Phuoc Duc'),
('20734', 'WARD', '511', 'Phước Năng', 'Phuoc Nang'),
('20737', 'WARD', '511', 'Phước Mỹ', 'Phuoc My'),
('20740', 'WARD', '511', 'Phước Chánh', 'Phuoc Chanh'),
('20743', 'WARD', '511', 'Phước Công', 'Phuoc Cong'),
('20746', 'WARD', '511', 'Phước Kim', 'Phuoc Kim'),
('20749', 'WARD', '511', 'Phước Lộc', 'Phuoc Loc'),
('20752', 'WARD', '511', 'Phước Thành', 'Phuoc Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 512 - Hiệp Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20758', 'WARD', '512', 'Quế Tân', 'Que Tan'),
('20764', 'WARD', '512', 'Quế Thọ', 'Que Tho'),
('20767', 'WARD', '512', 'Bình Lâm', 'Binh Lam'),
('20770', 'WARD', '512', 'Sông Trà', 'Song Tra'),
('20773', 'WARD', '512', 'Phước Trà', 'Phuoc Tra'),
('20776', 'WARD', '512', 'Phước Gia', 'Phuoc Gia'),
('20779', 'WARD', '512', 'Thị trấn Tân Bình', 'Thi tran Tan Binh'),
('20782', 'WARD', '512', 'Quế Lưu', 'Que Luu'),
('20785', 'WARD', '512', 'Thăng Phước', 'Thang Phuoc'),
('20788', 'WARD', '512', 'Bình Sơn', 'Binh Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 513 - Thăng Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20791', 'WARD', '513', 'Thị trấn Hà Lam', 'Thi tran Ha Lam'),
('20794', 'WARD', '513', 'Bình Dương', 'Binh Duong'),
('20797', 'WARD', '513', 'Bình Giang', 'Binh Giang'),
('20800', 'WARD', '513', 'Bình Nguyên', 'Binh Nguyen'),
('20803', 'WARD', '513', 'Bình Phục', 'Binh Phuc'),
('20806', 'WARD', '513', 'Bình Triều', 'Binh Trieu'),
('20809', 'WARD', '513', 'Bình Đào', 'Binh Dao'),
('20812', 'WARD', '513', 'Bình Minh', 'Binh Minh'),
('20815', 'WARD', '513', 'Bình Lãnh', 'Binh Lanh'),
('20818', 'WARD', '513', 'Bình Trị', 'Binh Tri'),
('20821', 'WARD', '513', 'Bình Định', 'Binh Dinh'),
('20824', 'WARD', '513', 'Bình Quý', 'Binh Quy'),
('20827', 'WARD', '513', 'Bình Phú', 'Binh Phu'),
('20833', 'WARD', '513', 'Bình Tú', 'Binh Tu'),
('20836', 'WARD', '513', 'Bình Sa', 'Binh Sa'),
('20839', 'WARD', '513', 'Bình Hải', 'Binh Hai'),
('20842', 'WARD', '513', 'Bình Quế', 'Binh Que'),
('20845', 'WARD', '513', 'Bình An', 'Binh An'),
('20848', 'WARD', '513', 'Bình Trung', 'Binh Trung'),
('20851', 'WARD', '513', 'Bình Nam', 'Binh Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 514 - Tiên Phước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20854', 'WARD', '514', 'Thị trấn Tiên Kỳ', 'Thi tran Tien Ky'),
('20857', 'WARD', '514', 'Tiên Sơn', 'Tien Son'),
('20860', 'WARD', '514', 'Tiên Hà', 'Tien Ha'),
('20866', 'WARD', '514', 'Tiên Châu', 'Tien Chau'),
('20869', 'WARD', '514', 'Tiên Lãnh', 'Tien Lanh'),
('20872', 'WARD', '514', 'Tiên Ngọc', 'Tien Ngoc'),
('20875', 'WARD', '514', 'Tiên Hiệp', 'Tien Hiep'),
('20878', 'WARD', '514', 'Tiên Cảnh', 'Tien Canh'),
('20881', 'WARD', '514', 'Tiên Mỹ', 'Tien My'),
('20884', 'WARD', '514', 'Tiên Phong', 'Tien Phong'),
('20887', 'WARD', '514', 'Tiên Thọ', 'Tien Tho'),
('20890', 'WARD', '514', 'Tiên An', 'Tien An'),
('20893', 'WARD', '514', 'Tiên Lộc', 'Tien Loc'),
('20896', 'WARD', '514', 'Tiên Lập', 'Tien Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 515 - Bắc Trà My
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20899', 'WARD', '515', 'Thị trấn Trà My', 'Thi tran Tra My'),
('20900', 'WARD', '515', 'Trà Sơn', 'Tra Son'),
('20902', 'WARD', '515', 'Trà Kót', 'Tra Kot'),
('20905', 'WARD', '515', 'Trà Nú', 'Tra Nu'),
('20908', 'WARD', '515', 'Trà Đông', 'Tra Dong'),
('20911', 'WARD', '515', 'Trà Dương', 'Tra Duong'),
('20914', 'WARD', '515', 'Trà Giang', 'Tra Giang'),
('20917', 'WARD', '515', 'Trà Bui', 'Tra Bui'),
('20920', 'WARD', '515', 'Trà Đốc', 'Tra Doc'),
('20923', 'WARD', '515', 'Trà Tân', 'Tra Tan'),
('20926', 'WARD', '515', 'Trà Giác', 'Tra Giac'),
('20929', 'WARD', '515', 'Trà Giáp', 'Tra Giap'),
('20932', 'WARD', '515', 'Trà Ka', 'Tra Ka')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 516 - Nam Trà My
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20935', 'WARD', '516', 'Trà Leng', 'Tra Leng'),
('20938', 'WARD', '516', 'Trà Dơn', 'Tra Don'),
('20941', 'WARD', '516', 'Trà Tập', 'Tra Tap'),
('20944', 'WARD', '516', 'Trà Mai', 'Tra Mai'),
('20947', 'WARD', '516', 'Trà Cang', 'Tra Cang'),
('20950', 'WARD', '516', 'Trà Linh', 'Tra Linh'),
('20953', 'WARD', '516', 'Trà Nam', 'Tra Nam'),
('20956', 'WARD', '516', 'Trà Don', 'Tra Don'),
('20959', 'WARD', '516', 'Trà Vân', 'Tra Van'),
('20962', 'WARD', '516', 'Trà Vinh', 'Tra Vinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 517 - Núi Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20965', 'WARD', '517', 'Thị trấn Núi Thành', 'Thi tran Nui Thanh'),
('20968', 'WARD', '517', 'Tam Xuân I', 'Tam Xuan I'),
('20971', 'WARD', '517', 'Tam Xuân II', 'Tam Xuan II'),
('20974', 'WARD', '517', 'Tam Tiến', 'Tam Tien'),
('20977', 'WARD', '517', 'Tam Sơn', 'Tam Son'),
('20980', 'WARD', '517', 'Tam Thạnh', 'Tam Thanh'),
('20983', 'WARD', '517', 'Tam Anh Bắc', 'Tam Anh Bac'),
('20984', 'WARD', '517', 'Tam Anh Nam', 'Tam Anh Nam'),
('20986', 'WARD', '517', 'Tam Hòa', 'Tam Hoa'),
('20989', 'WARD', '517', 'Tam Hiệp', 'Tam Hiep'),
('20992', 'WARD', '517', 'Tam Hải', 'Tam Hai'),
('20995', 'WARD', '517', 'Tam Giang', 'Tam Giang'),
('20998', 'WARD', '517', 'Tam Quang', 'Tam Quang'),
('21001', 'WARD', '517', 'Tam Nghĩa', 'Tam Nghia'),
('21004', 'WARD', '517', 'Tam Mỹ Tây', 'Tam My Tay'),
('21005', 'WARD', '517', 'Tam Mỹ Đông', 'Tam My Dong'),
('21007', 'WARD', '517', 'Tam Trà', 'Tam Tra')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 518 - Phú Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('20364', 'WARD', '518', 'Thị trấn Phú Thịnh', 'Thi tran Phu Thinh'),
('20365', 'WARD', '518', 'Tam Thành', 'Tam Thanh'),
('20368', 'WARD', '518', 'Tam An', 'Tam An'),
('20374', 'WARD', '518', 'Tam Đàn', 'Tam Dan'),
('20377', 'WARD', '518', 'Tam Lộc', 'Tam Loc'),
('20380', 'WARD', '518', 'Tam Phước', 'Tam Phuoc'),
('20386', 'WARD', '518', 'Tam Thái', 'Tam Thai'),
('20387', 'WARD', '518', 'Tam Đại', 'Tam Dai'),
('20392', 'WARD', '518', 'Tam Dân', 'Tam Dan'),
('20395', 'WARD', '518', 'Tam Lãnh', 'Tam Lanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 51 - Quảng Ngãi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('522', 'DISTRICT', '51', 'Quảng Ngãi', 'Thanh pho Quang Ngai'),
('524', 'DISTRICT', '51', 'Bình Sơn', 'Binh Son'),
('525', 'DISTRICT', '51', 'Trà Bồng', 'Tra Bong'),
('527', 'DISTRICT', '51', 'Sơn Tịnh', 'Son Tinh'),
('528', 'DISTRICT', '51', 'Tư Nghĩa', 'Tu Nghia'),
('529', 'DISTRICT', '51', 'Sơn Hà', 'Son Ha'),
('530', 'DISTRICT', '51', 'Sơn Tây', 'Son Tay'),
('531', 'DISTRICT', '51', 'Minh Long', 'Minh Long'),
('532', 'DISTRICT', '51', 'Nghĩa Hành', 'Nghia Hanh'),
('533', 'DISTRICT', '51', 'Mộ Đức', 'Mo Duc'),
('534', 'DISTRICT', '51', 'Thị Đức Phổ', 'Thi Duc Pho'),
('535', 'DISTRICT', '51', 'Ba Tơ', 'Ba To'),
('536', 'DISTRICT', '51', 'Lý Sơn', 'Ly Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 522 - Quảng Ngãi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21010', 'WARD', '522', 'Lê Hồng Phong', 'Le Hong Phong'),
('21013', 'WARD', '522', 'Trần Phú', 'Tran Phu'),
('21016', 'WARD', '522', 'Quảng Phú', 'Quang Phu'),
('21019', 'WARD', '522', 'Nghĩa Chánh', 'Nghia Chanh'),
('21022', 'WARD', '522', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('21025', 'WARD', '522', 'Nguyễn Nghiêm', 'Nguyen Nghiem'),
('21028', 'WARD', '522', 'Nghĩa Lộ', 'Nghia Lo'),
('21031', 'WARD', '522', 'Chánh Lộ', 'Chanh Lo'),
('21034', 'WARD', '522', 'Nghĩa Dũng', 'Nghia Dung'),
('21037', 'WARD', '522', 'Nghĩa Dõng', 'Nghia Dong'),
('21172', 'WARD', '522', 'Trương Quang Trọng', 'Truong Quang Trong'),
('21187', 'WARD', '522', 'Tịnh Hòa', 'Hoa'),
('21190', 'WARD', '522', 'Tịnh Kỳ', 'Ky'),
('21199', 'WARD', '522', 'Tịnh Thiện', 'Thien'),
('21202', 'WARD', '522', 'Tịnh Ấn Đông', 'An Dong'),
('21208', 'WARD', '522', 'Tịnh Châu', 'Chau'),
('21211', 'WARD', '522', 'Tịnh Khê', 'Khe'),
('21214', 'WARD', '522', 'Tịnh Long', 'Long'),
('21223', 'WARD', '522', 'Tịnh Ấn Tây', 'An Tay'),
('21232', 'WARD', '522', 'Tịnh An', 'An'),
('21256', 'WARD', '522', 'Nghĩa Hà', 'Nghia Ha'),
('21262', 'WARD', '522', 'An Phú', 'An Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 524 - Bình Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21040', 'WARD', '524', 'Thị trấn Châu Ổ', 'Thi tran Chau O'),
('21043', 'WARD', '524', 'Bình Thuận', 'Binh Thuan'),
('21046', 'WARD', '524', 'Bình Thạnh', 'Binh Thanh'),
('21049', 'WARD', '524', 'Bình Đông', 'Binh Dong'),
('21052', 'WARD', '524', 'Bình Chánh', 'Binh Chanh'),
('21055', 'WARD', '524', 'Bình Nguyên', 'Binh Nguyen'),
('21058', 'WARD', '524', 'Bình Khương', 'Binh Khuong'),
('21061', 'WARD', '524', 'Bình Trị', 'Binh Tri'),
('21064', 'WARD', '524', 'Bình An', 'Binh An'),
('21067', 'WARD', '524', 'Bình Hải', 'Binh Hai'),
('21070', 'WARD', '524', 'Bình Dương', 'Binh Duong'),
('21073', 'WARD', '524', 'Bình Phước', 'Binh Phuoc'),
('21079', 'WARD', '524', 'Bình Hòa', 'Binh Hoa'),
('21082', 'WARD', '524', 'Bình Trung', 'Binh Trung'),
('21085', 'WARD', '524', 'Bình Minh', 'Binh Minh'),
('21088', 'WARD', '524', 'Bình Long', 'Binh Long'),
('21091', 'WARD', '524', 'Bình Thanh', 'Binh Thanh'),
('21100', 'WARD', '524', 'Bình Chương', 'Binh Chuong'),
('21103', 'WARD', '524', 'Bình Hiệp', 'Binh Hiep'),
('21106', 'WARD', '524', 'Bình Mỹ', 'Binh My'),
('21109', 'WARD', '524', 'Bình Tân Phú', 'Binh Tan Phu'),
('21112', 'WARD', '524', 'Bình Châu', 'Binh Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 525 - Trà Bồng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21115', 'WARD', '525', 'Thị trấn Trà Xuân', 'Thi tran Tra Xuan'),
('21118', 'WARD', '525', 'Trà Giang', 'Tra Giang'),
('21121', 'WARD', '525', 'Trà Thủy', 'Tra Thuy'),
('21124', 'WARD', '525', 'Trà Hiệp', 'Tra Hiep'),
('21127', 'WARD', '525', 'Trà Bình', 'Tra Binh'),
('21130', 'WARD', '525', 'Trà Phú', 'Tra Phu'),
('21133', 'WARD', '525', 'Trà Lâm', 'Tra Lam'),
('21136', 'WARD', '525', 'Trà Tân', 'Tra Tan'),
('21139', 'WARD', '525', 'Trà Sơn', 'Tra Son'),
('21142', 'WARD', '525', 'Trà Bùi', 'Tra Bui'),
('21145', 'WARD', '525', 'Trà Thanh', 'Tra Thanh'),
('21148', 'WARD', '525', 'Sơn Trà', 'Son Tra'),
('21154', 'WARD', '525', 'Trà Phong', 'Tra Phong'),
('21157', 'WARD', '525', 'Hương Trà', 'Huong Tra'),
('21163', 'WARD', '525', 'Trà Xinh', 'Tra Xinh'),
('21166', 'WARD', '525', 'Trà Tây', 'Tra Tay')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 527 - Sơn Tịnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21175', 'WARD', '527', 'Tịnh Thọ', 'Tho'),
('21178', 'WARD', '527', 'Tịnh Trà', 'Tra'),
('21181', 'WARD', '527', 'Tịnh Phong', 'Phong'),
('21184', 'WARD', '527', 'Tịnh Hiệp', 'Hiep'),
('21193', 'WARD', '527', 'Tịnh Bình', 'Binh'),
('21196', 'WARD', '527', 'Tịnh Đông', 'Dong'),
('21205', 'WARD', '527', 'Tịnh Bắc', 'Bac'),
('21217', 'WARD', '527', 'Tịnh Sơn', 'Son'),
('21220', 'WARD', '527', 'Thị trấn Tịnh Hà', 'Thi tran Ha'),
('21226', 'WARD', '527', 'Tịnh Giang', 'Giang'),
('21229', 'WARD', '527', 'Tịnh Minh', 'Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 528 - Tư Nghĩa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21235', 'WARD', '528', 'Thị trấn La Hà', 'Thi tran La Ha'),
('21238', 'WARD', '528', 'Thị trấn Sông Vệ', 'Thi tran Song Ve'),
('21241', 'WARD', '528', 'Nghĩa Lâm', 'Nghia Lam'),
('21244', 'WARD', '528', 'Nghĩa Thắng', 'Nghia Thang'),
('21247', 'WARD', '528', 'Nghĩa Thuận', 'Nghia Thuan'),
('21250', 'WARD', '528', 'Nghĩa Kỳ', 'Nghia Ky'),
('21259', 'WARD', '528', 'Nghĩa Sơn', 'Nghia Son'),
('21268', 'WARD', '528', 'Nghĩa Hòa', 'Nghia Hoa'),
('21271', 'WARD', '528', 'Nghĩa Điền', 'Nghia Dien'),
('21274', 'WARD', '528', 'Nghĩa Thương', 'Nghia Thuong'),
('21277', 'WARD', '528', 'Nghĩa Trung', 'Nghia Trung'),
('21280', 'WARD', '528', 'Nghĩa Hiệp', 'Nghia Hiep'),
('21283', 'WARD', '528', 'Nghĩa Phương', 'Nghia Phuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 529 - Sơn Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21289', 'WARD', '529', 'Thị trấn Di Lăng', 'Thi tran Di Lang'),
('21292', 'WARD', '529', 'Sơn Hạ', 'Son Ha'),
('21295', 'WARD', '529', 'Sơn Thành', 'Son Thanh'),
('21298', 'WARD', '529', 'Sơn Nham', 'Son Nham'),
('21301', 'WARD', '529', 'Sơn Bao', 'Son Bao'),
('21304', 'WARD', '529', 'Sơn Linh', 'Son Linh'),
('21307', 'WARD', '529', 'Sơn Giang', 'Son Giang'),
('21310', 'WARD', '529', 'Sơn Trung', 'Son Trung'),
('21313', 'WARD', '529', 'Sơn Thượng', 'Son Thuong'),
('21316', 'WARD', '529', 'Sơn Cao', 'Son Cao'),
('21319', 'WARD', '529', 'Sơn Hải', 'Son Hai'),
('21322', 'WARD', '529', 'Sơn Thủy', 'Son Thuy'),
('21325', 'WARD', '529', 'Sơn Kỳ', 'Son Ky'),
('21328', 'WARD', '529', 'Sơn Ba', 'Son Ba')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 530 - Sơn Tây
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21331', 'WARD', '530', 'Sơn Bua', 'Son Bua'),
('21334', 'WARD', '530', 'Sơn Mùa', 'Son Mua'),
('21335', 'WARD', '530', 'Sơn Liên', 'Son Lien'),
('21337', 'WARD', '530', 'Sơn Tân', 'Son Tan'),
('21338', 'WARD', '530', 'Sơn Màu', 'Son Mau'),
('21340', 'WARD', '530', 'Sơn Dung', 'Son Dung'),
('21341', 'WARD', '530', 'Sơn Long', 'Son Long'),
('21343', 'WARD', '530', 'Sơn Tinh', 'Son Tinh'),
('21346', 'WARD', '530', 'Sơn Lập', 'Son Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 531 - Minh Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21349', 'WARD', '531', 'Long Sơn', 'Long Son'),
('21352', 'WARD', '531', 'Long Mai', 'Long Mai'),
('21355', 'WARD', '531', 'Thanh An', 'Thanh An'),
('21358', 'WARD', '531', 'Long Môn', 'Long Mon'),
('21361', 'WARD', '531', 'Long Hiệp', 'Long Hiep')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 532 - Nghĩa Hành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21364', 'WARD', '532', 'Thị trấn Chợ Chùa', 'Thi tran Cho Chua'),
('21367', 'WARD', '532', 'Hành Thuận', 'Hanh Thuan'),
('21370', 'WARD', '532', 'Hành Dũng', 'Hanh Dung'),
('21373', 'WARD', '532', 'Hành Trung', 'Hanh Trung'),
('21376', 'WARD', '532', 'Hành Nhân', 'Hanh Nhan'),
('21379', 'WARD', '532', 'Hành Đức', 'Hanh Duc'),
('21382', 'WARD', '532', 'Hành Minh', 'Hanh Minh'),
('21385', 'WARD', '532', 'Hành Phước', 'Hanh Phuoc'),
('21388', 'WARD', '532', 'Hành Thiện', 'Hanh Thien'),
('21391', 'WARD', '532', 'Hành Thịnh', 'Hanh Thinh'),
('21394', 'WARD', '532', 'Hành Tín Tây', 'Hanh Tin Tay'),
('21397', 'WARD', '532', 'Hành Tín Đông', 'Hanh Tin Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 533 - Mộ Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21400', 'WARD', '533', 'Thị trấn Mộ Đức', 'Thi tran Mo Duc'),
('21406', 'WARD', '533', 'Thắng Lợi', 'Thang Loi'),
('21409', 'WARD', '533', 'Đức Nhuận', 'Duc Nhuan'),
('21412', 'WARD', '533', 'Đức Chánh', 'Duc Chanh'),
('21415', 'WARD', '533', 'Đức Hiệp', 'Duc Hiep'),
('21418', 'WARD', '533', 'Đức Minh', 'Duc Minh'),
('21421', 'WARD', '533', 'Đức Thạnh', 'Duc Thanh'),
('21424', 'WARD', '533', 'Đức Hòa', 'Duc Hoa'),
('21427', 'WARD', '533', 'Đức Tân', 'Duc Tan'),
('21430', 'WARD', '533', 'Đức Phú', 'Duc Phu'),
('21433', 'WARD', '533', 'Đức Phong', 'Duc Phong'),
('21436', 'WARD', '533', 'Đức Lân', 'Duc Lan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 534 - Thị Đức Phổ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21439', 'WARD', '534', 'Nguyễn Nghiêm', 'Nguyen Nghiem'),
('21442', 'WARD', '534', 'Phổ An', 'Pho An'),
('21445', 'WARD', '534', 'Phổ Phong', 'Pho Phong'),
('21448', 'WARD', '534', 'Phổ Thuận', 'Pho Thuan'),
('21451', 'WARD', '534', 'Phổ Văn', 'Pho Van'),
('21454', 'WARD', '534', 'Phổ Quang', 'Pho Quang'),
('21457', 'WARD', '534', 'Phổ Nhơn', 'Pho Nhon'),
('21460', 'WARD', '534', 'Phổ Ninh', 'Pho Ninh'),
('21463', 'WARD', '534', 'Phổ Minh', 'Pho Minh'),
('21466', 'WARD', '534', 'Phổ Vinh', 'Pho Vinh'),
('21469', 'WARD', '534', 'Phổ Hòa', 'Pho Hoa'),
('21472', 'WARD', '534', 'Phổ Cường', 'Pho Cuong'),
('21475', 'WARD', '534', 'Phổ Khánh', 'Pho Khanh'),
('21478', 'WARD', '534', 'Phổ Thạnh', 'Pho Thanh'),
('21481', 'WARD', '534', 'Phổ Châu', 'Pho Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 535 - Ba Tơ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21484', 'WARD', '535', 'Thị trấn Ba Tơ', 'Thi tran Ba To'),
('21487', 'WARD', '535', 'Ba Điền', 'Ba Dien'),
('21490', 'WARD', '535', 'Ba Vinh', 'Ba Vinh'),
('21493', 'WARD', '535', 'Ba Thành', 'Ba Thanh'),
('21496', 'WARD', '535', 'Ba Động', 'Ba Dong'),
('21499', 'WARD', '535', 'Ba Dinh', 'Ba Dinh'),
('21500', 'WARD', '535', 'Ba Giang', 'Ba Giang'),
('21502', 'WARD', '535', 'Ba Liên', 'Ba Lien'),
('21505', 'WARD', '535', 'Ba Ngạc', 'Ba Ngac'),
('21508', 'WARD', '535', 'Ba Khâm', 'Ba Kham'),
('21511', 'WARD', '535', 'Ba Cung', 'Ba Cung'),
('21517', 'WARD', '535', 'Ba Tiêu', 'Ba Tieu'),
('21520', 'WARD', '535', 'Ba Trang', 'Ba Trang'),
('21523', 'WARD', '535', 'Ba Tô', 'Ba To'),
('21526', 'WARD', '535', 'Ba Bích', 'Ba Bich'),
('21529', 'WARD', '535', 'Ba Vì', 'Ba Vi'),
('21532', 'WARD', '535', 'Ba Lế', 'Ba Le'),
('21535', 'WARD', '535', 'Ba Nam', 'Ba Nam'),
('21538', 'WARD', '535', 'Ba Xa', 'Ba Xa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 52 - Bình Định
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('540', 'DISTRICT', '52', 'Quy Nhơn', 'Thanh pho Quy Nhon'),
('542', 'DISTRICT', '52', 'An Lão', 'An Lao'),
('543', 'DISTRICT', '52', 'Thị Hoài Nhơn', 'Thi Hoai Nhon'),
('544', 'DISTRICT', '52', 'Hoài Ân', 'Hoai An'),
('545', 'DISTRICT', '52', 'Phù Mỹ', 'Phu My'),
('546', 'DISTRICT', '52', 'Vĩnh Thạnh', 'Vinh Thanh'),
('547', 'DISTRICT', '52', 'Tây Sơn', 'Tay Son'),
('548', 'DISTRICT', '52', 'Phù Cát', 'Phu Cat'),
('549', 'DISTRICT', '52', 'Thị An Nhơn', 'Thi An Nhon'),
('550', 'DISTRICT', '52', 'Tuy Phước', 'Tuy Phuoc'),
('551', 'DISTRICT', '52', 'Vân Canh', 'Van Canh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 540 - Quy Nhơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21550', 'WARD', '540', 'Nhơn Bình', 'Nhon Binh'),
('21553', 'WARD', '540', 'Nhơn Phú', 'Nhon Phu'),
('21556', 'WARD', '540', 'Đống Đa', 'Dong Da'),
('21559', 'WARD', '540', 'Trần Quang Diệu', 'Tran Quang Dieu'),
('21562', 'WARD', '540', 'Hải Cảng', 'Hai Cang'),
('21565', 'WARD', '540', 'Quang Trung', 'Quang Trung'),
('21577', 'WARD', '540', 'Ngô Mây', 'Ngo May'),
('21580', 'WARD', '540', 'Trần Phú', 'Tran Phu'),
('21583', 'WARD', '540', 'Thị Nại', 'Thi Nai'),
('21589', 'WARD', '540', 'Bùi Thị Xuân', 'Bui Thi Xuan'),
('21592', 'WARD', '540', 'Nguyễn Văn Cừ', 'Nguyen Van Cu'),
('21595', 'WARD', '540', 'Ghềnh Ráng', 'Ghenh Rang'),
('21598', 'WARD', '540', 'Nhơn Lý', 'Nhon Ly'),
('21601', 'WARD', '540', 'Nhơn Hội', 'Nhon Hoi'),
('21604', 'WARD', '540', 'Nhơn Hải', 'Nhon Hai'),
('21607', 'WARD', '540', 'Nhơn Châu', 'Nhon Chau'),
('21991', 'WARD', '540', 'Phước Mỹ', 'Phuoc My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 542 - An Lão
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21609', 'WARD', '542', 'Thị trấn An Lão', 'Thi tran An Lao'),
('21610', 'WARD', '542', 'An Hưng', 'An Hung'),
('21613', 'WARD', '542', 'An Trung', 'An Trung'),
('21616', 'WARD', '542', 'An Dũng', 'An Dung'),
('21619', 'WARD', '542', 'An Vinh', 'An Vinh'),
('21622', 'WARD', '542', 'An Toàn', 'An Toan'),
('21625', 'WARD', '542', 'An Tân', 'An Tan'),
('21628', 'WARD', '542', 'An Hòa', 'An Hoa'),
('21631', 'WARD', '542', 'An Quang', 'An Quang'),
('21634', 'WARD', '542', 'An Nghĩa', 'An Nghia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 543 - Thị Hoài Nhơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21637', 'WARD', '543', 'Tam Quan', 'Tam Quan'),
('21640', 'WARD', '543', 'Bồng Sơn', 'Bong Son'),
('21643', 'WARD', '543', 'Hoài Sơn', 'Hoai Son'),
('21646', 'WARD', '543', 'Hoài Châu Bắc', 'Hoai Chau Bac'),
('21649', 'WARD', '543', 'Hoài Châu', 'Hoai Chau'),
('21652', 'WARD', '543', 'Hoài Phú', 'Hoai Phu'),
('21655', 'WARD', '543', 'Tam Bắc', 'Tam Bac'),
('21658', 'WARD', '543', 'Tam Nam', 'Tam Nam'),
('21661', 'WARD', '543', 'Hoài Hảo', 'Hoai Hao'),
('21664', 'WARD', '543', 'Hoài Thanh Tây', 'Hoai Thanh Tay'),
('21667', 'WARD', '543', 'Hoài Thanh', 'Hoai Thanh'),
('21670', 'WARD', '543', 'Hoài Hương', 'Hoai Huong'),
('21673', 'WARD', '543', 'Hoài Tân', 'Hoai Tan'),
('21676', 'WARD', '543', 'Hoài Hải', 'Hoai Hai'),
('21679', 'WARD', '543', 'Hoài Xuân', 'Hoai Xuan'),
('21682', 'WARD', '543', 'Hoài Mỹ', 'Hoai My'),
('21685', 'WARD', '543', 'Hoài Đức', 'Hoai Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 544 - Hoài Ân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21688', 'WARD', '544', 'Thị trấn Tăng Bạt Hổ', 'Thi tran Tang Bat Ho'),
('21690', 'WARD', '544', 'Ân Hảo Tây', 'An Hao Tay'),
('21691', 'WARD', '544', 'Ân Hảo Đông', 'An Hao Dong'),
('21694', 'WARD', '544', 'Ân Sơn', 'An Son'),
('21697', 'WARD', '544', 'Ân Mỹ', 'An My'),
('21700', 'WARD', '544', 'Đak Mang', 'Dak Mang'),
('21703', 'WARD', '544', 'Ân Tín', 'An Tin'),
('21706', 'WARD', '544', 'Ân Thạnh', 'An Thanh'),
('21709', 'WARD', '544', 'Ân Phong', 'An Phong'),
('21712', 'WARD', '544', 'Ân Đức', 'An Duc'),
('21715', 'WARD', '544', 'Ân Hữu', 'An Huu'),
('21718', 'WARD', '544', 'Bok Tới', 'Bok Toi'),
('21721', 'WARD', '544', 'Ân Tường Tây', 'An Tuong Tay'),
('21724', 'WARD', '544', 'Ân Tường Đông', 'An Tuong Dong'),
('21727', 'WARD', '544', 'Ân Nghĩa', 'An Nghia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 545 - Phù Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21730', 'WARD', '545', 'Thị trấn Phù Mỹ', 'Thi tran Phu My'),
('21733', 'WARD', '545', 'Thị trấn Bình Dương', 'Thi tran Binh Duong'),
('21736', 'WARD', '545', 'Mỹ Đức', 'My Duc'),
('21739', 'WARD', '545', 'Mỹ Châu', 'My Chau'),
('21742', 'WARD', '545', 'Mỹ Thắng', 'My Thang'),
('21745', 'WARD', '545', 'Mỹ Lộc', 'My Loc'),
('21748', 'WARD', '545', 'Mỹ Lợi', 'My Loi'),
('21751', 'WARD', '545', 'Mỹ An', 'My An'),
('21754', 'WARD', '545', 'Mỹ Phong', 'My Phong'),
('21757', 'WARD', '545', 'Mỹ Trinh', 'My Trinh'),
('21760', 'WARD', '545', 'Mỹ Thọ', 'My Tho'),
('21763', 'WARD', '545', 'Mỹ Hòa', 'My Hoa'),
('21766', 'WARD', '545', 'Mỹ Thành', 'My Thanh'),
('21769', 'WARD', '545', 'Mỹ Chánh', 'My Chanh'),
('21772', 'WARD', '545', 'Mỹ Quang', 'My Quang'),
('21775', 'WARD', '545', 'Mỹ Hiệp', 'My Hiep'),
('21778', 'WARD', '545', 'Mỹ Tài', 'My Tai'),
('21781', 'WARD', '545', 'Mỹ Cát', 'My Cat'),
('21784', 'WARD', '545', 'Mỹ Chánh Tây', 'My Chanh Tay')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 546 - Vĩnh Thạnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21786', 'WARD', '546', 'Thị trấn Vĩnh Thạnh', 'Thi tran Vinh Thanh'),
('21787', 'WARD', '546', 'Vĩnh Sơn', 'Vinh Son'),
('21790', 'WARD', '546', 'Vĩnh Kim', 'Vinh Kim'),
('21796', 'WARD', '546', 'Vĩnh Hiệp', 'Vinh Hiep'),
('21799', 'WARD', '546', 'Vĩnh Hảo', 'Vinh Hao'),
('21801', 'WARD', '546', 'Vĩnh Hòa', 'Vinh Hoa'),
('21802', 'WARD', '546', 'Vĩnh Thịnh', 'Vinh Thinh'),
('21804', 'WARD', '546', 'Vĩnh Thuận', 'Vinh Thuan'),
('21805', 'WARD', '546', 'Vĩnh Quang', 'Vinh Quang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 547 - Tây Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21808', 'WARD', '547', 'Thị trấn Phú Phong', 'Thi tran Phu Phong'),
('21811', 'WARD', '547', 'Bình Tân', 'Binh Tan'),
('21814', 'WARD', '547', 'Tây Thuận', 'Tay Thuan'),
('21817', 'WARD', '547', 'Bình Thuận', 'Binh Thuan'),
('21820', 'WARD', '547', 'Tây Giang', 'Tay Giang'),
('21823', 'WARD', '547', 'Bình Thành', 'Binh Thanh'),
('21826', 'WARD', '547', 'Tây An', 'Tay An'),
('21829', 'WARD', '547', 'Bình Hòa', 'Binh Hoa'),
('21832', 'WARD', '547', 'Tây Bình', 'Tay Binh'),
('21835', 'WARD', '547', 'Bình Tường', 'Binh Tuong'),
('21838', 'WARD', '547', 'Tây Vinh', 'Tay Vinh'),
('21841', 'WARD', '547', 'Vĩnh An', 'Vinh An'),
('21844', 'WARD', '547', 'Tây Xuân', 'Tay Xuan'),
('21847', 'WARD', '547', 'Bình Nghi', 'Binh Nghi'),
('21850', 'WARD', '547', 'Tây Phú', 'Tay Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 548 - Phù Cát
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21853', 'WARD', '548', 'Thị trấn Ngô Mây', 'Thi tran Ngo May'),
('21856', 'WARD', '548', 'Cát Sơn', 'Cat Son'),
('21859', 'WARD', '548', 'Cát Minh', 'Cat Minh'),
('21862', 'WARD', '548', 'Thị trấn Cát Khánh', 'Thi tran Cat Khanh'),
('21865', 'WARD', '548', 'Cát Tài', 'Cat Tai'),
('21868', 'WARD', '548', 'Cát Lâm', 'Cat Lam'),
('21871', 'WARD', '548', 'Cát Hanh', 'Cat Hanh'),
('21874', 'WARD', '548', 'Cát Thành', 'Cat Thanh'),
('21877', 'WARD', '548', 'Cát Trinh', 'Cat Trinh'),
('21880', 'WARD', '548', 'Cát Hải', 'Cat Hai'),
('21883', 'WARD', '548', 'Cát Hiệp', 'Cat Hiep'),
('21886', 'WARD', '548', 'Cát Nhơn', 'Cat Nhon'),
('21889', 'WARD', '548', 'Cát Hưng', 'Cat Hung'),
('21892', 'WARD', '548', 'Cát Tường', 'Cat Tuong'),
('21895', 'WARD', '548', 'Cát Tân', 'Cat Tan'),
('21898', 'WARD', '548', 'Thị trấn Cát Tiến', 'Thi tran Cat Tien'),
('21901', 'WARD', '548', 'Cát Thắng', 'Cat Thang'),
('21904', 'WARD', '548', 'Cát Chánh', 'Cat Chanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 549 - Thị An Nhơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21907', 'WARD', '549', 'Bình Định', 'Binh Dinh'),
('21910', 'WARD', '549', 'Đập Đá', 'Dap Da'),
('21913', 'WARD', '549', 'Nhơn Mỹ', 'Nhon My'),
('21916', 'WARD', '549', 'Nhơn Thành', 'Nhon Thanh'),
('21919', 'WARD', '549', 'Nhơn Hạnh', 'Nhon Hanh'),
('21922', 'WARD', '549', 'Nhơn Hậu', 'Nhon Hau'),
('21925', 'WARD', '549', 'Nhơn Phong', 'Nhon Phong'),
('21928', 'WARD', '549', 'Nhơn An', 'Nhon An'),
('21931', 'WARD', '549', 'Nhơn Phúc', 'Nhon Phuc'),
('21934', 'WARD', '549', 'Nhơn Hưng', 'Nhon Hung'),
('21937', 'WARD', '549', 'Nhơn Khánh', 'Nhon Khanh'),
('21940', 'WARD', '549', 'Nhơn Lộc', 'Nhon Loc'),
('21943', 'WARD', '549', 'Nhơn Hoà', 'Nhon Hoa'),
('21946', 'WARD', '549', 'Nhơn Tân', 'Nhon Tan'),
('21949', 'WARD', '549', 'Nhơn Thọ', 'Nhon Tho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 550 - Tuy Phước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21952', 'WARD', '550', 'Thị trấn Tuy Phước', 'Thi tran Tuy Phuoc'),
('21955', 'WARD', '550', 'Thị trấn Diêu Trì', 'Thi tran Dieu Tri'),
('21958', 'WARD', '550', 'Phước Thắng', 'Phuoc Thang'),
('21961', 'WARD', '550', 'Phước Hưng', 'Phuoc Hung'),
('21964', 'WARD', '550', 'Phước Quang', 'Phuoc Quang'),
('21967', 'WARD', '550', 'Phước Hòa', 'Phuoc Hoa'),
('21970', 'WARD', '550', 'Phước Sơn', 'Phuoc Son'),
('21973', 'WARD', '550', 'Phước Hiệp', 'Phuoc Hiep'),
('21976', 'WARD', '550', 'Phước Lộc', 'Phuoc Loc'),
('21979', 'WARD', '550', 'Phước Nghĩa', 'Phuoc Nghia'),
('21982', 'WARD', '550', 'Phước Thuận', 'Phuoc Thuan'),
('21985', 'WARD', '550', 'Phước An', 'Phuoc An'),
('21988', 'WARD', '550', 'Phước Thành', 'Phuoc Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 551 - Vân Canh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('21994', 'WARD', '551', 'Thị trấn Vân Canh', 'Thi tran Van Canh'),
('21997', 'WARD', '551', 'Canh Liên', 'Canh Lien'),
('22000', 'WARD', '551', 'Canh Hiệp', 'Canh Hiep'),
('22003', 'WARD', '551', 'Canh Vinh', 'Canh Vinh'),
('22006', 'WARD', '551', 'Canh Hiển', 'Canh Hien'),
('22009', 'WARD', '551', 'Canh Thuận', 'Canh Thuan'),
('22012', 'WARD', '551', 'Canh Hòa', 'Canh Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 54 - Phú Yên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('555', 'DISTRICT', '54', 'Tuy Hoà', 'Thanh pho Tuy Hoa'),
('557', 'DISTRICT', '54', 'Thị Sông Cầu', 'Thi Song Cau'),
('558', 'DISTRICT', '54', 'Đồng Xuân', 'Dong Xuan'),
('559', 'DISTRICT', '54', 'Tuy An', 'Tuy An'),
('560', 'DISTRICT', '54', 'Sơn Hòa', 'Son Hoa'),
('561', 'DISTRICT', '54', 'Sông Hinh', 'Song Hinh'),
('562', 'DISTRICT', '54', 'Tây Hoà', 'Tay Hoa'),
('563', 'DISTRICT', '54', 'Phú Hoà', 'Phu Hoa'),
('564', 'DISTRICT', '54', 'Thị Đông Hòa', 'Thi Dong Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 555 - Tuy Hoà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22015', 'WARD', '555', 'Phường 1', 'Ward 1'),
('22018', 'WARD', '555', 'Phường 2', 'Ward 2'),
('22024', 'WARD', '555', 'Phường 9', 'Ward 9'),
('22030', 'WARD', '555', 'Phường 4', 'Ward 4'),
('22033', 'WARD', '555', 'Phường 5', 'Ward 5'),
('22036', 'WARD', '555', 'Phường 7', 'Ward 7'),
('22040', 'WARD', '555', 'Phú Thạnh', 'Phu Thanh'),
('22041', 'WARD', '555', 'Phú Đông', 'Phu Dong'),
('22042', 'WARD', '555', 'Hòa Kiến', 'Hoa Kien'),
('22045', 'WARD', '555', 'Bình Kiến', 'Binh Kien'),
('22162', 'WARD', '555', 'An Phú', 'An Phu'),
('22240', 'WARD', '555', 'Phú Lâm', 'Phu Lam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 557 - Thị Sông Cầu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22051', 'WARD', '557', 'Xuân Phú', 'Xuan Phu'),
('22052', 'WARD', '557', 'Xuân Lâm', 'Xuan Lam'),
('22053', 'WARD', '557', 'Xuân Thành', 'Xuan Thanh'),
('22054', 'WARD', '557', 'Xuân Hải', 'Xuan Hai'),
('22057', 'WARD', '557', 'Xuân Lộc', 'Xuan Loc'),
('22060', 'WARD', '557', 'Xuân Bình', 'Xuan Binh'),
('22066', 'WARD', '557', 'Xuân Cảnh', 'Xuan Canh'),
('22069', 'WARD', '557', 'Xuân Thịnh', 'Xuan Thinh'),
('22072', 'WARD', '557', 'Xuân Phương', 'Xuan Phuong'),
('22073', 'WARD', '557', 'Xuân Yên', 'Xuan Yen'),
('22075', 'WARD', '557', 'Xuân Thọ 1', 'Xuan Tho 1'),
('22076', 'WARD', '557', 'Xuân Đài', 'Xuan Dai'),
('22078', 'WARD', '557', 'Xuân Thọ 2', 'Xuan Tho 2')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 558 - Đồng Xuân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22081', 'WARD', '558', 'Thị trấn La Hai', 'Thi tran La Hai'),
('22084', 'WARD', '558', 'Đa Lộc', 'Da Loc'),
('22087', 'WARD', '558', 'Phú Mỡ', 'Phu Mo'),
('22090', 'WARD', '558', 'Xuân Lãnh', 'Xuan Lanh'),
('22093', 'WARD', '558', 'Xuân Long', 'Xuan Long'),
('22096', 'WARD', '558', 'Xuân Quang 1', 'Xuan Quang 1'),
('22099', 'WARD', '558', 'Xuân Sơn Bắc', 'Xuan Son Bac'),
('22102', 'WARD', '558', 'Xuân Quang 2', 'Xuan Quang 2'),
('22105', 'WARD', '558', 'Xuân Sơn Nam', 'Xuan Son Nam'),
('22108', 'WARD', '558', 'Xuân Quang 3', 'Xuan Quang 3'),
('22111', 'WARD', '558', 'Xuân Phước', 'Xuan Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 559 - Tuy An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22114', 'WARD', '559', 'Thị trấn Chí Thạnh', 'Thi tran Chi Thanh'),
('22117', 'WARD', '559', 'An Dân', 'An Dan'),
('22120', 'WARD', '559', 'An Ninh Tây', 'An Ninh Tay'),
('22123', 'WARD', '559', 'An Ninh Đông', 'An Ninh Dong'),
('22126', 'WARD', '559', 'An Thạch', 'An Thach'),
('22129', 'WARD', '559', 'An Định', 'An Dinh'),
('22132', 'WARD', '559', 'An Nghiệp', 'An Nghiep'),
('22138', 'WARD', '559', 'An Cư', 'An Cu'),
('22141', 'WARD', '559', 'An Xuân', 'An Xuan'),
('22144', 'WARD', '559', 'An Lĩnh', 'An Linh'),
('22147', 'WARD', '559', 'An Hòa Hải', 'An Hoa Hai'),
('22150', 'WARD', '559', 'An Hiệp', 'An Hiep'),
('22153', 'WARD', '559', 'An Mỹ', 'An My'),
('22156', 'WARD', '559', 'An Chấn', 'An Chan'),
('22159', 'WARD', '559', 'An Thọ', 'An Tho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 560 - Sơn Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22165', 'WARD', '560', 'Thị trấn Củng Sơn', 'Thi tran Cung Son'),
('22168', 'WARD', '560', 'Phước Tân', 'Phuoc Tan'),
('22171', 'WARD', '560', 'Sơn Hội', 'Son Hoi'),
('22174', 'WARD', '560', 'Sơn Định', 'Son Dinh'),
('22177', 'WARD', '560', 'Sơn Long', 'Son Long'),
('22180', 'WARD', '560', 'Cà Lúi', 'Ca Lui'),
('22183', 'WARD', '560', 'Sơn Phước', 'Son Phuoc'),
('22186', 'WARD', '560', 'Sơn Xuân', 'Son Xuan'),
('22189', 'WARD', '560', 'Sơn Nguyên', 'Son Nguyen'),
('22192', 'WARD', '560', 'Eachà Rang', 'Eacha Rang'),
('22195', 'WARD', '560', 'Krông Pa', 'Krong Pa'),
('22198', 'WARD', '560', 'Suối Bạc', 'Suoi Bac'),
('22201', 'WARD', '560', 'Sơn Hà', 'Son Ha'),
('22204', 'WARD', '560', 'Suối Trai', 'Suoi Trai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 561 - Sông Hinh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22207', 'WARD', '561', 'Thị trấn Hai Riêng', 'Thi tran Hai Rieng'),
('22210', 'WARD', '561', 'Ea Lâm', 'Ea Lam'),
('22213', 'WARD', '561', 'Đức Bình Tây', 'Duc Binh Tay'),
('22216', 'WARD', '561', 'Ea Bá', 'Ea Ba'),
('22219', 'WARD', '561', 'Sơn Giang', 'Son Giang'),
('22222', 'WARD', '561', 'Đức Bình Đông', 'Duc Binh Dong'),
('22225', 'WARD', '561', 'EaBar', 'EaBar'),
('22228', 'WARD', '561', 'EaBia', 'EaBia'),
('22231', 'WARD', '561', 'EaTrol', 'EaTrol'),
('22234', 'WARD', '561', 'Sông Hinh', 'Song Hinh'),
('22237', 'WARD', '561', 'Ealy', 'Ealy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 562 - Tây Hoà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22249', 'WARD', '562', 'Sơn Thành Tây', 'Son Thanh Tay'),
('22250', 'WARD', '562', 'Sơn Thành Đông', 'Son Thanh Dong'),
('22252', 'WARD', '562', 'Hòa Bình 1', 'Hoa Binh 1'),
('22255', 'WARD', '562', 'Thị trấn Phú Thứ', 'Thi tran Phu Thu'),
('22264', 'WARD', '562', 'Hòa Phong', 'Hoa Phong'),
('22270', 'WARD', '562', 'Hòa Phú', 'Hoa Phu'),
('22273', 'WARD', '562', 'Hòa Tân Tây', 'Hoa Tan Tay'),
('22276', 'WARD', '562', 'Hòa Đồng', 'Hoa Dong'),
('22285', 'WARD', '562', 'Hòa Mỹ Đông', 'Hoa My Dong'),
('22288', 'WARD', '562', 'Hòa Mỹ Tây', 'Hoa My Tay'),
('22294', 'WARD', '562', 'Hòa Thịnh', 'Hoa Thinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 563 - Phú Hoà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22303', 'WARD', '563', 'Hòa Quang Bắc', 'Hoa Quang Bac'),
('22306', 'WARD', '563', 'Hòa Quang Nam', 'Hoa Quang Nam'),
('22309', 'WARD', '563', 'Hòa Hội', 'Hoa Hoi'),
('22312', 'WARD', '563', 'Hòa Trị', 'Hoa Tri'),
('22315', 'WARD', '563', 'Hòa An', 'Hoa An'),
('22318', 'WARD', '563', 'Hòa Định Đông', 'Hoa Dinh Dong'),
('22319', 'WARD', '563', 'Thị trấn Phú Hoà', 'Thi tran Phu Hoa'),
('22321', 'WARD', '563', 'Hòa Định Tây', 'Hoa Dinh Tay'),
('22324', 'WARD', '563', 'Hòa Thắng', 'Hoa Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 564 - Thị Đông Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22243', 'WARD', '564', 'Hòa Thành', 'Hoa Thanh'),
('22246', 'WARD', '564', 'Hòa Hiệp Bắc', 'Hoa Hiep Bac'),
('22258', 'WARD', '564', 'Hoà Vinh', 'Hoa Vinh'),
('22261', 'WARD', '564', 'Hoà Hiệp Trung', 'Hoa Hiep Trung'),
('22267', 'WARD', '564', 'Hòa Tân Đông', 'Hoa Tan Dong'),
('22279', 'WARD', '564', 'Hòa Xuân Tây', 'Hoa Xuan Tay'),
('22282', 'WARD', '564', 'Hòa Hiệp Nam', 'Hoa Hiep Nam'),
('22291', 'WARD', '564', 'Hòa Xuân Đông', 'Hoa Xuan Dong'),
('22297', 'WARD', '564', 'Hòa Tâm', 'Hoa Tam'),
('22300', 'WARD', '564', 'Hòa Xuân Nam', 'Hoa Xuan Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 56 - Khánh Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('568', 'DISTRICT', '56', 'Nha Trang', 'Thanh pho Nha Trang'),
('569', 'DISTRICT', '56', 'Cam Ranh', 'Thanh pho Cam Ranh'),
('570', 'DISTRICT', '56', 'Cam Lâm', 'Cam Lam'),
('571', 'DISTRICT', '56', 'Vạn Ninh', 'Van Ninh'),
('572', 'DISTRICT', '56', 'Thị Ninh Hòa', 'Thi Ninh Hoa'),
('573', 'DISTRICT', '56', 'Khánh Vĩnh', 'Khanh Vinh'),
('574', 'DISTRICT', '56', 'Diên Khánh', 'Dien Khanh'),
('575', 'DISTRICT', '56', 'Khánh Sơn', 'Khanh Son'),
('576', 'DISTRICT', '56', 'Trường Sa', 'Truong Sa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 568 - Nha Trang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22327', 'WARD', '568', 'Vĩnh Hòa', 'Vinh Hoa'),
('22330', 'WARD', '568', 'Vĩnh Hải', 'Vinh Hai'),
('22333', 'WARD', '568', 'Vĩnh Phước', 'Vinh Phuoc'),
('22336', 'WARD', '568', 'Ngọc Hiệp', 'Ngoc Hiep'),
('22339', 'WARD', '568', 'Vĩnh Thọ', 'Vinh Tho'),
('22348', 'WARD', '568', 'Vạn Thạnh', 'Van Thanh'),
('22351', 'WARD', '568', 'Phương Sài', 'Sai'),
('22357', 'WARD', '568', 'Phước Hải', 'Phuoc Hai'),
('22363', 'WARD', '568', 'Lộc Thọ', 'Loc Tho'),
('22366', 'WARD', '568', 'Tân Tiến', 'Tan Tien'),
('22372', 'WARD', '568', 'Phước Hòa', 'Phuoc Hoa'),
('22375', 'WARD', '568', 'Vĩnh Nguyên', 'Vinh Nguyen'),
('22378', 'WARD', '568', 'Phước Long', 'Phuoc Long'),
('22381', 'WARD', '568', 'Vĩnh Trường', 'Vinh Truong'),
('22384', 'WARD', '568', 'Vĩnh Lương', 'Vinh Luong'),
('22387', 'WARD', '568', 'Vĩnh Phương', 'Vinh Phuong'),
('22390', 'WARD', '568', 'Vĩnh Ngọc', 'Vinh Ngoc'),
('22393', 'WARD', '568', 'Vĩnh Thạnh', 'Vinh Thanh'),
('22396', 'WARD', '568', 'Vĩnh Trung', 'Vinh Trung'),
('22399', 'WARD', '568', 'Vĩnh Hiệp', 'Vinh Hiep'),
('22402', 'WARD', '568', 'Vĩnh Thái', 'Vinh Thai'),
('22405', 'WARD', '568', 'Phước Đồng', 'Phuoc Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 569 - Cam Ranh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22408', 'WARD', '569', 'Cam Nghĩa', 'Cam Nghia'),
('22411', 'WARD', '569', 'Cam Phúc Bắc', 'Cam Phuc Bac'),
('22414', 'WARD', '569', 'Cam Phúc Nam', 'Cam Phuc Nam'),
('22417', 'WARD', '569', 'Cam Lộc', 'Cam Loc'),
('22420', 'WARD', '569', 'Cam Phú', 'Cam Phu'),
('22423', 'WARD', '569', 'Ba Ngòi', 'Ba Ngoi'),
('22426', 'WARD', '569', 'Cam Thuận', 'Cam Thuan'),
('22429', 'WARD', '569', 'Cam Lợi', 'Cam Loi'),
('22432', 'WARD', '569', 'Cam Linh', 'Cam Linh'),
('22468', 'WARD', '569', 'Cam Thành Nam', 'Cam Thanh Nam'),
('22474', 'WARD', '569', 'Cam Phước Đông', 'Cam Phuoc Dong'),
('22477', 'WARD', '569', 'Cam Thịnh Tây', 'Cam Thinh Tay'),
('22480', 'WARD', '569', 'Cam Thịnh Đông', 'Cam Thinh Dong'),
('22483', 'WARD', '569', 'Cam Lập', 'Cam Lap'),
('22486', 'WARD', '569', 'Cam Bình', 'Cam Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 570 - Cam Lâm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22435', 'WARD', '570', 'Cam Tân', 'Cam Tan'),
('22438', 'WARD', '570', 'Cam Hòa', 'Cam Hoa'),
('22441', 'WARD', '570', 'Cam Hải Đông', 'Cam Hai Dong'),
('22444', 'WARD', '570', 'Cam Hải Tây', 'Cam Hai Tay'),
('22447', 'WARD', '570', 'Sơn Tân', 'Son Tan'),
('22450', 'WARD', '570', 'Cam Hiệp Bắc', 'Cam Hiep Bac'),
('22453', 'WARD', '570', 'Thị trấn Cam Đức', 'Thi tran Cam Duc'),
('22456', 'WARD', '570', 'Cam Hiệp Nam', 'Cam Hiep Nam'),
('22459', 'WARD', '570', 'Cam Phước Tây', 'Cam Phuoc Tay'),
('22462', 'WARD', '570', 'Cam Thành Bắc', 'Cam Thanh Bac'),
('22465', 'WARD', '570', 'Cam An Bắc', 'Cam An Bac'),
('22471', 'WARD', '570', 'Cam An Nam', 'Cam An Nam'),
('22708', 'WARD', '570', 'Suối Cát', 'Suoi Cat'),
('22711', 'WARD', '570', 'Suối Tân', 'Suoi Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 571 - Vạn Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22489', 'WARD', '571', 'Thị trấn Vạn Giã', 'Thi tran Van Gia'),
('22492', 'WARD', '571', 'Đại Lãnh', 'Dai Lanh'),
('22495', 'WARD', '571', 'Vạn Phước', 'Van Phuoc'),
('22498', 'WARD', '571', 'Vạn Long', 'Van Long'),
('22501', 'WARD', '571', 'Vạn Bình', 'Van Binh'),
('22504', 'WARD', '571', 'Vạn Thọ', 'Van Tho'),
('22507', 'WARD', '571', 'Vạn Khánh', 'Van Khanh'),
('22510', 'WARD', '571', 'Vạn Phú', 'Van Phu'),
('22513', 'WARD', '571', 'Vạn Lương', 'Van Luong'),
('22516', 'WARD', '571', 'Vạn Thắng', 'Van Thang'),
('22519', 'WARD', '571', 'Vạn Thạnh', 'Van Thanh'),
('22522', 'WARD', '571', 'Xuân Sơn', 'Xuan Son'),
('22525', 'WARD', '571', 'Vạn Hưng', 'Van Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 572 - Thị Ninh Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22528', 'WARD', '572', 'Ninh Hiệp', 'Ninh Hiep'),
('22531', 'WARD', '572', 'Ninh Sơn', 'Ninh Son'),
('22534', 'WARD', '572', 'Ninh Tây', 'Ninh Tay'),
('22537', 'WARD', '572', 'Ninh Thượng', 'Ninh Thuong'),
('22540', 'WARD', '572', 'Ninh An', 'Ninh An'),
('22543', 'WARD', '572', 'Ninh Hải', 'Ninh Hai'),
('22546', 'WARD', '572', 'Ninh Thọ', 'Ninh Tho'),
('22549', 'WARD', '572', 'Ninh Trung', 'Ninh Trung'),
('22552', 'WARD', '572', 'Ninh Sim', 'Ninh Sim'),
('22555', 'WARD', '572', 'Ninh Xuân', 'Ninh Xuan'),
('22558', 'WARD', '572', 'Ninh Thân', 'Ninh Than'),
('22561', 'WARD', '572', 'Ninh Diêm', 'Ninh Diem'),
('22564', 'WARD', '572', 'Ninh Đông', 'Ninh Dong'),
('22567', 'WARD', '572', 'Ninh Thủy', 'Ninh Thuy'),
('22570', 'WARD', '572', 'Ninh Đa', 'Ninh Da'),
('22573', 'WARD', '572', 'Ninh Phụng', 'Ninh Phung'),
('22576', 'WARD', '572', 'Ninh Bình', 'Ninh Binh'),
('22582', 'WARD', '572', 'Ninh Phú', 'Ninh Phu'),
('22585', 'WARD', '572', 'Ninh Tân', 'Ninh Tan'),
('22588', 'WARD', '572', 'Ninh Quang', 'Ninh Quang'),
('22591', 'WARD', '572', 'Ninh Giang', 'Ninh Giang'),
('22594', 'WARD', '572', 'Ninh Hà', 'Ninh Ha'),
('22597', 'WARD', '572', 'Ninh Hưng', 'Ninh Hung'),
('22600', 'WARD', '572', 'Ninh Lộc', 'Ninh Loc'),
('22603', 'WARD', '572', 'Ninh Ích', 'Ninh Ich'),
('22606', 'WARD', '572', 'Ninh Phước', 'Ninh Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 573 - Khánh Vĩnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22609', 'WARD', '573', 'Thị trấn Khánh Vĩnh', 'Thi tran Khanh Vinh'),
('22612', 'WARD', '573', 'Khánh Hiệp', 'Khanh Hiep'),
('22615', 'WARD', '573', 'Khánh Bình', 'Khanh Binh'),
('22618', 'WARD', '573', 'Khánh Trung', 'Khanh Trung'),
('22621', 'WARD', '573', 'Khánh Đông', 'Khanh Dong'),
('22624', 'WARD', '573', 'Khánh Thượng', 'Khanh Thuong'),
('22627', 'WARD', '573', 'Khánh Nam', 'Khanh Nam'),
('22630', 'WARD', '573', 'Sông Cầu', 'Song Cau'),
('22633', 'WARD', '573', 'Giang Ly', 'Giang Ly'),
('22636', 'WARD', '573', 'Cầu Bà', 'Cau Ba'),
('22639', 'WARD', '573', 'Liên Sang', 'Lien Sang'),
('22642', 'WARD', '573', 'Khánh Thành', 'Khanh Thanh'),
('22645', 'WARD', '573', 'Khánh Phú', 'Khanh Phu'),
('22648', 'WARD', '573', 'Sơn Thái', 'Son Thai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 574 - Diên Khánh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22651', 'WARD', '574', 'Thị trấn Diên Khánh', 'Thi tran Dien Khanh'),
('22654', 'WARD', '574', 'Diên Lâm', 'Dien Lam'),
('22657', 'WARD', '574', 'Diên Điền', 'Dien Dien'),
('22660', 'WARD', '574', 'Xuân Đồng', 'Xuan Dong'),
('22663', 'WARD', '574', 'Diên Sơn', 'Dien Son'),
('22669', 'WARD', '574', 'Diên Phú', 'Dien Phu'),
('22672', 'WARD', '574', 'Diên Thọ', 'Dien Tho'),
('22675', 'WARD', '574', 'Diên Phước', 'Dien Phuoc'),
('22678', 'WARD', '574', 'Diên Lạc', 'Dien Lac'),
('22681', 'WARD', '574', 'Diên Tân', 'Dien Tan'),
('22684', 'WARD', '574', 'Diên Hòa', 'Dien Hoa'),
('22687', 'WARD', '574', 'Diên Thạnh', 'Dien Thanh'),
('22690', 'WARD', '574', 'Diên Toàn', 'Dien Toan'),
('22693', 'WARD', '574', 'Diên An', 'Dien An'),
('22696', 'WARD', '574', 'Bình Lộc', 'Binh Loc'),
('22702', 'WARD', '574', 'Suối Hiệp', 'Suoi Hiep'),
('22705', 'WARD', '574', 'Suối Tiên', 'Suoi Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 575 - Khánh Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22714', 'WARD', '575', 'Thị trấn Tô Hạp', 'Thi tran To Hap'),
('22717', 'WARD', '575', 'Thành Sơn', 'Thanh Son'),
('22720', 'WARD', '575', 'Sơn Lâm', 'Son Lam'),
('22723', 'WARD', '575', 'Sơn Hiệp', 'Son Hiep'),
('22726', 'WARD', '575', 'Sơn Bình', 'Son Binh'),
('22729', 'WARD', '575', 'Sơn Trung', 'Son Trung'),
('22732', 'WARD', '575', 'Ba Cụm Bắc', 'Ba Cum Bac'),
('22735', 'WARD', '575', 'Ba Cụm Nam', 'Ba Cum Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 576 - Trường Sa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22736', 'WARD', '576', 'Thị trấn Trường Sa', 'Thi tran Truong Sa'),
('22737', 'WARD', '576', 'Song Tử Tây', 'Song Tu Tay'),
('22739', 'WARD', '576', 'Sinh Tồn', 'Sinh Ton')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 58 - Ninh Thuận
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('582', 'DISTRICT', '58', 'Phan Rang - Tháp Chàm', 'Thanh pho Phan Rang - Thap Cham'),
('584', 'DISTRICT', '58', 'Bác Ái', 'Bac Ai'),
('585', 'DISTRICT', '58', 'Ninh Sơn', 'Ninh Son'),
('586', 'DISTRICT', '58', 'Ninh Hải', 'Ninh Hai'),
('587', 'DISTRICT', '58', 'Ninh Phước', 'Ninh Phuoc'),
('588', 'DISTRICT', '58', 'Thuận Bắc', 'Thuan Bac'),
('589', 'DISTRICT', '58', 'Thuận Nam', 'Thuan Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 582 - Phan Rang - Tháp Chàm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22738', 'WARD', '582', 'Đô Vinh', 'Do Vinh'),
('22741', 'WARD', '582', 'Phước Mỹ', 'Phuoc My'),
('22744', 'WARD', '582', 'Bảo An', 'Bao An'),
('22750', 'WARD', '582', 'Phủ Hà', 'Phu Ha'),
('22759', 'WARD', '582', 'Kinh Dinh', 'Kinh Dinh'),
('22762', 'WARD', '582', 'Đạo Long', 'Dao Long'),
('22765', 'WARD', '582', 'Đài Sơn', 'Dai Son'),
('22768', 'WARD', '582', 'Đông Hải', 'Dong Hai'),
('22771', 'WARD', '582', 'Mỹ Đông', 'My Dong'),
('22774', 'WARD', '582', 'Thành Hải', 'Thanh Hai'),
('22777', 'WARD', '582', 'Văn Hải', 'Van Hai'),
('22779', 'WARD', '582', 'Mỹ Bình', 'My Binh'),
('22780', 'WARD', '582', 'Mỹ Hải', 'My Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 584 - Bác Ái
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22783', 'WARD', '584', 'Phước Bình', 'Phuoc Binh'),
('22786', 'WARD', '584', 'Phước Hòa', 'Phuoc Hoa'),
('22789', 'WARD', '584', 'Phước Tân', 'Phuoc Tan'),
('22792', 'WARD', '584', 'Phước Tiến', 'Phuoc Tien'),
('22795', 'WARD', '584', 'Phước Thắng', 'Phuoc Thang'),
('22798', 'WARD', '584', 'Phước Thành', 'Phuoc Thanh'),
('22801', 'WARD', '584', 'Phước Đại', 'Phuoc Dai'),
('22804', 'WARD', '584', 'Phước Chính', 'Phuoc Chinh'),
('22807', 'WARD', '584', 'Phước Trung', 'Phuoc Trung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 585 - Ninh Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22810', 'WARD', '585', 'Thị trấn Tân Sơn', 'Thi tran Tan Son'),
('22813', 'WARD', '585', 'Lâm Sơn', 'Lam Son'),
('22816', 'WARD', '585', 'Lương Sơn', 'Luong Son'),
('22819', 'WARD', '585', 'Quảng Sơn', 'Quang Son'),
('22822', 'WARD', '585', 'Mỹ Sơn', 'My Son'),
('22825', 'WARD', '585', 'Hòa Sơn', 'Hoa Son'),
('22828', 'WARD', '585', 'Ma Nới', 'Ma Noi'),
('22831', 'WARD', '585', 'Nhơn Sơn', 'Nhon Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 586 - Ninh Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22834', 'WARD', '586', 'Thị trấn Khánh Hải', 'Thi tran Khanh Hai'),
('22846', 'WARD', '586', 'Vĩnh Hải', 'Vinh Hai'),
('22852', 'WARD', '586', 'Phương Hải', 'Hai'),
('22855', 'WARD', '586', 'Tân Hải', 'Tan Hai'),
('22858', 'WARD', '586', 'Xuân Hải', 'Xuan Hai'),
('22861', 'WARD', '586', 'Hộ Hải', 'Ho Hai'),
('22864', 'WARD', '586', 'Tri Hải', 'Tri Hai'),
('22867', 'WARD', '586', 'Nhơn Hải', 'Nhon Hai'),
('22868', 'WARD', '586', 'Thanh Hải', 'Thanh Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 587 - Ninh Phước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22870', 'WARD', '587', 'Thị trấn Phước Dân', 'Thi tran Phuoc Dan'),
('22873', 'WARD', '587', 'Phước Sơn', 'Phuoc Son'),
('22876', 'WARD', '587', 'Phước Thái', 'Phuoc Thai'),
('22879', 'WARD', '587', 'Phước Hậu', 'Phuoc Hau'),
('22882', 'WARD', '587', 'Phước Thuận', 'Phuoc Thuan'),
('22888', 'WARD', '587', 'An Hải', 'An Hai'),
('22891', 'WARD', '587', 'Phước Hữu', 'Phuoc Huu'),
('22894', 'WARD', '587', 'Phước Hải', 'Phuoc Hai'),
('22912', 'WARD', '587', 'Phước Vinh', 'Phuoc Vinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 588 - Thuận Bắc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22837', 'WARD', '588', 'Phước Chiến', 'Phuoc Chien'),
('22840', 'WARD', '588', 'Công Hải', 'Cong Hai'),
('22843', 'WARD', '588', 'Phước Kháng', 'Phuoc Khang'),
('22849', 'WARD', '588', 'Lợi Hải', 'Loi Hai'),
('22853', 'WARD', '588', 'Bắc Sơn', 'Bac Son'),
('22856', 'WARD', '588', 'Bắc Phong', 'Bac Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 589 - Thuận Nam
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22885', 'WARD', '589', 'Phước Hà', 'Phuoc Ha'),
('22897', 'WARD', '589', 'Phước Nam', 'Phuoc Nam'),
('22898', 'WARD', '589', 'Phước Ninh', 'Phuoc Ninh'),
('22900', 'WARD', '589', 'Nhị Hà', 'Nhi Ha'),
('22903', 'WARD', '589', 'Phước Dinh', 'Phuoc Dinh'),
('22906', 'WARD', '589', 'Phước Minh', 'Phuoc Minh'),
('22909', 'WARD', '589', 'Phước Diêm', 'Phuoc Diem'),
('22910', 'WARD', '589', 'Cà Ná', 'Ca Na')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 60 - Bình Thuận
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('593', 'DISTRICT', '60', 'Phan Thiết', 'Thanh pho Phan Thiet'),
('594', 'DISTRICT', '60', 'Thị La Gi', 'Thi La Gi'),
('595', 'DISTRICT', '60', 'Tuy Phong', 'Tuy Phong'),
('596', 'DISTRICT', '60', 'Bắc Bình', 'Bac Binh'),
('597', 'DISTRICT', '60', 'Hàm Thuận Bắc', 'Ham Thuan Bac'),
('598', 'DISTRICT', '60', 'Hàm Thuận Nam', 'Ham Thuan Nam'),
('599', 'DISTRICT', '60', 'Tánh Linh', 'Tanh Linh'),
('600', 'DISTRICT', '60', 'Đức Linh', 'Duc Linh'),
('601', 'DISTRICT', '60', 'Hàm Tân', 'Ham Tan'),
('602', 'DISTRICT', '60', 'Phú Quí', 'Phu Qui')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 593 - Phan Thiết
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22915', 'WARD', '593', 'Mũi Né', 'Mui Ne'),
('22918', 'WARD', '593', 'Hàm Tiến', 'Ham Tien'),
('22921', 'WARD', '593', 'Phú Hài', 'Phu Hai'),
('22924', 'WARD', '593', 'Phú Thủy', 'Phu Thuy'),
('22927', 'WARD', '593', 'Phú Tài', 'Phu Tai'),
('22930', 'WARD', '593', 'Phú Trinh', 'Phu Trinh'),
('22933', 'WARD', '593', 'Xuân An', 'Xuan An'),
('22936', 'WARD', '593', 'Thanh Hải', 'Thanh Hai'),
('22945', 'WARD', '593', 'Lạc Đạo', 'Lac Dao'),
('22951', 'WARD', '593', 'Bình Hưng', 'Binh Hung'),
('22954', 'WARD', '593', 'Đức Long', 'Duc Long'),
('22957', 'WARD', '593', 'Thiện Nghiệp', 'Thien Nghiep'),
('22960', 'WARD', '593', 'Phong Nẫm', 'Phong Nam'),
('22963', 'WARD', '593', 'Tiến Lợi', 'Tien Loi'),
('22966', 'WARD', '593', 'Tiến Thành', 'Tien Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 594 - Thị La Gi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23231', 'WARD', '594', 'Phước Hội', 'Phuoc Hoi'),
('23232', 'WARD', '594', 'Phước Lộc', 'Phuoc Loc'),
('23234', 'WARD', '594', 'Tân Thiện', 'Tan Thien'),
('23235', 'WARD', '594', 'Tân An', 'Tan An'),
('23237', 'WARD', '594', 'Bình Tân', 'Binh Tan'),
('23245', 'WARD', '594', 'Tân Hải', 'Tan Hai'),
('23246', 'WARD', '594', 'Tân Tiến', 'Tan Tien'),
('23248', 'WARD', '594', 'Tân Bình', 'Tan Binh'),
('23268', 'WARD', '594', 'Tân Phước', 'Tan Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 595 - Tuy Phong
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('22969', 'WARD', '595', 'Thị trấn Liên Hương', 'Thi tran Lien Huong'),
('22972', 'WARD', '595', 'Thị trấn Phan Rí Cửa', 'Thi tran Phan Ri Cua'),
('22975', 'WARD', '595', 'Phan Dũng', 'Phan Dung'),
('22978', 'WARD', '595', 'Phong Phú', 'Phong Phu'),
('22981', 'WARD', '595', 'Vĩnh Hảo', 'Vinh Hao'),
('22984', 'WARD', '595', 'Vĩnh Tân', 'Vinh Tan'),
('22987', 'WARD', '595', 'Phú Lạc', 'Phu Lac'),
('22990', 'WARD', '595', 'Phước Thể', 'Phuoc The'),
('22993', 'WARD', '595', 'Hòa Minh', 'Hoa Minh'),
('22996', 'WARD', '595', 'Chí Công', 'Chi Cong'),
('22999', 'WARD', '595', 'Bình Thạnh', 'Binh Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 596 - Bắc Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23005', 'WARD', '596', 'Thị trấn Chợ Lầu', 'Thi tran Cho Lau'),
('23008', 'WARD', '596', 'Phan Sơn', 'Phan Son'),
('23011', 'WARD', '596', 'Phan Lâm', 'Phan Lam'),
('23014', 'WARD', '596', 'Bình An', 'Binh An'),
('23017', 'WARD', '596', 'Phan Điền', 'Phan Dien'),
('23020', 'WARD', '596', 'Hải Ninh', 'Hai Ninh'),
('23023', 'WARD', '596', 'Sông Lũy', 'Song Luy'),
('23026', 'WARD', '596', 'Phan Tiến', 'Phan Tien'),
('23029', 'WARD', '596', 'Sông Bình', 'Song Binh'),
('23032', 'WARD', '596', 'Thị trấn Lương Sơn', 'Thi tran Luong Son'),
('23035', 'WARD', '596', 'Phan Hòa', 'Phan Hoa'),
('23038', 'WARD', '596', 'Phan Thanh', 'Phan Thanh'),
('23041', 'WARD', '596', 'Hồng Thái', 'Hong Thai'),
('23044', 'WARD', '596', 'Phan Hiệp', 'Phan Hiep'),
('23047', 'WARD', '596', 'Bình Tân', 'Binh Tan'),
('23050', 'WARD', '596', 'Phan Rí Thành', 'Phan Ri Thanh'),
('23053', 'WARD', '596', 'Hòa Thắng', 'Hoa Thang'),
('23056', 'WARD', '596', 'Hồng Phong', 'Hong Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 597 - Hàm Thuận Bắc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23059', 'WARD', '597', 'Thị trấn Ma Lâm', 'Thi tran Ma Lam'),
('23062', 'WARD', '597', 'Thị trấn Phú Long', 'Thi tran Phu Long'),
('23065', 'WARD', '597', 'La Dạ', 'La Da'),
('23068', 'WARD', '597', 'Đông Tiến', 'Dong Tien'),
('23071', 'WARD', '597', 'Thuận Hòa', 'Thuan Hoa'),
('23074', 'WARD', '597', 'Đông Giang', 'Dong Giang'),
('23077', 'WARD', '597', 'Hàm Phú', 'Ham Phu'),
('23080', 'WARD', '597', 'Hồng Liêm', 'Hong Liem'),
('23083', 'WARD', '597', 'Thuận Minh', 'Thuan Minh'),
('23086', 'WARD', '597', 'Hồng Sơn', 'Hong Son'),
('23089', 'WARD', '597', 'Hàm Trí', 'Ham Tri'),
('23092', 'WARD', '597', 'Hàm Đức', 'Ham Duc'),
('23095', 'WARD', '597', 'Hàm Liêm', 'Ham Liem'),
('23098', 'WARD', '597', 'Hàm Chính', 'Ham Chinh'),
('23101', 'WARD', '597', 'Hàm Hiệp', 'Ham Hiep'),
('23104', 'WARD', '597', 'Hàm Thắng', 'Ham Thang'),
('23107', 'WARD', '597', 'Đa Mi', 'Da Mi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 598 - Hàm Thuận Nam
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23110', 'WARD', '598', 'Thị trấn Thuận Nam', 'Thi tran Thuan Nam'),
('23113', 'WARD', '598', 'Mỹ Thạnh', 'My Thanh'),
('23116', 'WARD', '598', 'Hàm Cần', 'Ham Can'),
('23119', 'WARD', '598', 'Mương Mán', 'Muong Man'),
('23122', 'WARD', '598', 'Hàm Thạnh', 'Ham Thanh'),
('23125', 'WARD', '598', 'Hàm Kiệm', 'Ham Kiem'),
('23128', 'WARD', '598', 'Hàm Cường', 'Ham Cuong'),
('23131', 'WARD', '598', 'Hàm Mỹ', 'Ham My'),
('23134', 'WARD', '598', 'Tân Lập', 'Tan Lap'),
('23137', 'WARD', '598', 'Hàm Minh', 'Ham Minh'),
('23140', 'WARD', '598', 'Thuận Quí', 'Thuan Qui'),
('23143', 'WARD', '598', 'Tân Thuận', 'Tan Thuan'),
('23146', 'WARD', '598', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 599 - Tánh Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23149', 'WARD', '599', 'Thị trấn Lạc Tánh', 'Thi tran Lac Tanh'),
('23152', 'WARD', '599', 'Bắc Ruộng', 'Bac Ruong'),
('23158', 'WARD', '599', 'Nghị Đức', 'Nghi Duc'),
('23161', 'WARD', '599', 'La Ngâu', 'La Ngau'),
('23164', 'WARD', '599', 'Huy Khiêm', 'Huy Khiem'),
('23167', 'WARD', '599', 'Măng Tố', 'Mang To'),
('23170', 'WARD', '599', 'Đức Phú', 'Duc Phu'),
('23173', 'WARD', '599', 'Đồng Kho', 'Dong Kho'),
('23176', 'WARD', '599', 'Gia An', 'Gia An'),
('23179', 'WARD', '599', 'Đức Bình', 'Duc Binh'),
('23182', 'WARD', '599', 'Gia Huynh', 'Gia Huynh'),
('23185', 'WARD', '599', 'Đức Thuận', 'Duc Thuan'),
('23188', 'WARD', '599', 'Suối Kiết', 'Suoi Kiet')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 600 - Đức Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23191', 'WARD', '600', 'Thị trấn Võ Xu', 'Thi tran Vo Xu'),
('23194', 'WARD', '600', 'Thị trấn Đức Tài', 'Thi tran Duc Tai'),
('23197', 'WARD', '600', 'Đa Kai', 'Da Kai'),
('23200', 'WARD', '600', 'Sùng Nhơn', 'Sung Nhon'),
('23203', 'WARD', '600', 'Mê Pu', 'Me Pu'),
('23206', 'WARD', '600', 'Nam Chính', 'Nam Chinh'),
('23212', 'WARD', '600', 'Đức Hạnh', 'Duc Hanh'),
('23215', 'WARD', '600', 'Đức Tín', 'Duc Tin'),
('23218', 'WARD', '600', 'Vũ Hoà', 'Vu Hoa'),
('23221', 'WARD', '600', 'Tân Hà', 'Tan Ha'),
('23224', 'WARD', '600', 'Đông Hà', 'Dong Ha'),
('23227', 'WARD', '600', 'Trà Tân', 'Tra Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 601 - Hàm Tân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23230', 'WARD', '601', 'Thị trấn Tân Minh', 'Thi tran Tan Minh'),
('23236', 'WARD', '601', 'Thị trấn Tân Nghĩa', 'Thi tran Tan Nghia'),
('23239', 'WARD', '601', 'Sông Phan', 'Song Phan'),
('23242', 'WARD', '601', 'Tân Phúc', 'Tan Phuc'),
('23251', 'WARD', '601', 'Tân Đức', 'Tan Duc'),
('23254', 'WARD', '601', 'Tân Thắng', 'Tan Thang'),
('23255', 'WARD', '601', 'Thắng Hải', 'Thang Hai'),
('23257', 'WARD', '601', 'Tân Hà', 'Tan Ha'),
('23260', 'WARD', '601', 'Tân Xuân', 'Tan Xuan'),
('23266', 'WARD', '601', 'Sơn Mỹ', 'Son My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 602 - Phú Quí
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23272', 'WARD', '602', 'Ngũ Phụng', 'Ngu Phung'),
('23275', 'WARD', '602', 'Long Hải', 'Long Hai'),
('23278', 'WARD', '602', 'Tam Thanh', 'Tam Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 62 - Kon Tum
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('608', 'DISTRICT', '62', 'Kon Tum', 'Thanh pho Kon Tum'),
('610', 'DISTRICT', '62', 'Đắk Glei', 'Dak Glei'),
('611', 'DISTRICT', '62', 'Ngọc Hồi', 'Ngoc Hoi'),
('612', 'DISTRICT', '62', 'Đắk Tô', 'Dak To'),
('613', 'DISTRICT', '62', 'Kon Plông', 'Kon Plong'),
('614', 'DISTRICT', '62', 'Kon Rẫy', 'Kon Ray'),
('615', 'DISTRICT', '62', 'Đắk Hà', 'Dak Ha'),
('616', 'DISTRICT', '62', 'Sa Thầy', 'Sa Thay'),
('617', 'DISTRICT', '62', 'Tu Mơ Rông', 'Tu Mo Rong'),
('618', 'DISTRICT', '62', 'Ia H'' Drai', 'Ia H'' Drai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 608 - Kon Tum
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23281', 'WARD', '608', 'Quang Trung', 'Quang Trung'),
('23284', 'WARD', '608', 'Duy Tân', 'Duy Tan'),
('23287', 'WARD', '608', 'Quyết Thắng', 'Quyet Thang'),
('23290', 'WARD', '608', 'Trường Chinh', 'Truong Chinh'),
('23293', 'WARD', '608', 'Thắng Lợi', 'Thang Loi'),
('23296', 'WARD', '608', 'Ngô Mây', 'Ngo May'),
('23299', 'WARD', '608', 'Thống Nhất', 'Thong Nhat'),
('23302', 'WARD', '608', 'Lê Lợi', 'Le Loi'),
('23305', 'WARD', '608', 'Nguyễn Trãi', 'Nguyen Trai'),
('23308', 'WARD', '608', 'Trần Hưng Đạo', 'Tran Hung Dao'),
('23311', 'WARD', '608', 'Đắk Cấm', 'Dak Cam'),
('23314', 'WARD', '608', 'Kroong', 'Kroong'),
('23317', 'WARD', '608', 'Ngọk Bay', 'Ngok Bay'),
('23320', 'WARD', '608', 'Vinh Quang', 'Vinh Quang'),
('23323', 'WARD', '608', 'Đắk Blà', 'Dak Bla'),
('23326', 'WARD', '608', 'Ia Chim', 'Ia Chim'),
('23327', 'WARD', '608', 'Đăk Năng', 'Dak Nang'),
('23329', 'WARD', '608', 'Đoàn Kết', 'Doan Ket'),
('23332', 'WARD', '608', 'Chư Hreng', 'Chu Hreng'),
('23335', 'WARD', '608', 'Đắk Rơ Wa', 'Dak Ro Wa'),
('23338', 'WARD', '608', 'Hòa Bình', 'Hoa Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 610 - Đắk Glei
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23341', 'WARD', '610', 'Thị trấn Đắk Glei', 'Thi tran Dak Glei'),
('23344', 'WARD', '610', 'Đắk Blô', 'Dak Blo'),
('23347', 'WARD', '610', 'Đắk Man', 'Dak Man'),
('23350', 'WARD', '610', 'Đắk Nhoong', 'Dak Nhoong'),
('23353', 'WARD', '610', 'Đắk Pék', 'Dak Pek'),
('23356', 'WARD', '610', 'Đắk Choong', 'Dak Choong'),
('23359', 'WARD', '610', 'Xốp', 'Xop'),
('23362', 'WARD', '610', 'Mường Hoong', 'Muong Hoong'),
('23365', 'WARD', '610', 'Ngọc Linh', 'Ngoc Linh'),
('23368', 'WARD', '610', 'Đắk Long', 'Dak Long'),
('23371', 'WARD', '610', 'Đắk KRoong', 'Dak KRoong'),
('23374', 'WARD', '610', 'Đắk Môn', 'Dak Mon')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 611 - Ngọc Hồi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23377', 'WARD', '611', 'Thị trấn Plei Kần', 'Thi tran Plei Kan'),
('23380', 'WARD', '611', 'Đắk Ang', 'Dak Ang'),
('23383', 'WARD', '611', 'Đắk Dục', 'Dak Duc'),
('23386', 'WARD', '611', 'Đắk Nông', 'Dak Nong'),
('23389', 'WARD', '611', 'Đắk Xú', 'Dak Xu'),
('23392', 'WARD', '611', 'Đắk Kan', 'Dak Kan'),
('23395', 'WARD', '611', 'Bờ Y', 'Bo Y'),
('23398', 'WARD', '611', 'Sa Loong', 'Sa Loong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 612 - Đắk Tô
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23401', 'WARD', '612', 'Thị trấn Đắk Tô', 'Thi tran Dak To'),
('23427', 'WARD', '612', 'Đắk Rơ Nga', 'Dak Ro Nga'),
('23428', 'WARD', '612', 'Ngọk Tụ', 'Ngok Tu'),
('23430', 'WARD', '612', 'Đắk Trăm', 'Dak Tram'),
('23431', 'WARD', '612', 'Văn Lem', 'Van Lem'),
('23434', 'WARD', '612', 'Kon Đào', 'Kon Dao'),
('23437', 'WARD', '612', 'Tân Cảnh', 'Tan Canh'),
('23440', 'WARD', '612', 'Diên Bình', 'Dien Binh'),
('23443', 'WARD', '612', 'Pô Kô', 'Po Ko')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 613 - Kon Plông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23452', 'WARD', '613', 'Đắk Nên', 'Dak Nen'),
('23455', 'WARD', '613', 'Đắk Ring', 'Dak Ring'),
('23458', 'WARD', '613', 'Măng Buk', 'Mang Buk'),
('23461', 'WARD', '613', 'Đắk Tăng', 'Dak Tang'),
('23464', 'WARD', '613', 'Ngok Tem', 'Ngok Tem'),
('23467', 'WARD', '613', 'Pờ Ê', 'Po E'),
('23470', 'WARD', '613', 'Măng Cành', 'Mang Canh'),
('23473', 'WARD', '613', 'Thị trấn Măng Đen', 'Thi tran Mang Den'),
('23476', 'WARD', '613', 'Hiếu', 'Hieu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 614 - Kon Rẫy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23479', 'WARD', '614', 'Thị trấn Đắk Rve', 'Thi tran Dak Rve'),
('23482', 'WARD', '614', 'Đắk Kôi', 'Dak Koi'),
('23485', 'WARD', '614', 'Đắk Tơ Lung', 'Dak To Lung'),
('23488', 'WARD', '614', 'Đắk Ruồng', 'Dak Ruong'),
('23491', 'WARD', '614', 'Đắk Pne', 'Dak Pne'),
('23494', 'WARD', '614', 'Đắk Tờ Re', 'Dak To Re'),
('23497', 'WARD', '614', 'Tân Lập', 'Tan Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 615 - Đắk Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23500', 'WARD', '615', 'Thị trấn Đắk Hà', 'Thi tran Dak Ha'),
('23503', 'WARD', '615', 'Đắk PXi', 'Dak PXi'),
('23504', 'WARD', '615', 'Đăk Long', 'Dak Long'),
('23506', 'WARD', '615', 'Đắk HRing', 'Dak HRing'),
('23509', 'WARD', '615', 'Đắk Ui', 'Dak Ui'),
('23510', 'WARD', '615', 'Đăk Ngọk', 'Dak Ngok'),
('23512', 'WARD', '615', 'Đắk Mar', 'Dak Mar'),
('23515', 'WARD', '615', 'Ngok Wang', 'Ngok Wang'),
('23518', 'WARD', '615', 'Ngok Réo', 'Ngok Reo'),
('23521', 'WARD', '615', 'Hà Mòn', 'Ha Mon'),
('23524', 'WARD', '615', 'Đắk La', 'Dak La')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 616 - Sa Thầy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23527', 'WARD', '616', 'Thị trấn Sa Thầy', 'Thi tran Sa Thay'),
('23530', 'WARD', '616', 'Rơ Kơi', 'Ro Koi'),
('23533', 'WARD', '616', 'Sa Nhơn', 'Sa Nhon'),
('23534', 'WARD', '616', 'Hơ Moong', 'Ho Moong'),
('23536', 'WARD', '616', 'Mô Rai', 'Mo Rai'),
('23539', 'WARD', '616', 'Sa Sơn', 'Sa Son'),
('23542', 'WARD', '616', 'Sa Nghĩa', 'Sa Nghia'),
('23545', 'WARD', '616', 'Sa Bình', 'Sa Binh'),
('23548', 'WARD', '616', 'Ya Xiêr', 'Ya Xier'),
('23551', 'WARD', '616', 'Ya Tăng', 'Ya Tang'),
('23554', 'WARD', '616', 'Ya ly', 'Ya ly')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 617 - Tu Mơ Rông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23404', 'WARD', '617', 'Ngọc Lây', 'Ngoc Lay'),
('23407', 'WARD', '617', 'Đắk Na', 'Dak Na'),
('23410', 'WARD', '617', 'Măng Ri', 'Mang Ri'),
('23413', 'WARD', '617', 'Ngọc Yêu', 'Ngoc Yeu'),
('23416', 'WARD', '617', 'Đắk Sao', 'Dak Sao'),
('23417', 'WARD', '617', 'Đắk Rơ Ông', 'Dak Ro Ong'),
('23419', 'WARD', '617', 'Đắk Tờ Kan', 'Dak To Kan'),
('23422', 'WARD', '617', 'Tu Mơ Rông', 'Tu Mo Rong'),
('23425', 'WARD', '617', 'Đắk Hà', 'Dak Ha'),
('23446', 'WARD', '617', 'Tê Xăng', 'Te Xang'),
('23449', 'WARD', '617', 'Văn Xuôi', 'Van Xuoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 618 - Ia H'' Drai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23535', 'WARD', '618', 'Ia Đal', 'Ia Dal'),
('23537', 'WARD', '618', 'Ia Dom', 'Ia Dom'),
('23538', 'WARD', '618', 'Ia Tơi', 'Ia Toi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 64 - Gia Lai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('622', 'DISTRICT', '64', 'Pleiku', 'Thanh pho Pleiku'),
('623', 'DISTRICT', '64', 'Thị An Khê', 'Thi An Khe'),
('624', 'DISTRICT', '64', 'Thị Ayun Pa', 'Thi Ayun Pa'),
('625', 'DISTRICT', '64', 'KBang', 'KBang'),
('626', 'DISTRICT', '64', 'Đăk Đoa', 'Dak Doa'),
('627', 'DISTRICT', '64', 'Chư Păh', 'Chu Pah'),
('628', 'DISTRICT', '64', 'Ia Grai', 'Ia Grai'),
('629', 'DISTRICT', '64', 'Mang Yang', 'Mang Yang'),
('630', 'DISTRICT', '64', 'Kông Chro', 'Kong Chro'),
('631', 'DISTRICT', '64', 'Đức Cơ', 'Duc Co'),
('632', 'DISTRICT', '64', 'Chư Prông', 'Chu Prong'),
('633', 'DISTRICT', '64', 'Chư Sê', 'Chu Se'),
('634', 'DISTRICT', '64', 'Đăk Pơ', 'Dak Po'),
('635', 'DISTRICT', '64', 'Ia Pa', 'Ia Pa'),
('637', 'DISTRICT', '64', 'Krông Pa', 'Krong Pa'),
('638', 'DISTRICT', '64', 'Phú Thiện', 'Phu Thien'),
('639', 'DISTRICT', '64', 'Chư Pưh', 'Chu Puh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 622 - Pleiku
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23557', 'WARD', '622', 'Yên Đỗ', 'Yen Do'),
('23560', 'WARD', '622', 'Diên Hồng', 'Dien Hong'),
('23563', 'WARD', '622', 'Ia Kring', 'Ia Kring'),
('23566', 'WARD', '622', 'Hội Thương', 'Hoi Thuong'),
('23569', 'WARD', '622', 'Hội Phú', 'Hoi Phu'),
('23570', 'WARD', '622', 'Phù Đổng', 'Phu Dong'),
('23572', 'WARD', '622', 'Hoa Lư', 'Hoa Lu'),
('23575', 'WARD', '622', 'Tây Sơn', 'Tay Son'),
('23578', 'WARD', '622', 'Thống Nhất', 'Thong Nhat'),
('23579', 'WARD', '622', 'Đống Đa', 'Dong Da'),
('23581', 'WARD', '622', 'Trà Bá', 'Tra Ba'),
('23582', 'WARD', '622', 'Thắng Lợi', 'Thang Loi'),
('23584', 'WARD', '622', 'Yên Thế', 'Yen The'),
('23586', 'WARD', '622', 'Chi Lăng', 'Chi Lang'),
('23590', 'WARD', '622', 'Biển Hồ', 'Bien Ho'),
('23596', 'WARD', '622', 'Trà Đa', 'Tra Da'),
('23599', 'WARD', '622', 'Chư Á', 'Chu A'),
('23602', 'WARD', '622', 'An Phú', 'An Phu'),
('23605', 'WARD', '622', 'Diên Phú', 'Dien Phu'),
('23608', 'WARD', '622', 'Ia Kênh', 'Ia Kenh'),
('23611', 'WARD', '622', 'Gào', 'Gao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 623 - Thị An Khê
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23614', 'WARD', '623', 'An Bình', 'An Binh'),
('23617', 'WARD', '623', 'Tây Sơn', 'Tay Son'),
('23620', 'WARD', '623', 'An Phú', 'An Phu'),
('23623', 'WARD', '623', 'An Tân', 'An Tan'),
('23626', 'WARD', '623', 'Tú An', 'Tu An'),
('23627', 'WARD', '623', 'Xuân An', 'Xuan An'),
('23629', 'WARD', '623', 'Cửu An', 'Cuu An'),
('23630', 'WARD', '623', 'An Phước', 'An Phuoc'),
('23632', 'WARD', '623', 'Song An', 'Song An'),
('23633', 'WARD', '623', 'Ngô Mây', 'Ngo May'),
('23635', 'WARD', '623', 'Thành An', 'Thanh An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 624 - Thị Ayun Pa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24041', 'WARD', '624', 'Cheo Reo', 'Cheo Reo'),
('24042', 'WARD', '624', 'Hòa Bình', 'Hoa Binh'),
('24044', 'WARD', '624', 'Đoàn Kết', 'Doan Ket'),
('24045', 'WARD', '624', 'Sông Bờ', 'Song Bo'),
('24064', 'WARD', '624', 'Ia RBol', 'Ia RBol'),
('24065', 'WARD', '624', 'Chư Băh', 'Chu Bah'),
('24070', 'WARD', '624', 'Ia RTô', 'Ia RTo'),
('24073', 'WARD', '624', 'Ia Sao', 'Ia Sao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 625 - KBang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23638', 'WARD', '625', 'Thị trấn KBang', 'Thi tran KBang'),
('23641', 'WARD', '625', 'Kon Pne', 'Kon Pne'),
('23644', 'WARD', '625', 'Đăk Roong', 'Dak Roong'),
('23647', 'WARD', '625', 'Sơn Lang', 'Son Lang'),
('23650', 'WARD', '625', 'KRong', 'KRong'),
('23653', 'WARD', '625', 'Sơ Pai', 'So Pai'),
('23656', 'WARD', '625', 'Lơ Ku', 'Lo Ku'),
('23659', 'WARD', '625', 'Đông', 'Dong'),
('23660', 'WARD', '625', 'Đak SMar', 'Dak SMar'),
('23662', 'WARD', '625', 'Nghĩa An', 'Nghia An'),
('23665', 'WARD', '625', 'Tơ Tung', 'To Tung'),
('23668', 'WARD', '625', 'Kông Lơng Khơng', 'Kong Long Khong'),
('23674', 'WARD', '625', 'Kông Bơ La', 'Kong Bo La')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 626 - Đăk Đoa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23677', 'WARD', '626', 'Thị trấn Đăk Đoa', 'Thi tran Dak Doa'),
('23680', 'WARD', '626', 'Hà Đông', 'Ha Dong'),
('23683', 'WARD', '626', 'Đăk Sơmei', 'Dak Somei'),
('23684', 'WARD', '626', 'Đăk Krong', 'Dak Krong'),
('23686', 'WARD', '626', 'Hải Yang', 'Hai Yang'),
('23689', 'WARD', '626', 'Kon Gang', 'Kon Gang'),
('23692', 'WARD', '626', 'Hà Bầu', 'Ha Bau'),
('23695', 'WARD', '626', 'Nam Yang', 'Nam Yang'),
('23698', 'WARD', '626', 'K'' Dang', 'K'' Dang'),
('23701', 'WARD', '626', 'H'' Neng', 'H'' Neng'),
('23704', 'WARD', '626', 'Tân Bình', 'Tan Binh'),
('23707', 'WARD', '626', 'Glar', 'Glar'),
('23710', 'WARD', '626', 'A Dơk', 'A Dok'),
('23713', 'WARD', '626', 'Trang', 'Trang'),
('23714', 'WARD', '626', 'HNol', 'HNol'),
('23716', 'WARD', '626', 'Ia Pết', 'Ia Pet'),
('23719', 'WARD', '626', 'Ia Băng', 'Ia Bang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 627 - Chư Păh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23722', 'WARD', '627', 'Thị trấn Phú Hòa', 'Thi tran Phu Hoa'),
('23725', 'WARD', '627', 'Hà Tây', 'Ha Tay'),
('23728', 'WARD', '627', 'Ia Khươl', 'Ia Khuol'),
('23731', 'WARD', '627', 'Ia Phí', 'Ia Phi'),
('23734', 'WARD', '627', 'Thị trấn Ia Ly', 'Thi tran Ia Ly'),
('23737', 'WARD', '627', 'Ia Mơ Nông', 'Ia Mo Nong'),
('23738', 'WARD', '627', 'Ia Kreng', 'Ia Kreng'),
('23740', 'WARD', '627', 'Đăk Tơ Ver', 'Dak To Ver'),
('23743', 'WARD', '627', 'Hòa Phú', 'Hoa Phu'),
('23746', 'WARD', '627', 'Chư Đăng Ya', 'Chu Dang Ya'),
('23749', 'WARD', '627', 'Ia Ka', 'Ia Ka'),
('23752', 'WARD', '627', 'Ia Nhin', 'Ia Nhin'),
('23755', 'WARD', '627', 'Nghĩa Hòa', 'Nghia Hoa'),
('23761', 'WARD', '627', 'Nghĩa Hưng', 'Nghia Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 628 - Ia Grai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23764', 'WARD', '628', 'Thị trấn Ia Kha', 'Thi tran Ia Kha'),
('23767', 'WARD', '628', 'Ia Sao', 'Ia Sao'),
('23768', 'WARD', '628', 'Ia Yok', 'Ia Yok'),
('23770', 'WARD', '628', 'Ia Hrung', 'Ia Hrung'),
('23771', 'WARD', '628', 'Ia Bă', 'Ia Ba'),
('23773', 'WARD', '628', 'Ia Khai', 'Ia Khai'),
('23776', 'WARD', '628', 'Ia KRai', 'Ia KRai'),
('23778', 'WARD', '628', 'Ia Grăng', 'Ia Grang'),
('23779', 'WARD', '628', 'Ia Tô', 'Ia To'),
('23782', 'WARD', '628', 'Ia O', 'Ia O'),
('23785', 'WARD', '628', 'Ia Dêr', 'Ia Der'),
('23788', 'WARD', '628', 'Ia Chia', 'Ia Chia'),
('23791', 'WARD', '628', 'Ia Pếch', 'Ia Pech')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 629 - Mang Yang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23794', 'WARD', '629', 'Thị trấn Kon Dơng', 'Thi tran Kon Dong'),
('23797', 'WARD', '629', 'Ayun', 'Ayun'),
('23798', 'WARD', '629', 'Đak Jơ Ta', 'Dak Jo Ta'),
('23799', 'WARD', '629', 'Đak Ta Ley', 'Dak Ta Ley'),
('23800', 'WARD', '629', 'Hra', 'Hra'),
('23803', 'WARD', '629', 'Đăk Yă', 'Dak Ya'),
('23806', 'WARD', '629', 'Đăk Djrăng', 'Dak Djrang'),
('23809', 'WARD', '629', 'Lơ Pang', 'Lo Pang'),
('23812', 'WARD', '629', 'Kon Thụp', 'Kon Thup'),
('23815', 'WARD', '629', 'Đê Ar', 'De Ar'),
('23818', 'WARD', '629', 'Kon Chiêng', 'Kon Chieng'),
('23821', 'WARD', '629', 'Đăk Trôi', 'Dak Troi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 630 - Kông Chro
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23824', 'WARD', '630', 'Thị trấn Kông Chro', 'Thi tran Kong Chro'),
('23827', 'WARD', '630', 'Chư Krêy', 'Chu Krey'),
('23830', 'WARD', '630', 'An Trung', 'An Trung'),
('23833', 'WARD', '630', 'Kông Yang', 'Kong Yang'),
('23836', 'WARD', '630', 'Đăk Tơ Pang', 'Dak To Pang'),
('23839', 'WARD', '630', 'SRó', 'SRo'),
('23840', 'WARD', '630', 'Đắk Kơ Ning', 'Dak Ko Ning'),
('23842', 'WARD', '630', 'Đăk Song', 'Dak Song'),
('23843', 'WARD', '630', 'Đăk Pling', 'Dak Pling'),
('23845', 'WARD', '630', 'Yang Trung', 'Yang Trung'),
('23846', 'WARD', '630', 'Đăk Pơ Pho', 'Dak Po Pho'),
('23848', 'WARD', '630', 'Ya Ma', 'Ya Ma'),
('23851', 'WARD', '630', 'Chơ Long', 'Cho Long'),
('23854', 'WARD', '630', 'Yang Nam', 'Yang Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 631 - Đức Cơ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23857', 'WARD', '631', 'Thị trấn Chư Ty', 'Thi tran Chu Ty'),
('23860', 'WARD', '631', 'Ia Dơk', 'Ia Dok'),
('23863', 'WARD', '631', 'Ia Krêl', 'Ia Krel'),
('23866', 'WARD', '631', 'Ia Din', 'Ia Din'),
('23869', 'WARD', '631', 'Ia Kla', 'Ia Kla'),
('23872', 'WARD', '631', 'Ia Dom', 'Ia Dom'),
('23875', 'WARD', '631', 'Ia Lang', 'Ia Lang'),
('23878', 'WARD', '631', 'Ia Kriêng', 'Ia Krieng'),
('23881', 'WARD', '631', 'Ia Pnôn', 'Ia Pnon'),
('23884', 'WARD', '631', 'Ia Nan', 'Ia Nan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 632 - Chư Prông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23887', 'WARD', '632', 'Thị trấn Chư Prông', 'Thi tran Chu Prong'),
('23888', 'WARD', '632', 'Ia Kly', 'Ia Kly'),
('23890', 'WARD', '632', 'Bình Giáo', 'Binh Giao'),
('23893', 'WARD', '632', 'Ia Drăng', 'Ia Drang'),
('23896', 'WARD', '632', 'Thăng Hưng', 'Thang Hung'),
('23899', 'WARD', '632', 'Bàu Cạn', 'Bau Can'),
('23902', 'WARD', '632', 'Ia Phìn', 'Ia Phin'),
('23905', 'WARD', '632', 'Ia Băng', 'Ia Bang'),
('23908', 'WARD', '632', 'Ia Tôr', 'Ia Tor'),
('23911', 'WARD', '632', 'Ia Boòng', 'Ia Boong'),
('23914', 'WARD', '632', 'Ia O', 'Ia O'),
('23917', 'WARD', '632', 'Ia Púch', 'Ia Puch'),
('23920', 'WARD', '632', 'Ia Me', 'Ia Me'),
('23923', 'WARD', '632', 'Ia Vê', 'Ia Ve'),
('23924', 'WARD', '632', 'Ia Bang', 'Ia Bang'),
('23926', 'WARD', '632', 'Ia Pia', 'Ia Pia'),
('23929', 'WARD', '632', 'Ia Ga', 'Ia Ga'),
('23932', 'WARD', '632', 'Ia Lâu', 'Ia Lau'),
('23935', 'WARD', '632', 'Ia Piơr', 'Ia Pior'),
('23938', 'WARD', '632', 'Ia Mơ', 'Ia Mo')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 633 - Chư Sê
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23941', 'WARD', '633', 'Thị trấn Chư Sê', 'Thi tran Chu Se'),
('23944', 'WARD', '633', 'Ia Tiêm', 'Ia Tiem'),
('23945', 'WARD', '633', 'Chư Pơng', 'Chu Pong'),
('23946', 'WARD', '633', 'Bar Măih', 'Bar Maih'),
('23947', 'WARD', '633', 'Bờ Ngoong', 'Bo Ngoong'),
('23950', 'WARD', '633', 'Ia Glai', 'Ia Glai'),
('23953', 'WARD', '633', 'AL Bá', 'AL Ba'),
('23954', 'WARD', '633', 'Kông HTok', 'Kong HTok'),
('23956', 'WARD', '633', 'AYun', 'AYun'),
('23959', 'WARD', '633', 'Ia HLốp', 'Ia HLop'),
('23962', 'WARD', '633', 'Ia Blang', 'Ia Blang'),
('23965', 'WARD', '633', 'Dun', 'Dun'),
('23966', 'WARD', '633', 'Ia Pal', 'Ia Pal'),
('23968', 'WARD', '633', 'H Bông', 'H Bong'),
('23977', 'WARD', '633', 'Ia Ko', 'Ia Ko')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 634 - Đăk Pơ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23989', 'WARD', '634', 'Hà Tam', 'Ha Tam'),
('23992', 'WARD', '634', 'An Thành', 'An Thanh'),
('23995', 'WARD', '634', 'Thị trấn Đak Pơ', 'Thi tran Dak Po'),
('23998', 'WARD', '634', 'Yang Bắc', 'Yang Bac'),
('24001', 'WARD', '634', 'Cư An', 'Cu An'),
('24004', 'WARD', '634', 'Tân An', 'Tan An'),
('24007', 'WARD', '634', 'Phú An', 'Phu An'),
('24010', 'WARD', '634', 'Ya Hội', 'Ya Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 635 - Ia Pa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24013', 'WARD', '635', 'Pờ Tó', 'Po To'),
('24016', 'WARD', '635', 'Chư Răng', 'Chu Rang'),
('24019', 'WARD', '635', 'Ia KDăm', 'Ia KDam'),
('24022', 'WARD', '635', 'Kim Tân', 'Kim Tan'),
('24025', 'WARD', '635', 'Chư Mố', 'Chu Mo'),
('24028', 'WARD', '635', 'Ia Tul', 'Ia Tul'),
('24031', 'WARD', '635', 'Ia Ma Rơn', 'Ia Ma Ron'),
('24034', 'WARD', '635', 'Ia Broăi', 'Ia Broai'),
('24037', 'WARD', '635', 'Ia Trok', 'Ia Trok')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 637 - Krông Pa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24076', 'WARD', '637', 'Thị trấn Phú Túc', 'Thi tran Phu Tuc'),
('24079', 'WARD', '637', 'Ia RSai', 'Ia RSai'),
('24082', 'WARD', '637', 'Ia RSươm', 'Ia RSuom'),
('24085', 'WARD', '637', 'Chư Gu', 'Chu Gu'),
('24088', 'WARD', '637', 'Đất Bằng', 'Dat Bang'),
('24091', 'WARD', '637', 'Ia Mláh', 'Ia Mlah'),
('24094', 'WARD', '637', 'Chư Drăng', 'Chu Drang'),
('24097', 'WARD', '637', 'Phú Cần', 'Phu Can'),
('24100', 'WARD', '637', 'Ia HDreh', 'Ia HDreh'),
('24103', 'WARD', '637', 'Ia RMok', 'Ia RMok'),
('24106', 'WARD', '637', 'Chư Ngọc', 'Chu Ngoc'),
('24109', 'WARD', '637', 'Uar', 'Uar'),
('24112', 'WARD', '637', 'Chư Rcăm', 'Chu Rcam'),
('24115', 'WARD', '637', 'Krông Năng', 'Krong Nang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 638 - Phú Thiện
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24043', 'WARD', '638', 'Thị trấn Phú Thiện', 'Thi tran Phu Thien'),
('24046', 'WARD', '638', 'Chư A Thai', 'Chu A Thai'),
('24048', 'WARD', '638', 'Ayun Hạ', 'Ayun Ha'),
('24049', 'WARD', '638', 'Ia Ake', 'Ia Ake'),
('24052', 'WARD', '638', 'Ia Sol', 'Ia Sol'),
('24055', 'WARD', '638', 'Ia Piar', 'Ia Piar'),
('24058', 'WARD', '638', 'Ia Peng', 'Ia Peng'),
('24060', 'WARD', '638', 'Chrôh Pơnan', 'Chroh Ponan'),
('24061', 'WARD', '638', 'Ia Hiao', 'Ia Hiao'),
('24067', 'WARD', '638', 'Ia Yeng', 'Ia Yeng')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 639 - Chư Pưh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('23942', 'WARD', '639', 'Thị trấn Nhơn Hoà', 'Thi tran Nhon Hoa'),
('23971', 'WARD', '639', 'Ia Hrú', 'Ia Hru'),
('23972', 'WARD', '639', 'Ia Rong', 'Ia Rong'),
('23974', 'WARD', '639', 'Ia Dreng', 'Ia Dreng'),
('23978', 'WARD', '639', 'Ia Hla', 'Ia Hla'),
('23980', 'WARD', '639', 'Chư Don', 'Chu Don'),
('23983', 'WARD', '639', 'Ia Phang', 'Ia Phang'),
('23986', 'WARD', '639', 'Ia Le', 'Ia Le'),
('23987', 'WARD', '639', 'Ia BLứ', 'Ia BLu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 66 - Đắk Lắk
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('643', 'DISTRICT', '66', 'Buôn Ma Thuột', 'Thanh pho Buon Ma Thuot'),
('644', 'DISTRICT', '66', 'Thị Buôn Hồ', 'Thi Buon Ho'),
('645', 'DISTRICT', '66', 'Ea H''leo', 'Ea H''leo'),
('646', 'DISTRICT', '66', 'Ea Súp', 'Ea Sup'),
('647', 'DISTRICT', '66', 'Buôn Đôn', 'Buon Don'),
('648', 'DISTRICT', '66', 'Cư M''gar', 'Cu M''gar'),
('649', 'DISTRICT', '66', 'Krông Búk', 'Krong Buk'),
('650', 'DISTRICT', '66', 'Krông Năng', 'Krong Nang'),
('651', 'DISTRICT', '66', 'Ea Kar', 'Ea Kar'),
('652', 'DISTRICT', '66', 'M''Đrắk', 'M''Drak'),
('653', 'DISTRICT', '66', 'Krông Bông', 'Krong Bong'),
('654', 'DISTRICT', '66', 'Krông Pắc', 'Krong Pac'),
('655', 'DISTRICT', '66', 'Krông A Na', 'Krong A Na'),
('656', 'DISTRICT', '66', 'Lắk', 'Lak'),
('657', 'DISTRICT', '66', 'Cư Kuin', 'Cu Kuin')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 643 - Buôn Ma Thuột
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24118', 'WARD', '643', 'Tân Lập', 'Tan Lap'),
('24121', 'WARD', '643', 'Tân Hòa', 'Tan Hoa'),
('24124', 'WARD', '643', 'Tân An', 'Tan An'),
('24130', 'WARD', '643', 'Thành Nhất', 'Thanh Nhat'),
('24133', 'WARD', '643', 'Thành Công', 'Thanh Cong'),
('24136', 'WARD', '643', 'Tân Lợi', 'Tan Loi'),
('24142', 'WARD', '643', 'Tân Thành', 'Tan Thanh'),
('24145', 'WARD', '643', 'Tân Tiến', 'Tan Tien'),
('24148', 'WARD', '643', 'Tự An', 'Tu An'),
('24151', 'WARD', '643', 'Ea Tam', 'Ea Tam'),
('24154', 'WARD', '643', 'Khánh Xuân', 'Khanh Xuan'),
('24157', 'WARD', '643', 'Hòa Thuận', 'Hoa Thuan'),
('24160', 'WARD', '643', 'Cư ÊBur', 'Cu EBur'),
('24163', 'WARD', '643', 'Ea Tu', 'Ea Tu'),
('24166', 'WARD', '643', 'Hòa Thắng', 'Hoa Thang'),
('24169', 'WARD', '643', 'Ea Kao', 'Ea Kao'),
('24172', 'WARD', '643', 'Hòa Phú', 'Hoa Phu'),
('24175', 'WARD', '643', 'Hòa Khánh', 'Hoa Khanh'),
('24178', 'WARD', '643', 'Hòa Xuân', 'Hoa Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 644 - Thị Buôn Hồ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24305', 'WARD', '644', 'An Lạc', 'An Lac'),
('24308', 'WARD', '644', 'An Bình', 'An Binh'),
('24311', 'WARD', '644', 'Thiện An', 'Thien An'),
('24318', 'WARD', '644', 'Đạt Hiếu', 'Dat Hieu'),
('24322', 'WARD', '644', 'Đoàn Kết', 'Doan Ket'),
('24328', 'WARD', '644', 'Ea Drông', 'Ea Drong'),
('24331', 'WARD', '644', 'Thống Nhất', 'Thong Nhat'),
('24332', 'WARD', '644', 'Bình Tân', 'Binh Tan'),
('24334', 'WARD', '644', 'Ea Siên', 'Ea Sien'),
('24337', 'WARD', '644', 'Bình Thuận', 'Binh Thuan'),
('24340', 'WARD', '644', 'Cư Bao', 'Cu Bao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 645 - Ea H''leo
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24181', 'WARD', '645', 'Thị trấn Ea Drăng', 'Thi tran Ea Drang'),
('24184', 'WARD', '645', 'Ea H''leo', 'Ea H''leo'),
('24187', 'WARD', '645', 'Ea Sol', 'Ea Sol'),
('24190', 'WARD', '645', 'Ea Ral', 'Ea Ral'),
('24193', 'WARD', '645', 'Ea Wy', 'Ea Wy'),
('24194', 'WARD', '645', 'Cư A Mung', 'Cu A Mung'),
('24196', 'WARD', '645', 'Cư Mốt', 'Cu Mot'),
('24199', 'WARD', '645', 'Ea Hiao', 'Ea Hiao'),
('24202', 'WARD', '645', 'Ea Khal', 'Ea Khal'),
('24205', 'WARD', '645', 'Dliê Yang', 'Dlie Yang'),
('24207', 'WARD', '645', 'Ea Tir', 'Ea Tir'),
('24208', 'WARD', '645', 'Ea Nam', 'Ea Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 646 - Ea Súp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24211', 'WARD', '646', 'Thị trấn Ea Súp', 'Thi tran Ea Sup'),
('24214', 'WARD', '646', 'Ia Lốp', 'Ia Lop'),
('24215', 'WARD', '646', 'Ia JLơi', 'Ia JLoi'),
('24217', 'WARD', '646', 'Ea Rốk', 'Ea Rok'),
('24220', 'WARD', '646', 'Ya Tờ Mốt', 'Ya To Mot'),
('24221', 'WARD', '646', 'Ia RVê', 'Ia RVe'),
('24223', 'WARD', '646', 'Ea Lê', 'Ea Le'),
('24226', 'WARD', '646', 'Cư KBang', 'Cu KBang'),
('24229', 'WARD', '646', 'Ea Bung', 'Ea Bung'),
('24232', 'WARD', '646', 'Cư M''Lan', 'Cu M''Lan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 647 - Buôn Đôn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24235', 'WARD', '647', 'Krông Na', 'Krong Na'),
('24238', 'WARD', '647', 'Ea Huar', 'Ea Huar'),
('24241', 'WARD', '647', 'Ea Wer', 'Ea Wer'),
('24244', 'WARD', '647', 'Tân Hoà', 'Tan Hoa'),
('24247', 'WARD', '647', 'Cuôr KNia', 'Cuor KNia'),
('24250', 'WARD', '647', 'Ea Bar', 'Ea Bar'),
('24253', 'WARD', '647', 'Ea Nuôl', 'Ea Nuol')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 648 - Cư M''gar
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24256', 'WARD', '648', 'Thị trấn Ea Pốk', 'Thi tran Ea Pok'),
('24259', 'WARD', '648', 'Thị trấn Quảng Phú', 'Thi tran Quang Phu'),
('24262', 'WARD', '648', 'Quảng Tiến', 'Quang Tien'),
('24264', 'WARD', '648', 'Ea Kuêh', 'Ea Kueh'),
('24265', 'WARD', '648', 'Ea Kiết', 'Ea Kiet'),
('24268', 'WARD', '648', 'Ea Tar', 'Ea Tar'),
('24271', 'WARD', '648', 'Cư Dliê M''nông', 'Cu Dlie M''nong'),
('24274', 'WARD', '648', 'Ea H''đinh', 'Ea H''dinh'),
('24277', 'WARD', '648', 'Ea Tul', 'Ea Tul'),
('24280', 'WARD', '648', 'Ea KPam', 'Ea KPam'),
('24283', 'WARD', '648', 'Ea M''DRóh', 'Ea M''DRoh'),
('24286', 'WARD', '648', 'Quảng Hiệp', 'Quang Hiep'),
('24289', 'WARD', '648', 'Cư M''gar', 'Cu M''gar'),
('24292', 'WARD', '648', 'Ea D''Rơng', 'Ea D''Rong'),
('24295', 'WARD', '648', 'Ea M''nang', 'Ea M''nang'),
('24298', 'WARD', '648', 'Cư Suê', 'Cu Sue'),
('24301', 'WARD', '648', 'Cuor Đăng', 'Cuor Dang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 649 - Krông Búk
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24307', 'WARD', '649', 'Cư Né', 'Cu Ne'),
('24310', 'WARD', '649', 'Chư KBô', 'Chu KBo'),
('24313', 'WARD', '649', 'Cư Pơng', 'Cu Pong'),
('24314', 'WARD', '649', 'Ea Sin', 'Ea Sin'),
('24316', 'WARD', '649', 'Thị trấn Pơng Drang', 'Thi tran Pong Drang'),
('24317', 'WARD', '649', 'Tân Lập', 'Tan Lap'),
('24319', 'WARD', '649', 'Ea Ngai', 'Ea Ngai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 650 - Krông Năng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24343', 'WARD', '650', 'Thị trấn Krông Năng', 'Thi tran Krong Nang'),
('24346', 'WARD', '650', 'ĐLiê Ya', 'DLie Ya'),
('24349', 'WARD', '650', 'Ea Tóh', 'Ea Toh'),
('24352', 'WARD', '650', 'Ea Tam', 'Ea Tam'),
('24355', 'WARD', '650', 'Phú Lộc', 'Phu Loc'),
('24358', 'WARD', '650', 'Tam Giang', 'Tam Giang'),
('24359', 'WARD', '650', 'Ea Puk', 'Ea Puk'),
('24360', 'WARD', '650', 'Ea Dăh', 'Ea Dah'),
('24361', 'WARD', '650', 'Ea Hồ', 'Ea Ho'),
('24364', 'WARD', '650', 'Phú Xuân', 'Phu Xuan'),
('24367', 'WARD', '650', 'Cư Klông', 'Cu Klong'),
('24370', 'WARD', '650', 'Ea Tân', 'Ea Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 651 - Ea Kar
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24373', 'WARD', '651', 'Thị trấn Ea Kar', 'Thi tran Ea Kar'),
('24376', 'WARD', '651', 'Thị trấn Ea Knốp', 'Thi tran Ea Knop'),
('24379', 'WARD', '651', 'Ea Sô', 'Ea So'),
('24380', 'WARD', '651', 'Ea Sar', 'Ea Sar'),
('24382', 'WARD', '651', 'Xuân Phú', 'Xuan Phu'),
('24385', 'WARD', '651', 'Cư Huê', 'Cu Hue'),
('24388', 'WARD', '651', 'Ea Tih', 'Ea Tih'),
('24391', 'WARD', '651', 'Ea Đar', 'Ea Dar'),
('24394', 'WARD', '651', 'Ea Kmút', 'Ea Kmut'),
('24397', 'WARD', '651', 'Cư Ni', 'Cu Ni'),
('24400', 'WARD', '651', 'Ea Păl', 'Ea Pal'),
('24401', 'WARD', '651', 'Cư Prông', 'Cu Prong'),
('24403', 'WARD', '651', 'Ea Ô', 'Ea O'),
('24404', 'WARD', '651', 'Cư ELang', 'Cu ELang'),
('24406', 'WARD', '651', 'Cư Bông', 'Cu Bong'),
('24409', 'WARD', '651', 'Cư Jang', 'Cu Jang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 652 - M''Đrắk
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24412', 'WARD', '652', 'Thị trấn M''Đrắk', 'Thi tran M''Drak'),
('24415', 'WARD', '652', 'Cư Prao', 'Cu Prao'),
('24418', 'WARD', '652', 'Ea Pil', 'Ea Pil'),
('24421', 'WARD', '652', 'Ea Lai', 'Ea Lai'),
('24424', 'WARD', '652', 'Ea H''MLay', 'Ea H''MLay'),
('24427', 'WARD', '652', 'Krông Jing', 'Krong Jing'),
('24430', 'WARD', '652', 'Ea M'' Doal', 'Ea M'' Doal'),
('24433', 'WARD', '652', 'Ea Riêng', 'Ea Rieng'),
('24436', 'WARD', '652', 'Cư M''ta', 'Cu M''ta'),
('24439', 'WARD', '652', 'Cư K Róa', 'Cu K Roa'),
('24442', 'WARD', '652', 'Krông Á', 'Krong A'),
('24444', 'WARD', '652', 'Cư San', 'Cu San'),
('24445', 'WARD', '652', 'Ea Trang', 'Ea Trang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 653 - Krông Bông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24448', 'WARD', '653', 'Thị trấn Krông Kmar', 'Thi tran Krong Kmar'),
('24451', 'WARD', '653', 'Dang Kang', 'Dang Kang'),
('24454', 'WARD', '653', 'Cư KTy', 'Cu KTy'),
('24457', 'WARD', '653', 'Hòa Thành', 'Hoa Thanh'),
('24463', 'WARD', '653', 'Hòa Phong', 'Hoa Phong'),
('24466', 'WARD', '653', 'Hòa Lễ', 'Hoa Le'),
('24469', 'WARD', '653', 'Yang Reh', 'Yang Reh'),
('24472', 'WARD', '653', 'Ea Trul', 'Ea Trul'),
('24475', 'WARD', '653', 'Khuê Ngọc Điền', 'Khue Ngoc Dien'),
('24478', 'WARD', '653', 'Cư Pui', 'Cu Pui'),
('24481', 'WARD', '653', 'Hòa Sơn', 'Hoa Son'),
('24484', 'WARD', '653', 'Cư Drăm', 'Cu Dram'),
('24487', 'WARD', '653', 'Yang Mao', 'Yang Mao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 654 - Krông Pắc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24490', 'WARD', '654', 'Thị trấn Phước An', 'Thi tran Phuoc An'),
('24493', 'WARD', '654', 'KRông Búk', 'KRong Buk'),
('24496', 'WARD', '654', 'Ea Kly', 'Ea Kly'),
('24499', 'WARD', '654', 'Ea Kênh', 'Ea Kenh'),
('24502', 'WARD', '654', 'Ea Phê', 'Ea Phe'),
('24505', 'WARD', '654', 'Ea KNuec', 'Ea KNuec'),
('24508', 'WARD', '654', 'Ea Yông', 'Ea Yong'),
('24511', 'WARD', '654', 'Hòa An', 'Hoa An'),
('24514', 'WARD', '654', 'Ea Kuăng', 'Ea Kuang'),
('24517', 'WARD', '654', 'Hòa Đông', 'Hoa Dong'),
('24520', 'WARD', '654', 'Ea Hiu', 'Ea Hiu'),
('24523', 'WARD', '654', 'Hòa Tiến', 'Hoa Tien'),
('24526', 'WARD', '654', 'Tân Tiến', 'Tan Tien'),
('24529', 'WARD', '654', 'Vụ Bổn', 'Vu Bon'),
('24532', 'WARD', '654', 'Ea Uy', 'Ea Uy'),
('24535', 'WARD', '654', 'Ea Yiêng', 'Ea Yieng')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 655 - Krông A Na
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24538', 'WARD', '655', 'Thị trấn Buôn Trấp', 'Thi tran Buon Trap'),
('24556', 'WARD', '655', 'Dray Sáp', 'Dray Sap'),
('24559', 'WARD', '655', 'Ea Na', 'Ea Na'),
('24565', 'WARD', '655', 'Ea Bông', 'Ea Bong'),
('24568', 'WARD', '655', 'Băng A Drênh', 'Bang A Drenh'),
('24571', 'WARD', '655', 'Dur KMăl', 'Dur KMal'),
('24574', 'WARD', '655', 'Bình Hòa', 'Binh Hoa'),
('24577', 'WARD', '655', 'Quảng Điền', 'Quang Dien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 656 - Lắk
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24580', 'WARD', '656', 'Thị trấn Liên Sơn', 'Thi tran Lien Son'),
('24583', 'WARD', '656', 'Yang Tao', 'Yang Tao'),
('24586', 'WARD', '656', 'Bông Krang', 'Bong Krang'),
('24589', 'WARD', '656', 'Đắk Liêng', 'Dak Lieng'),
('24592', 'WARD', '656', 'Buôn Triết', 'Buon Triet'),
('24595', 'WARD', '656', 'Buôn Tría', 'Buon Tria'),
('24598', 'WARD', '656', 'Đắk Phơi', 'Dak Phoi'),
('24601', 'WARD', '656', 'Đắk Nuê', 'Dak Nue'),
('24604', 'WARD', '656', 'Krông Nô', 'Krong No'),
('24607', 'WARD', '656', 'Nam Ka', 'Nam Ka'),
('24610', 'WARD', '656', 'Ea R''Bin', 'Ea R''Bin')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 657 - Cư Kuin
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24540', 'WARD', '657', 'Ea Ning', 'Ea Ning'),
('24541', 'WARD', '657', 'Cư Ê Wi', 'Cu E Wi'),
('24544', 'WARD', '657', 'Ea Ktur', 'Ea Ktur'),
('24547', 'WARD', '657', 'Ea Tiêu', 'Ea Tieu'),
('24550', 'WARD', '657', 'Ea BHốk', 'Ea BHok'),
('24553', 'WARD', '657', 'Ea Hu', 'Ea Hu'),
('24561', 'WARD', '657', 'Dray Bhăng', 'Dray Bhang'),
('24562', 'WARD', '657', 'Hòa Hiệp', 'Hoa Hiep')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 67 - Đắk Nông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('660', 'DISTRICT', '67', 'Gia Nghĩa', 'Thanh pho Gia Nghia'),
('661', 'DISTRICT', '67', 'Đăk Glong', 'Dak Glong'),
('662', 'DISTRICT', '67', 'Cư Jút', 'Cu Jut'),
('663', 'DISTRICT', '67', 'Đắk Mil', 'Dak Mil'),
('664', 'DISTRICT', '67', 'Krông Nô', 'Krong No'),
('665', 'DISTRICT', '67', 'Đắk Song', 'Dak Song'),
('666', 'DISTRICT', '67', 'Đắk R''Lấp', 'Dak R''Lap'),
('667', 'DISTRICT', '67', 'Tuy Đức', 'Tuy Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 660 - Gia Nghĩa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24611', 'WARD', '660', 'Nghĩa Đức', 'Nghia Duc'),
('24612', 'WARD', '660', 'Nghĩa Thành', 'Nghia Thanh'),
('24614', 'WARD', '660', 'Nghĩa Phú', 'Nghia Phu'),
('24615', 'WARD', '660', 'Nghĩa Tân', 'Nghia Tan'),
('24617', 'WARD', '660', 'Nghĩa Trung', 'Nghia Trung'),
('24618', 'WARD', '660', 'Đăk R''Moan', 'Dak R''Moan'),
('24619', 'WARD', '660', 'Quảng Thành', 'Quang Thanh'),
('24628', 'WARD', '660', 'Đắk Nia', 'Dak Nia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 661 - Đăk Glong
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24616', 'WARD', '661', 'Quảng Sơn', 'Quang Son'),
('24620', 'WARD', '661', 'Quảng Hoà', 'Quang Hoa'),
('24622', 'WARD', '661', 'Đắk Ha', 'Dak Ha'),
('24625', 'WARD', '661', 'Đắk R''Măng', 'Dak R''Mang'),
('24631', 'WARD', '661', 'Quảng Khê', 'Quang Khe'),
('24634', 'WARD', '661', 'Đắk Plao', 'Dak Plao'),
('24637', 'WARD', '661', 'Đắk Som', 'Dak Som')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 662 - Cư Jút
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24640', 'WARD', '662', 'Thị trấn Ea T''Ling', 'Thi tran Ea T''Ling'),
('24643', 'WARD', '662', 'Đắk Wil', 'Dak Wil'),
('24646', 'WARD', '662', 'Ea Pô', 'Ea Po'),
('24649', 'WARD', '662', 'Nam Dong', 'Nam Dong'),
('24652', 'WARD', '662', 'Đắk DRông', 'Dak DRong'),
('24655', 'WARD', '662', 'Tâm Thắng', 'Tam Thang'),
('24658', 'WARD', '662', 'Cư Knia', 'Cu Knia'),
('24661', 'WARD', '662', 'Trúc Sơn', 'Truc Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 663 - Đắk Mil
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24664', 'WARD', '663', 'Thị trấn Đắk Mil', 'Thi tran Dak Mil'),
('24667', 'WARD', '663', 'Đắk Lao', 'Dak Lao'),
('24670', 'WARD', '663', 'Đắk R''La', 'Dak R''La'),
('24673', 'WARD', '663', 'Đắk Gằn', 'Dak Gan'),
('24676', 'WARD', '663', 'Đức Mạnh', 'Duc Manh'),
('24677', 'WARD', '663', 'Đắk N''Drót', 'Dak N''Drot'),
('24678', 'WARD', '663', 'Long Sơn', 'Long Son'),
('24679', 'WARD', '663', 'Đắk Sắk', 'Dak Sak'),
('24682', 'WARD', '663', 'Thuận An', 'Thuan An'),
('24685', 'WARD', '663', 'Đức Minh', 'Duc Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 664 - Krông Nô
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24688', 'WARD', '664', 'Thị trấn Đắk Mâm', 'Thi tran Dak Mam'),
('24691', 'WARD', '664', 'Đắk Sôr', 'Dak Sor'),
('24692', 'WARD', '664', 'Nam Xuân', 'Nam Xuan'),
('24694', 'WARD', '664', 'Buôn Choah', 'Buon Choah'),
('24697', 'WARD', '664', 'Nam Đà', 'Nam Da'),
('24699', 'WARD', '664', 'Tân Thành', 'Tan Thanh'),
('24700', 'WARD', '664', 'Đắk Drô', 'Dak Dro'),
('24703', 'WARD', '664', 'Nâm Nung', 'Nam Nung'),
('24706', 'WARD', '664', 'Đức Xuyên', 'Duc Xuyen'),
('24709', 'WARD', '664', 'Đắk Nang', 'Dak Nang'),
('24712', 'WARD', '664', 'Quảng Phú', 'Quang Phu'),
('24715', 'WARD', '664', 'Nâm N''Đir', 'Nam N''Dir')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 665 - Đắk Song
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24717', 'WARD', '665', 'Thị trấn Đức An', 'Thi tran Duc An'),
('24718', 'WARD', '665', 'Đắk Môl', 'Dak Mol'),
('24719', 'WARD', '665', 'Đắk Hòa', 'Dak Hoa'),
('24721', 'WARD', '665', 'Nam Bình', 'Nam Binh'),
('24722', 'WARD', '665', 'Thuận Hà', 'Thuan Ha'),
('24724', 'WARD', '665', 'Thuận Hạnh', 'Thuan Hanh'),
('24727', 'WARD', '665', 'Đắk N''Dung', 'Dak N''Dung'),
('24728', 'WARD', '665', 'Nâm N''Jang', 'Nam N''Jang'),
('24730', 'WARD', '665', 'Trường Xuân', 'Truong Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 666 - Đắk R''Lấp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24733', 'WARD', '666', 'Thị trấn Kiến Đức', 'Thi tran Kien Duc'),
('24745', 'WARD', '666', 'Quảng Tín', 'Quang Tin'),
('24750', 'WARD', '666', 'Đắk Wer', 'Dak Wer'),
('24751', 'WARD', '666', 'Nhân Cơ', 'Nhan Co'),
('24754', 'WARD', '666', 'Kiến Thành', 'Kien Thanh'),
('24756', 'WARD', '666', 'Nghĩa Thắng', 'Nghia Thang'),
('24757', 'WARD', '666', 'Đạo Nghĩa', 'Dao Nghia'),
('24760', 'WARD', '666', 'Đắk Sin', 'Dak Sin'),
('24761', 'WARD', '666', 'Hưng Bình', 'Hung Binh'),
('24763', 'WARD', '666', 'Đắk Ru', 'Dak Ru'),
('24766', 'WARD', '666', 'Nhân Đạo', 'Nhan Dao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 667 - Tuy Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24736', 'WARD', '667', 'Quảng Trực', 'Quang Truc'),
('24739', 'WARD', '667', 'Đắk Búk So', 'Dak Buk So'),
('24740', 'WARD', '667', 'Quảng Tâm', 'Quang Tam'),
('24742', 'WARD', '667', 'Đắk R''Tíh', 'Dak R''Tih'),
('24746', 'WARD', '667', 'Đắk Ngo', 'Dak Ngo'),
('24748', 'WARD', '667', 'Quảng Tân', 'Quang Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 68 - Lâm Đồng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('672', 'DISTRICT', '68', 'Đà Lạt', 'Thanh pho Da Lat'),
('673', 'DISTRICT', '68', 'Bảo Lộc', 'Thanh pho Bao Loc'),
('674', 'DISTRICT', '68', 'Đam Rông', 'Dam Rong'),
('675', 'DISTRICT', '68', 'Lạc Dương', 'Lac Duong'),
('676', 'DISTRICT', '68', 'Lâm Hà', 'Lam Ha'),
('677', 'DISTRICT', '68', 'Đơn Dương', 'Don Duong'),
('678', 'DISTRICT', '68', 'Đức Trọng', 'Duc Trong'),
('679', 'DISTRICT', '68', 'Di Linh', 'Di Linh'),
('680', 'DISTRICT', '68', 'Bảo Lâm', 'Bao Lam'),
('682', 'DISTRICT', '68', 'Đạ Huoai', 'Da Huoai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 672 - Đà Lạt
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24769', 'WARD', '672', 'Phường 7', 'Ward 7'),
('24772', 'WARD', '672', 'Phường 8', 'Ward 8'),
('24775', 'WARD', '672', 'Phường 12', 'Ward 12'),
('24778', 'WARD', '672', 'Phường 9', 'Ward 9'),
('24781', 'WARD', '672', 'Phường 2', 'Ward 2'),
('24784', 'WARD', '672', 'Phường 1', 'Ward 1'),
('24787', 'WARD', '672', 'Phường 6', 'Ward 6'),
('24790', 'WARD', '672', 'Phường 5', 'Ward 5'),
('24793', 'WARD', '672', 'Phường 4', 'Ward 4'),
('24796', 'WARD', '672', 'Phường 10', 'Ward 10'),
('24799', 'WARD', '672', 'Phường 11', 'Ward 11'),
('24802', 'WARD', '672', 'Phường 3', 'Ward 3'),
('24805', 'WARD', '672', 'Xuân Thọ', 'Xuan Tho'),
('24808', 'WARD', '672', 'Tà Nung', 'Ta Nung'),
('24810', 'WARD', '672', 'Trạm Hành', 'Tram Hanh'),
('24811', 'WARD', '672', 'Xuân Trường', 'Xuan Truong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 673 - Bảo Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24814', 'WARD', '673', 'Lộc Phát', 'Loc Phat'),
('24817', 'WARD', '673', 'Lộc Tiến', 'Loc Tien'),
('24820', 'WARD', '673', 'Phường 2', 'Ward 2'),
('24823', 'WARD', '673', 'Phường 1', 'Ward 1'),
('24826', 'WARD', '673', 'B''lao', 'B''lao'),
('24829', 'WARD', '673', 'Lộc Sơn', 'Loc Son'),
('24832', 'WARD', '673', 'Đạm Bri', 'Dam Bri'),
('24835', 'WARD', '673', 'Lộc Thanh', 'Loc Thanh'),
('24838', 'WARD', '673', 'Lộc Nga', 'Loc Nga'),
('24841', 'WARD', '673', 'Lộc Châu', 'Loc Chau'),
('24844', 'WARD', '673', 'Đại Lào', 'Dai Lao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 674 - Đam Rông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24853', 'WARD', '674', 'Đạ Tông', 'Da Tong'),
('24856', 'WARD', '674', 'Đạ Long', 'Da Long'),
('24859', 'WARD', '674', 'Đạ M'' Rong', 'Da M'' Rong'),
('24874', 'WARD', '674', 'Liêng Srônh', 'Lieng Sronh'),
('24875', 'WARD', '674', 'Đạ Rsal', 'Da Rsal'),
('24877', 'WARD', '674', 'Rô Men', 'Ro Men'),
('24886', 'WARD', '674', 'Phi Liêng', 'Phi Lieng'),
('24889', 'WARD', '674', 'Đạ K'' Nàng', 'Da K'' Nang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 675 - Lạc Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24846', 'WARD', '675', 'Thị trấn Lạc Dương', 'Thi tran Lac Duong'),
('24847', 'WARD', '675', 'Đạ Chais', 'Da Chais'),
('24848', 'WARD', '675', 'Đạ Nhim', 'Da Nhim'),
('24850', 'WARD', '675', 'Đưng KNớ', 'Dung KNo'),
('24862', 'WARD', '675', 'Lát', 'Lat'),
('24865', 'WARD', '675', 'Đạ Sar', 'Da Sar')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 676 - Lâm Hà
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24868', 'WARD', '676', 'Thị trấn Nam Ban', 'Thi tran Nam Ban'),
('24871', 'WARD', '676', 'Thị trấn Đinh Văn', 'Thi tran Dinh Van'),
('24880', 'WARD', '676', 'Phú Sơn', 'Phu Son'),
('24883', 'WARD', '676', 'Phi Tô', 'Phi To'),
('24892', 'WARD', '676', 'Mê Linh', 'Me Linh'),
('24895', 'WARD', '676', 'Đạ Đờn', 'Da Don'),
('24898', 'WARD', '676', 'Phúc Thọ', 'Phuc Tho'),
('24901', 'WARD', '676', 'Đông Thanh', 'Dong Thanh'),
('24904', 'WARD', '676', 'Gia Lâm', 'Gia Lam'),
('24907', 'WARD', '676', 'Tân Thanh', 'Tan Thanh'),
('24910', 'WARD', '676', 'Tân Văn', 'Tan Van'),
('24913', 'WARD', '676', 'Hoài Đức', 'Hoai Duc'),
('24916', 'WARD', '676', 'Tân Hà', 'Tan Ha'),
('24919', 'WARD', '676', 'Liên Hà', 'Lien Ha'),
('24922', 'WARD', '676', 'Đan Phượng', 'Dan Phuong'),
('24925', 'WARD', '676', 'Nam Hà', 'Nam Ha')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 677 - Đơn Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24928', 'WARD', '677', 'Thị trấn D''Ran', 'Thi tran D''Ran'),
('24931', 'WARD', '677', 'Thị trấn Thạnh Mỹ', 'Thi tran Thanh My'),
('24934', 'WARD', '677', 'Lạc Xuân', 'Lac Xuan'),
('24937', 'WARD', '677', 'Đạ Ròn', 'Da Ron'),
('24940', 'WARD', '677', 'Lạc Lâm', 'Lac Lam'),
('24943', 'WARD', '677', 'Ka Đô', 'Ka Do'),
('24949', 'WARD', '677', 'Ka Đơn', 'Ka Don'),
('24952', 'WARD', '677', 'Tu Tra', 'Tu Tra'),
('24955', 'WARD', '677', 'Quảng Lập', 'Quang Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 678 - Đức Trọng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('24958', 'WARD', '678', 'Thị trấn Liên Nghĩa', 'Thi tran Lien Nghia'),
('24961', 'WARD', '678', 'Hiệp An', 'Hiep An'),
('24964', 'WARD', '678', 'Liên Hiệp', 'Lien Hiep'),
('24967', 'WARD', '678', 'Hiệp Thạnh', 'Hiep Thanh'),
('24970', 'WARD', '678', 'Bình Thạnh', 'Binh Thanh'),
('24973', 'WARD', '678', 'N''Thol Hạ', 'N''Thol Ha'),
('24976', 'WARD', '678', 'Tân Hội', 'Tan Hoi'),
('24979', 'WARD', '678', 'Tân Thành', 'Tan Thanh'),
('24982', 'WARD', '678', 'Phú Hội', 'Phu Hoi'),
('24985', 'WARD', '678', 'Ninh Gia', 'Ninh Gia'),
('24988', 'WARD', '678', 'Tà Năng', 'Ta Nang'),
('24989', 'WARD', '678', 'Đa Quyn', 'Da Quyn'),
('24991', 'WARD', '678', 'Tà Hine', 'Ta Hine'),
('24994', 'WARD', '678', 'Đà Loan', 'Da Loan'),
('24997', 'WARD', '678', 'Ninh Loan', 'Ninh Loan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 679 - Di Linh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25000', 'WARD', '679', 'Thị trấn Di Linh', 'Thi tran Di Linh'),
('25003', 'WARD', '679', 'Đinh Trang Thượng', 'Dinh Trang Thuong'),
('25006', 'WARD', '679', 'Tân Thượng', 'Tan Thuong'),
('25007', 'WARD', '679', 'Tân Lâm', 'Tan Lam'),
('25009', 'WARD', '679', 'Tân Châu', 'Tan Chau'),
('25012', 'WARD', '679', 'Tân Nghĩa', 'Tan Nghia'),
('25015', 'WARD', '679', 'Gia Hiệp', 'Gia Hiep'),
('25018', 'WARD', '679', 'Đinh Lạc', 'Dinh Lac'),
('25021', 'WARD', '679', 'Tam Bố', 'Tam Bo'),
('25024', 'WARD', '679', 'Đinh Trang Hòa', 'Dinh Trang Hoa'),
('25027', 'WARD', '679', 'Liên Đầm', 'Lien Dam'),
('25030', 'WARD', '679', 'Gung Ré', 'Gung Re'),
('25033', 'WARD', '679', 'Bảo Thuận', 'Bao Thuan'),
('25036', 'WARD', '679', 'Hòa Ninh', 'Hoa Ninh'),
('25039', 'WARD', '679', 'Hòa Trung', 'Hoa Trung'),
('25042', 'WARD', '679', 'Hòa Nam', 'Hoa Nam'),
('25045', 'WARD', '679', 'Hòa Bắc', 'Hoa Bac'),
('25048', 'WARD', '679', 'Sơn Điền', 'Son Dien'),
('25051', 'WARD', '679', 'Gia Bắc', 'Gia Bac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 680 - Bảo Lâm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25054', 'WARD', '680', 'Thị trấn Lộc Thắng', 'Thi tran Loc Thang'),
('25057', 'WARD', '680', 'Lộc Bảo', 'Loc Bao'),
('25060', 'WARD', '680', 'Lộc Lâm', 'Loc Lam'),
('25063', 'WARD', '680', 'Lộc Phú', 'Loc Phu'),
('25066', 'WARD', '680', 'Lộc Bắc', 'Loc Bac'),
('25069', 'WARD', '680', 'B'' Lá', 'B'' La'),
('25072', 'WARD', '680', 'Lộc Ngãi', 'Loc Ngai'),
('25075', 'WARD', '680', 'Lộc Quảng', 'Loc Quang'),
('25078', 'WARD', '680', 'Lộc Tân', 'Loc Tan'),
('25081', 'WARD', '680', 'Lộc Đức', 'Loc Duc'),
('25084', 'WARD', '680', 'Lộc An', 'Loc An'),
('25087', 'WARD', '680', 'Tân Lạc', 'Tan Lac'),
('25090', 'WARD', '680', 'Lộc Thành', 'Loc Thanh'),
('25093', 'WARD', '680', 'Lộc Nam', 'Loc Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 682 - Đạ Huoai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25096', 'WARD', '682', 'Thị trấn Đạ M''ri', 'Thi tran Da M''ri'),
('25099', 'WARD', '682', 'Thị trấn Ma Đa Guôi', 'Thi tran Ma Da Guoi'),
('25102', 'WARD', '682', 'Đạ M''ri', 'Da M''ri'),
('25105', 'WARD', '682', 'Hà Lâm', 'Ha Lam'),
('25111', 'WARD', '682', 'Đạ Oai', 'Da Oai'),
('25114', 'WARD', '682', 'Bà Gia', 'Ba Gia'),
('25117', 'WARD', '682', 'Ma Đa Guôi', 'Ma Da Guoi'),
('25126', 'WARD', '682', 'Thị trấn Đạ Tẻh', 'Thi tran Da Teh'),
('25129', 'WARD', '682', 'An Nhơn', 'An Nhon'),
('25132', 'WARD', '682', 'Quốc Oai', 'Quoc Oai'),
('25135', 'WARD', '682', 'Mỹ Đức', 'My Duc'),
('25138', 'WARD', '682', 'Quảng Trị', 'Quang Tri'),
('25141', 'WARD', '682', 'Đạ Lây', 'Da Lay'),
('25153', 'WARD', '682', 'Đạ Kho', 'Da Kho'),
('25156', 'WARD', '682', 'Đạ Pal', 'Da Pal'),
('25159', 'WARD', '682', 'Thị trấn Cát Tiên', 'Thi tran Cat Tien'),
('25162', 'WARD', '682', 'Tiên Hoàng', 'Tien Hoang'),
('25165', 'WARD', '682', 'Phước Cát 2', 'Phuoc Cat 2'),
('25168', 'WARD', '682', 'Gia Viễn', 'Gia Vien'),
('25171', 'WARD', '682', 'Nam Ninh', 'Nam Ninh'),
('25174', 'WARD', '682', 'Mỹ Lâm', 'My Lam'),
('25177', 'WARD', '682', 'Tư Nghĩa', 'Tu Nghia'),
('25180', 'WARD', '682', 'Thị trấn Phước Cát', 'Thi tran Phuoc Cat'),
('25183', 'WARD', '682', 'Đức Phổ', 'Duc Pho'),
('25186', 'WARD', '682', 'Phù Mỹ', 'Phu My'),
('25189', 'WARD', '682', 'Quảng Ngãi', 'Quang Ngai'),
('25192', 'WARD', '682', 'Đồng Nai Thượng', 'Dong Nai Thuong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 70 - Bình Phước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('688', 'DISTRICT', '70', 'Thị Phước Long', 'Thi Phuoc Long'),
('689', 'DISTRICT', '70', 'Đồng Xoài', 'Thanh pho Dong Xoai'),
('690', 'DISTRICT', '70', 'Thị Bình Long', 'Thi Binh Long'),
('691', 'DISTRICT', '70', 'Bù Gia Mập', 'Bu Gia Map'),
('692', 'DISTRICT', '70', 'Lộc Ninh', 'Loc Ninh'),
('693', 'DISTRICT', '70', 'Bù Đốp', 'Bu Dop'),
('694', 'DISTRICT', '70', 'Hớn Quản', 'Hon Quan'),
('695', 'DISTRICT', '70', 'Đồng Phú', 'Dong Phu'),
('696', 'DISTRICT', '70', 'Bù Đăng', 'Bu Dang'),
('697', 'DISTRICT', '70', 'Thị Chơn Thành', 'Thi Chon Thanh'),
('698', 'DISTRICT', '70', 'Phú Riềng', 'Phu Rieng')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 688 - Thị Phước Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25216', 'WARD', '688', 'Thác Mơ', 'Thac Mo'),
('25217', 'WARD', '688', 'Long Thủy', 'Long Thuy'),
('25219', 'WARD', '688', 'Phước Bình', 'Phuoc Binh'),
('25220', 'WARD', '688', 'Long Phước', 'Long Phuoc'),
('25237', 'WARD', '688', 'Sơn Giang', 'Son Giang'),
('25245', 'WARD', '688', 'Long Giang', 'Long Giang'),
('25249', 'WARD', '688', 'Phước Tín', 'Phuoc Tin')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 689 - Đồng Xoài
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25195', 'WARD', '689', 'Tân Phú', 'Tan Phu'),
('25198', 'WARD', '689', 'Tân Đồng', 'Tan Dong'),
('25201', 'WARD', '689', 'Tân Bình', 'Tan Binh'),
('25204', 'WARD', '689', 'Tân Xuân', 'Tan Xuan'),
('25205', 'WARD', '689', 'Tân Thiện', 'Tan Thien'),
('25207', 'WARD', '689', 'Tân Thành', 'Tan Thanh'),
('25210', 'WARD', '689', 'Tiến Thành', 'Tien Thanh'),
('25213', 'WARD', '689', 'Tiến Hưng', 'Tien Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 690 - Thị Bình Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25320', 'WARD', '690', 'Hưng Chiến', 'Hung Chien'),
('25324', 'WARD', '690', 'An Lộc', 'An Loc'),
('25325', 'WARD', '690', 'Phú Thịnh', 'Phu Thinh'),
('25326', 'WARD', '690', 'Phú Đức', 'Phu Duc'),
('25333', 'WARD', '690', 'Thanh Lương', 'Thanh Luong'),
('25336', 'WARD', '690', 'Thanh Phú', 'Thanh Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 691 - Bù Gia Mập
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25222', 'WARD', '691', 'Bù Gia Mập', 'Bu Gia Map'),
('25225', 'WARD', '691', 'Đak Ơ', 'Dak O'),
('25228', 'WARD', '691', 'Đức Hạnh', 'Duc Hanh'),
('25229', 'WARD', '691', 'Phú Văn', 'Phu Van'),
('25231', 'WARD', '691', 'Đa Kia', 'Da Kia'),
('25232', 'WARD', '691', 'Phước Minh', 'Phuoc Minh'),
('25234', 'WARD', '691', 'Bình Thắng', 'Binh Thang'),
('25267', 'WARD', '691', 'Phú Nghĩa', 'Phu Nghia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 692 - Lộc Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25270', 'WARD', '692', 'Thị trấn Lộc Ninh', 'Thi tran Loc Ninh'),
('25273', 'WARD', '692', 'Lộc Hòa', 'Loc Hoa'),
('25276', 'WARD', '692', 'Lộc An', 'Loc An'),
('25279', 'WARD', '692', 'Lộc Tấn', 'Loc Tan'),
('25280', 'WARD', '692', 'Lộc Thạnh', 'Loc Thanh'),
('25282', 'WARD', '692', 'Lộc Hiệp', 'Loc Hiep'),
('25285', 'WARD', '692', 'Lộc Thiện', 'Loc Thien'),
('25288', 'WARD', '692', 'Lộc Thuận', 'Loc Thuan'),
('25291', 'WARD', '692', 'Lộc Quang', 'Loc Quang'),
('25292', 'WARD', '692', 'Lộc Phú', 'Loc Phu'),
('25294', 'WARD', '692', 'Lộc Thành', 'Loc Thanh'),
('25297', 'WARD', '692', 'Lộc Thái', 'Loc Thai'),
('25300', 'WARD', '692', 'Lộc Điền', 'Loc Dien'),
('25303', 'WARD', '692', 'Lộc Hưng', 'Loc Hung'),
('25305', 'WARD', '692', 'Lộc Thịnh', 'Loc Thinh'),
('25306', 'WARD', '692', 'Lộc Khánh', 'Loc Khanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 693 - Bù Đốp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25308', 'WARD', '693', 'Thị trấn Thanh Bình', 'Thi tran Thanh Binh'),
('25309', 'WARD', '693', 'Hưng Phước', 'Hung Phuoc'),
('25310', 'WARD', '693', 'Phước Thiện', 'Phuoc Thien'),
('25312', 'WARD', '693', 'Thiện Hưng', 'Thien Hung'),
('25315', 'WARD', '693', 'Thanh Hòa', 'Thanh Hoa'),
('25318', 'WARD', '693', 'Tân Thành', 'Tan Thanh'),
('25321', 'WARD', '693', 'Tân Tiến', 'Tan Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 694 - Hớn Quản
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25327', 'WARD', '694', 'Thanh An', 'Thanh An'),
('25330', 'WARD', '694', 'An Khương', 'An Khuong'),
('25339', 'WARD', '694', 'An Phú', 'An Phu'),
('25342', 'WARD', '694', 'Tân Lợi', 'Tan Loi'),
('25345', 'WARD', '694', 'Tân Hưng', 'Tan Hung'),
('25348', 'WARD', '694', 'Minh Đức', 'Minh Duc'),
('25349', 'WARD', '694', 'Minh Tâm', 'Minh Tam'),
('25351', 'WARD', '694', 'Phước An', 'Phuoc An'),
('25354', 'WARD', '694', 'Thanh Bình', 'Thanh Binh'),
('25357', 'WARD', '694', 'Thị trấn Tân Khai', 'Thi tran Tan Khai'),
('25360', 'WARD', '694', 'Đồng Nơ', 'Dong No'),
('25361', 'WARD', '694', 'Tân Hiệp', 'Tan Hiep'),
('25438', 'WARD', '694', 'Tân Quan', 'Tan Quan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 695 - Đồng Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25363', 'WARD', '695', 'Thị trấn Tân Phú', 'Thi tran Tan Phu'),
('25366', 'WARD', '695', 'Thuận Lợi', 'Thuan Loi'),
('25369', 'WARD', '695', 'Đồng Tâm', 'Dong Tam'),
('25372', 'WARD', '695', 'Tân Phước', 'Tan Phuoc'),
('25375', 'WARD', '695', 'Tân Hưng', 'Tan Hung'),
('25378', 'WARD', '695', 'Tân Lợi', 'Tan Loi'),
('25381', 'WARD', '695', 'Tân Lập', 'Tan Lap'),
('25384', 'WARD', '695', 'Tân Hòa', 'Tan Hoa'),
('25387', 'WARD', '695', 'Thuận Phú', 'Thuan Phu'),
('25390', 'WARD', '695', 'Đồng Tiến', 'Dong Tien'),
('25393', 'WARD', '695', 'Tân Tiến', 'Tan Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 696 - Bù Đăng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25396', 'WARD', '696', 'Thị trấn Đức Phong', 'Thi tran Duc Phong'),
('25398', 'WARD', '696', 'Đường 10', 'Duong 10'),
('25399', 'WARD', '696', 'Đak Nhau', 'Dak Nhau'),
('25400', 'WARD', '696', 'Phú Sơn', 'Phu Son'),
('25402', 'WARD', '696', 'Thọ Sơn', 'Tho Son'),
('25404', 'WARD', '696', 'Bình Minh', 'Binh Minh'),
('25405', 'WARD', '696', 'Bom Bo', 'Bom Bo'),
('25408', 'WARD', '696', 'Minh Hưng', 'Minh Hung'),
('25411', 'WARD', '696', 'Đoàn Kết', 'Doan Ket'),
('25414', 'WARD', '696', 'Đồng Nai', 'Dong Nai'),
('25417', 'WARD', '696', 'Đức Liễu', 'Duc Lieu'),
('25420', 'WARD', '696', 'Thống Nhất', 'Thong Nhat'),
('25423', 'WARD', '696', 'Nghĩa Trung', 'Nghia Trung'),
('25424', 'WARD', '696', 'Nghĩa Bình', 'Nghia Binh'),
('25426', 'WARD', '696', 'Đăng Hà', 'Dang Ha'),
('25429', 'WARD', '696', 'Phước Sơn', 'Phuoc Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 697 - Thị Chơn Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25432', 'WARD', '697', 'Hưng Long', 'Hung Long'),
('25433', 'WARD', '697', 'Thành Tâm', 'Thanh Tam'),
('25435', 'WARD', '697', 'Minh Lập', 'Minh Lap'),
('25439', 'WARD', '697', 'Quang Minh', 'Quang Minh'),
('25441', 'WARD', '697', 'Minh Hưng', 'Minh Hung'),
('25444', 'WARD', '697', 'Minh Long', 'Minh Long'),
('25447', 'WARD', '697', 'Minh Thành', 'Minh Thanh'),
('25450', 'WARD', '697', 'Nha Bích', 'Nha Bich'),
('25453', 'WARD', '697', 'Minh Thắng', 'Minh Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 698 - Phú Riềng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25240', 'WARD', '698', 'Long Bình', 'Long Binh'),
('25243', 'WARD', '698', 'Bình Tân', 'Binh Tan'),
('25244', 'WARD', '698', 'Bình Sơn', 'Binh Son'),
('25246', 'WARD', '698', 'Long Hưng', 'Long Hung'),
('25250', 'WARD', '698', 'Phước Tân', 'Phuoc Tan'),
('25252', 'WARD', '698', 'Bù Nho', 'Bu Nho'),
('25255', 'WARD', '698', 'Long Hà', 'Long Ha'),
('25258', 'WARD', '698', 'Long Tân', 'Long Tan'),
('25261', 'WARD', '698', 'Phú Trung', 'Phu Trung'),
('25264', 'WARD', '698', 'Phú Riềng', 'Phu Rieng')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 72 - Tây Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('703', 'DISTRICT', '72', 'Tây Ninh', 'Thanh pho Tay Ninh'),
('705', 'DISTRICT', '72', 'Tân Biên', 'Tan Bien'),
('706', 'DISTRICT', '72', 'Tân Châu', 'Tan Chau'),
('707', 'DISTRICT', '72', 'Dương Minh Châu', 'Duong Minh Chau'),
('708', 'DISTRICT', '72', 'Châu Thành', 'Chau Thanh'),
('709', 'DISTRICT', '72', 'Thị Hòa Thành', 'Thi Hoa Thanh'),
('710', 'DISTRICT', '72', 'Gò Dầu', 'Go Dau'),
('711', 'DISTRICT', '72', 'Bến Cầu', 'Ben Cau'),
('712', 'DISTRICT', '72', 'Thị Trảng Bàng', 'Thi Trang Bang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 703 - Tây Ninh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25456', 'WARD', '703', 'Phường 1', 'Ward 1'),
('25459', 'WARD', '703', 'Phường 3', 'Ward 3'),
('25462', 'WARD', '703', 'Phường 4', 'Ward 4'),
('25465', 'WARD', '703', 'Hiệp Ninh', 'Hiep Ninh'),
('25468', 'WARD', '703', 'Phường 2', 'Ward 2'),
('25471', 'WARD', '703', 'Thạnh Tân', 'Thanh Tan'),
('25474', 'WARD', '703', 'Tân Bình', 'Tan Binh'),
('25477', 'WARD', '703', 'Bình Minh', 'Binh Minh'),
('25480', 'WARD', '703', 'Ninh Sơn', 'Ninh Son'),
('25483', 'WARD', '703', 'Ninh Thạnh', 'Ninh Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 705 - Tân Biên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25486', 'WARD', '705', 'Thị trấn Tân Biên', 'Thi tran Tan Bien'),
('25489', 'WARD', '705', 'Tân Lập', 'Tan Lap'),
('25492', 'WARD', '705', 'Thạnh Bắc', 'Thanh Bac'),
('25495', 'WARD', '705', 'Tân Bình', 'Tan Binh'),
('25498', 'WARD', '705', 'Thạnh Bình', 'Thanh Binh'),
('25501', 'WARD', '705', 'Thạnh Tây', 'Thanh Tay'),
('25504', 'WARD', '705', 'Hòa Hiệp', 'Hoa Hiep'),
('25507', 'WARD', '705', 'Tân Phong', 'Tan Phong'),
('25510', 'WARD', '705', 'Mỏ Công', 'Mo Cong'),
('25513', 'WARD', '705', 'Trà Vong', 'Tra Vong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 706 - Tân Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25516', 'WARD', '706', 'Thị trấn Tân Châu', 'Thi tran Tan Chau'),
('25519', 'WARD', '706', 'Tân Hà', 'Tan Ha'),
('25522', 'WARD', '706', 'Tân Đông', 'Tan Dong'),
('25525', 'WARD', '706', 'Tân Hội', 'Tan Hoi'),
('25528', 'WARD', '706', 'Tân Hòa', 'Tan Hoa'),
('25531', 'WARD', '706', 'Suối Ngô', 'Suoi Ngo'),
('25534', 'WARD', '706', 'Suối Dây', 'Suoi Day'),
('25537', 'WARD', '706', 'Tân Hiệp', 'Tan Hiep'),
('25540', 'WARD', '706', 'Thạnh Đông', 'Thanh Dong'),
('25543', 'WARD', '706', 'Tân Thành', 'Tan Thanh'),
('25546', 'WARD', '706', 'Tân Phú', 'Tan Phu'),
('25549', 'WARD', '706', 'Tân Hưng', 'Tan Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 707 - Dương Minh Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25552', 'WARD', '707', 'Thị trấn Dương Minh Châu', 'Thi tran Duong Minh Chau'),
('25555', 'WARD', '707', 'Suối Đá', 'Suoi Da'),
('25558', 'WARD', '707', 'Phan', 'Phan'),
('25561', 'WARD', '707', 'Phước Ninh', 'Phuoc Ninh'),
('25564', 'WARD', '707', 'Phước Minh', 'Phuoc Minh'),
('25567', 'WARD', '707', 'Bàu Năng', 'Bau Nang'),
('25570', 'WARD', '707', 'Chà Là', 'Cha La'),
('25573', 'WARD', '707', 'Cầu Khởi', 'Cau Khoi'),
('25576', 'WARD', '707', 'Bến Củi', 'Ben Cui'),
('25579', 'WARD', '707', 'Lộc Ninh', 'Loc Ninh'),
('25582', 'WARD', '707', 'Truông Mít', 'Truong Mit')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 708 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25585', 'WARD', '708', 'Thị trấn Châu Thành', 'Thi tran Chau Thanh'),
('25588', 'WARD', '708', 'Hảo Đước', 'Hao Duoc'),
('25591', 'WARD', '708', 'Phước Vinh', 'Phuoc Vinh'),
('25594', 'WARD', '708', 'Đồng Khởi', 'Dong Khoi'),
('25597', 'WARD', '708', 'Thái Bình', 'Thai Binh'),
('25600', 'WARD', '708', 'An Cơ', 'An Co'),
('25603', 'WARD', '708', 'Biên Giới', 'Bien Gioi'),
('25606', 'WARD', '708', 'Hòa Thạnh', 'Hoa Thanh'),
('25609', 'WARD', '708', 'Trí Bình', 'Tri Binh'),
('25612', 'WARD', '708', 'Hòa Hội', 'Hoa Hoi'),
('25615', 'WARD', '708', 'An Bình', 'An Binh'),
('25618', 'WARD', '708', 'Thanh Điền', 'Thanh Dien'),
('25621', 'WARD', '708', 'Thành Long', 'Thanh Long'),
('25624', 'WARD', '708', 'Ninh Điền', 'Ninh Dien'),
('25627', 'WARD', '708', 'Long Vĩnh', 'Long Vinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 709 - Thị Hòa Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25630', 'WARD', '709', 'Long Hoa', 'Long Hoa'),
('25633', 'WARD', '709', 'Hiệp Tân', 'Hiep Tan'),
('25636', 'WARD', '709', 'Long Thành Bắc', 'Long Thanh Bac'),
('25639', 'WARD', '709', 'Trường Hòa', 'Truong Hoa'),
('25642', 'WARD', '709', 'Trường Đông', 'Truong Dong'),
('25645', 'WARD', '709', 'Long Thành Trung', 'Long Thanh Trung'),
('25648', 'WARD', '709', 'Trường Tây', 'Truong Tay'),
('25651', 'WARD', '709', 'Long Thành Nam', 'Long Thanh Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 710 - Gò Dầu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25654', 'WARD', '710', 'Thị trấn Gò Dầu', 'Thi tran Go Dau'),
('25657', 'WARD', '710', 'Thạnh Đức', 'Thanh Duc'),
('25660', 'WARD', '710', 'Cẩm Giang', 'Cam Giang'),
('25663', 'WARD', '710', 'Hiệp Thạnh', 'Hiep Thanh'),
('25666', 'WARD', '710', 'Bàu Đồn', 'Bau Don'),
('25669', 'WARD', '710', 'Phước Thạnh', 'Phuoc Thanh'),
('25672', 'WARD', '710', 'Phước Đông', 'Phuoc Dong'),
('25675', 'WARD', '710', 'Phước Trạch', 'Phuoc Trach'),
('25678', 'WARD', '710', 'Thanh Phước', 'Thanh Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 711 - Bến Cầu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25681', 'WARD', '711', 'Thị trấn Bến Cầu', 'Thi tran Ben Cau'),
('25684', 'WARD', '711', 'Long Chữ', 'Long Chu'),
('25687', 'WARD', '711', 'Long Phước', 'Long Phuoc'),
('25690', 'WARD', '711', 'Long Giang', 'Long Giang'),
('25693', 'WARD', '711', 'Tiên Thuận', 'Tien Thuan'),
('25696', 'WARD', '711', 'Long Khánh', 'Long Khanh'),
('25699', 'WARD', '711', 'Lợi Thuận', 'Loi Thuan'),
('25702', 'WARD', '711', 'Long Thuận', 'Long Thuan'),
('25705', 'WARD', '711', 'An Thạnh', 'An Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 712 - Thị Trảng Bàng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25708', 'WARD', '712', 'Trảng Bàng', 'Trang Bang'),
('25711', 'WARD', '712', 'Đôn Thuận', 'Don Thuan'),
('25714', 'WARD', '712', 'Hưng Thuận', 'Hung Thuan'),
('25717', 'WARD', '712', 'Lộc Hưng', 'Loc Hung'),
('25720', 'WARD', '712', 'Gia Lộc', 'Gia Loc'),
('25723', 'WARD', '712', 'Gia Bình', 'Gia Binh'),
('25729', 'WARD', '712', 'Phước Bình', 'Phuoc Binh'),
('25732', 'WARD', '712', 'An Tịnh', 'An Tinh'),
('25735', 'WARD', '712', 'An Hòa', 'An Hoa'),
('25738', 'WARD', '712', 'Phước Chỉ', 'Phuoc Chi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 74 - Bình Dương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('718', 'DISTRICT', '74', 'Thủ Dầu Một', 'Thanh pho Thu Dau Mot'),
('719', 'DISTRICT', '74', 'Bàu Bàng', 'Bau Bang'),
('720', 'DISTRICT', '74', 'Dầu Tiếng', 'Dau Tieng'),
('721', 'DISTRICT', '74', 'Bến Cát', 'Thanh pho Ben Cat'),
('722', 'DISTRICT', '74', 'Phú Giáo', 'Phu Giao'),
('723', 'DISTRICT', '74', 'Tân Uyên', 'Thanh pho Tan Uyen'),
('724', 'DISTRICT', '74', 'Dĩ An', 'Thanh pho Di An'),
('725', 'DISTRICT', '74', 'Thuận An', 'Thanh pho Thuan An'),
('726', 'DISTRICT', '74', 'Bắc Tân Uyên', 'Bac Tan Uyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 718 - Thủ Dầu Một
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25741', 'WARD', '718', 'Hiệp Thành', 'Hiep Thanh'),
('25744', 'WARD', '718', 'Phú Lợi', 'Phu Loi'),
('25747', 'WARD', '718', 'Phú Cường', 'Phu Cuong'),
('25750', 'WARD', '718', 'Phú Hòa', 'Phu Hoa'),
('25753', 'WARD', '718', 'Phú Thọ', 'Phu Tho'),
('25756', 'WARD', '718', 'Chánh Nghĩa', 'Chanh Nghia'),
('25759', 'WARD', '718', 'Định Hoà', 'Dinh Hoa'),
('25760', 'WARD', '718', 'Hoà Phú', 'Hoa Phu'),
('25762', 'WARD', '718', 'Phú Mỹ', 'Phu My'),
('25763', 'WARD', '718', 'Phú Tân', 'Phu Tan'),
('25765', 'WARD', '718', 'Tân An', 'Tan An'),
('25768', 'WARD', '718', 'Hiệp An', 'Hiep An'),
('25771', 'WARD', '718', 'Tương Bình Hiệp', 'Tuong Binh Hiep'),
('25774', 'WARD', '718', 'Chánh Mỹ', 'Chanh My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 719 - Bàu Bàng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25816', 'WARD', '719', 'Trừ Văn Thố', 'Tru Van Tho'),
('25819', 'WARD', '719', 'Cây Trường II', 'Cay Truong II'),
('25822', 'WARD', '719', 'Thị trấn Lai Uyên', 'Thi tran Lai Uyen'),
('25825', 'WARD', '719', 'Tân Hưng', 'Tan Hung'),
('25828', 'WARD', '719', 'Long Nguyên', 'Long Nguyen'),
('25831', 'WARD', '719', 'Hưng Hòa', 'Hung Hoa'),
('25834', 'WARD', '719', 'Lai Hưng', 'Lai Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 720 - Dầu Tiếng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25777', 'WARD', '720', 'Thị trấn Dầu Tiếng', 'Thi tran Dau Tieng'),
('25780', 'WARD', '720', 'Minh Hoà', 'Minh Hoa'),
('25783', 'WARD', '720', 'Minh Thạnh', 'Minh Thanh'),
('25786', 'WARD', '720', 'Minh Tân', 'Minh Tan'),
('25789', 'WARD', '720', 'Định An', 'Dinh An'),
('25792', 'WARD', '720', 'Long Hoà', 'Long Hoa'),
('25795', 'WARD', '720', 'Định Thành', 'Dinh Thanh'),
('25798', 'WARD', '720', 'Định Hiệp', 'Dinh Hiep'),
('25801', 'WARD', '720', 'An Lập', 'An Lap'),
('25804', 'WARD', '720', 'Long Tân', 'Long Tan'),
('25807', 'WARD', '720', 'Thanh An', 'Thanh An'),
('25810', 'WARD', '720', 'Thanh Tuyền', 'Thanh Tuyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 721 - Bến Cát
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25813', 'WARD', '721', 'Mỹ Phước', 'My Phuoc'),
('25837', 'WARD', '721', 'Chánh Phú Hòa', 'Chanh Phu Hoa'),
('25840', 'WARD', '721', 'An Điền', 'An Dien'),
('25843', 'WARD', '721', 'An Tây', 'An Tay'),
('25846', 'WARD', '721', 'Thới Hòa', 'Thoi Hoa'),
('25849', 'WARD', '721', 'Hòa Lợi', 'Hoa Loi'),
('25852', 'WARD', '721', 'Tân Định', 'Tan Dinh'),
('25855', 'WARD', '721', 'Phú An', 'Phu An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 722 - Phú Giáo
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25858', 'WARD', '722', 'Thị trấn Phước Vĩnh', 'Thi tran Phuoc Vinh'),
('25861', 'WARD', '722', 'An Linh', 'An Linh'),
('25864', 'WARD', '722', 'Phước Sang', 'Phuoc Sang'),
('25865', 'WARD', '722', 'An Thái', 'An Thai'),
('25867', 'WARD', '722', 'An Long', 'An Long'),
('25870', 'WARD', '722', 'An Bình', 'An Binh'),
('25873', 'WARD', '722', 'Tân Hiệp', 'Tan Hiep'),
('25876', 'WARD', '722', 'Tam Lập', 'Tam Lap'),
('25879', 'WARD', '722', 'Tân Long', 'Tan Long'),
('25882', 'WARD', '722', 'Vĩnh Hoà', 'Vinh Hoa'),
('25885', 'WARD', '722', 'Phước Hoà', 'Phuoc Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 723 - Tân Uyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25888', 'WARD', '723', 'Uyên Hưng', 'Uyen Hung'),
('25891', 'WARD', '723', 'Tân Phước Khánh', 'Tan Phuoc Khanh'),
('25912', 'WARD', '723', 'Vĩnh Tân', 'Vinh Tan'),
('25915', 'WARD', '723', 'Hội Nghĩa', 'Hoi Nghia'),
('25920', 'WARD', '723', 'Tân Hiệp', 'Tan Hiep'),
('25921', 'WARD', '723', 'Khánh Bình', 'Khanh Binh'),
('25924', 'WARD', '723', 'Phú Chánh', 'Phu Chanh'),
('25930', 'WARD', '723', 'Bạch Đằng', 'Bach Dang'),
('25933', 'WARD', '723', 'Tân Vĩnh Hiệp', 'Tan Vinh Hiep'),
('25936', 'WARD', '723', 'Thạnh Phước', 'Thanh Phuoc'),
('25937', 'WARD', '723', 'Thạnh Hội', 'Thanh Hoi'),
('25939', 'WARD', '723', 'Thái Hòa', 'Thai Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 724 - Dĩ An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25942', 'WARD', '724', 'Dĩ An', 'Di An'),
('25945', 'WARD', '724', 'Tân Bình', 'Tan Binh'),
('25948', 'WARD', '724', 'Tân Đông Hiệp', 'Tan Dong Hiep'),
('25951', 'WARD', '724', 'Bình An', 'Binh An'),
('25954', 'WARD', '724', 'Bình Thắng', 'Binh Thang'),
('25957', 'WARD', '724', 'Đông Hòa', 'Dong Hoa'),
('25960', 'WARD', '724', 'An Bình', 'An Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 725 - Thuận An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25963', 'WARD', '725', 'An Thạnh', 'An Thanh'),
('25966', 'WARD', '725', 'Lái Thiêu', 'Lai Thieu'),
('25969', 'WARD', '725', 'Bình Chuẩn', 'Binh Chuan'),
('25972', 'WARD', '725', 'Thuận Giao', 'Thuan Giao'),
('25975', 'WARD', '725', 'An Phú', 'An Phu'),
('25978', 'WARD', '725', 'Hưng Định', 'Hung Dinh'),
('25981', 'WARD', '725', 'An Sơn', 'An Son'),
('25984', 'WARD', '725', 'Bình Nhâm', 'Binh Nham'),
('25987', 'WARD', '725', 'Bình Hòa', 'Binh Hoa'),
('25990', 'WARD', '725', 'Vĩnh Phú', 'Vinh Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 726 - Bắc Tân Uyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25894', 'WARD', '726', 'Tân Định', 'Tan Dinh'),
('25897', 'WARD', '726', 'Bình Mỹ', 'Binh My'),
('25900', 'WARD', '726', 'Thị trấn Tân Bình', 'Thi tran Tan Binh'),
('25903', 'WARD', '726', 'Tân Lập', 'Tan Lap'),
('25906', 'WARD', '726', 'Thị trấn Tân Thành', 'Thi tran Tan Thanh'),
('25907', 'WARD', '726', 'Đất Cuốc', 'Dat Cuoc'),
('25908', 'WARD', '726', 'Hiếu Liêm', 'Hieu Liem'),
('25909', 'WARD', '726', 'Lạc An', 'Lac An'),
('25918', 'WARD', '726', 'Tân Mỹ', 'Tan My'),
('25927', 'WARD', '726', 'Thường Tân', 'Thuong Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 75 - Đồng Nai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('731', 'DISTRICT', '75', 'Biên Hòa', 'Thanh pho Bien Hoa'),
('732', 'DISTRICT', '75', 'Long Khánh', 'Thanh pho Long Khanh'),
('734', 'DISTRICT', '75', 'Tân Phú', 'Tan Phu'),
('735', 'DISTRICT', '75', 'Vĩnh Cửu', 'Vinh Cuu'),
('736', 'DISTRICT', '75', 'Định Quán', 'Dinh Quan'),
('737', 'DISTRICT', '75', 'Trảng Bom', 'Trang Bom'),
('738', 'DISTRICT', '75', 'Thống Nhất', 'Thong Nhat'),
('739', 'DISTRICT', '75', 'Cẩm Mỹ', 'Cam My'),
('740', 'DISTRICT', '75', 'Long Thành', 'Long Thanh'),
('741', 'DISTRICT', '75', 'Xuân Lộc', 'Xuan Loc'),
('742', 'DISTRICT', '75', 'Nhơn Trạch', 'Nhon Trach')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 731 - Biên Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('25993', 'WARD', '731', 'Trảng Dài', 'Trang Dai'),
('25996', 'WARD', '731', 'Tân Phong', 'Tan Phong'),
('25999', 'WARD', '731', 'Tân Biên', 'Tan Bien'),
('26002', 'WARD', '731', 'Hố Nai', 'Ho Nai'),
('26005', 'WARD', '731', 'Tân Hòa', 'Tan Hoa'),
('26008', 'WARD', '731', 'Tân Hiệp', 'Tan Hiep'),
('26011', 'WARD', '731', 'Bửu Long', 'Buu Long'),
('26014', 'WARD', '731', 'Tân Mai', 'Tan Mai'),
('26017', 'WARD', '731', 'Tam Hiệp', 'Tam Hiep'),
('26020', 'WARD', '731', 'Long Bình', 'Long Binh'),
('26023', 'WARD', '731', 'Quang Vinh', 'Quang Vinh'),
('26029', 'WARD', '731', 'Thống Nhất', 'Thong Nhat'),
('26041', 'WARD', '731', 'Trung Dũng', 'Trung Dung'),
('26047', 'WARD', '731', 'Bình Đa', 'Binh Da'),
('26050', 'WARD', '731', 'An Bình', 'An Binh'),
('26053', 'WARD', '731', 'Bửu Hòa', 'Buu Hoa'),
('26056', 'WARD', '731', 'Long Bình Tân', 'Long Binh Tan'),
('26059', 'WARD', '731', 'Tân Vạn', 'Tan Van'),
('26062', 'WARD', '731', 'Tân Hạnh', 'Tan Hanh'),
('26065', 'WARD', '731', 'Hiệp Hòa', 'Hiep Hoa'),
('26068', 'WARD', '731', 'Hóa An', 'Hoa An'),
('26371', 'WARD', '731', 'An Hòa', 'An Hoa'),
('26374', 'WARD', '731', 'Tam Phước', 'Tam Phuoc'),
('26377', 'WARD', '731', 'Phước Tân', 'Phuoc Tan'),
('26380', 'WARD', '731', 'Long Hưng', 'Long Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 732 - Long Khánh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26077', 'WARD', '732', 'Xuân Bình', 'Xuan Binh'),
('26080', 'WARD', '732', 'Xuân An', 'Xuan An'),
('26083', 'WARD', '732', 'Xuân Hoà', 'Xuan Hoa'),
('26086', 'WARD', '732', 'Phú Bình', 'Phu Binh'),
('26089', 'WARD', '732', 'Bình Lộc', 'Binh Loc'),
('26092', 'WARD', '732', 'Bảo Quang', 'Bao Quang'),
('26095', 'WARD', '732', 'Suối Tre', 'Suoi Tre'),
('26098', 'WARD', '732', 'Bảo Vinh', 'Bao Vinh'),
('26101', 'WARD', '732', 'Xuân Lập', 'Xuan Lap'),
('26104', 'WARD', '732', 'Bàu Sen', 'Bau Sen'),
('26107', 'WARD', '732', 'Bàu Trâm', 'Bau Tram'),
('26110', 'WARD', '732', 'Xuân Tân', 'Xuan Tan'),
('26113', 'WARD', '732', 'Hàng Gòn', 'Hang Gon')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 734 - Tân Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26116', 'WARD', '734', 'Thị trấn Tân Phú', 'Thi tran Tan Phu'),
('26119', 'WARD', '734', 'Dak Lua', 'Dak Lua'),
('26122', 'WARD', '734', 'Nam Cát Tiên', 'Nam Cat Tien'),
('26125', 'WARD', '734', 'Phú An', 'Phu An'),
('26131', 'WARD', '734', 'Tà Lài', 'Ta Lai'),
('26134', 'WARD', '734', 'Phú Lập', 'Phu Lap'),
('26140', 'WARD', '734', 'Phú Thịnh', 'Phu Thinh'),
('26143', 'WARD', '734', 'Thanh Sơn', 'Thanh Son'),
('26146', 'WARD', '734', 'Phú Sơn', 'Phu Son'),
('26149', 'WARD', '734', 'Phú Xuân', 'Phu Xuan'),
('26152', 'WARD', '734', 'Phú Lộc', 'Phu Loc'),
('26155', 'WARD', '734', 'Phú Lâm', 'Phu Lam'),
('26158', 'WARD', '734', 'Phú Bình', 'Phu Binh'),
('26161', 'WARD', '734', 'Phú Thanh', 'Phu Thanh'),
('26164', 'WARD', '734', 'Trà Cổ', 'Tra Co'),
('26167', 'WARD', '734', 'Phú Điền', 'Phu Dien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 735 - Vĩnh Cửu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26170', 'WARD', '735', 'Thị trấn Vĩnh An', 'Thi tran Vinh An'),
('26173', 'WARD', '735', 'Phú Lý', 'Phu Ly'),
('26176', 'WARD', '735', 'Trị An', 'Tri An'),
('26179', 'WARD', '735', 'Tân An', 'Tan An'),
('26182', 'WARD', '735', 'Vĩnh Tân', 'Vinh Tan'),
('26185', 'WARD', '735', 'Bình Lợi', 'Binh Loi'),
('26188', 'WARD', '735', 'Thạnh Phú', 'Thanh Phu'),
('26191', 'WARD', '735', 'Thiện Tân', 'Thien Tan'),
('26194', 'WARD', '735', 'Tân Bình', 'Tan Binh'),
('26200', 'WARD', '735', 'Mã Đà', 'Ma Da')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 736 - Định Quán
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26206', 'WARD', '736', 'Thị trấn Định Quán', 'Thi tran Dinh Quan'),
('26209', 'WARD', '736', 'Thanh Sơn', 'Thanh Son'),
('26212', 'WARD', '736', 'Phú Tân', 'Phu Tan'),
('26215', 'WARD', '736', 'Phú Vinh', 'Phu Vinh'),
('26218', 'WARD', '736', 'Phú Lợi', 'Phu Loi'),
('26221', 'WARD', '736', 'Phú Hòa', 'Phu Hoa'),
('26224', 'WARD', '736', 'Ngọc Định', 'Ngoc Dinh'),
('26227', 'WARD', '736', 'La Ngà', 'La Nga'),
('26230', 'WARD', '736', 'Gia Canh', 'Gia Canh'),
('26233', 'WARD', '736', 'Phú Ngọc', 'Phu Ngoc'),
('26236', 'WARD', '736', 'Phú Cường', 'Phu Cuong'),
('26239', 'WARD', '736', 'Túc Trưng', 'Tuc Trung'),
('26242', 'WARD', '736', 'Phú Túc', 'Phu Tuc'),
('26245', 'WARD', '736', 'Suối Nho', 'Suoi Nho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 737 - Trảng Bom
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26248', 'WARD', '737', 'Thị trấn Trảng Bom', 'Thi tran Trang Bom'),
('26251', 'WARD', '737', 'Thanh Bình', 'Thanh Binh'),
('26254', 'WARD', '737', 'Cây Gáo', 'Cay Gao'),
('26257', 'WARD', '737', 'Bàu Hàm', 'Bau Ham'),
('26260', 'WARD', '737', 'Sông Thao', 'Song Thao'),
('26263', 'WARD', '737', 'Sông Trầu', 'Song Trau'),
('26266', 'WARD', '737', 'Đông Hoà', 'Dong Hoa'),
('26269', 'WARD', '737', 'Bắc Sơn', 'Bac Son'),
('26272', 'WARD', '737', 'Hố Nai 3', 'Ho Nai 3'),
('26275', 'WARD', '737', 'Tây Hoà', 'Tay Hoa'),
('26278', 'WARD', '737', 'Bình Minh', 'Binh Minh'),
('26281', 'WARD', '737', 'Trung Hoà', 'Trung Hoa'),
('26284', 'WARD', '737', 'Đồi 61', 'Doi 61'),
('26287', 'WARD', '737', 'Hưng Thịnh', 'Hung Thinh'),
('26290', 'WARD', '737', 'Quảng Tiến', 'Quang Tien'),
('26293', 'WARD', '737', 'Giang Điền', 'Giang Dien'),
('26296', 'WARD', '737', 'An Viễn', 'An Vien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 738 - Thống Nhất
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26299', 'WARD', '738', 'Gia Tân 1', 'Gia Tan 1'),
('26302', 'WARD', '738', 'Gia Tân 2', 'Gia Tan 2'),
('26305', 'WARD', '738', 'Gia Tân 3', 'Gia Tan 3'),
('26308', 'WARD', '738', 'Gia Kiệm', 'Gia Kiem'),
('26311', 'WARD', '738', 'Quang Trung', 'Quang Trung'),
('26314', 'WARD', '738', 'Bàu Hàm 2', 'Bau Ham 2'),
('26317', 'WARD', '738', 'Hưng Lộc', 'Hung Loc'),
('26320', 'WARD', '738', 'Lộ 25', 'Lo 25'),
('26323', 'WARD', '738', 'Xuân Thiện', 'Xuan Thien'),
('26326', 'WARD', '738', 'Thị trấn Dầu Giây', 'Thi tran Dau Giay')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 739 - Cẩm Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26329', 'WARD', '739', 'Sông Nhạn', 'Song Nhan'),
('26332', 'WARD', '739', 'Xuân Quế', 'Xuan Que'),
('26335', 'WARD', '739', 'Nhân Nghĩa', 'Nhan Nghia'),
('26338', 'WARD', '739', 'Xuân Đường', 'Xuan Duong'),
('26341', 'WARD', '739', 'Thị trấn Long Giao', 'Thi tran Long Giao'),
('26344', 'WARD', '739', 'Xuân Mỹ', 'Xuan My'),
('26347', 'WARD', '739', 'Thừa Đức', 'Thua Duc'),
('26350', 'WARD', '739', 'Bảo Bình', 'Bao Binh'),
('26353', 'WARD', '739', 'Xuân Bảo', 'Xuan Bao'),
('26356', 'WARD', '739', 'Xuân Tây', 'Xuan Tay'),
('26359', 'WARD', '739', 'Xuân Đông', 'Xuan Dong'),
('26362', 'WARD', '739', 'Sông Ray', 'Song Ray'),
('26365', 'WARD', '739', 'Lâm San', 'Lam San')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 740 - Long Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26368', 'WARD', '740', 'Thị trấn Long Thành', 'Thi tran Long Thanh'),
('26383', 'WARD', '740', 'An Phước', 'An Phuoc'),
('26386', 'WARD', '740', 'Bình An', 'Binh An'),
('26389', 'WARD', '740', 'Long Đức', 'Long Duc'),
('26392', 'WARD', '740', 'Lộc An', 'Loc An'),
('26395', 'WARD', '740', 'Bình Sơn', 'Binh Son'),
('26398', 'WARD', '740', 'Tam An', 'Tam An'),
('26401', 'WARD', '740', 'Cẩm Đường', 'Cam Duong'),
('26404', 'WARD', '740', 'Long An', 'Long An'),
('26410', 'WARD', '740', 'Bàu Cạn', 'Bau Can'),
('26413', 'WARD', '740', 'Long Phước', 'Long Phuoc'),
('26416', 'WARD', '740', 'Phước Bình', 'Phuoc Binh'),
('26419', 'WARD', '740', 'Tân Hiệp', 'Tan Hiep'),
('26422', 'WARD', '740', 'Phước Thái', 'Phuoc Thai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 741 - Xuân Lộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26425', 'WARD', '741', 'Thị trấn Gia Ray', 'Thi tran Gia Ray'),
('26428', 'WARD', '741', 'Xuân Bắc', 'Xuan Bac'),
('26431', 'WARD', '741', 'Suối Cao', 'Suoi Cao'),
('26434', 'WARD', '741', 'Xuân Thành', 'Xuan Thanh'),
('26437', 'WARD', '741', 'Xuân Thọ', 'Xuan Tho'),
('26440', 'WARD', '741', 'Xuân Trường', 'Xuan Truong'),
('26443', 'WARD', '741', 'Xuân Hòa', 'Xuan Hoa'),
('26446', 'WARD', '741', 'Xuân Hưng', 'Xuan Hung'),
('26449', 'WARD', '741', 'Xuân Tâm', 'Xuan Tam'),
('26452', 'WARD', '741', 'Suối Cát', 'Suoi Cat'),
('26455', 'WARD', '741', 'Xuân Hiệp', 'Xuan Hiep'),
('26458', 'WARD', '741', 'Xuân Phú', 'Xuan Phu'),
('26461', 'WARD', '741', 'Xuân Định', 'Xuan Dinh'),
('26464', 'WARD', '741', 'Bảo Hoà', 'Bao Hoa'),
('26467', 'WARD', '741', 'Lang Minh', 'Lang Minh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 742 - Nhơn Trạch
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26470', 'WARD', '742', 'Phước Thiền', 'Phuoc Thien'),
('26473', 'WARD', '742', 'Long Tân', 'Long Tan'),
('26476', 'WARD', '742', 'Đại Phước', 'Dai Phuoc'),
('26479', 'WARD', '742', 'Thị trấn Hiệp Phước', 'Thi tran Hiep Phuoc'),
('26482', 'WARD', '742', 'Phú Hữu', 'Phu Huu'),
('26485', 'WARD', '742', 'Phú Hội', 'Phu Hoi'),
('26488', 'WARD', '742', 'Phú Thạnh', 'Phu Thanh'),
('26491', 'WARD', '742', 'Phú Đông', 'Phu Dong'),
('26494', 'WARD', '742', 'Long Thọ', 'Long Tho'),
('26497', 'WARD', '742', 'Vĩnh Thanh', 'Vinh Thanh'),
('26500', 'WARD', '742', 'Phước Khánh', 'Phuoc Khanh'),
('26503', 'WARD', '742', 'Phước An', 'Phuoc An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 77 - Bà Rịa - Vũng Tàu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('747', 'DISTRICT', '77', 'Vũng Tàu', 'Thanh pho Vung Tau'),
('748', 'DISTRICT', '77', 'Bà Rịa', 'Thanh pho Ba Ria'),
('750', 'DISTRICT', '77', 'Châu Đức', 'Chau Duc'),
('751', 'DISTRICT', '77', 'Xuyên Mộc', 'Xuyen Moc'),
('753', 'DISTRICT', '77', 'Long Đất', 'Long Dat'),
('754', 'DISTRICT', '77', 'Thị Phú Mỹ', 'Thi Phu My'),
('755', 'DISTRICT', '77', 'Côn Đảo', 'Con Dao')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 747 - Vũng Tàu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26506', 'WARD', '747', 'Phường 1', 'Ward 1'),
('26508', 'WARD', '747', 'Thắng Tam', 'Thang Tam'),
('26509', 'WARD', '747', 'Phường 2', 'Ward 2'),
('26512', 'WARD', '747', 'Phường 3', 'Ward 3'),
('26515', 'WARD', '747', 'Phường 4', 'Ward 4'),
('26518', 'WARD', '747', 'Phường 5', 'Ward 5'),
('26521', 'WARD', '747', 'Thắng Nhì', 'Thang Nhi'),
('26524', 'WARD', '747', 'Phường 7', 'Ward 7'),
('26526', 'WARD', '747', 'Nguyễn An Ninh', 'Nguyen An Ninh'),
('26527', 'WARD', '747', 'Phường 8', 'Ward 8'),
('26530', 'WARD', '747', 'Phường 9', 'Ward 9'),
('26533', 'WARD', '747', 'Thắng Nhất', 'Thang Nhat'),
('26535', 'WARD', '747', 'Rạch Dừa', 'Rach Dua'),
('26536', 'WARD', '747', 'Phường 10', 'Ward 10'),
('26539', 'WARD', '747', 'Phường 11', 'Ward 11'),
('26542', 'WARD', '747', 'Phường 12', 'Ward 12'),
('26545', 'WARD', '747', 'Long Sơn', 'Long Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 748 - Bà Rịa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26548', 'WARD', '748', 'Phước Hưng', 'Phuoc Hung'),
('26554', 'WARD', '748', 'Phước Nguyên', 'Phuoc Nguyen'),
('26557', 'WARD', '748', 'Long Toàn', 'Long Toan'),
('26558', 'WARD', '748', 'Long Tâm', 'Long Tam'),
('26560', 'WARD', '748', 'Phước Trung', 'Phuoc Trung'),
('26563', 'WARD', '748', 'Long Hương', 'Long Huong'),
('26566', 'WARD', '748', 'Kim Dinh', 'Kim Dinh'),
('26567', 'WARD', '748', 'Tân Hưng', 'Tan Hung'),
('26569', 'WARD', '748', 'Long Phước', 'Long Phuoc'),
('26572', 'WARD', '748', 'Hoà Long', 'Hoa Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 750 - Châu Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26574', 'WARD', '750', 'Bàu Chinh', 'Bau Chinh'),
('26575', 'WARD', '750', 'Thị trấn Ngãi Giao', 'Thi tran Ngai Giao'),
('26578', 'WARD', '750', 'Bình Ba', 'Binh Ba'),
('26581', 'WARD', '750', 'Suối Nghệ', 'Suoi Nghe'),
('26584', 'WARD', '750', 'Xuân Sơn', 'Xuan Son'),
('26587', 'WARD', '750', 'Sơn Bình', 'Son Binh'),
('26590', 'WARD', '750', 'Bình Giã', 'Binh Gia'),
('26593', 'WARD', '750', 'Bình Trung', 'Binh Trung'),
('26596', 'WARD', '750', 'Xà Bang', 'Bang'),
('26599', 'WARD', '750', 'Cù Bị', 'Cu Bi'),
('26602', 'WARD', '750', 'Láng Lớn', 'Lang Lon'),
('26605', 'WARD', '750', 'Quảng Thành', 'Quang Thanh'),
('26608', 'WARD', '750', 'Thị trấn Kim Long', 'Thi tran Kim Long'),
('26611', 'WARD', '750', 'Suối Rao', 'Suoi Rao'),
('26614', 'WARD', '750', 'Đá Bạc', 'Da Bac'),
('26617', 'WARD', '750', 'Nghĩa Thành', 'Nghia Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 751 - Xuyên Mộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26620', 'WARD', '751', 'Thị trấn Phước Bửu', 'Thi tran Phuoc Buu'),
('26623', 'WARD', '751', 'Phước Thuận', 'Phuoc Thuan'),
('26626', 'WARD', '751', 'Phước Tân', 'Phuoc Tan'),
('26629', 'WARD', '751', 'Xuyên Mộc', 'Xuyen Moc'),
('26632', 'WARD', '751', 'Bông Trang', 'Bong Trang'),
('26635', 'WARD', '751', 'Tân Lâm', 'Tan Lam'),
('26638', 'WARD', '751', 'Bàu Lâm', 'Bau Lam'),
('26641', 'WARD', '751', 'Hòa Bình', 'Hoa Binh'),
('26644', 'WARD', '751', 'Hòa Hưng', 'Hoa Hung'),
('26647', 'WARD', '751', 'Hòa Hiệp', 'Hoa Hiep'),
('26650', 'WARD', '751', 'Hòa Hội', 'Hoa Hoi'),
('26653', 'WARD', '751', 'Bưng Riềng', 'Bung Rieng'),
('26656', 'WARD', '751', 'Bình Châu', 'Binh Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 753 - Long Đất
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26659', 'WARD', '753', 'Thị trấn Long Điền', 'Thi tran Long Dien'),
('26662', 'WARD', '753', 'Thị trấn Long Hải', 'Thi tran Long Hai'),
('26668', 'WARD', '753', 'Tam An', 'Tam An'),
('26674', 'WARD', '753', 'Phước Tỉnh', 'Phuoc Tinh'),
('26677', 'WARD', '753', 'Phước Hưng', 'Phuoc Hung'),
('26680', 'WARD', '753', 'Thị trấn Đất Đỏ', 'Thi tran Dat Do'),
('26683', 'WARD', '753', 'Phước Long Thọ', 'Phuoc Long Tho'),
('26686', 'WARD', '753', 'Phước Hội', 'Phuoc Hoi'),
('26689', 'WARD', '753', 'Thị trấn Phước Hải', 'Thi tran Phuoc Hai'),
('26695', 'WARD', '753', 'Long Tân', 'Long Tan'),
('26698', 'WARD', '753', 'Láng Dài', 'Lang Dai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 754 - Thị Phú Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26704', 'WARD', '754', 'Phú Mỹ', 'Phu My'),
('26707', 'WARD', '754', 'Tân Hoà', 'Tan Hoa'),
('26710', 'WARD', '754', 'Tân Hải', 'Tan Hai'),
('26713', 'WARD', '754', 'Phước Hoà', 'Phuoc Hoa'),
('26716', 'WARD', '754', 'Tân Phước', 'Tan Phuoc'),
('26719', 'WARD', '754', 'Mỹ Xuân', 'My Xuan'),
('26722', 'WARD', '754', 'Sông Xoài', 'Song Xoai'),
('26725', 'WARD', '754', 'Hắc Dịch', 'Hac Dich'),
('26728', 'WARD', '754', 'Châu Pha', 'Chau Pha'),
('26731', 'WARD', '754', 'Tóc Tiên', 'Toc Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 79 - Hồ Chí Minh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('760', 'DISTRICT', '79', 'Quận 1', 'District 1'),
('761', 'DISTRICT', '79', 'Quận 12', 'District 12'),
('764', 'DISTRICT', '79', 'Gò Vấp', 'Go Vap'),
('765', 'DISTRICT', '79', 'Bình Thạnh', 'Binh Thanh'),
('766', 'DISTRICT', '79', 'Tân Bình', 'Tan Binh'),
('767', 'DISTRICT', '79', 'Tân Phú', 'Tan Phu'),
('768', 'DISTRICT', '79', 'Phú Nhuận', 'Phu Nhuan'),
('769', 'DISTRICT', '79', 'Thủ Đức', 'Thanh pho Thu Duc'),
('770', 'DISTRICT', '79', 'Quận 3', 'District 3'),
('771', 'DISTRICT', '79', 'Quận 10', 'District 10'),
('772', 'DISTRICT', '79', 'Quận 11', 'District 11'),
('773', 'DISTRICT', '79', 'Quận 4', 'District 4'),
('774', 'DISTRICT', '79', 'Quận 5', 'District 5'),
('775', 'DISTRICT', '79', 'Quận 6', 'District 6'),
('776', 'DISTRICT', '79', 'Quận 8', 'District 8'),
('777', 'DISTRICT', '79', 'Bình Tân', 'Binh Tan'),
('778', 'DISTRICT', '79', 'Quận 7', 'District 7'),
('783', 'DISTRICT', '79', 'Củ Chi', 'Cu Chi'),
('784', 'DISTRICT', '79', 'Hóc Môn', 'Hoc Mon'),
('785', 'DISTRICT', '79', 'Bình Chánh', 'Binh Chanh'),
('786', 'DISTRICT', '79', 'Nhà Bè', 'Nha Be'),
('787', 'DISTRICT', '79', 'Cần Giờ', 'Can Gio')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 760 - 1
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26734', 'WARD', '760', 'Tân Định', 'Tan Dinh'),
('26737', 'WARD', '760', 'Đa Kao', 'Da Kao'),
('26740', 'WARD', '760', 'Bến Nghé', 'Ben Nghe'),
('26743', 'WARD', '760', 'Bến Thành', 'Ben Thanh'),
('26746', 'WARD', '760', 'Nguyễn Thái Bình', 'Nguyen Thai Binh'),
('26749', 'WARD', '760', 'Phạm Ngũ Lão', 'Pham Ngu Lao'),
('26752', 'WARD', '760', 'Cầu Ông Lãnh', 'Cau Ong Lanh'),
('26755', 'WARD', '760', 'Cô Giang', 'Co Giang'),
('26758', 'WARD', '760', 'Nguyễn Cư Trinh', 'Nguyen Cu Trinh'),
('26761', 'WARD', '760', 'Cầu Kho', 'Cau Kho')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 761 - 12
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26764', 'WARD', '761', 'Thạnh Xuân', 'Thanh Xuan'),
('26767', 'WARD', '761', 'Thạnh Lộc', 'Thanh Loc'),
('26770', 'WARD', '761', 'Hiệp Thành', 'Hiep Thanh'),
('26773', 'WARD', '761', 'Thới An', 'Thoi An'),
('26776', 'WARD', '761', 'Tân Chánh Hiệp', 'Tan Chanh Hiep'),
('26779', 'WARD', '761', 'An Phú Đông', 'An Phu Dong'),
('26782', 'WARD', '761', 'Tân Thới Hiệp', 'Tan Thoi Hiep'),
('26785', 'WARD', '761', 'Trung Mỹ Tây', 'Trung My Tay'),
('26787', 'WARD', '761', 'Tân Hưng Thuận', 'Tan Hung Thuan'),
('26788', 'WARD', '761', 'Đông Hưng Thuận', 'Dong Hung Thuan'),
('26791', 'WARD', '761', 'Tân Thới Nhất', 'Tan Thoi Nhat')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 764 - Gò Vấp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26872', 'WARD', '764', 'Phường 15', 'Ward 15'),
('26875', 'WARD', '764', 'Phường 17', 'Ward 17'),
('26876', 'WARD', '764', 'Phường 6', 'Ward 6'),
('26878', 'WARD', '764', 'Phường 16', 'Ward 16'),
('26881', 'WARD', '764', 'Phường 12', 'Ward 12'),
('26882', 'WARD', '764', 'Phường 14', 'Ward 14'),
('26884', 'WARD', '764', 'Phường 10', 'Ward 10'),
('26887', 'WARD', '764', 'Phường 5', 'Ward 5'),
('26890', 'WARD', '764', 'Phường 1', 'Ward 1'),
('26898', 'WARD', '764', 'Phường 8', 'Ward 8'),
('26899', 'WARD', '764', 'Phường 11', 'Ward 11'),
('26902', 'WARD', '764', 'Phường 3', 'Ward 3')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 765 - Bình Thạnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26905', 'WARD', '765', 'Phường 13', 'Ward 13'),
('26908', 'WARD', '765', 'Phường 11', 'Ward 11'),
('26911', 'WARD', '765', 'Phường 27', 'Ward 27'),
('26914', 'WARD', '765', 'Phường 26', 'Ward 26'),
('26917', 'WARD', '765', 'Phường 12', 'Ward 12'),
('26920', 'WARD', '765', 'Phường 25', 'Ward 25'),
('26923', 'WARD', '765', 'Phường 5', 'Ward 5'),
('26926', 'WARD', '765', 'Phường 7', 'Ward 7'),
('26935', 'WARD', '765', 'Phường 14', 'Ward 14'),
('26941', 'WARD', '765', 'Phường 2', 'Ward 2'),
('26944', 'WARD', '765', 'Phường 1', 'Ward 1'),
('26950', 'WARD', '765', 'Phường 17', 'Ward 17'),
('26956', 'WARD', '765', 'Phường 22', 'Ward 22'),
('26959', 'WARD', '765', 'Phường 19', 'Ward 19'),
('26962', 'WARD', '765', 'Phường 28', 'Ward 28')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 766 - Tân Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26965', 'WARD', '766', 'Phường 2', 'Ward 2'),
('26968', 'WARD', '766', 'Phường 4', 'Ward 4'),
('26971', 'WARD', '766', 'Phường 12', 'Ward 12'),
('26974', 'WARD', '766', 'Phường 13', 'Ward 13'),
('26977', 'WARD', '766', 'Phường 1', 'Ward 1'),
('26980', 'WARD', '766', 'Phường 3', 'Ward 3'),
('26983', 'WARD', '766', 'Phường 11', 'Ward 11'),
('26986', 'WARD', '766', 'Phường 7', 'Ward 7'),
('26989', 'WARD', '766', 'Phường 5', 'Ward 5'),
('26992', 'WARD', '766', 'Phường 10', 'Ward 10'),
('26995', 'WARD', '766', 'Phường 6', 'Ward 6'),
('26998', 'WARD', '766', 'Phường 8', 'Ward 8'),
('27001', 'WARD', '766', 'Phường 9', 'Ward 9'),
('27004', 'WARD', '766', 'Phường 14', 'Ward 14'),
('27007', 'WARD', '766', 'Phường 15', 'Ward 15')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 767 - Tân Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27010', 'WARD', '767', 'Tân Sơn Nhì', 'Tan Son Nhi'),
('27013', 'WARD', '767', 'Tây Thạnh', 'Tay Thanh'),
('27016', 'WARD', '767', 'Sơn Kỳ', 'Son Ky'),
('27019', 'WARD', '767', 'Tân Quý', 'Tan Quy'),
('27022', 'WARD', '767', 'Tân Thành', 'Tan Thanh'),
('27025', 'WARD', '767', 'Phú Thọ Hòa', 'Phu Tho Hoa'),
('27028', 'WARD', '767', 'Phú Thạnh', 'Phu Thanh'),
('27031', 'WARD', '767', 'Phú Trung', 'Phu Trung'),
('27034', 'WARD', '767', 'Hòa Thạnh', 'Hoa Thanh'),
('27037', 'WARD', '767', 'Hiệp Tân', 'Hiep Tan'),
('27040', 'WARD', '767', 'Tân Thới Hòa', 'Tan Thoi Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 768 - Phú Nhuận
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27043', 'WARD', '768', 'Phường 4', 'Ward 4'),
('27046', 'WARD', '768', 'Phường 5', 'Ward 5'),
('27049', 'WARD', '768', 'Phường 9', 'Ward 9'),
('27052', 'WARD', '768', 'Phường 7', 'Ward 7'),
('27058', 'WARD', '768', 'Phường 1', 'Ward 1'),
('27061', 'WARD', '768', 'Phường 2', 'Ward 2'),
('27064', 'WARD', '768', 'Phường 8', 'Ward 8'),
('27067', 'WARD', '768', 'Phường 15', 'Ward 15'),
('27070', 'WARD', '768', 'Phường 10', 'Ward 10'),
('27073', 'WARD', '768', 'Phường 11', 'Ward 11'),
('27085', 'WARD', '768', 'Phường 13', 'Ward 13')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 769 - Thủ Đức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('26794', 'WARD', '769', 'Linh Xuân', 'Linh Xuan'),
('26797', 'WARD', '769', 'Bình Chiểu', 'Binh Chieu'),
('26800', 'WARD', '769', 'Linh Trung', 'Linh Trung'),
('26803', 'WARD', '769', 'Tam Bình', 'Tam Binh'),
('26806', 'WARD', '769', 'Tam Phú', 'Tam Phu'),
('26809', 'WARD', '769', 'Hiệp Bình Phước', 'Hiep Binh Phuoc'),
('26812', 'WARD', '769', 'Hiệp Bình Chánh', 'Hiep Binh Chanh'),
('26815', 'WARD', '769', 'Linh Chiểu', 'Linh Chieu'),
('26818', 'WARD', '769', 'Linh Tây', 'Linh Tay'),
('26821', 'WARD', '769', 'Linh Đông', 'Linh Dong'),
('26824', 'WARD', '769', 'Bình Thọ', 'Binh Tho'),
('26827', 'WARD', '769', 'Trường Thọ', 'Truong Tho'),
('26830', 'WARD', '769', 'Long Bình', 'Long Binh'),
('26833', 'WARD', '769', 'Long Thạnh Mỹ', 'Long Thanh My'),
('26836', 'WARD', '769', 'Tân Phú', 'Tan Phu'),
('26839', 'WARD', '769', 'Hiệp Phú', 'Hiep Phu'),
('26842', 'WARD', '769', 'Tăng Nhơn Phú A', 'Tang Nhon Phu A'),
('26845', 'WARD', '769', 'Tăng Nhơn Phú B', 'Tang Nhon Phu B'),
('26848', 'WARD', '769', 'Phước Long B', 'Phuoc Long B'),
('26851', 'WARD', '769', 'Phước Long A', 'Phuoc Long A'),
('26854', 'WARD', '769', 'Trường Thạnh', 'Truong Thanh'),
('26857', 'WARD', '769', 'Long Phước', 'Long Phuoc'),
('26860', 'WARD', '769', 'Long Trường', 'Long Truong'),
('26863', 'WARD', '769', 'Phước Bình', 'Phuoc Binh'),
('26866', 'WARD', '769', 'Phú Hữu', 'Phu Huu'),
('27088', 'WARD', '769', 'Thảo Điền', 'Thao Dien'),
('27091', 'WARD', '769', 'An Phú', 'An Phu'),
('27094', 'WARD', '769', 'An Khánh', 'An Khanh'),
('27097', 'WARD', '769', 'Bình Trưng Đông', 'Binh Trung Dong'),
('27100', 'WARD', '769', 'Bình Trưng Tây', 'Binh Trung Tay'),
('27109', 'WARD', '769', 'Cát Lái', 'Cat Lai'),
('27112', 'WARD', '769', 'Thạnh Mỹ Lợi', 'Thanh My Loi'),
('27115', 'WARD', '769', 'An Lợi Đông', 'An Loi Dong'),
('27118', 'WARD', '769', 'Thủ Thiêm', 'Thu Thiem')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 770 - 3
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27127', 'WARD', '770', 'Phường 14', 'Ward 14'),
('27130', 'WARD', '770', 'Phường 12', 'Ward 12'),
('27133', 'WARD', '770', 'Phường 11', 'Ward 11'),
('27139', 'WARD', '770', 'Võ Thị Sáu', 'Vo Thi Sau'),
('27142', 'WARD', '770', 'Phường 9', 'Ward 9'),
('27148', 'WARD', '770', 'Phường 4', 'Ward 4'),
('27151', 'WARD', '770', 'Phường 5', 'Ward 5'),
('27154', 'WARD', '770', 'Phường 3', 'Ward 3'),
('27157', 'WARD', '770', 'Phường 2', 'Ward 2'),
('27160', 'WARD', '770', 'Phường 1', 'Ward 1')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 771 - 10
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27163', 'WARD', '771', 'Phường 15', 'Ward 15'),
('27166', 'WARD', '771', 'Phường 13', 'Ward 13'),
('27169', 'WARD', '771', 'Phường 14', 'Ward 14'),
('27172', 'WARD', '771', 'Phường 12', 'Ward 12'),
('27178', 'WARD', '771', 'Phường 10', 'Ward 10'),
('27181', 'WARD', '771', 'Phường 9', 'Ward 9'),
('27184', 'WARD', '771', 'Phường 1', 'Ward 1'),
('27187', 'WARD', '771', 'Phường 8', 'Ward 8'),
('27190', 'WARD', '771', 'Phường 2', 'Ward 2'),
('27193', 'WARD', '771', 'Phường 4', 'Ward 4'),
('27202', 'WARD', '771', 'Phường 6', 'Ward 6')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 772 - 11
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27208', 'WARD', '772', 'Phường 15', 'Ward 15'),
('27211', 'WARD', '772', 'Phường 5', 'Ward 5'),
('27214', 'WARD', '772', 'Phường 14', 'Ward 14'),
('27217', 'WARD', '772', 'Phường 11', 'Ward 11'),
('27220', 'WARD', '772', 'Phường 3', 'Ward 3'),
('27223', 'WARD', '772', 'Phường 10', 'Ward 10'),
('27229', 'WARD', '772', 'Phường 8', 'Ward 8'),
('27238', 'WARD', '772', 'Phường 7', 'Ward 7'),
('27247', 'WARD', '772', 'Phường 1', 'Ward 1'),
('27253', 'WARD', '772', 'Phường 16', 'Ward 16')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 773 - 4
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27259', 'WARD', '773', 'Phường 13', 'Ward 13'),
('27265', 'WARD', '773', 'Phường 9', 'Ward 9'),
('27271', 'WARD', '773', 'Phường 8', 'Ward 8'),
('27277', 'WARD', '773', 'Phường 18', 'Ward 18'),
('27283', 'WARD', '773', 'Phường 4', 'Ward 4'),
('27286', 'WARD', '773', 'Phường 3', 'Ward 3'),
('27289', 'WARD', '773', 'Phường 16', 'Ward 16'),
('27292', 'WARD', '773', 'Phường 2', 'Ward 2'),
('27295', 'WARD', '773', 'Phường 15', 'Ward 15'),
('27298', 'WARD', '773', 'Phường 1', 'Ward 1')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 774 - 5
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27301', 'WARD', '774', 'Phường 4', 'Ward 4'),
('27304', 'WARD', '774', 'Phường 9', 'Ward 9'),
('27307', 'WARD', '774', 'Phường 2', 'Ward 2'),
('27310', 'WARD', '774', 'Phường 12', 'Ward 12'),
('27316', 'WARD', '774', 'Phường 7', 'Ward 7'),
('27325', 'WARD', '774', 'Phường 1', 'Ward 1'),
('27328', 'WARD', '774', 'Phường 11', 'Ward 11'),
('27331', 'WARD', '774', 'Phường 14', 'Ward 14'),
('27334', 'WARD', '774', 'Phường 5', 'Ward 5'),
('27343', 'WARD', '774', 'Phường 13', 'Ward 13')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 775 - 6
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27346', 'WARD', '775', 'Phường 14', 'Ward 14'),
('27349', 'WARD', '775', 'Phường 13', 'Ward 13'),
('27352', 'WARD', '775', 'Phường 9', 'Ward 9'),
('27358', 'WARD', '775', 'Phường 12', 'Ward 12'),
('27361', 'WARD', '775', 'Phường 2', 'Ward 2'),
('27364', 'WARD', '775', 'Phường 11', 'Ward 11'),
('27376', 'WARD', '775', 'Phường 8', 'Ward 8'),
('27379', 'WARD', '775', 'Phường 1', 'Ward 1'),
('27382', 'WARD', '775', 'Phường 7', 'Ward 7'),
('27385', 'WARD', '775', 'Phường 10', 'Ward 10')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 776 - 8
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27397', 'WARD', '776', 'Rạch Ông', 'Rach Ong'),
('27403', 'WARD', '776', 'Hưng Phú', 'Hung Phu'),
('27409', 'WARD', '776', 'Phường 4', 'Ward 4'),
('27415', 'WARD', '776', 'Xóm Củi', 'Xom Cui'),
('27418', 'WARD', '776', 'Phường 5', 'Ward 5'),
('27421', 'WARD', '776', 'Phường 14', 'Ward 14'),
('27424', 'WARD', '776', 'Phường 6', 'Ward 6'),
('27427', 'WARD', '776', 'Phường 15', 'Ward 15'),
('27430', 'WARD', '776', 'Phường 16', 'Ward 16'),
('27433', 'WARD', '776', 'Phường 7', 'Ward 7')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 777 - Bình Tân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27436', 'WARD', '777', 'Bình Hưng Hòa', 'Binh Hung Hoa'),
('27439', 'WARD', '777', 'Bình Hưng Hoà A', 'Binh Hung Hoa A'),
('27442', 'WARD', '777', 'Bình Hưng Hoà B', 'Binh Hung Hoa B'),
('27445', 'WARD', '777', 'Bình Trị Đông', 'Binh Tri Dong'),
('27448', 'WARD', '777', 'Bình Trị Đông A', 'Binh Tri Dong A'),
('27451', 'WARD', '777', 'Bình Trị Đông B', 'Binh Tri Dong B'),
('27454', 'WARD', '777', 'Tân Tạo', 'Tan Tao'),
('27457', 'WARD', '777', 'Tân Tạo A', 'Tan Tao A'),
('27460', 'WARD', '777', 'An Lạc', 'An Lac'),
('27463', 'WARD', '777', 'An Lạc A', 'An Lac A')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 778 - 7
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27466', 'WARD', '778', 'Tân Thuận Đông', 'Tan Thuan Dong'),
('27469', 'WARD', '778', 'Tân Thuận Tây', 'Tan Thuan Tay'),
('27472', 'WARD', '778', 'Tân Kiểng', 'Tan Kieng'),
('27475', 'WARD', '778', 'Tân Hưng', 'Tan Hung'),
('27478', 'WARD', '778', 'Bình Thuận', 'Binh Thuan'),
('27481', 'WARD', '778', 'Tân Quy', 'Tan Quy'),
('27484', 'WARD', '778', 'Phú Thuận', 'Phu Thuan'),
('27487', 'WARD', '778', 'Tân Phú', 'Tan Phu'),
('27490', 'WARD', '778', 'Tân Phong', 'Tan Phong'),
('27493', 'WARD', '778', 'Phú Mỹ', 'Phu My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 783 - Củ Chi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27496', 'WARD', '783', 'Thị trấn Củ Chi', 'Thi tran Cu Chi'),
('27499', 'WARD', '783', 'Phú Mỹ Hưng', 'Phu My Hung'),
('27502', 'WARD', '783', 'An Phú', 'An Phu'),
('27505', 'WARD', '783', 'Trung Lập Thượng', 'Trung Lap Thuong'),
('27508', 'WARD', '783', 'An Nhơn Tây', 'An Nhon Tay'),
('27511', 'WARD', '783', 'Nhuận Đức', 'Nhuan Duc'),
('27514', 'WARD', '783', 'Phạm Văn Cội', 'Pham Van Coi'),
('27517', 'WARD', '783', 'Phú Hòa Đông', 'Phu Hoa Dong'),
('27520', 'WARD', '783', 'Trung Lập Hạ', 'Trung Lap Ha'),
('27523', 'WARD', '783', 'Trung An', 'Trung An'),
('27526', 'WARD', '783', 'Phước Thạnh', 'Phuoc Thanh'),
('27529', 'WARD', '783', 'Phước Hiệp', 'Phuoc Hiep'),
('27532', 'WARD', '783', 'Tân An Hội', 'Tan An Hoi'),
('27535', 'WARD', '783', 'Phước Vĩnh An', 'Phuoc Vinh An'),
('27538', 'WARD', '783', 'Thái Mỹ', 'Thai My'),
('27541', 'WARD', '783', 'Tân Thạnh Tây', 'Tan Thanh Tay'),
('27544', 'WARD', '783', 'Hòa Phú', 'Hoa Phu'),
('27547', 'WARD', '783', 'Tân Thạnh Đông', 'Tan Thanh Dong'),
('27550', 'WARD', '783', 'Bình Mỹ', 'Binh My'),
('27553', 'WARD', '783', 'Tân Phú Trung', 'Tan Phu Trung'),
('27556', 'WARD', '783', 'Tân Thông Hội', 'Tan Thong Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 784 - Hóc Môn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27559', 'WARD', '784', 'Thị trấn Hóc Môn', 'Thi tran Hoc Mon'),
('27562', 'WARD', '784', 'Tân Hiệp', 'Tan Hiep'),
('27565', 'WARD', '784', 'Nhị Bình', 'Nhi Binh'),
('27568', 'WARD', '784', 'Đông Thạnh', 'Dong Thanh'),
('27571', 'WARD', '784', 'Tân Thới Nhì', 'Tan Thoi Nhi'),
('27574', 'WARD', '784', 'Thới Tam Thôn', 'Thoi Tam Thon'),
('27577', 'WARD', '784', 'Xuân Thới Sơn', 'Xuan Thoi Son'),
('27580', 'WARD', '784', 'Tân Xuân', 'Tan Xuan'),
('27583', 'WARD', '784', 'Xuân Thới Đông', 'Xuan Thoi Dong'),
('27586', 'WARD', '784', 'Trung Chánh', 'Trung Chanh'),
('27589', 'WARD', '784', 'Xuân Thới Thượng', 'Xuan Thoi Thuong'),
('27592', 'WARD', '784', 'Bà Điểm', 'Ba Diem')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 785 - Bình Chánh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27595', 'WARD', '785', 'Thị trấn Tân Túc', 'Thi tran Tan Tuc'),
('27598', 'WARD', '785', 'Phạm Văn Hai', 'Pham Van Hai'),
('27601', 'WARD', '785', 'Vĩnh Lộc A', 'Vinh Loc A'),
('27604', 'WARD', '785', 'Vĩnh Lộc B', 'Vinh Loc B'),
('27607', 'WARD', '785', 'Bình Lợi', 'Binh Loi'),
('27610', 'WARD', '785', 'Lê Minh Xuân', 'Le Minh Xuan'),
('27613', 'WARD', '785', 'Tân Nhựt', 'Tan Nhut'),
('27616', 'WARD', '785', 'Tân Kiên', 'Tan Kien'),
('27619', 'WARD', '785', 'Bình Hưng', 'Binh Hung'),
('27622', 'WARD', '785', 'Phong Phú', 'Phong Phu'),
('27625', 'WARD', '785', 'An Phú Tây', 'An Phu Tay'),
('27628', 'WARD', '785', 'Hưng Long', 'Hung Long'),
('27631', 'WARD', '785', 'Đa Phước', 'Da Phuoc'),
('27634', 'WARD', '785', 'Tân Quý Tây', 'Tan Quy Tay'),
('27637', 'WARD', '785', 'Bình Chánh', 'Binh Chanh'),
('27640', 'WARD', '785', 'Quy Đức', 'Quy Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 786 - Nhà Bè
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27643', 'WARD', '786', 'Thị trấn Nhà Bè', 'Thi tran Nha Be'),
('27646', 'WARD', '786', 'Phước Kiển', 'Phuoc Kien'),
('27649', 'WARD', '786', 'Phước Lộc', 'Phuoc Loc'),
('27652', 'WARD', '786', 'Nhơn Đức', 'Nhon Duc'),
('27655', 'WARD', '786', 'Phú Xuân', 'Phu Xuan'),
('27658', 'WARD', '786', 'Long Thới', 'Long Thoi'),
('27661', 'WARD', '786', 'Hiệp Phước', 'Hiep Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 787 - Cần Giờ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27664', 'WARD', '787', 'Thị trấn Cần Thạnh', 'Thi tran Can Thanh'),
('27667', 'WARD', '787', 'Bình Khánh', 'Binh Khanh'),
('27670', 'WARD', '787', 'Tam Thôn Hiệp', 'Tam Thon Hiep'),
('27673', 'WARD', '787', 'An Thới Đông', 'An Thoi Dong'),
('27676', 'WARD', '787', 'Thạnh An', 'Thanh An'),
('27679', 'WARD', '787', 'Long Hòa', 'Long Hoa'),
('27682', 'WARD', '787', 'Lý Nhơn', 'Ly Nhon')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 80 - Long An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('794', 'DISTRICT', '80', 'Tân An', 'Thanh pho Tan An'),
('795', 'DISTRICT', '80', 'Thị Kiến Tường', 'Thi Kien Tuong'),
('796', 'DISTRICT', '80', 'Tân Hưng', 'Tan Hung'),
('797', 'DISTRICT', '80', 'Vĩnh Hưng', 'Vinh Hung'),
('798', 'DISTRICT', '80', 'Mộc Hóa', 'Moc Hoa'),
('799', 'DISTRICT', '80', 'Tân Thạnh', 'Tan Thanh'),
('800', 'DISTRICT', '80', 'Thạnh Hóa', 'Thanh Hoa'),
('801', 'DISTRICT', '80', 'Đức Huệ', 'Duc Hue'),
('802', 'DISTRICT', '80', 'Đức Hòa', 'Duc Hoa'),
('803', 'DISTRICT', '80', 'Bến Lức', 'Ben Luc'),
('804', 'DISTRICT', '80', 'Thủ Thừa', 'Thu Thua'),
('805', 'DISTRICT', '80', 'Tân Trụ', 'Tan Tru'),
('806', 'DISTRICT', '80', 'Cần Đước', 'Can Duoc'),
('807', 'DISTRICT', '80', 'Cần Giuộc', 'Can Giuoc'),
('808', 'DISTRICT', '80', 'Châu Thành', 'Chau Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 794 - Tân An
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27685', 'WARD', '794', 'Phường 5', 'Ward 5'),
('27691', 'WARD', '794', 'Phường 4', 'Ward 4'),
('27692', 'WARD', '794', 'Tân Khánh', 'Tan Khanh'),
('27694', 'WARD', '794', 'Phường 1', 'Ward 1'),
('27697', 'WARD', '794', 'Phường 3', 'Ward 3'),
('27698', 'WARD', '794', 'Phường 7', 'Ward 7'),
('27700', 'WARD', '794', 'Phường 6', 'Ward 6'),
('27703', 'WARD', '794', 'Hướng Thọ Phú', 'Huong Tho Phu'),
('27706', 'WARD', '794', 'Nhơn Thạnh Trung', 'Nhon Thanh Trung'),
('27709', 'WARD', '794', 'Lợi Bình Nhơn', 'Loi Binh Nhon'),
('27712', 'WARD', '794', 'Bình Tâm', 'Binh Tam'),
('27715', 'WARD', '794', 'Khánh Hậu', 'Khanh Hau'),
('27718', 'WARD', '794', 'An Vĩnh Ngãi', 'An Vinh Ngai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 795 - Thị Kiến Tường
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27787', 'WARD', '795', 'Phường 1', 'Ward 1'),
('27788', 'WARD', '795', 'Phường 2', 'Ward 2'),
('27790', 'WARD', '795', 'Thạnh Trị', 'Thanh Tri'),
('27793', 'WARD', '795', 'Bình Hiệp', 'Binh Hiep'),
('27799', 'WARD', '795', 'Bình Tân', 'Binh Tan'),
('27805', 'WARD', '795', 'Tuyên Thạnh', 'Tuyen Thanh'),
('27806', 'WARD', '795', 'Phường 3', 'Ward 3'),
('27817', 'WARD', '795', 'Thạnh Hưng', 'Thanh Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 796 - Tân Hưng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27721', 'WARD', '796', 'Thị trấn Tân Hưng', 'Thi tran Tan Hung'),
('27724', 'WARD', '796', 'Hưng Hà', 'Hung Ha'),
('27727', 'WARD', '796', 'Hưng Điền B', 'Hung Dien B'),
('27730', 'WARD', '796', 'Hưng Điền', 'Hung Dien'),
('27733', 'WARD', '796', 'Thạnh Hưng', 'Thanh Hung'),
('27736', 'WARD', '796', 'Hưng Thạnh', 'Hung Thanh'),
('27739', 'WARD', '796', 'Vĩnh Thạnh', 'Vinh Thanh'),
('27742', 'WARD', '796', 'Vĩnh Châu B', 'Vinh Chau B'),
('27745', 'WARD', '796', 'Vĩnh Lợi', 'Vinh Loi'),
('27748', 'WARD', '796', 'Vĩnh Đại', 'Vinh Dai'),
('27751', 'WARD', '796', 'Vĩnh Châu A', 'Vinh Chau A'),
('27754', 'WARD', '796', 'Vĩnh Bửu', 'Vinh Buu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 797 - Vĩnh Hưng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27757', 'WARD', '797', 'Thị trấn Vĩnh Hưng', 'Thi tran Vinh Hung'),
('27760', 'WARD', '797', 'Hưng Điền A', 'Hung Dien A'),
('27763', 'WARD', '797', 'Khánh Hưng', 'Khanh Hung'),
('27766', 'WARD', '797', 'Thái Trị', 'Thai Tri'),
('27769', 'WARD', '797', 'Vĩnh Trị', 'Vinh Tri'),
('27772', 'WARD', '797', 'Thái Bình Trung', 'Thai Binh Trung'),
('27775', 'WARD', '797', 'Vĩnh Bình', 'Vinh Binh'),
('27778', 'WARD', '797', 'Vĩnh Thuận', 'Vinh Thuan'),
('27781', 'WARD', '797', 'Tuyên Bình', 'Tuyen Binh'),
('27784', 'WARD', '797', 'Tuyên Bình Tây', 'Tuyen Binh Tay')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 798 - Mộc Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27796', 'WARD', '798', 'Bình Hòa Tây', 'Binh Hoa Tay'),
('27802', 'WARD', '798', 'Bình Thạnh', 'Binh Thanh'),
('27808', 'WARD', '798', 'Bình Hòa Trung', 'Binh Hoa Trung'),
('27811', 'WARD', '798', 'Bình Hòa Đông', 'Binh Hoa Dong'),
('27814', 'WARD', '798', 'Thị trấn Bình Phong Thạnh', 'Thi tran Binh Phong Thanh'),
('27820', 'WARD', '798', 'Tân Lập', 'Tan Lap'),
('27823', 'WARD', '798', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 799 - Tân Thạnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27826', 'WARD', '799', 'Thị trấn Tân Thạnh', 'Thi tran Tan Thanh'),
('27829', 'WARD', '799', 'Bắc Hòa', 'Bac Hoa'),
('27832', 'WARD', '799', 'Hậu Thạnh Tây', 'Hau Thanh Tay'),
('27835', 'WARD', '799', 'Nhơn Hòa Lập', 'Nhon Hoa Lap'),
('27838', 'WARD', '799', 'Tân Lập', 'Tan Lap'),
('27841', 'WARD', '799', 'Hậu Thạnh Đông', 'Hau Thanh Dong'),
('27844', 'WARD', '799', 'Nhơn Hoà', 'Nhon Hoa'),
('27847', 'WARD', '799', 'Kiến Bình', 'Kien Binh'),
('27850', 'WARD', '799', 'Tân Thành', 'Tan Thanh'),
('27853', 'WARD', '799', 'Tân Bình', 'Tan Binh'),
('27856', 'WARD', '799', 'Tân Ninh', 'Tan Ninh'),
('27859', 'WARD', '799', 'Nhơn Ninh', 'Nhon Ninh'),
('27862', 'WARD', '799', 'Tân Hòa', 'Tan Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 800 - Thạnh Hóa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27865', 'WARD', '800', 'Thị trấn Thạnh Hóa', 'Thi tran Thanh Hoa'),
('27868', 'WARD', '800', 'Tân Hiệp', 'Tan Hiep'),
('27871', 'WARD', '800', 'Thuận Bình', 'Thuan Binh'),
('27874', 'WARD', '800', 'Thạnh Phước', 'Thanh Phuoc'),
('27877', 'WARD', '800', 'Thạnh Phú', 'Thanh Phu'),
('27880', 'WARD', '800', 'Thuận Nghĩa Hòa', 'Thuan Nghia Hoa'),
('27883', 'WARD', '800', 'Thủy Đông', 'Thuy Dong'),
('27886', 'WARD', '800', 'Thủy Tây', 'Thuy Tay'),
('27889', 'WARD', '800', 'Tân Tây', 'Tan Tay'),
('27892', 'WARD', '800', 'Tân Đông', 'Tan Dong'),
('27895', 'WARD', '800', 'Thạnh An', 'Thanh An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 801 - Đức Huệ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27898', 'WARD', '801', 'Thị trấn Đông Thành', 'Thi tran Dong Thanh'),
('27901', 'WARD', '801', 'Mỹ Quý Đông', 'My Quy Dong'),
('27904', 'WARD', '801', 'Mỹ Thạnh Bắc', 'My Thanh Bac'),
('27907', 'WARD', '801', 'Mỹ Quý Tây', 'My Quy Tay'),
('27910', 'WARD', '801', 'Mỹ Thạnh Tây', 'My Thanh Tay'),
('27913', 'WARD', '801', 'Mỹ Thạnh Đông', 'My Thanh Dong'),
('27916', 'WARD', '801', 'Bình Thành', 'Binh Thanh'),
('27919', 'WARD', '801', 'Bình Hòa Bắc', 'Binh Hoa Bac'),
('27922', 'WARD', '801', 'Bình Hòa Hưng', 'Binh Hoa Hung'),
('27925', 'WARD', '801', 'Bình Hòa Nam', 'Binh Hoa Nam'),
('27928', 'WARD', '801', 'Mỹ Bình', 'My Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 802 - Đức Hòa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27931', 'WARD', '802', 'Thị trấn Hậu Nghĩa', 'Thi tran Hau Nghia'),
('27934', 'WARD', '802', 'Thị trấn Hiệp Hòa', 'Thi tran Hiep Hoa'),
('27937', 'WARD', '802', 'Thị trấn Đức Hòa', 'Thi tran Duc Hoa'),
('27940', 'WARD', '802', 'Lộc Giang', 'Loc Giang'),
('27943', 'WARD', '802', 'An Ninh Đông', 'An Ninh Dong'),
('27946', 'WARD', '802', 'An Ninh Tây', 'An Ninh Tay'),
('27949', 'WARD', '802', 'Tân Mỹ', 'Tan My'),
('27952', 'WARD', '802', 'Hiệp Hòa', 'Hiep Hoa'),
('27955', 'WARD', '802', 'Đức Lập Thượng', 'Duc Lap Thuong'),
('27958', 'WARD', '802', 'Đức Lập Hạ', 'Duc Lap Ha'),
('27961', 'WARD', '802', 'Tân Phú', 'Tan Phu'),
('27964', 'WARD', '802', 'Mỹ Hạnh Bắc', 'My Hanh Bac'),
('27967', 'WARD', '802', 'Đức Hòa Thượng', 'Duc Hoa Thuong'),
('27970', 'WARD', '802', 'Hòa Khánh Tây', 'Hoa Khanh Tay'),
('27973', 'WARD', '802', 'Hòa Khánh Đông', 'Hoa Khanh Dong'),
('27976', 'WARD', '802', 'Mỹ Hạnh Nam', 'My Hanh Nam'),
('27979', 'WARD', '802', 'Hòa Khánh Nam', 'Hoa Khanh Nam'),
('27982', 'WARD', '802', 'Đức Hòa Đông', 'Duc Hoa Dong'),
('27985', 'WARD', '802', 'Đức Hòa Hạ', 'Duc Hoa Ha'),
('27988', 'WARD', '802', 'Hựu Thạnh', 'Huu Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 803 - Bến Lức
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('27991', 'WARD', '803', 'Thị trấn Bến Lức', 'Thi tran Ben Luc'),
('27994', 'WARD', '803', 'Thạnh Lợi', 'Thanh Loi'),
('27997', 'WARD', '803', 'Lương Bình', 'Luong Binh'),
('28000', 'WARD', '803', 'Thạnh Hòa', 'Thanh Hoa'),
('28003', 'WARD', '803', 'Lương Hòa', 'Luong Hoa'),
('28009', 'WARD', '803', 'Tân Bửu', 'Tan Buu'),
('28012', 'WARD', '803', 'An Thạnh', 'An Thanh'),
('28015', 'WARD', '803', 'Bình Đức', 'Binh Duc'),
('28018', 'WARD', '803', 'Mỹ Yên', 'My Yen'),
('28021', 'WARD', '803', 'Thanh Phú', 'Thanh Phu'),
('28024', 'WARD', '803', 'Long Hiệp', 'Long Hiep'),
('28027', 'WARD', '803', 'Thạnh Đức', 'Thanh Duc'),
('28030', 'WARD', '803', 'Phước Lợi', 'Phuoc Loi'),
('28033', 'WARD', '803', 'Nhựt Chánh', 'Nhut Chanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 804 - Thủ Thừa
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28036', 'WARD', '804', 'Thị trấn Thủ Thừa', 'Thi tran Thu Thua'),
('28039', 'WARD', '804', 'Long Thạnh', 'Long Thanh'),
('28042', 'WARD', '804', 'Tân Thành', 'Tan Thanh'),
('28045', 'WARD', '804', 'Long Thuận', 'Long Thuan'),
('28048', 'WARD', '804', 'Mỹ Lạc', 'My Lac'),
('28051', 'WARD', '804', 'Mỹ Thạnh', 'My Thanh'),
('28054', 'WARD', '804', 'Bình An', 'Binh An'),
('28057', 'WARD', '804', 'Nhị Thành', 'Nhi Thanh'),
('28060', 'WARD', '804', 'Mỹ An', 'My An'),
('28063', 'WARD', '804', 'Bình Thạnh', 'Binh Thanh'),
('28066', 'WARD', '804', 'Mỹ Phú', 'My Phu'),
('28072', 'WARD', '804', 'Tân Long', 'Tan Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 805 - Tân Trụ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28075', 'WARD', '805', 'Thị trấn Tân Trụ', 'Thi tran Tan Tru'),
('28078', 'WARD', '805', 'Tân Bình', 'Tan Binh'),
('28084', 'WARD', '805', 'Quê Mỹ Thạnh', 'Que My Thanh'),
('28087', 'WARD', '805', 'Lạc Tấn', 'Lac Tan'),
('28090', 'WARD', '805', 'Bình Trinh Đông', 'Binh Trinh Dong'),
('28093', 'WARD', '805', 'Tân Phước Tây', 'Tan Phuoc Tay'),
('28096', 'WARD', '805', 'Bình Lãng', 'Binh Lang'),
('28099', 'WARD', '805', 'Bình Tịnh', 'Binh Tinh'),
('28102', 'WARD', '805', 'Đức Tân', 'Duc Tan'),
('28105', 'WARD', '805', 'Nhựt Ninh', 'Nhut Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 806 - Cần Đước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28108', 'WARD', '806', 'Thị trấn Cần Đước', 'Thi tran Can Duoc'),
('28111', 'WARD', '806', 'Long Trạch', 'Long Trach'),
('28114', 'WARD', '806', 'Long Khê', 'Long Khe'),
('28117', 'WARD', '806', 'Long Định', 'Long Dinh'),
('28120', 'WARD', '806', 'Phước Vân', 'Phuoc Van'),
('28123', 'WARD', '806', 'Long Hòa', 'Long Hoa'),
('28126', 'WARD', '806', 'Long Cang', 'Long Cang'),
('28129', 'WARD', '806', 'Long Sơn', 'Long Son'),
('28132', 'WARD', '806', 'Tân Trạch', 'Tan Trach'),
('28135', 'WARD', '806', 'Mỹ Lệ', 'My Le'),
('28138', 'WARD', '806', 'Tân Lân', 'Tan Lan'),
('28141', 'WARD', '806', 'Phước Tuy', 'Phuoc Tuy'),
('28144', 'WARD', '806', 'Long Hựu Đông', 'Long Huu Dong'),
('28147', 'WARD', '806', 'Tân Ân', 'Tan An'),
('28150', 'WARD', '806', 'Phước Đông', 'Phuoc Dong'),
('28153', 'WARD', '806', 'Long Hựu Tây', 'Long Huu Tay'),
('28156', 'WARD', '806', 'Tân Chánh', 'Tan Chanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 807 - Cần Giuộc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28159', 'WARD', '807', 'Thị trấn Cần Giuộc', 'Thi tran Can Giuoc'),
('28162', 'WARD', '807', 'Phước Lý', 'Phuoc Ly'),
('28165', 'WARD', '807', 'Long Thượng', 'Long Thuong'),
('28168', 'WARD', '807', 'Long Hậu', 'Long Hau'),
('28174', 'WARD', '807', 'Phước Hậu', 'Phuoc Hau'),
('28177', 'WARD', '807', 'Mỹ Lộc', 'My Loc'),
('28180', 'WARD', '807', 'Phước Lại', 'Phuoc Lai'),
('28183', 'WARD', '807', 'Phước Lâm', 'Phuoc Lam'),
('28189', 'WARD', '807', 'Thuận Thành', 'Thuan Thanh'),
('28192', 'WARD', '807', 'Phước Vĩnh Tây', 'Phuoc Vinh Tay'),
('28195', 'WARD', '807', 'Phước Vĩnh Đông', 'Phuoc Vinh Dong'),
('28198', 'WARD', '807', 'Long An', 'Long An'),
('28201', 'WARD', '807', 'Long Phụng', 'Long Phung'),
('28204', 'WARD', '807', 'Đông Thạnh', 'Dong Thanh'),
('28207', 'WARD', '807', 'Tân Tập', 'Tan Tap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 808 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28210', 'WARD', '808', 'Thị trấn Tầm Vu', 'Thi tran Tam Vu'),
('28213', 'WARD', '808', 'Bình Quới', 'Binh Quoi'),
('28216', 'WARD', '808', 'Hòa Phú', 'Hoa Phu'),
('28219', 'WARD', '808', 'Phú Ngãi Trị', 'Phu Ngai Tri'),
('28222', 'WARD', '808', 'Vĩnh Công', 'Vinh Cong'),
('28225', 'WARD', '808', 'Thuận Mỹ', 'Thuan My'),
('28228', 'WARD', '808', 'Hiệp Thạnh', 'Hiep Thanh'),
('28231', 'WARD', '808', 'Phước Tân Hưng', 'Phuoc Tan Hung'),
('28234', 'WARD', '808', 'Thanh Phú Long', 'Thanh Phu Long'),
('28237', 'WARD', '808', 'Dương Xuân Hội', 'Duong Xuan Hoi'),
('28240', 'WARD', '808', 'An Lục Long', 'An Luc Long'),
('28243', 'WARD', '808', 'Long Trì', 'Long Tri'),
('28246', 'WARD', '808', 'Thanh Vĩnh Đông', 'Thanh Vinh Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 82 - Tiền Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('815', 'DISTRICT', '82', 'Mỹ Tho', 'Thanh pho My Tho'),
('816', 'DISTRICT', '82', 'Gò Công', 'Thanh pho Go Cong'),
('817', 'DISTRICT', '82', 'Thị Cai Lậy', 'Thi Cai Lay'),
('818', 'DISTRICT', '82', 'Tân Phước', 'Tan Phuoc'),
('819', 'DISTRICT', '82', 'Cái Bè', 'Cai Be'),
('820', 'DISTRICT', '82', 'Cai Lậy', 'Cai Lay'),
('821', 'DISTRICT', '82', 'Châu Thành', 'Chau Thanh'),
('822', 'DISTRICT', '82', 'Chợ Gạo', 'Cho Gao'),
('823', 'DISTRICT', '82', 'Gò Công Tây', 'Go Cong Tay'),
('824', 'DISTRICT', '82', 'Gò Công Đông', 'Go Cong Dong'),
('825', 'DISTRICT', '82', 'Tân Phú Đông', 'Tan Phu Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 815 - Mỹ Tho
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28249', 'WARD', '815', 'Phường 5', 'Ward 5'),
('28252', 'WARD', '815', 'Phường 4', 'Ward 4'),
('28261', 'WARD', '815', 'Phường 1', 'Ward 1'),
('28264', 'WARD', '815', 'Phường 2', 'Ward 2'),
('28270', 'WARD', '815', 'Phường 6', 'Ward 6'),
('28273', 'WARD', '815', 'Phường 9', 'Ward 9'),
('28276', 'WARD', '815', 'Phường 10', 'Ward 10'),
('28279', 'WARD', '815', 'Tân Long', 'Tan Long'),
('28282', 'WARD', '815', 'Đạo Thạnh', 'Dao Thanh'),
('28285', 'WARD', '815', 'Trung An', 'Trung An'),
('28288', 'WARD', '815', 'Mỹ Phong', 'My Phong'),
('28291', 'WARD', '815', 'Tân Mỹ Chánh', 'Tan My Chanh'),
('28567', 'WARD', '815', 'Phước Thạnh', 'Phuoc Thanh'),
('28591', 'WARD', '815', 'Thới Sơn', 'Thoi Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 816 - Gò Công
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28297', 'WARD', '816', 'Phường 2', 'Ward 2'),
('28300', 'WARD', '816', 'Phường 1', 'Ward 1'),
('28306', 'WARD', '816', 'Phường 5', 'Ward 5'),
('28309', 'WARD', '816', 'Long Hưng', 'Long Hung'),
('28312', 'WARD', '816', 'Long Thuận', 'Long Thuan'),
('28315', 'WARD', '816', 'Long Chánh', 'Long Chanh'),
('28318', 'WARD', '816', 'Long Hòa', 'Long Hoa'),
('28708', 'WARD', '816', 'Bình Đông', 'Binh Dong'),
('28717', 'WARD', '816', 'Bình Xuân', 'Binh Xuan'),
('28729', 'WARD', '816', 'Tân Trung', 'Tan Trung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 817 - Thị Cai Lậy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28435', 'WARD', '817', 'Phường 1', 'Ward 1'),
('28436', 'WARD', '817', 'Phường 2', 'Ward 2'),
('28437', 'WARD', '817', 'Phường 3', 'Ward 3'),
('28439', 'WARD', '817', 'Phường 4', 'Ward 4'),
('28440', 'WARD', '817', 'Phường 5', 'Ward 5'),
('28447', 'WARD', '817', 'Mỹ Phước Tây', 'My Phuoc Tay'),
('28450', 'WARD', '817', 'Mỹ Hạnh Đông', 'My Hanh Dong'),
('28453', 'WARD', '817', 'Mỹ Hạnh Trung', 'My Hanh Trung'),
('28459', 'WARD', '817', 'Tân Phú', 'Tan Phu'),
('28462', 'WARD', '817', 'Tân Bình', 'Tan Binh'),
('28468', 'WARD', '817', 'Tân Hội', 'Tan Hoi'),
('28474', 'WARD', '817', 'Nhị Mỹ', 'Nhi My'),
('28477', 'WARD', '817', 'Nhị Quý', 'Nhi Quy'),
('28480', 'WARD', '817', 'Thanh Hòa', 'Thanh Hoa'),
('28483', 'WARD', '817', 'Phú Quý', 'Phu Quy'),
('28486', 'WARD', '817', 'Long Khánh', 'Long Khanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 818 - Tân Phước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28321', 'WARD', '818', 'Thị trấn Mỹ Phước', 'Thi tran My Phuoc'),
('28324', 'WARD', '818', 'Tân Hòa Đông', 'Tan Hoa Dong'),
('28327', 'WARD', '818', 'Thạnh Tân', 'Thanh Tan'),
('28330', 'WARD', '818', 'Thạnh Mỹ', 'Thanh My'),
('28333', 'WARD', '818', 'Thạnh Hoà', 'Thanh Hoa'),
('28336', 'WARD', '818', 'Phú Mỹ', 'Phu My'),
('28339', 'WARD', '818', 'Tân Hòa Thành', 'Tan Hoa Thanh'),
('28342', 'WARD', '818', 'Hưng Thạnh', 'Hung Thanh'),
('28345', 'WARD', '818', 'Tân Lập 1', 'Tan Lap 1'),
('28348', 'WARD', '818', 'Tân Hòa Tây', 'Tan Hoa Tay'),
('28354', 'WARD', '818', 'Tân Lập 2', 'Tan Lap 2'),
('28357', 'WARD', '818', 'Phước Lập', 'Phuoc Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 819 - Cái Bè
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28360', 'WARD', '819', 'Thị trấn Cái Bè', 'Thi tran Cai Be'),
('28363', 'WARD', '819', 'Hậu Mỹ Bắc B', 'Hau My Bac B'),
('28366', 'WARD', '819', 'Hậu Mỹ Bắc A', 'Hau My Bac A'),
('28369', 'WARD', '819', 'Mỹ Trung', 'My Trung'),
('28372', 'WARD', '819', 'Hậu Mỹ Trinh', 'Hau My Trinh'),
('28375', 'WARD', '819', 'Hậu Mỹ Phú', 'Hau My Phu'),
('28378', 'WARD', '819', 'Mỹ Tân', 'My Tan'),
('28381', 'WARD', '819', 'Mỹ Lợi B', 'My Loi B'),
('28384', 'WARD', '819', 'Thiện Trung', 'Thien Trung'),
('28387', 'WARD', '819', 'Mỹ Hội', 'My Hoi'),
('28390', 'WARD', '819', 'An Cư', 'An Cu'),
('28393', 'WARD', '819', 'Hậu Thành', 'Hau Thanh'),
('28396', 'WARD', '819', 'Mỹ Lợi A', 'My Loi A'),
('28399', 'WARD', '819', 'Hòa Khánh', 'Hoa Khanh'),
('28402', 'WARD', '819', 'Thiện Trí', 'Thien Tri'),
('28405', 'WARD', '819', 'Mỹ Đức Đông', 'My Duc Dong'),
('28408', 'WARD', '819', 'Mỹ Đức Tây', 'My Duc Tay'),
('28411', 'WARD', '819', 'Đông Hòa Hiệp', 'Dong Hoa Hiep'),
('28414', 'WARD', '819', 'An Thái Đông', 'An Thai Dong'),
('28417', 'WARD', '819', 'Tân Hưng', 'Tan Hung'),
('28420', 'WARD', '819', 'Mỹ Lương', 'My Luong'),
('28423', 'WARD', '819', 'Tân Thanh', 'Tan Thanh'),
('28426', 'WARD', '819', 'An Thái Trung', 'An Thai Trung'),
('28429', 'WARD', '819', 'An Hữu', 'An Huu'),
('28432', 'WARD', '819', 'Hòa Hưng', 'Hoa Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 820 - Cai Lậy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28438', 'WARD', '820', 'Thạnh Lộc', 'Thanh Loc'),
('28441', 'WARD', '820', 'Mỹ Thành Bắc', 'My Thanh Bac'),
('28444', 'WARD', '820', 'Phú Cường', 'Phu Cuong'),
('28456', 'WARD', '820', 'Mỹ Thành Nam', 'My Thanh Nam'),
('28465', 'WARD', '820', 'Phú Nhuận', 'Phu Nhuan'),
('28471', 'WARD', '820', 'Thị trấn Bình Phú', 'Thi tran Binh Phu'),
('28489', 'WARD', '820', 'Cẩm Sơn', 'Cam Son'),
('28492', 'WARD', '820', 'Phú An', 'Phu An'),
('28495', 'WARD', '820', 'Mỹ Long', 'My Long'),
('28498', 'WARD', '820', 'Long Tiên', 'Long Tien'),
('28501', 'WARD', '820', 'Hiệp Đức', 'Hiep Duc'),
('28504', 'WARD', '820', 'Long Trung', 'Long Trung'),
('28507', 'WARD', '820', 'Hội Xuân', 'Hoi Xuan'),
('28510', 'WARD', '820', 'Tân Phong', 'Tan Phong'),
('28513', 'WARD', '820', 'Tam Bình', 'Tam Binh'),
('28516', 'WARD', '820', 'Ngũ Hiệp', 'Ngu Hiep')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 821 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28519', 'WARD', '821', 'Thị trấn Tân Hiệp', 'Thi tran Tan Hiep'),
('28522', 'WARD', '821', 'Tân Hội Đông', 'Tan Hoi Dong'),
('28525', 'WARD', '821', 'Tân Hương', 'Tan Huong'),
('28528', 'WARD', '821', 'Tân Lý Đông', 'Tan Ly Dong'),
('28534', 'WARD', '821', 'Thân Cửu Nghĩa', 'Than Cuu Nghia'),
('28537', 'WARD', '821', 'Tam Hiệp', 'Tam Hiep'),
('28540', 'WARD', '821', 'Điềm Hy', 'Diem Hy'),
('28543', 'WARD', '821', 'Nhị Bình', 'Nhi Binh'),
('28549', 'WARD', '821', 'Đông Hòa', 'Dong Hoa'),
('28552', 'WARD', '821', 'Long Định', 'Long Dinh'),
('28558', 'WARD', '821', 'Long An', 'Long An'),
('28561', 'WARD', '821', 'Long Hưng', 'Long Hung'),
('28564', 'WARD', '821', 'Bình Trưng', 'Binh Trung'),
('28570', 'WARD', '821', 'Thạnh Phú', 'Thanh Phu'),
('28573', 'WARD', '821', 'Bàn Long', 'Ban Long'),
('28576', 'WARD', '821', 'Vĩnh Kim', 'Vinh Kim'),
('28579', 'WARD', '821', 'Bình Đức', 'Binh Duc'),
('28582', 'WARD', '821', 'Song Thuận', 'Song Thuan'),
('28585', 'WARD', '821', 'Kim Sơn', 'Kim Son'),
('28588', 'WARD', '821', 'Phú Phong', 'Phu Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 822 - Chợ Gạo
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28594', 'WARD', '822', 'Thị trấn Chợ Gạo', 'Thi tran Cho Gao'),
('28597', 'WARD', '822', 'Trung Hòa', 'Trung Hoa'),
('28600', 'WARD', '822', 'Hòa Tịnh', 'Hoa Tinh'),
('28603', 'WARD', '822', 'Mỹ Tịnh An', 'My An'),
('28606', 'WARD', '822', 'Tân Bình Thạnh', 'Tan Binh Thanh'),
('28609', 'WARD', '822', 'Phú Kiết', 'Phu Kiet'),
('28612', 'WARD', '822', 'Lương Hòa Lạc', 'Luong Hoa Lac'),
('28615', 'WARD', '822', 'Thanh Bình', 'Thanh Binh'),
('28618', 'WARD', '822', 'Quơn Long', 'Quon Long'),
('28621', 'WARD', '822', 'Bình Phục Nhứt', 'Binh Phuc Nhut'),
('28624', 'WARD', '822', 'Đăng Hưng Phước', 'Dang Hung Phuoc'),
('28627', 'WARD', '822', 'Tân Thuận Bình', 'Tan Thuan Binh'),
('28630', 'WARD', '822', 'Song Bình', 'Song Binh'),
('28633', 'WARD', '822', 'Bình Phan', 'Binh Phan'),
('28636', 'WARD', '822', 'Long Bình Điền', 'Long Binh Dien'),
('28639', 'WARD', '822', 'An Thạnh Thủy', 'An Thanh Thuy'),
('28642', 'WARD', '822', 'Xuân Đông', 'Xuan Dong'),
('28645', 'WARD', '822', 'Hòa Định', 'Hoa Dinh'),
('28648', 'WARD', '822', 'Bình Ninh', 'Binh Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 823 - Gò Công Tây
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28651', 'WARD', '823', 'Thị trấn Vĩnh Bình', 'Thi tran Vinh Binh'),
('28654', 'WARD', '823', 'Đồng Sơn', 'Dong Son'),
('28657', 'WARD', '823', 'Bình Phú', 'Binh Phu'),
('28660', 'WARD', '823', 'Đồng Thạnh', 'Dong Thanh'),
('28663', 'WARD', '823', 'Thành Công', 'Thanh Cong'),
('28666', 'WARD', '823', 'Bình Nhì', 'Binh Nhi'),
('28669', 'WARD', '823', 'Yên Luông', 'Yen Luong'),
('28672', 'WARD', '823', 'Thạnh Trị', 'Thanh Tri'),
('28675', 'WARD', '823', 'Thạnh Nhựt', 'Thanh Nhut'),
('28678', 'WARD', '823', 'Long Vĩnh', 'Long Vinh'),
('28681', 'WARD', '823', 'Bình Tân', 'Binh Tan'),
('28684', 'WARD', '823', 'Vĩnh Hựu', 'Vinh Huu'),
('28687', 'WARD', '823', 'Long Bình', 'Long Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 824 - Gò Công Đông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28702', 'WARD', '824', 'Thị trấn Tân Hòa', 'Thi tran Tan Hoa'),
('28705', 'WARD', '824', 'Tăng Hoà', 'Tang Hoa'),
('28711', 'WARD', '824', 'Tân Phước', 'Tan Phuoc'),
('28714', 'WARD', '824', 'Gia Thuận', 'Gia Thuan'),
('28720', 'WARD', '824', 'Thị trấn Vàm Láng', 'Thi tran Vam Lang'),
('28723', 'WARD', '824', 'Tân Tây', 'Tan Tay'),
('28726', 'WARD', '824', 'Kiểng Phước', 'Kieng Phuoc'),
('28732', 'WARD', '824', 'Tân Đông', 'Tan Dong'),
('28735', 'WARD', '824', 'Bình Ân', 'Binh An'),
('28738', 'WARD', '824', 'Tân Điền', 'Tan Dien'),
('28741', 'WARD', '824', 'Bình Nghị', 'Binh Nghi'),
('28744', 'WARD', '824', 'Phước Trung', 'Phuoc Trung'),
('28747', 'WARD', '824', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 825 - Tân Phú Đông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28690', 'WARD', '825', 'Tân Thới', 'Tan Thoi'),
('28693', 'WARD', '825', 'Tân Phú', 'Tan Phu'),
('28696', 'WARD', '825', 'Phú Thạnh', 'Phu Thanh'),
('28699', 'WARD', '825', 'Tân Thạnh', 'Tan Thanh'),
('28750', 'WARD', '825', 'Phú Đông', 'Phu Dong'),
('28753', 'WARD', '825', 'Phú Tân', 'Phu Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 83 - Bến Tre
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('829', 'DISTRICT', '83', 'Bến Tre', 'Thanh pho Ben Tre'),
('831', 'DISTRICT', '83', 'Châu Thành', 'Chau Thanh'),
('832', 'DISTRICT', '83', 'Chợ Lách', 'Cho Lach'),
('833', 'DISTRICT', '83', 'Mỏ Cày Nam', 'Mo Cay Nam'),
('834', 'DISTRICT', '83', 'Giồng Trôm', 'Giong Trom'),
('835', 'DISTRICT', '83', 'Bình Đại', 'Binh Dai'),
('836', 'DISTRICT', '83', 'Ba Tri', 'Ba Tri'),
('837', 'DISTRICT', '83', 'Thạnh Phú', 'Thanh Phu'),
('838', 'DISTRICT', '83', 'Mỏ Cày Bắc', 'Mo Cay Bac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 829 - Bến Tre
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28756', 'WARD', '829', 'Phú Khương', 'Phu Khuong'),
('28757', 'WARD', '829', 'Phú Tân', 'Phu Tan'),
('28759', 'WARD', '829', 'Phường 8', 'Ward 8'),
('28762', 'WARD', '829', 'Phường 6', 'Ward 6'),
('28777', 'WARD', '829', 'An Hội', 'An Hoi'),
('28780', 'WARD', '829', 'Phường 7', 'Ward 7'),
('28783', 'WARD', '829', 'Sơn Đông', 'Son Dong'),
('28786', 'WARD', '829', 'Phú Hưng', 'Phu Hung'),
('28789', 'WARD', '829', 'Bình Phú', 'Binh Phu'),
('28792', 'WARD', '829', 'Mỹ Thạnh An', 'My Thanh An'),
('28795', 'WARD', '829', 'Nhơn Thạnh', 'Nhon Thanh'),
('28798', 'WARD', '829', 'Phú Nhuận', 'Phu Nhuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 831 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28804', 'WARD', '831', 'Tân Thạch', 'Tan Thach'),
('28807', 'WARD', '831', 'Qưới Sơn', 'Quoi Son'),
('28810', 'WARD', '831', 'Thị trấn Châu Thành', 'Thi tran Chau Thanh'),
('28813', 'WARD', '831', 'Giao Long', 'Giao Long'),
('28819', 'WARD', '831', 'Phú Túc', 'Phu Tuc'),
('28822', 'WARD', '831', 'Phú Đức', 'Phu Duc'),
('28828', 'WARD', '831', 'An Phước', 'An Phuoc'),
('28831', 'WARD', '831', 'Tam Phước', 'Tam Phuoc'),
('28834', 'WARD', '831', 'Thành Triệu', 'Thanh Trieu'),
('28840', 'WARD', '831', 'Tân Phú', 'Tan Phu'),
('28843', 'WARD', '831', 'Quới Thành', 'Quoi Thanh'),
('28846', 'WARD', '831', 'Phước Thạnh', 'Phuoc Thanh'),
('28852', 'WARD', '831', 'Tiên Long', 'Tien Long'),
('28855', 'WARD', '831', 'Tường Đa', 'Tuong Da'),
('28858', 'WARD', '831', 'Hữu Định', 'Huu Dinh'),
('28861', 'WARD', '831', 'Thị trấn Tiên Thủy', 'Thi tran Tien Thuy')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 832 - Chợ Lách
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28870', 'WARD', '832', 'Thị trấn Chợ Lách', 'Thi tran Cho Lach'),
('28873', 'WARD', '832', 'Phú Phụng', 'Phu Phung'),
('28876', 'WARD', '832', 'Sơn Định', 'Son Dinh'),
('28879', 'WARD', '832', 'Vĩnh Bình', 'Vinh Binh'),
('28882', 'WARD', '832', 'Hòa Nghĩa', 'Hoa Nghia'),
('28885', 'WARD', '832', 'Long Thới', 'Long Thoi'),
('28888', 'WARD', '832', 'Phú Sơn', 'Phu Son'),
('28891', 'WARD', '832', 'Tân Thiềng', 'Tan Thieng'),
('28894', 'WARD', '832', 'Vĩnh Thành', 'Vinh Thanh'),
('28897', 'WARD', '832', 'Vĩnh Hòa', 'Vinh Hoa'),
('28900', 'WARD', '832', 'Hưng Khánh Trung B', 'Hung Khanh Trung B')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 833 - Mỏ Cày Nam
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28903', 'WARD', '833', 'Thị trấn Mỏ Cày', 'Thi tran Mo Cay'),
('28930', 'WARD', '833', 'Định Thủy', 'Dinh Thuy'),
('28939', 'WARD', '833', 'Đa Phước Hội', 'Da Phuoc Hoi'),
('28940', 'WARD', '833', 'Tân Hội', 'Tan Hoi'),
('28942', 'WARD', '833', 'Phước Hiệp', 'Phuoc Hiep'),
('28945', 'WARD', '833', 'Bình Khánh', 'Binh Khanh'),
('28951', 'WARD', '833', 'An Thạnh', 'An Thanh'),
('28957', 'WARD', '833', 'An Định', 'An Dinh'),
('28960', 'WARD', '833', 'Thành Thới B', 'Thanh Thoi B'),
('28963', 'WARD', '833', 'Tân Trung', 'Tan Trung'),
('28966', 'WARD', '833', 'An Thới', 'An Thoi'),
('28969', 'WARD', '833', 'Thành Thới A', 'Thanh Thoi A'),
('28972', 'WARD', '833', 'Minh Đức', 'Minh Duc'),
('28975', 'WARD', '833', 'Ngãi Đăng', 'Ngai Dang'),
('28978', 'WARD', '833', 'Cẩm Sơn', 'Cam Son'),
('28981', 'WARD', '833', 'Hương Mỹ', 'Huong My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 834 - Giồng Trôm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28984', 'WARD', '834', 'Thị trấn Giồng Trôm', 'Thi tran Giong Trom'),
('28987', 'WARD', '834', 'Phong Nẫm', 'Phong Nam'),
('28993', 'WARD', '834', 'Mỹ Thạnh', 'My Thanh'),
('28996', 'WARD', '834', 'Châu Hòa', 'Chau Hoa'),
('28999', 'WARD', '834', 'Lương Hòa', 'Luong Hoa'),
('29002', 'WARD', '834', 'Lương Quới', 'Luong Quoi'),
('29005', 'WARD', '834', 'Lương Phú', 'Luong Phu'),
('29008', 'WARD', '834', 'Châu Bình', 'Chau Binh'),
('29011', 'WARD', '834', 'Thuận Điền', 'Thuan Dien'),
('29014', 'WARD', '834', 'Sơn Phú', 'Son Phu'),
('29017', 'WARD', '834', 'Bình Hoà', 'Binh Hoa'),
('29020', 'WARD', '834', 'Phước Long', 'Phuoc Long'),
('29023', 'WARD', '834', 'Hưng Phong', 'Hung Phong'),
('29026', 'WARD', '834', 'Long Mỹ', 'Long My'),
('29029', 'WARD', '834', 'Tân Hào', 'Tan Hao'),
('29032', 'WARD', '834', 'Bình Thành', 'Binh Thanh'),
('29035', 'WARD', '834', 'Tân Thanh', 'Tan Thanh'),
('29038', 'WARD', '834', 'Tân Lợi Thạnh', 'Tan Loi Thanh'),
('29041', 'WARD', '834', 'Thạnh Phú Đông', 'Thanh Phu Dong'),
('29044', 'WARD', '834', 'Hưng Nhượng', 'Hung Nhuong'),
('29047', 'WARD', '834', 'Hưng Lễ', 'Hung Le')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 835 - Bình Đại
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29050', 'WARD', '835', 'Thị trấn Bình Đại', 'Thi tran Binh Dai'),
('29053', 'WARD', '835', 'Tam Hiệp', 'Tam Hiep'),
('29056', 'WARD', '835', 'Long Định', 'Long Dinh'),
('29059', 'WARD', '835', 'Long Hòa', 'Long Hoa'),
('29062', 'WARD', '835', 'Phú Thuận', 'Phu Thuan'),
('29065', 'WARD', '835', 'Vang Quới Tây', 'Vang Quoi Tay'),
('29068', 'WARD', '835', 'Vang Quới Đông', 'Vang Quoi Dong'),
('29071', 'WARD', '835', 'Châu Hưng', 'Chau Hung'),
('29077', 'WARD', '835', 'Lộc Thuận', 'Loc Thuan'),
('29080', 'WARD', '835', 'Định Trung', 'Dinh Trung'),
('29083', 'WARD', '835', 'Thới Lai', 'Thoi Lai'),
('29086', 'WARD', '835', 'Bình Thới', 'Binh Thoi'),
('29089', 'WARD', '835', 'Phú Long', 'Phu Long'),
('29092', 'WARD', '835', 'Bình Thắng', 'Binh Thang'),
('29095', 'WARD', '835', 'Thạnh Trị', 'Thanh Tri'),
('29098', 'WARD', '835', 'Đại Hòa Lộc', 'Dai Hoa Loc'),
('29101', 'WARD', '835', 'Thừa Đức', 'Thua Duc'),
('29104', 'WARD', '835', 'Thạnh Phước', 'Thanh Phuoc'),
('29107', 'WARD', '835', 'Thới Thuận', 'Thoi Thuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 836 - Ba Tri
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29110', 'WARD', '836', 'Thị trấn Ba Tri', 'Thi tran Ba Tri'),
('29116', 'WARD', '836', 'Mỹ Hòa', 'My Hoa'),
('29119', 'WARD', '836', 'Tân Xuân', 'Tan Xuan'),
('29122', 'WARD', '836', 'Mỹ Chánh', 'My Chanh'),
('29125', 'WARD', '836', 'Bảo Thạnh', 'Bao Thanh'),
('29128', 'WARD', '836', 'An Phú Trung', 'An Phu Trung'),
('29131', 'WARD', '836', 'Mỹ Thạnh', 'My Thanh'),
('29134', 'WARD', '836', 'Mỹ Nhơn', 'My Nhon'),
('29137', 'WARD', '836', 'Phước Ngãi', 'Phuoc Ngai'),
('29143', 'WARD', '836', 'An Ngãi Trung', 'An Ngai Trung'),
('29146', 'WARD', '836', 'Phú Lễ', 'Phu Le'),
('29149', 'WARD', '836', 'An Bình Tây', 'An Binh Tay'),
('29152', 'WARD', '836', 'Bảo Thuận', 'Bao Thuan'),
('29155', 'WARD', '836', 'Tân Hưng', 'Tan Hung'),
('29158', 'WARD', '836', 'An Ngãi Tây', 'An Ngai Tay'),
('29161', 'WARD', '836', 'An Hiệp', 'An Hiep'),
('29164', 'WARD', '836', 'Vĩnh Hòa', 'Vinh Hoa'),
('29167', 'WARD', '836', 'Tân Thủy', 'Tan Thuy'),
('29170', 'WARD', '836', 'Vĩnh An', 'Vinh An'),
('29173', 'WARD', '836', 'An Đức', 'An Duc'),
('29176', 'WARD', '836', 'An Hòa Tây', 'An Hoa Tay'),
('29179', 'WARD', '836', 'Thị trấn Tiệm Tôm', 'Thi tran Tiem Tom')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 837 - Thạnh Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29182', 'WARD', '837', 'Thị trấn Thạnh Phú', 'Thi tran Thanh Phu'),
('29185', 'WARD', '837', 'Phú Khánh', 'Phu Khanh'),
('29188', 'WARD', '837', 'Đại Điền', 'Dai Dien'),
('29191', 'WARD', '837', 'Quới Điền', 'Quoi Dien'),
('29194', 'WARD', '837', 'Tân Phong', 'Tan Phong'),
('29197', 'WARD', '837', 'Mỹ Hưng', 'My Hung'),
('29200', 'WARD', '837', 'An Thạnh', 'An Thanh'),
('29203', 'WARD', '837', 'Thới Thạnh', 'Thoi Thanh'),
('29206', 'WARD', '837', 'Hòa Lợi', 'Hoa Loi'),
('29209', 'WARD', '837', 'An Điền', 'An Dien'),
('29212', 'WARD', '837', 'Bình Thạnh', 'Binh Thanh'),
('29215', 'WARD', '837', 'An Thuận', 'An Thuan'),
('29218', 'WARD', '837', 'An Quy', 'An Quy'),
('29221', 'WARD', '837', 'Thạnh Hải', 'Thanh Hai'),
('29224', 'WARD', '837', 'An Nhơn', 'An Nhon'),
('29227', 'WARD', '837', 'Giao Thạnh', 'Giao Thanh'),
('29230', 'WARD', '837', 'Thạnh Phong', 'Thanh Phong'),
('29233', 'WARD', '837', 'Mỹ An', 'My An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 838 - Mỏ Cày Bắc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('28889', 'WARD', '838', 'Phú Mỹ', 'Phu My'),
('28901', 'WARD', '838', 'Hưng Khánh Trung A', 'Hung Khanh Trung A'),
('28906', 'WARD', '838', 'Thanh Tân', 'Thanh Tan'),
('28909', 'WARD', '838', 'Thạnh Ngãi', 'Thanh Ngai'),
('28912', 'WARD', '838', 'Tân Phú Tây', 'Tan Phu Tay'),
('28915', 'WARD', '838', 'Thị trấn Phước Mỹ Trung', 'Thi tran Phuoc My Trung'),
('28918', 'WARD', '838', 'Tân Thành Bình', 'Tan Thanh Binh'),
('28921', 'WARD', '838', 'Thành An', 'Thanh An'),
('28924', 'WARD', '838', 'Hòa Lộc', 'Hoa Loc'),
('28927', 'WARD', '838', 'Tân Thanh Tây', 'Tan Thanh Tay'),
('28933', 'WARD', '838', 'Tân Bình', 'Tan Binh'),
('28936', 'WARD', '838', 'Nhuận Phú Tân', 'Nhuan Phu Tan'),
('28948', 'WARD', '838', 'Khánh Thạnh Tân', 'Khanh Thanh Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 84 - Trà Vinh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('842', 'DISTRICT', '84', 'Trà Vinh', 'Thanh pho Tra Vinh'),
('844', 'DISTRICT', '84', 'Càng Long', 'Cang Long'),
('845', 'DISTRICT', '84', 'Cầu Kè', 'Cau Ke'),
('846', 'DISTRICT', '84', 'Tiểu Cần', 'Tieu Can'),
('847', 'DISTRICT', '84', 'Châu Thành', 'Chau Thanh'),
('848', 'DISTRICT', '84', 'Cầu Ngang', 'Cau Ngang'),
('849', 'DISTRICT', '84', 'Trà Cú', 'Tra Cu'),
('850', 'DISTRICT', '84', 'Duyên Hải', 'Duyen Hai'),
('851', 'DISTRICT', '84', 'Thị Duyên Hải', 'Thi Duyen Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 842 - Trà Vinh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29236', 'WARD', '842', 'Phường 4', 'Ward 4'),
('29239', 'WARD', '842', 'Phường 1', 'Ward 1'),
('29242', 'WARD', '842', 'Phường 3', 'Ward 3'),
('29248', 'WARD', '842', 'Phường 5', 'Ward 5'),
('29254', 'WARD', '842', 'Phường 7', 'Ward 7'),
('29257', 'WARD', '842', 'Phường 8', 'Ward 8'),
('29260', 'WARD', '842', 'Phường 9', 'Ward 9'),
('29263', 'WARD', '842', 'Long Đức', 'Long Duc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 844 - Càng Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29266', 'WARD', '844', 'Thị trấn Càng Long', 'Thi tran Cang Long'),
('29269', 'WARD', '844', 'Mỹ Cẩm', 'My Cam'),
('29272', 'WARD', '844', 'An Trường A', 'An Truong A'),
('29275', 'WARD', '844', 'An Trường', 'An Truong'),
('29278', 'WARD', '844', 'Huyền Hội', 'Hoi'),
('29281', 'WARD', '844', 'Tân An', 'Tan An'),
('29284', 'WARD', '844', 'Tân Bình', 'Tan Binh'),
('29287', 'WARD', '844', 'Bình Phú', 'Binh Phu'),
('29290', 'WARD', '844', 'Phương Thạnh', 'Thanh'),
('29293', 'WARD', '844', 'Đại Phúc', 'Dai Phuc'),
('29296', 'WARD', '844', 'Đại Phước', 'Dai Phuoc'),
('29299', 'WARD', '844', 'Nhị Long Phú', 'Nhi Long Phu'),
('29302', 'WARD', '844', 'Nhị Long', 'Nhi Long'),
('29305', 'WARD', '844', 'Đức Mỹ', 'Duc My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 845 - Cầu Kè
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29308', 'WARD', '845', 'Thị trấn Cầu Kè', 'Thi tran Cau Ke'),
('29311', 'WARD', '845', 'Hòa Ân', 'Hoa An'),
('29314', 'WARD', '845', 'Châu Điền', 'Chau Dien'),
('29317', 'WARD', '845', 'An Phú Tân', 'An Phu Tan'),
('29320', 'WARD', '845', 'Hoà Tân', 'Hoa Tan'),
('29323', 'WARD', '845', 'Ninh Thới', 'Ninh Thoi'),
('29326', 'WARD', '845', 'Phong Phú', 'Phong Phu'),
('29329', 'WARD', '845', 'Phong Thạnh', 'Phong Thanh'),
('29332', 'WARD', '845', 'Tam Ngãi', 'Tam Ngai'),
('29335', 'WARD', '845', 'Thông Hòa', 'Thong Hoa'),
('29338', 'WARD', '845', 'Thạnh Phú', 'Thanh Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 846 - Tiểu Cần
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29341', 'WARD', '846', 'Thị trấn Tiểu Cần', 'Thi tran Tieu Can'),
('29344', 'WARD', '846', 'Thị trấn Cầu Quan', 'Thi tran Cau Quan'),
('29347', 'WARD', '846', 'Phú Cần', 'Phu Can'),
('29350', 'WARD', '846', 'Hiếu Tử', 'Hieu Tu'),
('29353', 'WARD', '846', 'Hiếu Trung', 'Hieu Trung'),
('29356', 'WARD', '846', 'Long Thới', 'Long Thoi'),
('29359', 'WARD', '846', 'Hùng Hòa', 'Hung Hoa'),
('29362', 'WARD', '846', 'Tân Hùng', 'Tan Hung'),
('29365', 'WARD', '846', 'Tập Ngãi', 'Tap Ngai'),
('29368', 'WARD', '846', 'Ngãi Hùng', 'Ngai Hung'),
('29371', 'WARD', '846', 'Tân Hòa', 'Tan Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 847 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29374', 'WARD', '847', 'Thị trấn Châu Thành', 'Thi tran Chau Thanh'),
('29377', 'WARD', '847', 'Đa Lộc', 'Da Loc'),
('29380', 'WARD', '847', 'Mỹ Chánh', 'My Chanh'),
('29383', 'WARD', '847', 'Thanh Mỹ', 'Thanh My'),
('29386', 'WARD', '847', 'Lương Hoà A', 'Luong Hoa A'),
('29389', 'WARD', '847', 'Lương Hòa', 'Luong Hoa'),
('29392', 'WARD', '847', 'Song Lộc', 'Song Loc'),
('29395', 'WARD', '847', 'Nguyệt Hóa', 'Nguyet Hoa'),
('29398', 'WARD', '847', 'Hòa Thuận', 'Hoa Thuan'),
('29401', 'WARD', '847', 'Hòa Lợi', 'Hoa Loi'),
('29404', 'WARD', '847', 'Phước Hảo', 'Phuoc Hao'),
('29407', 'WARD', '847', 'Hưng Mỹ', 'Hung My'),
('29410', 'WARD', '847', 'Hòa Minh', 'Hoa Minh'),
('29413', 'WARD', '847', 'Long Hòa', 'Long Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 848 - Cầu Ngang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29416', 'WARD', '848', 'Thị trấn Cầu Ngang', 'Thi tran Cau Ngang'),
('29419', 'WARD', '848', 'Thị trấn Mỹ Long', 'Thi tran My Long'),
('29422', 'WARD', '848', 'Mỹ Long Bắc', 'My Long Bac'),
('29425', 'WARD', '848', 'Mỹ Long Nam', 'My Long Nam'),
('29428', 'WARD', '848', 'Mỹ Hòa', 'My Hoa'),
('29431', 'WARD', '848', 'Vĩnh Kim', 'Vinh Kim'),
('29434', 'WARD', '848', 'Kim Hòa', 'Kim Hoa'),
('29437', 'WARD', '848', 'Hiệp Hòa', 'Hiep Hoa'),
('29440', 'WARD', '848', 'Thuận Hòa', 'Thuan Hoa'),
('29443', 'WARD', '848', 'Long Sơn', 'Long Son'),
('29446', 'WARD', '848', 'Nhị Trường', 'Nhi Truong'),
('29449', 'WARD', '848', 'Trường Thọ', 'Truong Tho'),
('29452', 'WARD', '848', 'Hiệp Mỹ Đông', 'Hiep My Dong'),
('29455', 'WARD', '848', 'Hiệp Mỹ Tây', 'Hiep My Tay'),
('29458', 'WARD', '848', 'Thạnh Hòa Sơn', 'Thanh Hoa Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 849 - Trà Cú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29461', 'WARD', '849', 'Thị trấn Trà Cú', 'Thi tran Tra Cu'),
('29462', 'WARD', '849', 'Thị trấn Định An', 'Thi tran Dinh An'),
('29464', 'WARD', '849', 'Phước Hưng', 'Phuoc Hung'),
('29467', 'WARD', '849', 'Tập Sơn', 'Tap Son'),
('29470', 'WARD', '849', 'Tân Sơn', 'Tan Son'),
('29473', 'WARD', '849', 'An Quảng Hữu', 'An Quang Huu'),
('29476', 'WARD', '849', 'Lưu Nghiệp Anh', 'Luu Nghiep Anh'),
('29479', 'WARD', '849', 'Ngãi Xuyên', 'Ngai Xuyen'),
('29482', 'WARD', '849', 'Kim Sơn', 'Kim Son'),
('29485', 'WARD', '849', 'Thanh Sơn', 'Thanh Son'),
('29488', 'WARD', '849', 'Hàm Giang', 'Ham Giang'),
('29489', 'WARD', '849', 'Hàm Tân', 'Ham Tan'),
('29491', 'WARD', '849', 'Đại An', 'Dai An'),
('29494', 'WARD', '849', 'Định An', 'Dinh An'),
('29503', 'WARD', '849', 'Ngọc Biên', 'Ngoc Bien'),
('29506', 'WARD', '849', 'Long Hiệp', 'Long Hiep'),
('29509', 'WARD', '849', 'Tân Hiệp', 'Tan Hiep')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 850 - Duyên Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29497', 'WARD', '850', 'Đôn Xuân', 'Don Xuan'),
('29500', 'WARD', '850', 'Đôn Châu', 'Don Chau'),
('29513', 'WARD', '850', 'Thị trấn Long Thành', 'Thi tran Long Thanh'),
('29521', 'WARD', '850', 'Long Khánh', 'Long Khanh'),
('29530', 'WARD', '850', 'Ngũ Lạc', 'Ngu Lac'),
('29533', 'WARD', '850', 'Long Vĩnh', 'Long Vinh'),
('29536', 'WARD', '850', 'Đông Hải', 'Dong Hai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 851 - Thị Duyên Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29512', 'WARD', '851', 'Phường 1', 'Ward 1'),
('29515', 'WARD', '851', 'Long Toàn', 'Long Toan'),
('29516', 'WARD', '851', 'Phường 2', 'Ward 2'),
('29518', 'WARD', '851', 'Long Hữu', 'Long Huu'),
('29524', 'WARD', '851', 'Dân Thành', 'Dan Thanh'),
('29527', 'WARD', '851', 'Trường Long Hòa', 'Truong Long Hoa'),
('29539', 'WARD', '851', 'Hiệp Thạnh', 'Hiep Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 86 - Vĩnh Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('855', 'DISTRICT', '86', 'Vĩnh Long', 'Thanh pho Vinh Long'),
('857', 'DISTRICT', '86', 'Long Hồ', 'Long Ho'),
('858', 'DISTRICT', '86', 'Mang Thít', 'Mang Thit'),
('859', 'DISTRICT', '86', 'Vũng Liêm', 'Vung Liem'),
('860', 'DISTRICT', '86', 'Tam Bình', 'Tam Binh'),
('861', 'DISTRICT', '86', 'Thị Bình Minh', 'Thi Binh Minh'),
('862', 'DISTRICT', '86', 'Trà Ôn', 'Tra On'),
('863', 'DISTRICT', '86', 'Bình Tân', 'Binh Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 855 - Vĩnh Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29542', 'WARD', '855', 'Phường 9', 'Ward 9'),
('29545', 'WARD', '855', 'Phường 5', 'Ward 5'),
('29551', 'WARD', '855', 'Phường 1', 'Ward 1'),
('29554', 'WARD', '855', 'Phường 4', 'Ward 4'),
('29557', 'WARD', '855', 'Phường 3', 'Ward 3'),
('29560', 'WARD', '855', 'Phường 8', 'Ward 8'),
('29563', 'WARD', '855', 'Tân Ngãi', 'Tan Ngai'),
('29566', 'WARD', '855', 'Tân Hòa', 'Tan Hoa'),
('29569', 'WARD', '855', 'Tân Hội', 'Tan Hoi'),
('29572', 'WARD', '855', 'Trường An', 'Truong An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 857 - Long Hồ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29578', 'WARD', '857', 'Đồng Phú', 'Dong Phu'),
('29581', 'WARD', '857', 'Bình Hòa Phước', 'Binh Hoa Phuoc'),
('29584', 'WARD', '857', 'Hòa Ninh', 'Hoa Ninh'),
('29587', 'WARD', '857', 'An Bình', 'An Binh'),
('29590', 'WARD', '857', 'Thanh Đức', 'Thanh Duc'),
('29593', 'WARD', '857', 'Tân Hạnh', 'Tan Hanh'),
('29596', 'WARD', '857', 'Phước Hậu', 'Phuoc Hau'),
('29599', 'WARD', '857', 'Long Phước', 'Long Phuoc'),
('29602', 'WARD', '857', 'Thị trấn Long Hồ', 'Thi tran Long Ho'),
('29605', 'WARD', '857', 'Lộc Hòa', 'Loc Hoa'),
('29608', 'WARD', '857', 'Long An', 'Long An'),
('29611', 'WARD', '857', 'Phú Quới', 'Phu Quoi'),
('29614', 'WARD', '857', 'Thạnh Quới', 'Thanh Quoi'),
('29617', 'WARD', '857', 'Hòa Phú', 'Hoa Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 858 - Mang Thít
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29623', 'WARD', '858', 'Mỹ An', 'My An'),
('29626', 'WARD', '858', 'Mỹ Phước', 'My Phuoc'),
('29629', 'WARD', '858', 'An Phước', 'An Phuoc'),
('29632', 'WARD', '858', 'Nhơn Phú', 'Nhon Phu'),
('29635', 'WARD', '858', 'Long Mỹ', 'Long My'),
('29638', 'WARD', '858', 'Hòa Tịnh', 'Hoa Tinh'),
('29641', 'WARD', '858', 'Thị trấn Cái Nhum', 'Thi tran Cai Nhum'),
('29644', 'WARD', '858', 'Bình Phước', 'Binh Phuoc'),
('29647', 'WARD', '858', 'Chánh An', 'Chanh An'),
('29650', 'WARD', '858', 'Tân An Hội', 'Tan An Hoi'),
('29653', 'WARD', '858', 'Tân Long', 'Tan Long'),
('29656', 'WARD', '858', 'Tân Long Hội', 'Tan Long Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 859 - Vũng Liêm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29659', 'WARD', '859', 'Thị trấn Vũng Liêm', 'Thi tran Vung Liem'),
('29662', 'WARD', '859', 'Tân Quới Trung', 'Tan Quoi Trung'),
('29665', 'WARD', '859', 'Quới Thiện', 'Quoi Thien'),
('29668', 'WARD', '859', 'Quới An', 'Quoi An'),
('29671', 'WARD', '859', 'Trung Chánh', 'Trung Chanh'),
('29674', 'WARD', '859', 'Tân An Luông', 'Tan An Luong'),
('29677', 'WARD', '859', 'Thanh Bình', 'Thanh Binh'),
('29680', 'WARD', '859', 'Trung Thành Tây', 'Trung Thanh Tay'),
('29683', 'WARD', '859', 'Trung Hiệp', 'Trung Hiep'),
('29686', 'WARD', '859', 'Hiếu Phụng', 'Hieu Phung'),
('29689', 'WARD', '859', 'Trung Thành Đông', 'Trung Thanh Dong'),
('29692', 'WARD', '859', 'Trung Thành', 'Trung Thanh'),
('29695', 'WARD', '859', 'Trung Hiếu', 'Trung Hieu'),
('29698', 'WARD', '859', 'Trung Ngãi', 'Trung Ngai'),
('29701', 'WARD', '859', 'Hiếu Thuận', 'Hieu Thuan'),
('29704', 'WARD', '859', 'Trung Nghĩa', 'Trung Nghia'),
('29707', 'WARD', '859', 'Trung An', 'Trung An'),
('29710', 'WARD', '859', 'Hiếu Nhơn', 'Hieu Nhon'),
('29713', 'WARD', '859', 'Hiếu Thành', 'Hieu Thanh'),
('29716', 'WARD', '859', 'Hiếu Nghĩa', 'Hieu Nghia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 860 - Tam Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29719', 'WARD', '860', 'Thị trấn Tam Bình', 'Thi tran Tam Binh'),
('29722', 'WARD', '860', 'Tân Lộc', 'Tan Loc'),
('29725', 'WARD', '860', 'Phú Thịnh', 'Phu Thinh'),
('29728', 'WARD', '860', 'Hậu Lộc', 'Hau Loc'),
('29731', 'WARD', '860', 'Hòa Thạnh', 'Hoa Thanh'),
('29734', 'WARD', '860', 'Hoà Lộc', 'Hoa Loc'),
('29737', 'WARD', '860', 'Phú Lộc', 'Phu Loc'),
('29740', 'WARD', '860', 'Song Phú', 'Song Phu'),
('29743', 'WARD', '860', 'Hòa Hiệp', 'Hoa Hiep'),
('29746', 'WARD', '860', 'Mỹ Lộc', 'My Loc'),
('29749', 'WARD', '860', 'Tân Phú', 'Tan Phu'),
('29752', 'WARD', '860', 'Long Phú', 'Long Phu'),
('29755', 'WARD', '860', 'Mỹ Thạnh Trung', 'My Thanh Trung'),
('29761', 'WARD', '860', 'Loan Mỹ', 'Loan My'),
('29764', 'WARD', '860', 'Ngãi Tứ', 'Ngai Tu'),
('29767', 'WARD', '860', 'Bình Ninh', 'Binh Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 861 - Thị Bình Minh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29770', 'WARD', '861', 'Cái Vồn', 'Cai Von'),
('29771', 'WARD', '861', 'Thành Phước', 'Thanh Phuoc'),
('29806', 'WARD', '861', 'Thuận An', 'Thuan An'),
('29809', 'WARD', '861', 'Đông Thạnh', 'Dong Thanh'),
('29812', 'WARD', '861', 'Đông Bình', 'Dong Binh'),
('29813', 'WARD', '861', 'Đông Thuận', 'Dong Thuan'),
('29815', 'WARD', '861', 'Mỹ Hòa', 'My Hoa'),
('29818', 'WARD', '861', 'Đông Thành', 'Dong Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 862 - Trà Ôn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29821', 'WARD', '862', 'Thị trấn Trà Ôn', 'Thi tran Tra On'),
('29824', 'WARD', '862', 'Xuân Hiệp', 'Xuan Hiep'),
('29827', 'WARD', '862', 'Nhơn Bình', 'Nhon Binh'),
('29830', 'WARD', '862', 'Hòa Bình', 'Hoa Binh'),
('29833', 'WARD', '862', 'Thới Hòa', 'Thoi Hoa'),
('29836', 'WARD', '862', 'Trà Côn', 'Tra Con'),
('29839', 'WARD', '862', 'Tân Mỹ', 'Tan My'),
('29842', 'WARD', '862', 'Hựu Thành', 'Huu Thanh'),
('29845', 'WARD', '862', 'Vĩnh Xuân', 'Vinh Xuan'),
('29848', 'WARD', '862', 'Thuận Thới', 'Thuan Thoi'),
('29851', 'WARD', '862', 'Phú Thành', 'Phu Thanh'),
('29857', 'WARD', '862', 'Lục Sỹ Thành', 'Luc Sy Thanh'),
('29860', 'WARD', '862', 'Tích Thiện', 'Tich Thien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 863 - Bình Tân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29776', 'WARD', '863', 'Tân Thành', 'Tan Thanh'),
('29779', 'WARD', '863', 'Thành Trung', 'Thanh Trung'),
('29782', 'WARD', '863', 'Tân An Thạnh', 'Tan An Thanh'),
('29785', 'WARD', '863', 'Tân Lược', 'Tan Luoc'),
('29788', 'WARD', '863', 'Nguyễn Văn Thảnh', 'Nguyen Van Thanh'),
('29791', 'WARD', '863', 'Thành Lợi', 'Thanh Loi'),
('29794', 'WARD', '863', 'Mỹ Thuận', 'My Thuan'),
('29797', 'WARD', '863', 'Tân Bình', 'Tan Binh'),
('29800', 'WARD', '863', 'Thị trấn Tân Quới', 'Thi tran Tan Quoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 87 - Đồng Tháp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('866', 'DISTRICT', '87', 'Cao Lãnh', 'Thanh pho Cao Lanh'),
('867', 'DISTRICT', '87', 'Sa Đéc', 'Thanh pho Sa Dec'),
('868', 'DISTRICT', '87', 'Hồng Ngự', 'Thanh pho Hong Ngu'),
('869', 'DISTRICT', '87', 'Tân Hồng', 'Tan Hong'),
('870', 'DISTRICT', '87', 'Hồng Ngự', 'Hong Ngu'),
('871', 'DISTRICT', '87', 'Tam Nông', 'Tam Nong'),
('872', 'DISTRICT', '87', 'Tháp Mười', 'Thap Muoi'),
('873', 'DISTRICT', '87', 'Cao Lãnh', 'Cao Lanh'),
('874', 'DISTRICT', '87', 'Thanh Bình', 'Thanh Binh'),
('875', 'DISTRICT', '87', 'Lấp Vò', 'Lap Vo'),
('876', 'DISTRICT', '87', 'Lai Vung', 'Lai Vung'),
('877', 'DISTRICT', '87', 'Châu Thành', 'Chau Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 866 - Cao Lãnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29869', 'WARD', '866', 'Phường 1', 'Ward 1'),
('29872', 'WARD', '866', 'Phường 4', 'Ward 4'),
('29875', 'WARD', '866', 'Phường 3', 'Ward 3'),
('29878', 'WARD', '866', 'Phường 6', 'Ward 6'),
('29881', 'WARD', '866', 'Mỹ Ngãi', 'My Ngai'),
('29884', 'WARD', '866', 'Mỹ Tân', 'My Tan'),
('29887', 'WARD', '866', 'Mỹ Trà', 'My Tra'),
('29888', 'WARD', '866', 'Mỹ Phú', 'My Phu'),
('29890', 'WARD', '866', 'Tân Thuận Tây', 'Tan Thuan Tay'),
('29892', 'WARD', '866', 'Hoà Thuận', 'Hoa Thuan'),
('29893', 'WARD', '866', 'Hòa An', 'Hoa An'),
('29896', 'WARD', '866', 'Tân Thuận Đông', 'Tan Thuan Dong'),
('29899', 'WARD', '866', 'Tịnh Thới', 'Thoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 867 - Sa Đéc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29902', 'WARD', '867', 'Phường 3', 'Ward 3'),
('29905', 'WARD', '867', 'Phường 1', 'Ward 1'),
('29908', 'WARD', '867', 'Phường 4', 'Ward 4'),
('29911', 'WARD', '867', 'Phường 2', 'Ward 2'),
('29914', 'WARD', '867', 'Tân Khánh Đông', 'Tan Khanh Dong'),
('29917', 'WARD', '867', 'Tân Quy Đông', 'Tan Quy Dong'),
('29919', 'WARD', '867', 'An Hoà', 'An Hoa'),
('29920', 'WARD', '867', 'Tân Quy Tây', 'Tan Quy Tay'),
('29923', 'WARD', '867', 'Tân Phú Đông', 'Tan Phu Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 868 - Hồng Ngự
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29954', 'WARD', '868', 'An Lộc', 'An Loc'),
('29955', 'WARD', '868', 'An Thạnh', 'An Thanh'),
('29959', 'WARD', '868', 'Bình Thạnh', 'Binh Thanh'),
('29965', 'WARD', '868', 'Tân Hội', 'Tan Hoi'),
('29978', 'WARD', '868', 'An Lạc', 'An Lac'),
('29986', 'WARD', '868', 'An Bình B', 'An Binh B'),
('29989', 'WARD', '868', 'An Bình A', 'An Binh A')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 869 - Tân Hồng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29926', 'WARD', '869', 'Thị trấn Sa Rài', 'Thi tran Sa Rai'),
('29929', 'WARD', '869', 'Tân Hộ Cơ', 'Tan Ho Co'),
('29932', 'WARD', '869', 'Thông Bình', 'Thong Binh'),
('29935', 'WARD', '869', 'Bình Phú', 'Binh Phu'),
('29938', 'WARD', '869', 'Tân Thành A', 'Tan Thanh A'),
('29941', 'WARD', '869', 'Tân Thành B', 'Tan Thanh B'),
('29944', 'WARD', '869', 'Tân Phước', 'Tan Phuoc'),
('29947', 'WARD', '869', 'Tân Công Chí', 'Tan Cong Chi'),
('29950', 'WARD', '869', 'An Phước', 'An Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 870 - Hồng Ngự
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('29956', 'WARD', '870', 'Thường Phước 1', 'Thuong Phuoc 1'),
('29962', 'WARD', '870', 'Thường Thới Hậu A', 'Thuong Thoi Hau A'),
('29971', 'WARD', '870', 'Thị trấn Thường Thới Tiền', 'Thi tran Thuong Thoi Tien'),
('29974', 'WARD', '870', 'Thường Phước 2', 'Thuong Phuoc 2'),
('29977', 'WARD', '870', 'Thường Lạc', 'Thuong Lac'),
('29980', 'WARD', '870', 'Long Khánh A', 'Long Khanh A'),
('29983', 'WARD', '870', 'Long Khánh B', 'Long Khanh B'),
('29992', 'WARD', '870', 'Long Thuận', 'Long Thuan'),
('29995', 'WARD', '870', 'Phú Thuận B', 'Phu Thuan B'),
('29998', 'WARD', '870', 'Phú Thuận A', 'Phu Thuan A')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 871 - Tam Nông
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30001', 'WARD', '871', 'Thị trấn Tràm Chim', 'Thi tran Tram Chim'),
('30004', 'WARD', '871', 'Hoà Bình', 'Hoa Binh'),
('30007', 'WARD', '871', 'Tân Công Sính', 'Tan Cong Sinh'),
('30010', 'WARD', '871', 'Phú Hiệp', 'Phu Hiep'),
('30013', 'WARD', '871', 'Phú Đức', 'Phu Duc'),
('30016', 'WARD', '871', 'Phú Thành B', 'Phu Thanh B'),
('30019', 'WARD', '871', 'An Hòa', 'An Hoa'),
('30022', 'WARD', '871', 'An Long', 'An Long'),
('30025', 'WARD', '871', 'Phú Cường', 'Phu Cuong'),
('30028', 'WARD', '871', 'Phú Ninh', 'Phu Ninh'),
('30031', 'WARD', '871', 'Phú Thọ', 'Phu Tho'),
('30034', 'WARD', '871', 'Phú Thành A', 'Phu Thanh A')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 872 - Tháp Mười
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30037', 'WARD', '872', 'Thị trấn Mỹ An', 'Thi tran My An'),
('30040', 'WARD', '872', 'Thạnh Lợi', 'Thanh Loi'),
('30043', 'WARD', '872', 'Hưng Thạnh', 'Hung Thanh'),
('30046', 'WARD', '872', 'Trường Xuân', 'Truong Xuan'),
('30049', 'WARD', '872', 'Tân Kiều', 'Tan Kieu'),
('30052', 'WARD', '872', 'Mỹ Hòa', 'My Hoa'),
('30055', 'WARD', '872', 'Mỹ Quý', 'My Quy'),
('30058', 'WARD', '872', 'Mỹ Đông', 'My Dong'),
('30061', 'WARD', '872', 'Đốc Binh Kiều', 'Doc Binh Kieu'),
('30064', 'WARD', '872', 'Mỹ An', 'My An'),
('30067', 'WARD', '872', 'Phú Điền', 'Phu Dien'),
('30070', 'WARD', '872', 'Láng Biển', 'Lang Bien'),
('30073', 'WARD', '872', 'Thanh Mỹ', 'Thanh My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 873 - Cao Lãnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30076', 'WARD', '873', 'Thị trấn Mỹ Thọ', 'Thi tran My Tho'),
('30079', 'WARD', '873', 'Gáo Giồng', 'Gao Giong'),
('30082', 'WARD', '873', 'Phương Thịnh', 'Thinh'),
('30085', 'WARD', '873', 'Ba Sao', 'Ba Sao'),
('30088', 'WARD', '873', 'Phong Mỹ', 'Phong My'),
('30091', 'WARD', '873', 'Tân Nghĩa', 'Tan Nghia'),
('30094', 'WARD', '873', 'Phương Trà', 'Tra'),
('30097', 'WARD', '873', 'Nhị Mỹ', 'Nhi My'),
('30100', 'WARD', '873', 'Mỹ Thọ', 'My Tho'),
('30103', 'WARD', '873', 'Tân Hội Trung', 'Tan Hoi Trung'),
('30106', 'WARD', '873', 'An Bình', 'An Binh'),
('30109', 'WARD', '873', 'Mỹ Hội', 'My Hoi'),
('30112', 'WARD', '873', 'Mỹ Hiệp', 'My Hiep'),
('30115', 'WARD', '873', 'Mỹ Long', 'My Long'),
('30118', 'WARD', '873', 'Bình Hàng Trung', 'Binh Hang Trung'),
('30121', 'WARD', '873', 'Mỹ Xương', 'My Xuong'),
('30124', 'WARD', '873', 'Bình Hàng Tây', 'Binh Hang Tay'),
('30127', 'WARD', '873', 'Bình Thạnh', 'Binh Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 874 - Thanh Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30130', 'WARD', '874', 'Thị trấn Thanh Bình', 'Thi tran Thanh Binh'),
('30133', 'WARD', '874', 'Tân Quới', 'Tan Quoi'),
('30136', 'WARD', '874', 'Tân Hòa', 'Tan Hoa'),
('30139', 'WARD', '874', 'An Phong', 'An Phong'),
('30142', 'WARD', '874', 'Phú Lợi', 'Phu Loi'),
('30145', 'WARD', '874', 'Tân Mỹ', 'Tan My'),
('30148', 'WARD', '874', 'Bình Tấn', 'Binh Tan'),
('30151', 'WARD', '874', 'Tân Huề', 'Tan Hue'),
('30154', 'WARD', '874', 'Tân Bình', 'Tan Binh'),
('30157', 'WARD', '874', 'Tân Thạnh', 'Tan Thanh'),
('30160', 'WARD', '874', 'Tân Phú', 'Tan Phu'),
('30163', 'WARD', '874', 'Bình Thành', 'Binh Thanh'),
('30166', 'WARD', '874', 'Tân Long', 'Tan Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 875 - Lấp Vò
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30169', 'WARD', '875', 'Thị trấn Lấp Vò', 'Thi tran Lap Vo'),
('30172', 'WARD', '875', 'Mỹ An Hưng A', 'My An Hung A'),
('30175', 'WARD', '875', 'Tân Mỹ', 'Tan My'),
('30178', 'WARD', '875', 'Mỹ An Hưng B', 'My An Hung B'),
('30181', 'WARD', '875', 'Tân Khánh Trung', 'Tan Khanh Trung'),
('30184', 'WARD', '875', 'Long Hưng A', 'Long Hung A'),
('30187', 'WARD', '875', 'Vĩnh Thạnh', 'Vinh Thanh'),
('30190', 'WARD', '875', 'Long Hưng B', 'Long Hung B'),
('30193', 'WARD', '875', 'Bình Thành', 'Binh Thanh'),
('30196', 'WARD', '875', 'Định An', 'Dinh An'),
('30199', 'WARD', '875', 'Định Yên', 'Dinh Yen'),
('30202', 'WARD', '875', 'Hội An Đông', 'Hoi An Dong'),
('30205', 'WARD', '875', 'Bình Thạnh Trung', 'Binh Thanh Trung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 876 - Lai Vung
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30208', 'WARD', '876', 'Thị trấn Lai Vung', 'Thi tran Lai Vung'),
('30211', 'WARD', '876', 'Tân Dương', 'Tan Duong'),
('30214', 'WARD', '876', 'Hòa Thành', 'Hoa Thanh'),
('30217', 'WARD', '876', 'Long Hậu', 'Long Hau'),
('30220', 'WARD', '876', 'Tân Phước', 'Tan Phuoc'),
('30223', 'WARD', '876', 'Hòa Long', 'Hoa Long'),
('30226', 'WARD', '876', 'Tân Thành', 'Tan Thanh'),
('30229', 'WARD', '876', 'Long Thắng', 'Long Thang'),
('30232', 'WARD', '876', 'Vĩnh Thới', 'Vinh Thoi'),
('30235', 'WARD', '876', 'Tân Hòa', 'Tan Hoa'),
('30238', 'WARD', '876', 'Định Hòa', 'Dinh Hoa'),
('30241', 'WARD', '876', 'Phong Hòa', 'Phong Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 877 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30244', 'WARD', '877', 'Thị trấn Cái Tàu Hạ', 'Thi tran Cai Tau Ha'),
('30247', 'WARD', '877', 'An Hiệp', 'An Hiep'),
('30250', 'WARD', '877', 'An Nhơn', 'An Nhon'),
('30253', 'WARD', '877', 'Tân Nhuận Đông', 'Tan Nhuan Dong'),
('30256', 'WARD', '877', 'Tân Bình', 'Tan Binh'),
('30259', 'WARD', '877', 'Tân Phú Trung', 'Tan Phu Trung'),
('30262', 'WARD', '877', 'Phú Long', 'Phu Long'),
('30265', 'WARD', '877', 'An Phú Thuận', 'An Phu Thuan'),
('30268', 'WARD', '877', 'Phú Hựu', 'Phu Huu'),
('30271', 'WARD', '877', 'An Khánh', 'An Khanh'),
('30274', 'WARD', '877', 'Tân Phú', 'Tan Phu'),
('30277', 'WARD', '877', 'Hòa Tân', 'Hoa Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 89 - An Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('883', 'DISTRICT', '89', 'Long Xuyên', 'Thanh pho Long Xuyen'),
('884', 'DISTRICT', '89', 'Châu Đốc', 'Thanh pho Chau Doc'),
('886', 'DISTRICT', '89', 'An Phú', 'An Phu'),
('887', 'DISTRICT', '89', 'Thị Tân Châu', 'Thi Tan Chau'),
('888', 'DISTRICT', '89', 'Phú Tân', 'Phu Tan'),
('889', 'DISTRICT', '89', 'Châu Phú', 'Chau Phu'),
('890', 'DISTRICT', '89', 'Thị Tịnh Biên', 'Thi Bien'),
('891', 'DISTRICT', '89', 'Tri Tôn', 'Tri Ton'),
('892', 'DISTRICT', '89', 'Châu Thành', 'Chau Thanh'),
('893', 'DISTRICT', '89', 'Chợ Mới', 'Cho Moi'),
('894', 'DISTRICT', '89', 'Thoại Sơn', 'Thoai Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 883 - Long Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30280', 'WARD', '883', 'Mỹ Bình', 'My Binh'),
('30283', 'WARD', '883', 'Mỹ Long', 'My Long'),
('30286', 'WARD', '883', 'Mỹ Xuyên', 'My Xuyen'),
('30289', 'WARD', '883', 'Bình Đức', 'Binh Duc'),
('30292', 'WARD', '883', 'Bình Khánh', 'Binh Khanh'),
('30295', 'WARD', '883', 'Mỹ Phước', 'My Phuoc'),
('30298', 'WARD', '883', 'Mỹ Quý', 'My Quy'),
('30301', 'WARD', '883', 'Mỹ Thới', 'My Thoi'),
('30304', 'WARD', '883', 'Mỹ Thạnh', 'My Thanh'),
('30307', 'WARD', '883', 'Mỹ Hòa', 'My Hoa'),
('30310', 'WARD', '883', 'Mỹ Khánh', 'My Khanh'),
('30313', 'WARD', '883', 'Mỹ Hoà Hưng', 'My Hoa Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 884 - Châu Đốc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30316', 'WARD', '884', 'Châu Phú B', 'Chau Phu B'),
('30319', 'WARD', '884', 'Châu Phú A', 'Chau Phu A'),
('30322', 'WARD', '884', 'Vĩnh Mỹ', 'Vinh My'),
('30325', 'WARD', '884', 'Núi Sam', 'Nui Sam'),
('30328', 'WARD', '884', 'Vĩnh Ngươn', 'Vinh Nguon'),
('30331', 'WARD', '884', 'Vĩnh Tế', 'Vinh Te'),
('30334', 'WARD', '884', 'Vĩnh Châu', 'Vinh Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 886 - An Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30337', 'WARD', '886', 'Thị trấn An Phú', 'Thi tran An Phu'),
('30340', 'WARD', '886', 'Khánh An', 'Khanh An'),
('30341', 'WARD', '886', 'Thị trấn Long Bình', 'Thi tran Long Binh'),
('30343', 'WARD', '886', 'Khánh Bình', 'Khanh Binh'),
('30346', 'WARD', '886', 'Quốc Thái', 'Quoc Thai'),
('30349', 'WARD', '886', 'Nhơn Hội', 'Nhon Hoi'),
('30352', 'WARD', '886', 'Phú Hữu', 'Phu Huu'),
('30355', 'WARD', '886', 'Phú Hội', 'Phu Hoi'),
('30358', 'WARD', '886', 'Phước Hưng', 'Phuoc Hung'),
('30361', 'WARD', '886', 'Vĩnh Lộc', 'Vinh Loc'),
('30364', 'WARD', '886', 'Vĩnh Hậu', 'Vinh Hau'),
('30367', 'WARD', '886', 'Vĩnh Trường', 'Vinh Truong'),
('30370', 'WARD', '886', 'Vĩnh Hội Đông', 'Vinh Hoi Dong'),
('30373', 'WARD', '886', 'Thị trấn Đa Phước', 'Thi tran Da Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 887 - Thị Tân Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30376', 'WARD', '887', 'Long Thạnh', 'Long Thanh'),
('30377', 'WARD', '887', 'Long Hưng', 'Long Hung'),
('30378', 'WARD', '887', 'Long Châu', 'Long Chau'),
('30379', 'WARD', '887', 'Phú Lộc', 'Phu Loc'),
('30382', 'WARD', '887', 'Vĩnh Xương', 'Vinh Xuong'),
('30385', 'WARD', '887', 'Vĩnh Hòa', 'Vinh Hoa'),
('30387', 'WARD', '887', 'Tân Thạnh', 'Tan Thanh'),
('30388', 'WARD', '887', 'Tân An', 'Tan An'),
('30391', 'WARD', '887', 'Long An', 'Long An'),
('30394', 'WARD', '887', 'Long Phú', 'Long Phu'),
('30397', 'WARD', '887', 'Châu Phong', 'Chau Phong'),
('30400', 'WARD', '887', 'Phú Vĩnh', 'Phu Vinh'),
('30403', 'WARD', '887', 'Lê Chánh', 'Le Chanh'),
('30412', 'WARD', '887', 'Long Sơn', 'Long Son')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 888 - Phú Tân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30406', 'WARD', '888', 'Thị trấn Phú Mỹ', 'Thi tran Phu My'),
('30409', 'WARD', '888', 'Thị trấn Chợ Vàm', 'Thi tran Cho Vam'),
('30415', 'WARD', '888', 'Long Hoà', 'Long Hoa'),
('30418', 'WARD', '888', 'Phú Long', 'Phu Long'),
('30421', 'WARD', '888', 'Phú Lâm', 'Phu Lam'),
('30424', 'WARD', '888', 'Phú Hiệp', 'Phu Hiep'),
('30427', 'WARD', '888', 'Phú Thạnh', 'Phu Thanh'),
('30430', 'WARD', '888', 'Hoà Lạc', 'Hoa Lac'),
('30433', 'WARD', '888', 'Phú Thành', 'Phu Thanh'),
('30436', 'WARD', '888', 'Phú An', 'Phu An'),
('30439', 'WARD', '888', 'Phú Xuân', 'Phu Xuan'),
('30442', 'WARD', '888', 'Hiệp Xương', 'Hiep Xuong'),
('30445', 'WARD', '888', 'Phú Bình', 'Phu Binh'),
('30448', 'WARD', '888', 'Phú Thọ', 'Phu Tho'),
('30451', 'WARD', '888', 'Phú Hưng', 'Phu Hung'),
('30454', 'WARD', '888', 'Bình Thạnh Đông', 'Binh Thanh Dong'),
('30457', 'WARD', '888', 'Tân Hòa', 'Tan Hoa'),
('30460', 'WARD', '888', 'Tân Trung', 'Tan Trung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 889 - Châu Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30463', 'WARD', '889', 'Thị trấn Cái Dầu', 'Thi tran Cai Dau'),
('30466', 'WARD', '889', 'Khánh Hòa', 'Khanh Hoa'),
('30469', 'WARD', '889', 'Mỹ Đức', 'My Duc'),
('30472', 'WARD', '889', 'Mỹ Phú', 'My Phu'),
('30475', 'WARD', '889', 'Ô Long Vỹ', 'O Long Vy'),
('30478', 'WARD', '889', 'Thị trấn Vĩnh Thạnh Trung', 'Thi tran Vinh Thanh Trung'),
('30481', 'WARD', '889', 'Thạnh Mỹ Tây', 'Thanh My Tay'),
('30484', 'WARD', '889', 'Bình Long', 'Binh Long'),
('30487', 'WARD', '889', 'Bình Mỹ', 'Binh My'),
('30490', 'WARD', '889', 'Bình Thủy', 'Binh Thuy'),
('30493', 'WARD', '889', 'Đào Hữu Cảnh', 'Dao Huu Canh'),
('30496', 'WARD', '889', 'Bình Phú', 'Binh Phu'),
('30499', 'WARD', '889', 'Bình Chánh', 'Binh Chanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 890 - Thị Tịnh Biên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30502', 'WARD', '890', 'Nhà Bàng', 'Nha Bang'),
('30505', 'WARD', '890', 'Chi Lăng', 'Chi Lang'),
('30508', 'WARD', '890', 'Núi Voi', 'Nui Voi'),
('30511', 'WARD', '890', 'Nhơn Hưng', 'Nhon Hung'),
('30514', 'WARD', '890', 'An Phú', 'An Phu'),
('30517', 'WARD', '890', 'Thới Sơn', 'Thoi Son'),
('30520', 'WARD', '890', 'Tịnh Biên', 'Bien'),
('30523', 'WARD', '890', 'Văn Giáo', 'Van Giao'),
('30526', 'WARD', '890', 'An Cư', 'An Cu'),
('30529', 'WARD', '890', 'An Nông', 'An Nong'),
('30532', 'WARD', '890', 'Vĩnh Trung', 'Vinh Trung'),
('30535', 'WARD', '890', 'Tân Lợi', 'Tan Loi'),
('30538', 'WARD', '890', 'An Hảo', 'An Hao'),
('30541', 'WARD', '890', 'Tân Lập', 'Tan Lap')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 891 - Tri Tôn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30544', 'WARD', '891', 'Thị trấn Tri Tôn', 'Thi tran Tri Ton'),
('30547', 'WARD', '891', 'Thị trấn Ba Chúc', 'Thi tran Ba Chuc'),
('30550', 'WARD', '891', 'Lạc Quới', 'Lac Quoi'),
('30553', 'WARD', '891', 'Lê Trì', 'Le Tri'),
('30556', 'WARD', '891', 'Vĩnh Gia', 'Vinh Gia'),
('30559', 'WARD', '891', 'Vĩnh Phước', 'Vinh Phuoc'),
('30562', 'WARD', '891', 'Châu Lăng', 'Chau Lang'),
('30565', 'WARD', '891', 'Lương Phi', 'Luong Phi'),
('30568', 'WARD', '891', 'Lương An Trà', 'Luong An Tra'),
('30571', 'WARD', '891', 'Tà Đảnh', 'Ta Danh'),
('30574', 'WARD', '891', 'Núi Tô', 'Nui To'),
('30577', 'WARD', '891', 'An Tức', 'An Tuc'),
('30580', 'WARD', '891', 'Thị trấn Cô Tô', 'Thi tran Co To'),
('30583', 'WARD', '891', 'Tân Tuyến', 'Tan Tuyen'),
('30586', 'WARD', '891', 'Ô Lâm', 'O Lam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 892 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30589', 'WARD', '892', 'Thị trấn An Châu', 'Thi tran An Chau'),
('30592', 'WARD', '892', 'An Hòa', 'An Hoa'),
('30595', 'WARD', '892', 'Cần Đăng', 'Can Dang'),
('30598', 'WARD', '892', 'Vĩnh Hanh', 'Vinh Hanh'),
('30601', 'WARD', '892', 'Bình Thạnh', 'Binh Thanh'),
('30604', 'WARD', '892', 'Thị trấn Vĩnh Bình', 'Thi tran Vinh Binh'),
('30607', 'WARD', '892', 'Bình Hòa', 'Binh Hoa'),
('30610', 'WARD', '892', 'Vĩnh An', 'Vinh An'),
('30613', 'WARD', '892', 'Hòa Bình Thạnh', 'Hoa Binh Thanh'),
('30616', 'WARD', '892', 'Vĩnh Lợi', 'Vinh Loi'),
('30619', 'WARD', '892', 'Vĩnh Nhuận', 'Vinh Nhuan'),
('30622', 'WARD', '892', 'Tân Phú', 'Tan Phu'),
('30625', 'WARD', '892', 'Vĩnh Thành', 'Vinh Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 893 - Chợ Mới
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30628', 'WARD', '893', 'Thị trấn Chợ Mới', 'Thi tran Cho Moi'),
('30631', 'WARD', '893', 'Thị trấn Mỹ Luông', 'Thi tran My Luong'),
('30634', 'WARD', '893', 'Kiến An', 'Kien An'),
('30637', 'WARD', '893', 'Mỹ Hội Đông', 'My Hoi Dong'),
('30640', 'WARD', '893', 'Long Điền A', 'Long Dien A'),
('30643', 'WARD', '893', 'Tấn Mỹ', 'Tan My'),
('30646', 'WARD', '893', 'Long Điền B', 'Long Dien B'),
('30649', 'WARD', '893', 'Kiến Thành', 'Kien Thanh'),
('30652', 'WARD', '893', 'Mỹ Hiệp', 'My Hiep'),
('30655', 'WARD', '893', 'Mỹ An', 'My An'),
('30658', 'WARD', '893', 'Nhơn Mỹ', 'Nhon My'),
('30661', 'WARD', '893', 'Long Giang', 'Long Giang'),
('30664', 'WARD', '893', 'Long Kiến', 'Long Kien'),
('30667', 'WARD', '893', 'Bình Phước Xuân', 'Binh Phuoc Xuan'),
('30670', 'WARD', '893', 'An Thạnh Trung', 'An Thanh Trung'),
('30673', 'WARD', '893', 'Thị trấn Hội An', 'Thi tran Hoi An'),
('30676', 'WARD', '893', 'Hòa Bình', 'Hoa Binh'),
('30679', 'WARD', '893', 'Hòa An', 'Hoa An')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 894 - Thoại Sơn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30682', 'WARD', '894', 'Thị trấn Núi Sập', 'Thi tran Nui Sap'),
('30685', 'WARD', '894', 'Thị trấn Phú Hoà', 'Thi tran Phu Hoa'),
('30688', 'WARD', '894', 'Thị trấn Óc Eo', 'Thi tran Oc Eo'),
('30691', 'WARD', '894', 'Tây Phú', 'Tay Phu'),
('30692', 'WARD', '894', 'An Bình', 'An Binh'),
('30694', 'WARD', '894', 'Vĩnh Phú', 'Vinh Phu'),
('30697', 'WARD', '894', 'Vĩnh Trạch', 'Vinh Trach'),
('30700', 'WARD', '894', 'Phú Thuận', 'Phu Thuan'),
('30703', 'WARD', '894', 'Vĩnh Chánh', 'Vinh Chanh'),
('30706', 'WARD', '894', 'Định Mỹ', 'Dinh My'),
('30709', 'WARD', '894', 'Định Thành', 'Dinh Thanh'),
('30712', 'WARD', '894', 'Mỹ Phú Đông', 'My Phu Dong'),
('30715', 'WARD', '894', 'Vọng Đông', 'Vong Dong'),
('30718', 'WARD', '894', 'Vĩnh Khánh', 'Vinh Khanh'),
('30721', 'WARD', '894', 'Thoại Giang', 'Thoai Giang'),
('30724', 'WARD', '894', 'Bình Thành', 'Binh Thanh'),
('30727', 'WARD', '894', 'Vọng Thê', 'Vong The')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 91 - Kiên Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('899', 'DISTRICT', '91', 'Rạch Giá', 'Thanh pho Rach Gia'),
('900', 'DISTRICT', '91', 'Hà Tiên', 'Thanh pho Ha Tien'),
('902', 'DISTRICT', '91', 'Kiên Lương', 'Kien Luong'),
('903', 'DISTRICT', '91', 'Hòn Đất', 'Hon Dat'),
('904', 'DISTRICT', '91', 'Tân Hiệp', 'Tan Hiep'),
('905', 'DISTRICT', '91', 'Châu Thành', 'Chau Thanh'),
('906', 'DISTRICT', '91', 'Giồng Riềng', 'Giong Rieng'),
('907', 'DISTRICT', '91', 'Gò Quao', 'Go Quao'),
('908', 'DISTRICT', '91', 'An Biên', 'An Bien'),
('909', 'DISTRICT', '91', 'An Minh', 'An Minh'),
('910', 'DISTRICT', '91', 'Vĩnh Thuận', 'Vinh Thuan'),
('911', 'DISTRICT', '91', 'Phú Quốc', 'Thanh pho Phu Quoc'),
('912', 'DISTRICT', '91', 'Kiên Hải', 'Kien Hai'),
('913', 'DISTRICT', '91', 'U Minh Thượng', 'U Minh Thuong'),
('914', 'DISTRICT', '91', 'Giang Thành', 'Giang Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 899 - Rạch Giá
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30733', 'WARD', '899', 'Vĩnh Thanh', 'Vinh Thanh'),
('30736', 'WARD', '899', 'Vĩnh Quang', 'Vinh Quang'),
('30739', 'WARD', '899', 'Vĩnh Hiệp', 'Vinh Hiep'),
('30742', 'WARD', '899', 'Vĩnh Thanh Vân', 'Vinh Thanh Van'),
('30745', 'WARD', '899', 'Vĩnh Lạc', 'Vinh Lac'),
('30748', 'WARD', '899', 'An Hòa', 'An Hoa'),
('30751', 'WARD', '899', 'An Bình', 'An Binh'),
('30754', 'WARD', '899', 'Rạch Sỏi', 'Rach Soi'),
('30757', 'WARD', '899', 'Vĩnh Lợi', 'Vinh Loi'),
('30760', 'WARD', '899', 'Vĩnh Thông', 'Vinh Thong'),
('30763', 'WARD', '899', 'Phi Thông', 'Phi Thong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 900 - Hà Tiên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30766', 'WARD', '900', 'Tô Châu', 'To Chau'),
('30769', 'WARD', '900', 'Đông Hồ', 'Dong Ho'),
('30772', 'WARD', '900', 'Bình San', 'Binh San'),
('30775', 'WARD', '900', 'Pháo Đài', 'Phao Dai'),
('30778', 'WARD', '900', 'Mỹ Đức', 'My Duc'),
('30781', 'WARD', '900', 'Tiên Hải', 'Tien Hai'),
('30784', 'WARD', '900', 'Thuận Yên', 'Thuan Yen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 902 - Kiên Lương
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30787', 'WARD', '902', 'Thị trấn Kiên Lương', 'Thi tran Kien Luong'),
('30790', 'WARD', '902', 'Kiên Bình', 'Kien Binh'),
('30802', 'WARD', '902', 'Hòa Điền', 'Hoa Dien'),
('30805', 'WARD', '902', 'Dương Hòa', 'Duong Hoa'),
('30808', 'WARD', '902', 'Bình An', 'Binh An'),
('30809', 'WARD', '902', 'Bình Trị', 'Binh Tri'),
('30811', 'WARD', '902', 'Sơn Hải', 'Son Hai'),
('30814', 'WARD', '902', 'Hòn Nghệ', 'Hon Nghe')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 903 - Hòn Đất
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30817', 'WARD', '903', 'Thị trấn Hòn Đất', 'Thi tran Hon Dat'),
('30820', 'WARD', '903', 'Thị trấn Sóc Sơn', 'Thi tran Soc Son'),
('30823', 'WARD', '903', 'Bình Sơn', 'Binh Son'),
('30826', 'WARD', '903', 'Bình Giang', 'Binh Giang'),
('30828', 'WARD', '903', 'Mỹ Thái', 'My Thai'),
('30829', 'WARD', '903', 'Nam Thái Sơn', 'Nam Thai Son'),
('30832', 'WARD', '903', 'Mỹ Hiệp Sơn', 'My Hiep Son'),
('30835', 'WARD', '903', 'Sơn Kiên', 'Son Kien'),
('30836', 'WARD', '903', 'Sơn Bình', 'Son Binh'),
('30838', 'WARD', '903', 'Mỹ Thuận', 'My Thuan'),
('30840', 'WARD', '903', 'Lình Huỳnh', 'Linh Huynh'),
('30841', 'WARD', '903', 'Thổ Sơn', 'Tho Son'),
('30844', 'WARD', '903', 'Mỹ Lâm', 'My Lam'),
('30847', 'WARD', '903', 'Mỹ Phước', 'My Phuoc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 904 - Tân Hiệp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30850', 'WARD', '904', 'Thị trấn Tân Hiệp', 'Thi tran Tan Hiep'),
('30853', 'WARD', '904', 'Tân Hội', 'Tan Hoi'),
('30856', 'WARD', '904', 'Tân Thành', 'Tan Thanh'),
('30859', 'WARD', '904', 'Tân Hiệp B', 'Tan Hiep B'),
('30860', 'WARD', '904', 'Tân Hoà', 'Tan Hoa'),
('30862', 'WARD', '904', 'Thạnh Đông B', 'Thanh Dong B'),
('30865', 'WARD', '904', 'Thạnh Đông', 'Thanh Dong'),
('30868', 'WARD', '904', 'Tân Hiệp A', 'Tan Hiep A'),
('30871', 'WARD', '904', 'Tân An', 'Tan An'),
('30874', 'WARD', '904', 'Thạnh Đông A', 'Thanh Dong A'),
('30877', 'WARD', '904', 'Thạnh Trị', 'Thanh Tri')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 905 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30880', 'WARD', '905', 'Thị trấn Minh Lương', 'Thi tran Minh Luong'),
('30883', 'WARD', '905', 'Mong Thọ A', 'Mong Tho A'),
('30886', 'WARD', '905', 'Mong Thọ B', 'Mong Tho B'),
('30887', 'WARD', '905', 'Mong Thọ', 'Mong Tho'),
('30889', 'WARD', '905', 'Giục Tượng', 'Giuc Tuong'),
('30892', 'WARD', '905', 'Vĩnh Hòa Hiệp', 'Vinh Hoa Hiep'),
('30893', 'WARD', '905', 'Vĩnh Hoà Phú', 'Vinh Hoa Phu'),
('30895', 'WARD', '905', 'Minh Hòa', 'Minh Hoa'),
('30898', 'WARD', '905', 'Bình An', 'Binh An'),
('30901', 'WARD', '905', 'Thạnh Lộc', 'Thanh Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 906 - Giồng Riềng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30904', 'WARD', '906', 'Thị trấn Giồng Riềng', 'Thi tran Giong Rieng'),
('30907', 'WARD', '906', 'Thạnh Hưng', 'Thanh Hung'),
('30910', 'WARD', '906', 'Thạnh Phước', 'Thanh Phuoc'),
('30913', 'WARD', '906', 'Thạnh Lộc', 'Thanh Loc'),
('30916', 'WARD', '906', 'Thạnh Hòa', 'Thanh Hoa'),
('30917', 'WARD', '906', 'Thạnh Bình', 'Thanh Binh'),
('30919', 'WARD', '906', 'Bàn Thạch', 'Ban Thach'),
('30922', 'WARD', '906', 'Bàn Tân Định', 'Ban Tan Dinh'),
('30925', 'WARD', '906', 'Ngọc Thành', 'Ngoc Thanh'),
('30928', 'WARD', '906', 'Ngọc Chúc', 'Ngoc Chuc'),
('30931', 'WARD', '906', 'Ngọc Thuận', 'Ngoc Thuan'),
('30934', 'WARD', '906', 'Hòa Hưng', 'Hoa Hung'),
('30937', 'WARD', '906', 'Hoà Lợi', 'Hoa Loi'),
('30940', 'WARD', '906', 'Hoà An', 'Hoa An'),
('30943', 'WARD', '906', 'Long Thạnh', 'Long Thanh'),
('30946', 'WARD', '906', 'Vĩnh Thạnh', 'Vinh Thanh'),
('30947', 'WARD', '906', 'Vĩnh Phú', 'Vinh Phu'),
('30949', 'WARD', '906', 'Hòa Thuận', 'Hoa Thuan'),
('30950', 'WARD', '906', 'Ngọc Hoà', 'Ngoc Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 907 - Gò Quao
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30952', 'WARD', '907', 'Thị trấn Gò Quao', 'Thi tran Go Quao'),
('30955', 'WARD', '907', 'Vĩnh Hòa Hưng Bắc', 'Vinh Hoa Hung Bac'),
('30958', 'WARD', '907', 'Định Hòa', 'Dinh Hoa'),
('30961', 'WARD', '907', 'Thới Quản', 'Thoi Quan'),
('30964', 'WARD', '907', 'Định An', 'Dinh An'),
('30967', 'WARD', '907', 'Thủy Liễu', 'Thuy Lieu'),
('30970', 'WARD', '907', 'Vĩnh Hòa Hưng Nam', 'Vinh Hoa Hung Nam'),
('30973', 'WARD', '907', 'Vĩnh Phước A', 'Vinh Phuoc A'),
('30976', 'WARD', '907', 'Vĩnh Phước B', 'Vinh Phuoc B'),
('30979', 'WARD', '907', 'Vĩnh Tuy', 'Vinh Tuy'),
('30982', 'WARD', '907', 'Vĩnh Thắng', 'Vinh Thang')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 908 - An Biên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30985', 'WARD', '908', 'Thị trấn Thứ Ba', 'Thi tran Thu Ba'),
('30988', 'WARD', '908', 'Tây Yên', 'Tay Yen'),
('30991', 'WARD', '908', 'Tây Yên A', 'Tay Yen A'),
('30994', 'WARD', '908', 'Nam Yên', 'Nam Yen'),
('30997', 'WARD', '908', 'Hưng Yên', 'Hung Yen'),
('31000', 'WARD', '908', 'Nam Thái', 'Nam Thai'),
('31003', 'WARD', '908', 'Nam Thái A', 'Nam Thai A'),
('31006', 'WARD', '908', 'Đông Thái', 'Dong Thai'),
('31009', 'WARD', '908', 'Đông Yên', 'Dong Yen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 909 - An Minh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31018', 'WARD', '909', 'Thị trấn Thứ Mười Một', 'Thi tran Thu Muoi Mot'),
('31021', 'WARD', '909', 'Thuận Hoà', 'Thuan Hoa'),
('31024', 'WARD', '909', 'Đông Hòa', 'Dong Hoa'),
('31030', 'WARD', '909', 'Đông Thạnh', 'Dong Thanh'),
('31031', 'WARD', '909', 'Tân Thạnh', 'Tan Thanh'),
('31033', 'WARD', '909', 'Đông Hưng', 'Dong Hung'),
('31036', 'WARD', '909', 'Đông Hưng A', 'Dong Hung A'),
('31039', 'WARD', '909', 'Đông Hưng B', 'Dong Hung B'),
('31042', 'WARD', '909', 'Vân Khánh', 'Van Khanh'),
('31045', 'WARD', '909', 'Vân Khánh Đông', 'Van Khanh Dong'),
('31048', 'WARD', '909', 'Vân Khánh Tây', 'Van Khanh Tay')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 910 - Vĩnh Thuận
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31051', 'WARD', '910', 'Thị trấn Vĩnh Thuận', 'Thi tran Vinh Thuan'),
('31060', 'WARD', '910', 'Vĩnh Bình Bắc', 'Vinh Binh Bac'),
('31063', 'WARD', '910', 'Vĩnh Bình Nam', 'Vinh Binh Nam'),
('31064', 'WARD', '910', 'Bình Minh', 'Binh Minh'),
('31069', 'WARD', '910', 'Vĩnh Thuận', 'Vinh Thuan'),
('31072', 'WARD', '910', 'Tân Thuận', 'Tan Thuan'),
('31074', 'WARD', '910', 'Phong Đông', 'Phong Dong'),
('31075', 'WARD', '910', 'Vĩnh Phong', 'Vinh Phong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 911 - Phú Quốc
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31078', 'WARD', '911', 'Dương Đông', 'Duong Dong'),
('31081', 'WARD', '911', 'An Thới', 'An Thoi'),
('31084', 'WARD', '911', 'Cửa Cạn', 'Cua Can'),
('31087', 'WARD', '911', 'Gành Dầu', 'Ganh Dau'),
('31090', 'WARD', '911', 'Cửa Dương', 'Cua Duong'),
('31093', 'WARD', '911', 'Hàm Ninh', 'Ham Ninh'),
('31096', 'WARD', '911', 'Dương Tơ', 'Duong To'),
('31102', 'WARD', '911', 'Bãi Thơm', 'Bai Thom'),
('31105', 'WARD', '911', 'Thổ Châu', 'Tho Chau')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 912 - Kiên Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31108', 'WARD', '912', 'Hòn Tre', 'Hon Tre'),
('31111', 'WARD', '912', 'Lại Sơn', 'Lai Son'),
('31114', 'WARD', '912', 'An Sơn', 'An Son'),
('31115', 'WARD', '912', 'Nam Du', 'Nam Du')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 913 - U Minh Thượng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31012', 'WARD', '913', 'Thạnh Yên', 'Thanh Yen'),
('31015', 'WARD', '913', 'Thạnh Yên A', 'Thanh Yen A'),
('31027', 'WARD', '913', 'An Minh Bắc', 'An Minh Bac'),
('31054', 'WARD', '913', 'Vĩnh Hòa', 'Vinh Hoa'),
('31057', 'WARD', '913', 'Hoà Chánh', 'Hoa Chanh'),
('31066', 'WARD', '913', 'Minh Thuận', 'Minh Thuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 914 - Giang Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('30791', 'WARD', '914', 'Vĩnh Phú', 'Vinh Phu'),
('30793', 'WARD', '914', 'Vĩnh Điều', 'Vinh Dieu'),
('30796', 'WARD', '914', 'Tân Khánh Hòa', 'Tan Khanh Hoa'),
('30797', 'WARD', '914', 'Phú Lợi', 'Phu Loi'),
('30799', 'WARD', '914', 'Phú Mỹ', 'Phu My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 92 - Cần Thơ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('916', 'DISTRICT', '92', 'Ninh Kiều', 'Ninh Kieu'),
('917', 'DISTRICT', '92', 'Ô Môn', 'O Mon'),
('918', 'DISTRICT', '92', 'Bình Thuỷ', 'Binh Thuy'),
('919', 'DISTRICT', '92', 'Cái Răng', 'Cai Rang'),
('923', 'DISTRICT', '92', 'Thốt Nốt', 'Thot Not'),
('924', 'DISTRICT', '92', 'Vĩnh Thạnh', 'Vinh Thanh'),
('925', 'DISTRICT', '92', 'Cờ Đỏ', 'Co Do'),
('926', 'DISTRICT', '92', 'Phong Điền', 'Phong Dien'),
('927', 'DISTRICT', '92', 'Thới Lai', 'Thoi Lai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 916 - Ninh Kiều
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31117', 'WARD', '916', 'Cái Khế', 'Cai Khe'),
('31120', 'WARD', '916', 'An Hòa', 'An Hoa'),
('31123', 'WARD', '916', 'Thới Bình', 'Thoi Binh'),
('31135', 'WARD', '916', 'Tân An', 'Tan An'),
('31144', 'WARD', '916', 'Xuân Khánh', 'Xuan Khanh'),
('31147', 'WARD', '916', 'Hưng Lợi', 'Hung Loi'),
('31149', 'WARD', '916', 'An Khánh', 'An Khanh'),
('31150', 'WARD', '916', 'An Bình', 'An Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 917 - Ô Môn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31153', 'WARD', '917', 'Châu Văn Liêm', 'Chau Van Liem'),
('31154', 'WARD', '917', 'Thới Hòa', 'Thoi Hoa'),
('31156', 'WARD', '917', 'Thới Long', 'Thoi Long'),
('31157', 'WARD', '917', 'Long Hưng', 'Long Hung'),
('31159', 'WARD', '917', 'Thới An', 'Thoi An'),
('31162', 'WARD', '917', 'Phước Thới', 'Phuoc Thoi'),
('31165', 'WARD', '917', 'Trường Lạc', 'Truong Lac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 918 - Bình Thuỷ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31168', 'WARD', '918', 'Bình Thủy', 'Binh Thuy'),
('31169', 'WARD', '918', 'Trà An', 'Tra An'),
('31171', 'WARD', '918', 'Trà Nóc', 'Tra Noc'),
('31174', 'WARD', '918', 'Thới An Đông', 'Thoi An Dong'),
('31177', 'WARD', '918', 'An Thới', 'An Thoi'),
('31178', 'WARD', '918', 'Bùi Hữu Nghĩa', 'Bui Huu Nghia'),
('31180', 'WARD', '918', 'Long Hòa', 'Long Hoa'),
('31183', 'WARD', '918', 'Long Tuyền', 'Long Tuyen')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 919 - Cái Răng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31186', 'WARD', '919', 'Lê Bình', 'Le Binh'),
('31189', 'WARD', '919', 'Hưng Phú', 'Hung Phu'),
('31192', 'WARD', '919', 'Hưng Thạnh', 'Hung Thanh'),
('31195', 'WARD', '919', 'Ba Láng', 'Ba Lang'),
('31198', 'WARD', '919', 'Thường Thạnh', 'Thuong Thanh'),
('31201', 'WARD', '919', 'Phú Thứ', 'Phu Thu'),
('31204', 'WARD', '919', 'Tân Phú', 'Tan Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 923 - Thốt Nốt
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31207', 'WARD', '923', 'Thốt Nốt', 'Thot Not'),
('31210', 'WARD', '923', 'Thới Thuận', 'Thoi Thuan'),
('31212', 'WARD', '923', 'Thuận An', 'Thuan An'),
('31213', 'WARD', '923', 'Tân Lộc', 'Tan Loc'),
('31216', 'WARD', '923', 'Trung Nhứt', 'Trung Nhut'),
('31217', 'WARD', '923', 'Thạnh Hoà', 'Thanh Hoa'),
('31219', 'WARD', '923', 'Trung Kiên', 'Trung Kien'),
('31227', 'WARD', '923', 'Tân Hưng', 'Tan Hung'),
('31228', 'WARD', '923', 'Thuận Hưng', 'Thuan Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 924 - Vĩnh Thạnh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31211', 'WARD', '924', 'Vĩnh Bình', 'Vinh Binh'),
('31231', 'WARD', '924', 'Thị trấn Thanh An', 'Thi tran Thanh An'),
('31232', 'WARD', '924', 'Thị trấn Vĩnh Thạnh', 'Thi tran Vinh Thanh'),
('31234', 'WARD', '924', 'Thạnh Mỹ', 'Thanh My'),
('31237', 'WARD', '924', 'Vĩnh Trinh', 'Vinh Trinh'),
('31240', 'WARD', '924', 'Thạnh An', 'Thanh An'),
('31241', 'WARD', '924', 'Thạnh Tiến', 'Thanh Tien'),
('31243', 'WARD', '924', 'Thạnh Thắng', 'Thanh Thang'),
('31244', 'WARD', '924', 'Thạnh Lợi', 'Thanh Loi'),
('31246', 'WARD', '924', 'Thạnh Qưới', 'Thanh Quoi'),
('31252', 'WARD', '924', 'Thạnh Lộc', 'Thanh Loc')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 925 - Cờ Đỏ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31222', 'WARD', '925', 'Trung An', 'Trung An'),
('31225', 'WARD', '925', 'Trung Thạnh', 'Trung Thanh'),
('31249', 'WARD', '925', 'Thạnh Phú', 'Thanh Phu'),
('31255', 'WARD', '925', 'Trung Hưng', 'Trung Hung'),
('31261', 'WARD', '925', 'Thị trấn Cờ Đỏ', 'Thi tran Co Do'),
('31264', 'WARD', '925', 'Thới Hưng', 'Thoi Hung'),
('31273', 'WARD', '925', 'Đông Hiệp', 'Dong Hiep'),
('31274', 'WARD', '925', 'Đông Thắng', 'Dong Thang'),
('31276', 'WARD', '925', 'Thới Đông', 'Thoi Dong'),
('31277', 'WARD', '925', 'Thới Xuân', 'Thoi Xuan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 926 - Phong Điền
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31299', 'WARD', '926', 'Thị trấn Phong Điền', 'Thi tran Phong Dien'),
('31300', 'WARD', '926', 'Nhơn Ái', 'Nhon Ai'),
('31303', 'WARD', '926', 'Giai Xuân', 'Giai Xuan'),
('31306', 'WARD', '926', 'Tân Thới', 'Tan Thoi'),
('31309', 'WARD', '926', 'Trường Long', 'Truong Long'),
('31312', 'WARD', '926', 'Mỹ Khánh', 'My Khanh'),
('31315', 'WARD', '926', 'Nhơn Nghĩa', 'Nhon Nghia')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 927 - Thới Lai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31258', 'WARD', '927', 'Thị trấn Thới Lai', 'Thi tran Thoi Lai'),
('31267', 'WARD', '927', 'Thới Thạnh', 'Thoi Thanh'),
('31268', 'WARD', '927', 'Tân Thạnh', 'Tan Thanh'),
('31270', 'WARD', '927', 'Xuân Thắng', 'Xuan Thang'),
('31279', 'WARD', '927', 'Đông Bình', 'Dong Binh'),
('31282', 'WARD', '927', 'Đông Thuận', 'Dong Thuan'),
('31285', 'WARD', '927', 'Thới Tân', 'Thoi Tan'),
('31286', 'WARD', '927', 'Trường Thắng', 'Truong Thang'),
('31288', 'WARD', '927', 'Định Môn', 'Dinh Mon'),
('31291', 'WARD', '927', 'Trường Thành', 'Truong Thanh'),
('31294', 'WARD', '927', 'Trường Xuân', 'Truong Xuan'),
('31297', 'WARD', '927', 'Trường Xuân A', 'Truong Xuan A'),
('31298', 'WARD', '927', 'Trường Xuân B', 'Truong Xuan B')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 93 - Hậu Giang
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('930', 'DISTRICT', '93', 'Vị Thanh', 'Thanh pho Vi Thanh'),
('931', 'DISTRICT', '93', 'Ngã Bảy', 'Thanh pho Nga Bay'),
('932', 'DISTRICT', '93', 'Châu Thành A', 'Chau Thanh A'),
('933', 'DISTRICT', '93', 'Châu Thành', 'Chau Thanh'),
('934', 'DISTRICT', '93', 'Phụng Hiệp', 'Phung Hiep'),
('935', 'DISTRICT', '93', 'Vị Thuỷ', 'Vi Thuy'),
('936', 'DISTRICT', '93', 'Long Mỹ', 'Long My'),
('937', 'DISTRICT', '93', 'Thị Long Mỹ', 'Thi Long My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 930 - Vị Thanh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31318', 'WARD', '930', 'I', 'I'),
('31321', 'WARD', '930', 'III', 'III'),
('31324', 'WARD', '930', 'IV', 'IV'),
('31327', 'WARD', '930', 'V', 'V'),
('31330', 'WARD', '930', 'VII', 'VII'),
('31333', 'WARD', '930', 'Vị Tân', 'Vi Tan'),
('31336', 'WARD', '930', 'Hoả Lựu', 'Hoa Luu'),
('31338', 'WARD', '930', 'Tân Tiến', 'Tan Tien'),
('31339', 'WARD', '930', 'Hoả Tiến', 'Hoa Tien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 931 - Ngã Bảy
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31340', 'WARD', '931', 'Ngã Bảy', 'Nga Bay'),
('31341', 'WARD', '931', 'Lái Hiếu', 'Lai Hieu'),
('31343', 'WARD', '931', 'Hiệp Thành', 'Hiep Thanh'),
('31344', 'WARD', '931', 'Hiệp Lợi', 'Hiep Loi'),
('31411', 'WARD', '931', 'Đại Thành', 'Dai Thanh'),
('31414', 'WARD', '931', 'Tân Thành', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 932 - Châu Thành A
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31342', 'WARD', '932', 'Thị trấn Một Ngàn', 'Thi tran Mot Ngan'),
('31345', 'WARD', '932', 'Tân Hoà', 'Tan Hoa'),
('31346', 'WARD', '932', 'Thị trấn Bảy Ngàn', 'Thi tran Bay Ngan'),
('31348', 'WARD', '932', 'Trường Long Tây', 'Truong Long Tay'),
('31351', 'WARD', '932', 'Trường Long A', 'Truong Long A'),
('31357', 'WARD', '932', 'Nhơn Nghĩa A', 'Nhon Nghia A'),
('31359', 'WARD', '932', 'Thị trấn Rạch Gòi', 'Thi tran Rach Goi'),
('31360', 'WARD', '932', 'Thạnh Xuân', 'Thanh Xuan'),
('31362', 'WARD', '932', 'Thị trấn Cái Tắc', 'Thi tran Cai Tac'),
('31363', 'WARD', '932', 'Tân Phú Thạnh', 'Tan Phu Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 933 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31366', 'WARD', '933', 'Thị trấn Ngã Sáu', 'Thi tran Nga Sau'),
('31369', 'WARD', '933', 'Đông Thạnh', 'Dong Thanh'),
('31375', 'WARD', '933', 'Đông Phú', 'Dong Phu'),
('31378', 'WARD', '933', 'Phú Hữu', 'Phu Huu'),
('31379', 'WARD', '933', 'Phú Tân', 'Phu Tan'),
('31381', 'WARD', '933', 'Thị trấn Mái Dầm', 'Thi tran Mai Dam'),
('31384', 'WARD', '933', 'Đông Phước', 'Dong Phuoc'),
('31387', 'WARD', '933', 'Đông Phước A', 'Dong Phuoc A')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 934 - Phụng Hiệp
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31393', 'WARD', '934', 'Thị trấn Kinh Cùng', 'Thi tran Kinh Cung'),
('31396', 'WARD', '934', 'Thị trấn Cây Dương', 'Thi tran Cay Duong'),
('31399', 'WARD', '934', 'Tân Bình', 'Tan Binh'),
('31402', 'WARD', '934', 'Bình Thành', 'Binh Thanh'),
('31405', 'WARD', '934', 'Thạnh Hòa', 'Thanh Hoa'),
('31408', 'WARD', '934', 'Long Thạnh', 'Long Thanh'),
('31417', 'WARD', '934', 'Phụng Hiệp', 'Phung Hiep'),
('31420', 'WARD', '934', 'Hòa Mỹ', 'Hoa My'),
('31423', 'WARD', '934', 'Hòa An', 'Hoa An'),
('31426', 'WARD', '934', 'Phương Bình', 'Binh'),
('31429', 'WARD', '934', 'Hiệp Hưng', 'Hiep Hung'),
('31432', 'WARD', '934', 'Tân Phước Hưng', 'Tan Phuoc Hung'),
('31433', 'WARD', '934', 'Thị trấn Búng Tàu', 'Thi tran Bung Tau'),
('31435', 'WARD', '934', 'Phương Phú', 'Phu'),
('31438', 'WARD', '934', 'Tân Long', 'Tan Long')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 935 - Vị Thuỷ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31441', 'WARD', '935', 'Thị trấn Nàng Mau', 'Thi tran Nang Mau'),
('31444', 'WARD', '935', 'Vị Trung', 'Vi Trung'),
('31447', 'WARD', '935', 'Vị Thuỷ', 'Vi Thuy'),
('31450', 'WARD', '935', 'Vị Thắng', 'Vi Thang'),
('31453', 'WARD', '935', 'Vĩnh Thuận Tây', 'Vinh Thuan Tay'),
('31456', 'WARD', '935', 'Vĩnh Trung', 'Vinh Trung'),
('31459', 'WARD', '935', 'Vĩnh Tường', 'Vinh Tuong'),
('31462', 'WARD', '935', 'Vị Đông', 'Vi Dong'),
('31465', 'WARD', '935', 'Vị Thanh', 'Vi Thanh'),
('31468', 'WARD', '935', 'Vị Bình', 'Vi Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 936 - Long Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31483', 'WARD', '936', 'Thuận Hưng', 'Thuan Hung'),
('31484', 'WARD', '936', 'Thuận Hòa', 'Thuan Hoa'),
('31486', 'WARD', '936', 'Vĩnh Thuận Đông', 'Vinh Thuan Dong'),
('31489', 'WARD', '936', 'Thị trấn Vĩnh Viễn', 'Thi tran Vinh Vien'),
('31490', 'WARD', '936', 'Vĩnh Viễn A', 'Vinh Vien A'),
('31492', 'WARD', '936', 'Lương Tâm', 'Luong Tam'),
('31493', 'WARD', '936', 'Lương Nghĩa', 'Luong Nghia'),
('31495', 'WARD', '936', 'Xà Phiên', 'Phien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 937 - Thị Long Mỹ
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31471', 'WARD', '937', 'Thuận An', 'Thuan An'),
('31472', 'WARD', '937', 'Trà Lồng', 'Tra Long'),
('31473', 'WARD', '937', 'Bình Thạnh', 'Binh Thanh'),
('31474', 'WARD', '937', 'Long Bình', 'Long Binh'),
('31475', 'WARD', '937', 'Vĩnh Tường', 'Vinh Tuong'),
('31477', 'WARD', '937', 'Long Trị', 'Long Tri'),
('31478', 'WARD', '937', 'Long Trị A', 'Long Tri A'),
('31480', 'WARD', '937', 'Long Phú', 'Long Phu'),
('31481', 'WARD', '937', 'Tân Phú', 'Tan Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 94 - Sóc Trăng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('941', 'DISTRICT', '94', 'Sóc Trăng', 'Thanh pho Soc Trang'),
('942', 'DISTRICT', '94', 'Châu Thành', 'Chau Thanh'),
('943', 'DISTRICT', '94', 'Kế Sách', 'Ke Sach'),
('944', 'DISTRICT', '94', 'Mỹ Tú', 'My Tu'),
('945', 'DISTRICT', '94', 'Cù Lao Dung', 'Cu Lao Dung'),
('946', 'DISTRICT', '94', 'Long Phú', 'Long Phu'),
('947', 'DISTRICT', '94', 'Mỹ Xuyên', 'My Xuyen'),
('948', 'DISTRICT', '94', 'Thị Ngã Năm', 'Thi Nga Nam'),
('949', 'DISTRICT', '94', 'Thạnh Trị', 'Thanh Tri'),
('950', 'DISTRICT', '94', 'Thị Vĩnh Châu', 'Thi Vinh Chau'),
('951', 'DISTRICT', '94', 'Trần Đề', 'Tran De')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 941 - Sóc Trăng
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31498', 'WARD', '941', 'Phường 5', 'Ward 5'),
('31501', 'WARD', '941', 'Phường 7', 'Ward 7'),
('31504', 'WARD', '941', 'Phường 8', 'Ward 8'),
('31507', 'WARD', '941', 'Phường 6', 'Ward 6'),
('31510', 'WARD', '941', 'Phường 2', 'Ward 2'),
('31516', 'WARD', '941', 'Phường 4', 'Ward 4'),
('31519', 'WARD', '941', 'Phường 3', 'Ward 3'),
('31522', 'WARD', '941', 'Phường 1', 'Ward 1'),
('31525', 'WARD', '941', 'Phường 10', 'Ward 10')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 942 - Châu Thành
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31569', 'WARD', '942', 'Thị trấn Châu Thành', 'Thi tran Chau Thanh'),
('31570', 'WARD', '942', 'Hồ Đắc Kiện', 'Ho Dac Kien'),
('31573', 'WARD', '942', 'Phú Tâm', 'Phu Tam'),
('31576', 'WARD', '942', 'Thuận Hòa', 'Thuan Hoa'),
('31582', 'WARD', '942', 'Phú Tân', 'Phu Tan'),
('31585', 'WARD', '942', 'Thiện Mỹ', 'Thien My'),
('31594', 'WARD', '942', 'An Hiệp', 'An Hiep'),
('31600', 'WARD', '942', 'An Ninh', 'An Ninh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 943 - Kế Sách
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31528', 'WARD', '943', 'Thị trấn Kế Sách', 'Thi tran Ke Sach'),
('31531', 'WARD', '943', 'Thị trấn An Lạc Thôn', 'Thi tran An Lac Thon'),
('31534', 'WARD', '943', 'Xuân Hòa', 'Xuan Hoa'),
('31537', 'WARD', '943', 'Phong Nẫm', 'Phong Nam'),
('31540', 'WARD', '943', 'An Lạc Tây', 'An Lac Tay'),
('31543', 'WARD', '943', 'Trinh Phú', 'Trinh Phu'),
('31546', 'WARD', '943', 'Ba Trinh', 'Ba Trinh'),
('31549', 'WARD', '943', 'Thới An Hội', 'Thoi An Hoi'),
('31552', 'WARD', '943', 'Nhơn Mỹ', 'Nhon My'),
('31555', 'WARD', '943', 'Kế Thành', 'Ke Thanh'),
('31558', 'WARD', '943', 'Kế An', 'Ke An'),
('31561', 'WARD', '943', 'Đại Hải', 'Dai Hai'),
('31564', 'WARD', '943', 'An Mỹ', 'An My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 944 - Mỹ Tú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31567', 'WARD', '944', 'Thị trấn Huỳnh Hữu Nghĩa', 'Thi tran Huynh Huu Nghia'),
('31579', 'WARD', '944', 'Long Hưng', 'Long Hung'),
('31588', 'WARD', '944', 'Hưng Phú', 'Hung Phu'),
('31591', 'WARD', '944', 'Mỹ Hương', 'My Huong'),
('31597', 'WARD', '944', 'Mỹ Tú', 'My Tu'),
('31603', 'WARD', '944', 'Mỹ Phước', 'My Phuoc'),
('31606', 'WARD', '944', 'Thuận Hưng', 'Thuan Hung'),
('31609', 'WARD', '944', 'Mỹ Thuận', 'My Thuan'),
('31612', 'WARD', '944', 'Phú Mỹ', 'Phu My')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 945 - Cù Lao Dung
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31615', 'WARD', '945', 'Thị trấn Cù Lao Dung', 'Thi tran Cu Lao Dung'),
('31618', 'WARD', '945', 'An Thạnh 1', 'An Thanh 1'),
('31621', 'WARD', '945', 'An Thạnh Tây', 'An Thanh Tay'),
('31624', 'WARD', '945', 'An Thạnh Đông', 'An Thanh Dong'),
('31627', 'WARD', '945', 'Đại Ân 1', 'Dai An 1'),
('31630', 'WARD', '945', 'An Thạnh 2', 'An Thanh 2'),
('31633', 'WARD', '945', 'An Thạnh 3', 'An Thanh 3'),
('31636', 'WARD', '945', 'An Thạnh Nam', 'An Thanh Nam')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 946 - Long Phú
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31639', 'WARD', '946', 'Thị trấn Long Phú', 'Thi tran Long Phu'),
('31642', 'WARD', '946', 'Song Phụng', 'Song Phung'),
('31645', 'WARD', '946', 'Thị trấn Đại Ngãi', 'Thi tran Dai Ngai'),
('31648', 'WARD', '946', 'Hậu Thạnh', 'Hau Thanh'),
('31651', 'WARD', '946', 'Long Đức', 'Long Duc'),
('31654', 'WARD', '946', 'Trường Khánh', 'Truong Khanh'),
('31657', 'WARD', '946', 'Phú Hữu', 'Phu Huu'),
('31660', 'WARD', '946', 'Tân Hưng', 'Tan Hung'),
('31663', 'WARD', '946', 'Châu Khánh', 'Chau Khanh'),
('31666', 'WARD', '946', 'Tân Thạnh', 'Tan Thanh'),
('31669', 'WARD', '946', 'Long Phú', 'Long Phu')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 947 - Mỹ Xuyên
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31684', 'WARD', '947', 'Thị trấn Mỹ Xuyên', 'Thi tran My Xuyen'),
('31690', 'WARD', '947', 'Đại Tâm', 'Dai Tam'),
('31693', 'WARD', '947', 'Tham Đôn', 'Tham Don'),
('31708', 'WARD', '947', 'Thạnh Phú', 'Thanh Phu'),
('31711', 'WARD', '947', 'Ngọc Đông', 'Ngoc Dong'),
('31714', 'WARD', '947', 'Thạnh Quới', 'Thanh Quoi'),
('31717', 'WARD', '947', 'Hòa Tú 1', 'Hoa Tu 1'),
('31720', 'WARD', '947', 'Gia Hòa 1', 'Gia Hoa 1'),
('31723', 'WARD', '947', 'Ngọc Tố', 'Ngoc To'),
('31726', 'WARD', '947', 'Gia Hòa 2', 'Gia Hoa 2'),
('31729', 'WARD', '947', 'Hòa Tú II', 'Hoa Tu II')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 948 - Thị Ngã Năm
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31732', 'WARD', '948', 'Phường 1', 'Ward 1'),
('31735', 'WARD', '948', 'Phường 2', 'Ward 2'),
('31738', 'WARD', '948', 'Vĩnh Quới', 'Vinh Quoi'),
('31741', 'WARD', '948', 'Tân Long', 'Tan Long'),
('31744', 'WARD', '948', 'Long Bình', 'Long Binh'),
('31747', 'WARD', '948', 'Phường 3', 'Ward 3'),
('31750', 'WARD', '948', 'Mỹ Bình', 'My Binh'),
('31753', 'WARD', '948', 'Mỹ Quới', 'My Quoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 949 - Thạnh Trị
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31756', 'WARD', '949', 'Thị trấn Phú Lộc', 'Thi tran Phu Loc'),
('31757', 'WARD', '949', 'Thị trấn Hưng Lợi', 'Thi tran Hung Loi'),
('31759', 'WARD', '949', 'Lâm Tân', 'Lam Tan'),
('31762', 'WARD', '949', 'Thạnh Tân', 'Thanh Tan'),
('31765', 'WARD', '949', 'Lâm Kiết', 'Lam Kiet'),
('31768', 'WARD', '949', 'Tuân Tức', 'Tuan Tuc'),
('31771', 'WARD', '949', 'Vĩnh Thành', 'Vinh Thanh'),
('31774', 'WARD', '949', 'Thạnh Trị', 'Thanh Tri'),
('31777', 'WARD', '949', 'Vĩnh Lợi', 'Vinh Loi'),
('31780', 'WARD', '949', 'Châu Hưng', 'Chau Hung')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 950 - Thị Vĩnh Châu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31783', 'WARD', '950', 'Phường 1', 'Ward 1'),
('31786', 'WARD', '950', 'Hòa Đông', 'Hoa Dong'),
('31789', 'WARD', '950', 'Khánh Hòa', 'Khanh Hoa'),
('31792', 'WARD', '950', 'Vĩnh Hiệp', 'Vinh Hiep'),
('31795', 'WARD', '950', 'Vĩnh Hải', 'Vinh Hai'),
('31798', 'WARD', '950', 'Lạc Hòa', 'Lac Hoa'),
('31801', 'WARD', '950', 'Phường 2', 'Ward 2'),
('31804', 'WARD', '950', 'Vĩnh Phước', 'Vinh Phuoc'),
('31807', 'WARD', '950', 'Vĩnh Tân', 'Vinh Tan'),
('31810', 'WARD', '950', 'Lai Hòa', 'Lai Hoa')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 951 - Trần Đề
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31672', 'WARD', '951', 'Đại Ân 2', 'Dai An 2'),
('31673', 'WARD', '951', 'Thị trấn Trần Đề', 'Thi tran Tran De'),
('31675', 'WARD', '951', 'Liêu Tú', 'Lieu Tu'),
('31678', 'WARD', '951', 'Lịch Hội Thượng', 'Lich Hoi Thuong'),
('31679', 'WARD', '951', 'Thị trấn Lịch Hội Thượng', 'Thi tran Lich Hoi Thuong'),
('31681', 'WARD', '951', 'Trung Bình', 'Trung Binh'),
('31687', 'WARD', '951', 'Tài Văn', 'Tai Van'),
('31696', 'WARD', '951', 'Viên An', 'Vien An'),
('31699', 'WARD', '951', 'Thạnh Thới An', 'Thanh Thoi An'),
('31702', 'WARD', '951', 'Thạnh Thới Thuận', 'Thanh Thoi Thuan'),
('31705', 'WARD', '951', 'Viên Bình', 'Vien Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 95 - Bạc Liêu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('954', 'DISTRICT', '95', 'Bạc Liêu', 'Thanh pho Bac Lieu'),
('956', 'DISTRICT', '95', 'Hồng Dân', 'Hong Dan'),
('957', 'DISTRICT', '95', 'Phước Long', 'Phuoc Long'),
('958', 'DISTRICT', '95', 'Vĩnh Lợi', 'Vinh Loi'),
('959', 'DISTRICT', '95', 'Thị Giá Rai', 'Thi Gia Rai'),
('960', 'DISTRICT', '95', 'Đông Hải', 'Dong Hai'),
('961', 'DISTRICT', '95', 'Hoà Bình', 'Hoa Binh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 954 - Bạc Liêu
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31813', 'WARD', '954', 'Phường 2', 'Ward 2'),
('31816', 'WARD', '954', 'Phường 3', 'Ward 3'),
('31819', 'WARD', '954', 'Phường 5', 'Ward 5'),
('31822', 'WARD', '954', 'Phường 7', 'Ward 7'),
('31825', 'WARD', '954', 'Phường 1', 'Ward 1'),
('31828', 'WARD', '954', 'Phường 8', 'Ward 8'),
('31831', 'WARD', '954', 'Nhà Mát', 'Nha Mat'),
('31834', 'WARD', '954', 'Vĩnh Trạch', 'Vinh Trach'),
('31837', 'WARD', '954', 'Vĩnh Trạch Đông', 'Vinh Trach Dong'),
('31840', 'WARD', '954', 'Hiệp Thành', 'Hiep Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 956 - Hồng Dân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31843', 'WARD', '956', 'Thị trấn Ngan Dừa', 'Thi tran Ngan Dua'),
('31846', 'WARD', '956', 'Ninh Quới', 'Ninh Quoi'),
('31849', 'WARD', '956', 'Ninh Quới A', 'Ninh Quoi A'),
('31852', 'WARD', '956', 'Ninh Hòa', 'Ninh Hoa'),
('31855', 'WARD', '956', 'Lộc Ninh', 'Loc Ninh'),
('31858', 'WARD', '956', 'Vĩnh Lộc', 'Vinh Loc'),
('31861', 'WARD', '956', 'Vĩnh Lộc A', 'Vinh Loc A'),
('31863', 'WARD', '956', 'Ninh Thạnh Lợi A', 'Ninh Thanh Loi A'),
('31864', 'WARD', '956', 'Ninh Thạnh Lợi', 'Ninh Thanh Loi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 957 - Phước Long
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31867', 'WARD', '957', 'Thị trấn Phước Long', 'Thi tran Phuoc Long'),
('31870', 'WARD', '957', 'Vĩnh Phú Đông', 'Vinh Phu Dong'),
('31873', 'WARD', '957', 'Vĩnh Phú Tây', 'Vinh Phu Tay'),
('31876', 'WARD', '957', 'Phước Long', 'Phuoc Long'),
('31879', 'WARD', '957', 'Hưng Phú', 'Hung Phu'),
('31882', 'WARD', '957', 'Vĩnh Thanh', 'Vinh Thanh'),
('31885', 'WARD', '957', 'Phong Thạnh Tây A', 'Phong Thanh Tay A'),
('31888', 'WARD', '957', 'Phong Thạnh Tây B', 'Phong Thanh Tay B')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 958 - Vĩnh Lợi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31894', 'WARD', '958', 'Vĩnh Hưng', 'Vinh Hung'),
('31897', 'WARD', '958', 'Vĩnh Hưng A', 'Vinh Hung A'),
('31900', 'WARD', '958', 'Thị trấn Châu Hưng', 'Thi tran Chau Hung'),
('31903', 'WARD', '958', 'Châu Hưng A', 'Chau Hung A'),
('31906', 'WARD', '958', 'Hưng Thành', 'Hung Thanh'),
('31909', 'WARD', '958', 'Hưng Hội', 'Hung Hoi'),
('31912', 'WARD', '958', 'Châu Thới', 'Chau Thoi'),
('31921', 'WARD', '958', 'Long Thạnh', 'Long Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 959 - Thị Giá Rai
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31942', 'WARD', '959', 'Phường 1', 'Ward 1'),
('31945', 'WARD', '959', 'Hộ Phòng', 'Ho Phong'),
('31948', 'WARD', '959', 'Phong Thạnh Đông', 'Phong Thanh Dong'),
('31951', 'WARD', '959', 'Láng Tròn', 'Lang Tron'),
('31954', 'WARD', '959', 'Phong Tân', 'Phong Tan'),
('31957', 'WARD', '959', 'Tân Phong', 'Tan Phong'),
('31960', 'WARD', '959', 'Phong Thạnh', 'Phong Thanh'),
('31963', 'WARD', '959', 'Phong Thạnh A', 'Phong Thanh A'),
('31966', 'WARD', '959', 'Phong Thạnh Tây', 'Phong Thanh Tay'),
('31969', 'WARD', '959', 'Tân Thạnh', 'Tan Thanh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 960 - Đông Hải
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31972', 'WARD', '960', 'Thị trấn Gành Hào', 'Thi tran Ganh Hao'),
('31975', 'WARD', '960', 'Long Điền Đông', 'Long Dien Dong'),
('31978', 'WARD', '960', 'Long Điền Đông A', 'Long Dien Dong A'),
('31981', 'WARD', '960', 'Long Điền', 'Long Dien'),
('31984', 'WARD', '960', 'Long Điền Tây', 'Long Dien Tay'),
('31985', 'WARD', '960', 'Điền Hải', 'Dien Hai'),
('31987', 'WARD', '960', 'An Trạch', 'An Trach'),
('31988', 'WARD', '960', 'An Trạch A', 'An Trach A'),
('31990', 'WARD', '960', 'An Phúc', 'An Phuc'),
('31993', 'WARD', '960', 'Định Thành', 'Dinh Thanh'),
('31996', 'WARD', '960', 'Định Thành A', 'Dinh Thanh A')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 961 - Hoà Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31891', 'WARD', '961', 'Thị trấn Hòa Bình', 'Thi tran Hoa Binh'),
('31915', 'WARD', '961', 'Minh Diệu', 'Minh Dieu'),
('31918', 'WARD', '961', 'Vĩnh Bình', 'Vinh Binh'),
('31924', 'WARD', '961', 'Vĩnh Mỹ B', 'Vinh My B'),
('31927', 'WARD', '961', 'Vĩnh Hậu', 'Vinh Hau'),
('31930', 'WARD', '961', 'Vĩnh Hậu A', 'Vinh Hau A'),
('31933', 'WARD', '961', 'Vĩnh Mỹ A', 'Vinh My A'),
('31936', 'WARD', '961', 'Vĩnh Thịnh', 'Vinh Thinh')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- DISTRICT lookup block for province 96 - Cà Mau
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('964', 'DISTRICT', '96', 'Cà Mau', 'Thanh pho Ca Mau'),
('966', 'DISTRICT', '96', 'U Minh', 'U Minh'),
('967', 'DISTRICT', '96', 'Thới Bình', 'Thoi Binh'),
('968', 'DISTRICT', '96', 'Trần Văn Thời', 'Tran Van Thoi'),
('969', 'DISTRICT', '96', 'Cái Nước', 'Cai Nuoc'),
('970', 'DISTRICT', '96', 'Đầm Dơi', 'Dam Doi'),
('971', 'DISTRICT', '96', 'Năm Căn', 'Nam Can'),
('972', 'DISTRICT', '96', 'Phú Tân', 'Phu Tan'),
('973', 'DISTRICT', '96', 'Ngọc Hiển', 'Ngoc Hien')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 964 - Cà Mau
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('31999', 'WARD', '964', 'Phường 9', 'Ward 9'),
('32002', 'WARD', '964', 'Phường 2', 'Ward 2'),
('32005', 'WARD', '964', 'Phường 1', 'Ward 1'),
('32008', 'WARD', '964', 'Phường 5', 'Ward 5'),
('32014', 'WARD', '964', 'Phường 8', 'Ward 8'),
('32017', 'WARD', '964', 'Phường 6', 'Ward 6'),
('32020', 'WARD', '964', 'Phường 7', 'Ward 7'),
('32022', 'WARD', '964', 'Tân Xuyên', 'Tan Xuyen'),
('32023', 'WARD', '964', 'An Xuyên', 'An Xuyen'),
('32025', 'WARD', '964', 'Tân Thành', 'Tan Thanh'),
('32026', 'WARD', '964', 'Tân Thành', 'Tan Thanh'),
('32029', 'WARD', '964', 'Tắc Vân', 'Tac Van'),
('32032', 'WARD', '964', 'Lý Văn Lâm', 'Ly Van Lam'),
('32035', 'WARD', '964', 'Định Bình', 'Dinh Binh'),
('32038', 'WARD', '964', 'Hòa Thành', 'Hoa Thanh'),
('32041', 'WARD', '964', 'Hòa Tân', 'Hoa Tan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 966 - U Minh
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32044', 'WARD', '966', 'Thị trấn U Minh', 'Thi tran U Minh'),
('32047', 'WARD', '966', 'Khánh Hòa', 'Khanh Hoa'),
('32048', 'WARD', '966', 'Khánh Thuận', 'Khanh Thuan'),
('32050', 'WARD', '966', 'Khánh Tiến', 'Khanh Tien'),
('32053', 'WARD', '966', 'Nguyễn Phích', 'Nguyen Phich'),
('32056', 'WARD', '966', 'Khánh Lâm', 'Khanh Lam'),
('32059', 'WARD', '966', 'Khánh An', 'Khanh An'),
('32062', 'WARD', '966', 'Khánh Hội', 'Khanh Hoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 967 - Thới Bình
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32065', 'WARD', '967', 'Thị trấn Thới Bình', 'Thi tran Thoi Binh'),
('32068', 'WARD', '967', 'Biển Bạch', 'Bien Bach'),
('32069', 'WARD', '967', 'Tân Bằng', 'Tan Bang'),
('32071', 'WARD', '967', 'Trí Phải', 'Tri Phai'),
('32072', 'WARD', '967', 'Trí Lực', 'Tri Luc'),
('32074', 'WARD', '967', 'Biển Bạch Đông', 'Bien Bach Dong'),
('32077', 'WARD', '967', 'Thới Bình', 'Thoi Binh'),
('32080', 'WARD', '967', 'Tân Phú', 'Tan Phu'),
('32083', 'WARD', '967', 'Tân Lộc Bắc', 'Tan Loc Bac'),
('32086', 'WARD', '967', 'Tân Lộc', 'Tan Loc'),
('32089', 'WARD', '967', 'Tân Lộc Đông', 'Tan Loc Dong'),
('32092', 'WARD', '967', 'Hồ Thị Kỷ', 'Ho Thi Ky')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 968 - Trần Văn Thời
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32095', 'WARD', '968', 'Thị trấn Trần Văn Thời', 'Thi tran Tran Van Thoi'),
('32098', 'WARD', '968', 'Thị trấn Sông Đốc', 'Thi tran Song Doc'),
('32101', 'WARD', '968', 'Khánh Bình Tây Bắc', 'Khanh Binh Tay Bac'),
('32104', 'WARD', '968', 'Khánh Bình Tây', 'Khanh Binh Tay'),
('32107', 'WARD', '968', 'Trần Hợi', 'Tran Hoi'),
('32108', 'WARD', '968', 'Khánh Lộc', 'Khanh Loc'),
('32110', 'WARD', '968', 'Khánh Bình', 'Khanh Binh'),
('32113', 'WARD', '968', 'Khánh Hưng', 'Khanh Hung'),
('32116', 'WARD', '968', 'Khánh Bình Đông', 'Khanh Binh Dong'),
('32119', 'WARD', '968', 'Khánh Hải', 'Khanh Hai'),
('32122', 'WARD', '968', 'Lợi An', 'Loi An'),
('32124', 'WARD', '968', 'Phong Điền', 'Phong Dien'),
('32125', 'WARD', '968', 'Phong Lạc', 'Phong Lac')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 969 - Cái Nước
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32128', 'WARD', '969', 'Thị trấn Cái Nước', 'Thi tran Cai Nuoc'),
('32130', 'WARD', '969', 'Thạnh Phú', 'Thanh Phu'),
('32131', 'WARD', '969', 'Lương Thế Trân', 'Luong The Tran'),
('32134', 'WARD', '969', 'Phú Hưng', 'Phu Hung'),
('32137', 'WARD', '969', 'Tân Hưng', 'Tan Hung'),
('32140', 'WARD', '969', 'Hưng Mỹ', 'Hung My'),
('32141', 'WARD', '969', 'Hoà Mỹ', 'Hoa My'),
('32142', 'WARD', '969', 'Đông Hưng', 'Dong Hung'),
('32143', 'WARD', '969', 'Đông Thới', 'Dong Thoi'),
('32146', 'WARD', '969', 'Tân Hưng Đông', 'Tan Hung Dong'),
('32149', 'WARD', '969', 'Trần Thới', 'Tran Thoi')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 970 - Đầm Dơi
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32152', 'WARD', '970', 'Thị trấn Đầm Dơi', 'Thi tran Dam Doi'),
('32155', 'WARD', '970', 'Tạ An Khương', 'Ta An Khuong'),
('32158', 'WARD', '970', 'Tạ An Khương Đông', 'Ta An Khuong Dong'),
('32161', 'WARD', '970', 'Trần Phán', 'Tran Phan'),
('32162', 'WARD', '970', 'Tân Trung', 'Tan Trung'),
('32164', 'WARD', '970', 'Tân Đức', 'Tan Duc'),
('32167', 'WARD', '970', 'Tân Thuận', 'Tan Thuan'),
('32170', 'WARD', '970', 'Tạ An Khương Nam', 'Ta An Khuong Nam'),
('32173', 'WARD', '970', 'Tân Duyệt', 'Tan Duyet'),
('32174', 'WARD', '970', 'Tân Dân', 'Tan Dan'),
('32176', 'WARD', '970', 'Tân Tiến', 'Tan Tien'),
('32179', 'WARD', '970', 'Quách Phẩm Bắc', 'Quach Pham Bac'),
('32182', 'WARD', '970', 'Quách Phẩm', 'Quach Pham'),
('32185', 'WARD', '970', 'Thanh Tùng', 'Thanh Tung'),
('32186', 'WARD', '970', 'Ngọc Chánh', 'Ngoc Chanh'),
('32188', 'WARD', '970', 'Nguyễn Huân', 'Nguyen Huan')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 971 - Năm Căn
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32191', 'WARD', '971', 'Thị trấn Năm Căn', 'Thi tran Nam Can'),
('32194', 'WARD', '971', 'Hàm Rồng', 'Ham Rong'),
('32197', 'WARD', '971', 'Hiệp Tùng', 'Hiep Tung'),
('32200', 'WARD', '971', 'Đất Mới', 'Dat Moi'),
('32201', 'WARD', '971', 'Lâm Hải', 'Lam Hai'),
('32203', 'WARD', '971', 'Hàng Vịnh', 'Hang Vinh'),
('32206', 'WARD', '971', 'Tam Giang', 'Tam Giang'),
('32209', 'WARD', '971', 'Tam Giang Đông', 'Tam Giang Dong')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 972 - Phú Tân
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32212', 'WARD', '972', 'Thị trấn Cái Đôi Vàm', 'Thi tran Cai Doi Vam'),
('32214', 'WARD', '972', 'Phú Thuận', 'Phu Thuan'),
('32215', 'WARD', '972', 'Phú Mỹ', 'Phu My'),
('32218', 'WARD', '972', 'Phú Tân', 'Phu Tan'),
('32221', 'WARD', '972', 'Tân Hải', 'Tan Hai'),
('32224', 'WARD', '972', 'Việt Thắng', 'Viet Thang'),
('32227', 'WARD', '972', 'Tân Hưng Tây', 'Tan Hung Tay'),
('32228', 'WARD', '972', 'Rạch Chèo', 'Rach Cheo'),
('32230', 'WARD', '972', 'Nguyễn Việt Khái', 'Nguyen Viet Khai')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;

-- WARD lookup block for district 973 - Ngọc Hiển
INSERT INTO `lookup` (`keyMap`, `type`, `parentKeyMap`, `value_vi`, `value_en`) VALUES
('32233', 'WARD', '973', 'Tam Giang Tây', 'Tam Giang Tay'),
('32236', 'WARD', '973', 'Tân Ân Tây', 'Tan An Tay'),
('32239', 'WARD', '973', 'Viên An Đông', 'Vien An Dong'),
('32242', 'WARD', '973', 'Viên An', 'Vien An'),
('32244', 'WARD', '973', 'Thị trấn Rạch Gốc', 'Thi tran Rach Goc'),
('32245', 'WARD', '973', 'Tân Ân', 'Tan An'),
('32248', 'WARD', '973', 'Đất Mũi', 'Dat Mui')
ON DUPLICATE KEY UPDATE
  `parentKeyMap` = VALUES(`parentKeyMap`),
  `value_vi` = VALUES(`value_vi`),
  `value_en` = VALUES(`value_en`),
  `updatedAt` = CURRENT_TIMESTAMP;