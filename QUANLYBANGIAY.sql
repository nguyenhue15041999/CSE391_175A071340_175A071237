CREATE DATABASE QUANLYSHOPGIAY

CREATE TABLE HANG(
Mahang CHAR(5) PRIMARY KEY not null,
Tenhang VARCHAR(30) not null,
size int,
Dongia money
);


CREATE TABLE Nhasanxuat(
MaNhasx CHAR(5) PRIMARY KEY not null,
TenNhasx NVARCHAR(30) not null,
DtNSX VARCHAR(10), 

);

CREATE TABLE HOADONNHAP(
MaHDN CHAR(10) PRIMARY KEY not null,
MaNhasx CHAR(5),
FOREIGN KEY (MaNhasx) REFERENCES Nhasanxuat(MaNhasx),
TenNhasx NVARCHAR(30),
Mahang char(5),
FOREIGN KEY (Mahang) REFERENCES HANG(Mahang),
SoLuongNhap INT,
DongiaNhap money
);

CREATE TABLE NHANVIEN(
MANV CHAR(5) PRIMARY KEY not null,
TENNV NVARCHAR(20) not null,
DCNV VARCHAR(20),
Mabophan char(5),
FOREIGN KEY (Mabophan) REFERENCES BoPhan(Mabophan),
)
create table BoPhan(
MaBophan char(5) primary key not null,
TenBophan nvarchar(30) not null,
SoluongNV int,
)
create table Khohang(
Mahang char(5),
foreign key(Mahang) references Hang(Mahang),
Tenhang nvarchar(30),
SoluongTon int
)

CREATE TABLE KHACH(
MAK CHAR(5) PRIMARY KEY,
TENK NVARCHAR(20),
GT VARCHAR(20),
DCK VARCHAR(20),
CONSTRAINT UN_TEN_DC UNIQUE (TENK,DCK),
DTK VARCHAR(10),
);


CREATE TABLE HOADON(
MAHD CHAR(5) PRIMARY KEY,
Mahang CHAR(5),
FOREIGN KEY (Mahang) REFERENCES HANG(Mahang),
Tenhang VARCHAR(20),
SIZE INT,
SL INT,
Dongia money,
MANV char(5),
TENNV NVARCHAR(20),
NGAYTT DATE);

create table SP_Donhang(
MaHD char(5),
foreign key (MaHD) references HOADON(MaHD),
Mahang char(5),
foreign key (Mahang) references HANG(Mahang),
SoLuong int,
DonGiaBan money,
TyleGiamGia float,

);

CREATE TABLE ChiTietDonHang(
MAHD CHAR(5) ,
FOREIGN KEY (MAHD) REFERENCES Hoadon(MAHD),
Mahang CHAR(5),
FOREIGN KEY (Mahang) REFERENCES HANG(Mahang),
TENH VARCHAR(30),
MaNhasx char(5),
FOREIGN KEY (MaNhasx) REFERENCES Nhasanxuat(MaNhasx),
SIZE INT,
Soluong INT,
Dongia money,
DonGiaNhap money,
TyLegiamgia float,
TENNV NVARCHAR(20),
NGAYTT DATE,
)


