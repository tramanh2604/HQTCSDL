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
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select dg.ma_docgia as "MaDocGia Nguoi Lon", dg.ho + ' ' + dg.tenlot + ' ' + dg.ten as "Ho Ten", nl.dienthoai, nl.han_sd
from NguoiLon nl
	join DocGia dg on nl.ma_docgia = dg.ma_docgia
where dg.ma_docgia >= 25 and dg.ma_docgia <= 88;

-- 3) Liệt kê họ tên độc giả trẻ em và họ tên độc giả người lớn đã bảo lãnh trẻ em có 
-- địa chỉ nhà ở quận 1,6,7,BT,GV
-- KQ: NguoiLon (hoten), TreEm(hoten)
-- ĐK: địa chỉ nhà ở quận 1,6,7,BT,GV
-- Họ tên: Bùi Huỳnh Trâm Anh, MSSV: 23880201
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
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select *
from DocGia d join NguoiLon l on d.ma_docgia=l.ma_docgia
left join TreEm te on te.ma_docgia_nguoilon=d.ma_docgia
where te.ma_docgia is null

select *
from DocGia d
where d.ma_docgia in (
	select l.ma_docgia
	from NguoiLon l
	except
	select l2.ma_docgia
	from TreEm te 
		join NguoiLon l2 on te.ma_docgia_nguoilon=l2.ma_docgia)

--5) Liệt kê danh sách độc giả đang đăng ký mượn sách và tên đầu sách cần mượn
--KQ: ho ten và ma_docgia (DocGia), tên đầu sách (TuaSach)
--DK: đang đăng ký mượn sách
-- Họ tên: Bùi Huỳnh Trâm Anh, MSSV: 23880201	
select d.ho,d.ten,d.ma_docgia,ts.TuaSach
from DocGia d join DangKy dk on (d.ma_docgia=dk.ma_docgia)
join DauSach ds on (ds.isbn=dk.isbn)
join TuaSach ts on (ts.ma_tuasach=ds.ma_tuasach)

--6) Liệt kê danh sách độc giả đang đăng ký mượn sách và số lượng đầu sách đã đăng ký.
--KQ: ho ten và ma_docgia (DocGia), số lượng đầu sách đã đăng ký
--DK: đang đăng ký mượn sách
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select d.ho,d.ten,d.ma_docgia, count(dk.isbn)
from DocGia d join DangKy dk on (d.ma_docgia=dk.ma_docgia)
group by d.ho,d.ten,d.ma_docgia

--7) Liệt kê danh sách mã isbn và tên đầu sách đang được độc giả đăng ký mượn và đang trong trạng thái sẵn sàng cho mượn
--KQ: mã isbn (DauSach) và tên đầu sách (TuaSach)
--DK: đang được độc giả đăng ký mượn và đang trong trạng thái sẵn sàng cho mượn
-- Họ tên: Bùi Huỳnh Trâm Anh, MSSV: 23880201
select distinct ds.isbn,ts.TuaSach
from DauSach ds join TuaSach ts on (ds.ma_tuasach=ts.ma_tuasach)
join DangKy dk on (dk.isbn=ds.isbn)
where ds.trangthai='Y'

--8) Với mỗi đầu sách,cho biết số lần đã mượn (và đã trả)
--KQ:  mỗi đầu sách (DauSach)
--DK: số lần đã mượn (Muon), số lần đã trả (QuaTrinhMuon)
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select ds.isbn,ds.ma_tuasach,ds.ngonngu,ds.bia,ds.trangthai,count(m.isbn) as "Đã mượn", count(qtm.isbn) as "Đã trả"
from DauSach ds left join Muon m on (ds.isbn=m.isbn)
left join QuaTrinhMuon qtm on (qtm.isbn=ds.isbn)
group by ds.isbn,ds.ma_tuasach,ds.ngonngu,ds.bia,ds.trangthai


-------------------------Bài tập làm thêm--------------------------------
--Nhóm A
--5) Liêt kê tất cả họ tên đọc giả người lớn có trong hệ thống và số lượng trẻ em mà họ bảo lãnh (nếu có)
--KQ: ho ten (docgia,nguoilon),so luong tre em (tre em)
--DK: 
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select d.ho,d.tenlot,d.ten,count(te.ma_docgia) as 'số lượng trẻ em bảo lãnh'
from DocGia d join NguoiLon l on d.ma_docgia=l.ma_docgia
left join TreEm te on te.ma_docgia_nguoilon=l.ma_docgia
group by d.ho,d.tenlot,d.ten


 --6) Liệt kê thông tin các đầu sách vẫn còn khả năng được mượn
 --KQ: DauSach
 --DK: Vẫn còn khả năng được mượn
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
 select *
 from DauSach ds 
 where ds.trangthai='Y'

 --7)  Với mỗi đầu sách, liệt kê thông tin đầu sách và số lượng cuốn sách vẫn còn trong thư viện
 --KQ: thông tin đầu sách (dauSach) và số lương cuốn sách (cuonSach)
 --DK: cuốn sách vẫn còn trong thư viện
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
 select ds.isbn,ds.ma_tuasach,ds.ngonngu,ds.bia,ds.trangthai,count(cs.Ma_CuonSach) as 'Số lượng'
 from DauSach ds join CuonSach cs on ds.isbn=cs.isbn
 where cs.TinhTrang='Y'
 group by ds.isbn,ds.ma_tuasach,ds.ngonngu,ds.bia,ds.trangthai\

 --8) Với từng ngôn ngữ sách có trong hệ thống, cho biết tên ngôn ngữ và số lượng đầu sách thuộc ngôn ngữ đó
 --KQ: tên ngôn ngữ, số lương đầu sách (DauSach)
 --ĐK: 
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
 select ds.ngonngu,count(ds.isbn)
 from DauSach ds
 group by ds.ngonngu

--Nhóm B
--1) Liệt kê danh sách họ tên và mã độc giả người lớn đang mượn sách chưa trả và số lượng sách họ đang mượn
--KQ: ho ten và ma_docgia (DocGia), số lượng sách (Muon)
--DK: người lớn và đang mượn sách chưa trả 
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select d.ho, d.ten, count(d.ma_docgia) as "Số lượng sách mượn"
from DocGia d join NguoiLon l on (d.ma_docgia=l.ma_docgia)
join Muon m on(d.ma_docgia=m.ma_docgia)
group by d.ho,d.ten,d.ma_docgia

--2) Liệt kê danh sách họ tên và mã độc giả người lớn đang mượn sách trễ hạn (so với quy định)
--KQ: ho ten và ma_docgia (DocGia)
--DK: người lớn và đang mượn sách trễ hạn 
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select distinct d.ho, d.ten,  d.ma_docgia
from DocGia d join NguoiLon l on (d.ma_docgia=l.ma_docgia)
join Muon m on(d.ma_docgia=m.ma_docgia)
where GETDATE() > m.ngay_hethan

--3) Liệt kê danh sách họ tên đọc giả trẻ em đang mượn sách chưa trả và tên đầu sách mà trẻ em đang mượn
--KQ: ho ten và ma_docgia (DocGia)
--DK: người trẻ em và đang mượn sách chưa trả (Muon) và tên đầu sách mà trẻ em đang mượn (TuaSach)
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select d.ho, d.ten,ts.TuaSach 
from DocGia d join TreEm te on (d.ma_docgia=te.ma_docgia)
join Muon m on (d.ma_docgia=m.ma_docgia)
join CuonSach cs on (cs.Ma_CuonSach=m.ma_cuonsach)
join DauSach ds on (ds.isbn=cs.isbn)
join TuaSach ts on (ts.ma_tuasach=ds.ma_tuasach)

--4) Liệt kê danh sách các độc giả người lớn đang mượn sách chưa trả 
--đồng thời trẻ em mà người lớn đó đang bảo lãnh cũng có mượn sách chưa trả.
--KQ: ho ten và ma_docgia (DocGia)
--DK: người lớn và đang mượn sách chưa trả, đồng thời trẻ em mà người lớn đó đang bảo lãnh cũng có mượn sách chưa trả.
--Họ tên: Trần Hoàng Hà, MSSV: 23880224
select distinct d.ho,d.ten,d.ma_docgia
from DocGia d join NguoiLon l on (d.ma_docgia=l.ma_docgia)
join Muon m on(l.ma_docgia=m.ma_docgia)
join TreEm te on (l.ma_docgia=te.ma_docgia_nguoilon)
join Muon m2 on (te.ma_docgia=m2.ma_docgia)
