-- Thông tin sinh viên
-- Họ tên: Bùi Huỳnh Trâm Anh
-- MSSV: 23880201
-- Email: 23880201@student.hcmus.edu.vn

-- Họ tên: Trần Hoàng Hà
-- MSSV: 23880224
-- Email: 23880224@student.hcmus.edu.vn

use QLTV_23880201;

-- 1) Liệt kê danh sách thông tin độc giả có mã độc giả trong khoảng từ 25 đến 88
-- KQ: bảng DocGia
-- ĐK: mã độc giả từ 25 đến 88
-- Họ tên: Bùi Huỳnh Trâm Anh, MSSV: 23880201
Select *
From DocGia dg
where ma_docgia >= 25 and ma_docgia <= 88;

-- 2) Liệt kê danh sách độc giả người lớn có mã độc giả trong khoảng 25 đến 88 
-- (mã độc giả, họ tên, ngày sinh, đt, hạn sử dụng)
-- KQ: NguoiLon (mã độc giả, họ tên, ngày sinh, đt, hạn sử dụng) 
-- ĐK: có mã độc giả trong khoảng 25 đến 88
-- Note: k có ngày sinh vì data NguoiLon k có
select dg.ma_docgia as "MaDocGia Nguoi Lon", dg.ho + ' ' + dg.tenlot + ' ' + dg.ten as "Ho Ten", nl.dienthoai, nl.han_sd
from NguoiLon nl
	join DocGia dg on nl.ma_docgia = dg.ma_docgia
where dg.ma_docgia >= 25 and dg.ma_docgia <= 88;

-- 3) Liệt kê họ tên độc giả trẻ em và họ tên độc giả người lớn đã bảo lãnh trẻ em có 
-- địa chỉ nhà ở quận 1,6,7,BT,GV
-- KQ: NguoiLon (hoten), TreEm(hoten)
-- ĐK: địa chỉ nhà ở quận 1,6,7,BT,GV
select dg.ma_docgia, dg.ho+ ' ' +dg.tenlot+ ' '+dg.ten as "Tre Em", dg2.ma_docgia, dg2.ho + ' '+dg2.tenlot+ ' '+dg2.ten as "Nguoi Lon"
from TreEm t
	join NguoiLon nl on t.ma_docgia_nguoilon = nl.ma_docgia
	join DocGia dg on t.ma_docgia = dg.ma_docgia
	join DocGia dg2 on nl.ma_docgia = dg2.ma_docgia
where (nl.quan like 'Q1' or 
		nl.quan like 'Q6' or
		nl.quan like 'Q7' or
		nl.quan like 'BT' or
		nl.quan like 'GV');

-- 4) Liệt kê danh sách họ tên và mã độc giả k có bảo lãnh trẻ em
-- KQ: DocGia (hoten, ma_docgia)
-- ĐK: k có bảo lãnh trẻ em


-- 5) Liệt kê danh sách độc giả đang đăng ký mượn sách và tên đầu sách cần mượn
-- KQ: DocGia, TuaSach (tuasach)
-- ĐK: độc giả đang đăng ký mượn sách


-- 6) Liệt kê danh sách độc giả đang đăng ký mượn sách và số lượng đầu sách đã đăng ký


-- 7) Liệt kê danh sách mã isbn và tên đầu sách đang được độc giả đky mượn và đang trong trạng
-- thái sẵn sàng cho mượn


-- 8) Với mỗi đầu sách, cho biết số lần đã mượn (và đã trả)