
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


--Bảo mật, phân quyền-----------------------------------------------------------------------
--------------------------------------------------------------------------------------------
go
use QUANLYSHOPGIAY

exec sp_addlogin 'admin' ,'11223344'  --loginName and Password

exec sp_adduser 'admin', N'Nguyễn Thị Loan'  --loginName, userName

exec sp_addrolemember 'db_owner', N'Nguyễn Thị Loan' --quyền full, userName
go





--CÁC CÂU LỆNH TRUY VẤN
--2.	Tính doanh thu bán hàng mỗi ngày.
SELECT NGAYTT, SUM(Dongia) AS DOANHTHU
FROM HOADON
GROUP BY NGAYTT;

--TẠO VIEWW
--3.Viết một hàm v_ThanhTien trả về thành tiền với ThanhTien = SoLuong * DonGiaBan * (1-TyLeGiamGia) 
--trong bảng SP_DONHang

create view v_thanhtien
as
select *,ThanhTien = SoLuong * Dongia * (1-TyLeGiamGia)  from SP_DonHang  h
select * from v_thanhtien
--.Viết một hàm v_ChiTietdonhang trả về số TienLai
create view v_ChiTietDonHang
as select H.MaHD, H.Mahang,H.soluong,H.Dongia,H.DongiaNhap ,ThanhTien, TienLai=(ThanhTien - DongiaNhap)
from ChiTietDonHang H,v_thanhtien
where H.MaHD=v_thanhtien.MaHD 
select * from v_ChiTietDonHang
--Tạo view xem thông tin về 10 loại giày có số lượng tồn kho lớn nhất
GO 
CREATE VIEW v_TonKho
AS 
SELECT * FROM Khohang
WHERE (SELECT COUNT(*) FROM Khohang
	   WHERE SoLuongTon > Khohang.SoluongTon) > 10;
GO 
--Tạo view xem top 5 sản phẩm bán chạy nhất
go
create view v_Top5hangban
as
select Top(5) SP_Donhang.Mahang, Sum(SP_Donhang.SoLuong) as SoLuongDaBan from SP_Donhang join ChiTietDonHang on SP_Donhang.Mahang = ChiTietDonHang.Mahang
group by SP_Donhang.Mahang
order by SoLuongDaBan DESC
go


--TẠO PROC
--Tạo thủ tục thêm khách hàng
go
create proc sp_ThemKhachHang
    @MaK char(5),
	@Tenkhach nvarchar(50),
	@GioiTinh nvarchar(4),
	@DCK nvarchar(50),
	@DienThoai varchar(11)	
as
begin
	begin try
		select (convert (int,@DienThoai))
	end try
	begin catch
		throw 50002,N'Số điện thoại không hợp lệ',1;
	end catch
	insert into Khach(MaK,TENK, GT,DCK,DienThoai)
           values (@MaK, @Tenkhach, @GioiTinh,@DCK,@DienThoai)
end;

--Tạo thủ tục sửa khách hàng
go
create procedure sp_SuaKhachHang
    @MaK char(5),
	@Tenkhach nvarchar(50),
	@GioiTinh nvarchar(4),
	@DCK nvarchar(50),
	@DienThoai varchar(11)	
as
begin
	begin try
		select (convert (int,@DienThoai))
	end try
	begin catch
		throw 50003,N'Số điện thoại không hợp lệ',1;
	end catch
	update Khach
	set  TENK = @Tenkhach, GT = @GioiTinh, DienThoai = @DienThoai, DCK = @DCK
	where MaK = @MaK;
end
go
--Tạo thủ tục xóa khách hàng
go
create procedure sp_XoaKhachHang
	@MaK int
as
	delete from Khach where @MaK = MaK

go
--Tạo thủ tục thêm nhân viên
go
create procedure sp_ThemNhanVien
	@MaNV char(5),
	@TenNV nvarchar(30),
	@DCNV nvarchar(50),
	@Mabophan char(5)

as
begin
	insert into NhanVien(MANV,TENNV,DCNV,Mabophan)
		   values (@MaNV, @TenNV, @DCNV,@Mabophan);
end
go

--Tạo thủ tục sửa nhân viên
go
create procedure sp_SuaNhanVien
	@MaNV char(5),
	@TenNV nvarchar(30),
	@DCNV nvarchar(50),
	@Mabophan char(5)
as
begin

	update NhanVien
	set MANV = @MaNV, TENNV=@TenNV,DCNV=@DCNV, Mabophan=@Mabophan
	
	where MaNV = @MaNV;
end
go

--Tạo thủ tục xóa nhân viên
go
create procedure sp_XoaNhanVien
	@MaNV char(5)
as
	delete from NhanVien where MaNV = @MaNV;
go

--Tạo thủ tục thêm nhà cung cấp
go
create proc sp_ThemNhaCungCap
@TenNCC nvarchar(50),
@DiaChi nvarchar(50),
@SDT char(11)
as
begin try
	select (convert (int,@SDT))
end try
begin catch
	throw 50008,N'Số điện thoại không hợp lệ, mời nhập lại',1;
end catch
	insert into NhaCungCap(TenNCC, DiaChi, SDT)
	       values (@TenNCC, @DiaChi, @SDT);
go  
select * from Nhasanxuat
--Tạo thủ tục sửa nhà sản xuất
go
create procedure sp_SuaNhaSanxuat
	@MaNhasx char(5),
	@TenNhasx nvarchar(50),
	@SDT char(11)
as
begin try
	select (convert (int,@SDT))
end try
begin catch
	throw 50007,N'Số điện thoại không hợp lệ',1;
end catch
	update Nhasanxuat
	set MaNhasx = @MaNhasx, TenNhasx= @TenNhasx, DtNSX = @SDT
	where MaNhasx = @MaNhasx;
go

--Tạo thủ tục xóa nhà cung cấp
go
create procedure sp_XoaNhaCungCap
	@MaNhasx char(5)
as
	delete from Nhasanxuat where MaNhasx = @MaNhasx
go
--Tạo thủ tục thêm hóa đơn
go
create procedure sp_ThemHoaDon
	@MaHD char(5),
	@MaK char(5),
	@MaH char(5),
	@tenhang nvarchar(20),
	@size int,
	@soluong int,
	@Dongia money,
	@MaNV char(5),
	@NgayTT date
as
	insert into HoaDon(MAHD,MaK,Mahang,Tenhang,SIZE,SoLuong,Dongia,MANV,NGAYTT) 
	values (@MaHD,@MaK,@MaH,@tenhang,@size,@soluong,@Dongia,@MaNV,@NgayTT);
go
--Tạo thủ tục thêm chi tiết hóa đơn
go
create procedure sp_ThemChiTietDH
	@MaHD char(5), 
	@Mahang char(5),
	@Tenhang nvarchar(20),
	@Manhasx char(5),
	@size int,
	@soluong int,
	@dongia money,
	@dongianhap money,
	@tylegiamgia float,
	@MaNV char(5),
	@ngayTT date
as
	insert into ChiTietDonHang(MAHD,Mahang,Tenhang,MaNhasx,SIZE,Soluong,Dongia,DonGiaNhap,TyLegiamgia,MaNV,NGAYTT)
	 values (@MaHD, @Mahang, @Tenhang, @Manhasx,@size,@soluong,@dongia,@dongianhap,@tylegiamgia,@MaNV,@ngayTT);
go

--Tạo thủ tục thêm hàng
go
create procedure sp_ThemHang
    @Mahang char(5),
	@Tenhang nvarchar(50),
	@size int,
	@DonGia money,
	@Manhasx char(5)
as
	insert into HANG values (@Mahang,@Tenhang,@size,0,@Manhasx)
go


--Tạo thủ tục xóa sản phẩm
go
create procedure sp_XoaSanPham
	@Mahang int
as
	delete from HANG where Mahang = @Mahang
go
--Tạo thủ tục sửa kho hang
go
create procedure sp_SuaKhoHang
	@Mahang char(5),
	@Tenhang nvarchar(50),
	@size int,
	@SoLuongTon int
as
update khohang
set Mahang=@Mahang,Tenhang=@Tenhang,size=@size, SoluongTon= @SoLuongTon
where Mahang = @Mahang
go

--Tạo thủ tục thêm đơn nhập hàng
go
create proc sp_ThemHoaDonNhap
	@MaHDN char(6),
	@MaNhasx char(5),
	@TenNhasx nvarchar(20),
	@Mahang char(5),
	@size int,
	@soluongnhap int,
	@GiaNhap money	
as
insert into HOADONNHAP (MaHDN,MaNhasx,TenNhasx,Mahang,size,SoLuongNhap,DongiaNhap)
values (@MaHDN,@MaNhasx,@TenNhasx,@Mahang,@size,@soluongnhap,@GiaNhap);
go

---Trigger-------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--Tạo trigger báo không được để trống họ tên trong bảng khách hàng
go
create trigger KhachHang_Insert_Update
on Khach
after insert,update
as
if exists (select * from inserted where inserted.TENK = '')
	throw 50001,N'Họ, tên không được để trống',1;
go

--Tạo trigger báo không được để trống họ tên trong bảng nhân viên
go
create trigger NhanVien_Insert_Update
on NhanVien
after insert,update
as
if exists (select * from inserted where inserted.TENNV = '')
	throw 50006,N'Họ, tên không được để trống',1;
go

--Tạo trigger báo không được để trống nhà cung cấp
go
create trigger NhaCungCap_Insert_Update
on Nhasanxuat
after insert,update
as
if exists (select * from inserted where inserted.TenNhasx = '')
	throw 50010,N'Tên nhà cung cấp không được để trống',1;
go
--Tạo trigger báo không được để trống tên sản phẩm
go
create trigger Hang_Insert_Update
on Hang
after insert,update
as
if exists (select * from inserted where inserted.Tenhang='' )
	throw 50001,N'Tên sản phẩm không được để trống',1;
go

--Tạo trigger báo không được để trống mã nhân viên khi thêm hóa đơn
go
create trigger MaNVofHoaDon_Insert_Update
on HoaDon
after insert,update
as
if exists (select * from inserted where inserted.MaNV = '')
	throw 50011,N'Bạn điền mã nhân viên để tạo hóa đơn',1;
go
--Tạo trigder cập nhập số lượng tồn sau khi tạo hóa đơn
go
create trigger ChiTietHoaDon_Insert
	on ChiTietDonHang
	after insert
as
begin
	update Khohang
	set SoLuongTon = SoLuongTon - (select inserted.Soluong from inserted where inserted.Mahang = Mahang)
	where Mahang = (select inserted.Mahang from inserted);
end
go
--Tạo trigger cập nhập số lượng tồn sản phẩm khi nhập thêm hàng
go
create trigger NhapHang_insert
	on HoaDonNhap
	after insert
as
begin
   update Khohang
   set SoLuongTon = SoLuongTon + (select inserted.SoLuongNhap from inserted  where inserted.Mahang = Mahang)
   where Mahang = (select inserted.Mahang from inserted);
end
go

--hiển thị các loại giày đang giảm giá 
select * from SP_Donhang
where TyleGiamGia>0;

--TẠO FUNCTION
--Tạo hàm tính tiền lãi trong ngày


