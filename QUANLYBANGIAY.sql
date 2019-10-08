
ALTER TABLE HANG ADD MaNhasx char(5)  FOREIGN KEY(MaNhasx) REFERENCES Nhasanxuat(MaNhasx)
CREATE TABLE KHACH(
MAK CHAR(5) PRIMARY KEY,
TENK NVARCHAR(20),
GT NVARCHAR(20),
DCK NVARCHAR(20),
CONSTRAINT UN_TEN_DC UNIQUE (TENK,DCK),
DienThoai VARCHAR(10),
)
;select * from Nhasanxuat
---khach hang
insert into KHACH
values ('KH01',N'Nguyễn THị Huế',N'Nữ', N'Hưng yên','0911222333')
;
insert into KHACH
values ('KH02',N'Nguyễn THị Loan',N'Nữ', N'Thái Bình','0911222333')
;
insert into KHACH
values ('KH03',N'Nguyễn Văn Nam',N'Nam', N'Hà Nội','0988542903')
;
insert into KHACH
values ('KH04',N'Nguyễn Văn Hoàng',N'Nam', N'Nam Định','0167228933')
;
insert into KHACH
values ('KH05',N'Nguyễn Hoàng Giang',N'Nữ', N'Hà Nội','0966532717')
;
insert into KHACH
values ('KH06',N'Phạm Văn Hiếu',N'Nam', N'Thanh Hoá','0373529401')
;
insert into KHACH
values ('KH07',N'Lê Minh Hồng',N'Nữ', N'Hưng Yên','0363789120')
;
insert into KHACH
values ('KH08',N'Vũ Mai Linh',N'Nữ', N'Ninh Bình','0988764309')
;
insert into KHACH
values ('KH09',N'Hà Văn Hiếu',N'Nam', N'Hải Dương','098400673')
;
insert into KHACH
values ('KH10',N'Phạm Minh Trường',N'Nam', N'Hà Nội','0358743204')
;
select *from KHACH

CREATE TABLE HOADON(
MAHD CHAR(5) PRIMARY KEY,
MaK char(5),
foreign key(MaK) references Khach(MaK),
Mahang CHAR(5),
FOREIGN KEY (Mahang) REFERENCES HANG(Mahang),
Tenhang VARCHAR(20),
SIZE INT,
SoLuong INT,
Dongia money,
MANV char(5),
NGAYTT DATE)
;


--Hoa don 
insert into HOADON
values ('HD01','KH01','ad1', 'adidas','36','1','3200000','TN1','2019/01/15');
insert into HOADON
values ('HD02','KH02','ad1', 'adidas','36','1','3200000','TN2','2019/04/25');
insert into HOADON
values ('HD03','KH03','nike1', 'nike','38','1','3900000','TN1','2019/02/11');

create table SP_Donhang(
MaHD char(5),
foreign key (MaHD) references HOADON(MaHD),
Mahang char(5),
foreign key (Mahang) references HANG(Mahang),
SoLuong int,
DonGia money,
TyleGiamGia float,

);
--SP_DONHANG
insert into SP_Donhang
values ('HD01','ad1','1','3200000','0.03');
insert into SP_Donhang
values ('HD02','ad1','1','3200000','0.03');
insert into SP_Donhang
values ('HD03','nike1','1','3000000','0');


CREATE TABLE ChiTietDonHang(
MAHD CHAR(5) ,
FOREIGN KEY (MAHD) REFERENCES Hoadon(MAHD),
Mahang CHAR(5),
FOREIGN KEY (Mahang) REFERENCES HANG(Mahang),
Tenhang VARCHAR(30),
MaNhasx char(5),
FOREIGN KEY (MaNhasx) REFERENCES Nhasanxuat(MaNhasx),
SIZE INT,
Soluong INT,
Dongia money,
DonGiaNhap money,
TyLegiamgia float,
MaNV char(5),
foreign key(MaNV) references Nhanvien(MaNV),
NGAYTT DATE,
)

--CHi tiết hóa đơn
insert into ChiTietDonHang
values ('HD01','ad1',N'utra Boost đen','NSX01','36','1','3200000','2500000','0.03','TN1','2019/01/15');
insert into ChiTietDonHang
values ('HD02','ad1',N'utra Boost đen','NSX01','36','1','3200000','2500000','0.03','TN2','2019/04/25');
insert into ChiTietDonHang
values ('HD03','nike1',N'nike air mã 97 xám','NSX02','38','1','3000000','2400000','0','TN1','2019/02/11');
select * from HOADON
select * from KHACH
--CÁC CÂU LỆNH TRUY VẤN
--1.	In ra danh sách các khách hàng (MAK, TenK) đã mua hàng trong ngày 25/4/2019.
SELECT K.MaK, TENK
FROM KHACH K INNER JOIN HOADON H
ON K.MaK = H.MAK
WHERE  NGAYTT= '2019-04-25';
--2.	Tính doanh thu bán hàng mỗi ngày.
SELECT NGAYTT, SUM(Dongia) AS DOANHTHU
FROM HOADON
GROUP BY NGAYTT
--3.Viết một hàm v_ThanhTien trả về thành tiền với ThanhTien = SoLuong * DonGiaBan * (1-TyLeGiamGia) 
--trong bảng SP_DONHang

create view v_thanhtien
as
select *,ThanhTien = SoLuong * Dongia * (1-TyLeGiamGia)  from SP_DonHang  h
select * from v_thanhtien

--4.Viết một hàm v_ChiTietdonhang trả về số TienLai
create view v_ChiTietDonHang
as select H.MaHD, H.Mahang,H.soluong,H.Dongia,H.DongiaNhap ,ThanhTien, TienLai=(ThanhTien - DongiaNhap)
from ChiTietDonHang H,v_thanhtien
where H.MaHD=v_thanhtien.MaHD 
select * from v_ChiTietDonHang
--5. Tạo View Tổng Hợp Thông Tin Về Khách Hàng Có Địa Chỉ ở Thái Nguyên Và Từng Mua Hàng Tại Cửa Hàng 
alter VIEW v_DIACHIKHACH
AS
SELECT *
FROM KHACH
WHERE  DCK= N'Hà Nội'
select * from v_DIACHIKHACH



--Tạo Trigger để đảm bảo rằng khi thêm một loại mặt hàng vào bảng LoaiHang
-- thì tên loại mặt hàng thêm vào phải chưa có trong bảng. 
--Nếu người dùng nhập một tên loại mặt hàng đã có trong danh sách thì báo lỗi. 

--Tạo Trigger để đảm bảo rằng khi sửa một loại mặt hàng trong bảng LoaiHang thì tên 
--loại mặt hàng sau khi sửa phải khác tên loai mặt hàng trước khi sửa và tên loại mặt
-- hàng sau khi sửa không trùng với tên các loại hàng đã có trong bảng. Nếu vi phạm thì thông báo lỗi. 
 