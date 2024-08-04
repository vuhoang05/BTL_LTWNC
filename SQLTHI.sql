
Đề thi: 
Câu1: Tạo thêm 1 trang mới chọn 1 bảng để hiển thị. Ví dụ tạo thêm 1 trang sản phẩm mới đề CSS theo yêu cầu Website thì hiển thị 3sp thành 1 hãng, mobile 1sp 1 hàng. Trang mới được click từ 1 trang cũ trong Btl
Câu 2: Thêm 1 cột dữ liệu vào 1 bảng nào đó(check dữ liệu có 8 ký tự và ít nhất có 1 số)
 Insert dữ liệu cái bàng vừa thêm cột vào, thực hiện thay đổi cac chung năng them sửa xóa phù hợp
cau3 từ bảng chọn ở câu 1 thêm nút xóa ở mỗi sản phẩm thực hiện xóa bằng ajax

CREATE DATABASE sqlQuanLyBanDoAn22 ON 
(
	NAME = 'sqlQuanLyBanDoAn,',
	FILENAME = 'H:\STUDY\LapTrinhWebNangCao\sqlQuanLyBanDoAn.mdf',
	SIZE = 100MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)



CREATE TABLE tblRole
(
	iRoleID int IDENTITY,
	sRoleName nvarchar(50),
	CONSTRAINT PK_tblRole PRIMARY KEY (iRoleID),
)
INSERT INTO tblRole (sRoleName)
VALUES ('Admin'), ('Customer');

CREATE TABLE tblUser
(
	iUserID int IDENTITY,
	sUserName nvarchar(100) not null,
	sUserPassword nvarchar(100) not null,
	iUserRoleID int DEFAULT 2,
	CONSTRAINT PK_tblUser PRIMARY KEY (iUserID),
	CONSTRAINT FK_tblUser_tblRole FOREIGN KEY (iUserRoleID) REFERENCES tblRole(iRoleID)
)
INSERT INTO tblUser (sUserName, sUserPassword, iUserRoleID)
VALUES ('admin', 'admin123', 1),
       ('hoang', 'hoang123', 2);

CREATE TABLE tblProductCategory 
(
	iCategoryID int IDENTITY,
	sCategoryName nvarchar(50) not null,
	CONSTRAINT PK_tblCategory PRIMARY KEY (iCategoryID)
)

CREATE TABLE tblProduct
(
	c int IDENTITY,
	sProductName nvarchar(50) not null,
	iProductCategoryId int not null,
	fPrice float not null,
	sImageUrl nvarchar(Max) not null,
	CONSTRAINT PK_Product PRIMARY KEY (iProductID),
	CONSTRAINT FK_tblProduct_tblProductCategory 
		FOREIGN KEY (iProductCategoryId) REFERENCES tblProductCategory(iCategoryID) ON DELETE CASCADE
)
alter table tblProduct add Descreption nvarchar(500)

INSERT INTO tblProductCategory (sCategoryName)
VALUES ( 'Fast Food'),
       ( 'Italian'),
       ( 'Asian'),
       ('Desserts'),
       ('Drinks');

INSERT INTO tblProduct (sProductName, iProductCategoryId, fPrice, sImageUrl, Descreption)
VALUES
  ('Pizza', 1, 12.99, 'images/pizza.jpg', 'Classic Italian pizza with your choice of toppings'),  -- Replace with actual image path
  ('Hamburger', 2, 8.99, 'images/hamburger.jpg', 'Delicious all-American hamburger with juicy patty, cheese, and toppings'),  -- Replace with actual image path
  ('Sushi', 3, 15.99, 'images/sushi.jpg', 'Fresh and flavorful sushi rolls with various fillings'),  -- Replace with actual image path
  ('Salad', 4, 7.50, 'images/salad.jpg', 'Healthy and refreshing salad with your choice of greens, vegetables, and dressing'),  -- Replace with actual image path
  ('Pasta', 5, 10.99, 'images/pasta.jpg', 'Hearty and comforting pasta dish with various sauces and toppings');  -- Replace with actual image path

CREATE TABLE tblOrder
(
	iOrderID int IDENTITY,
	dOrderDate datetime not null DEFAULT GETDATE(),
	sCustomerName nvarchar(50) not null,
	sCustomerPhone nvarchar(20) not null,
	sCustomerAddress nvarchar(200) not null,
	fTotal float not null,
	CONSTRAINT PK_tblOrder PRIMARY KEY (iOrderID),
)

CREATE TABLE tblOrderDetail
(
	iDetailID int IDENTITY,
	iDetailOrderID int not null,
	iDetailProductID int not null,
	fDetailPrice float not null,
	iDetailQuantity int not null,
	--OrderiOrderID int not null,
	--ProductiProductID int not null,
	CONSTRAINT PK_tblOrderDetail PRIMARY KEY (iDetailID),
	CONSTRAINT FK_tblOrderDetail_tblOrder FOREIGN KEY (iDetailOrderID) REFERENCES tblOrder(iOrderID) ON DELETE CASCADE,
	CONSTRAINT FK_tblOrderDetail_tblProduct FOREIGN KEY (iDetailProductID) REFERENCES tblProduct(iProductID),
)


create PROC spGetUserVM AS
BEGIN
	SELECT tblUser.iUserID, tblUser.sUserName, tblUser.sUserPassword, tblRole.sRoleName
	FROM tblUser, tblRole
	WHERE tblUser.iUserRoleID = tblRole.iRoleID
	ORDER BY tblUser.iUserID
END

exec spGetUserVM


create  PROC spGetProductVM AS
BEGIN
	SELECT tblProduct.iProductID, tblProduct.sProductName, tblProductCategory.sCategoryName, tblProduct.fPrice, tblProduct.sImageUrl , tblProduct.Descreption
	FROM tblProductCategory, tblProduct
	WHERE tblProduct.iProductCategoryId = tblProductCategory.iCategoryID
	ORDER BY tblProduct.iProductID
END

exec spGetProductVM

select * from tblProduct


create PROC spGetFeatureProduct AS
BEGIN
	SELECT TOP 4 tblProduct.iProductID, tblProduct.sProductName, tblProduct.iProductCategoryId, tblProduct.fPrice, tblProduct.sImageUrl,tblProduct.Descreption
	FROM tblProduct
END

exec spGetFeatureProduct

create PROC spGetProductByID @id int AS
BEGIN
	SELECT tblProduct.iProductID, tblProduct.sProductName, tblProductCategory.sCategoryName, tblProduct.fPrice, tblProduct.sImageUrl,tblProduct.Descreption
	FROM tblProductCategory, tblProduct
	WHERE tblProduct.iProductID = @id AND tblProduct.iProductCategoryId = tblProductCategory.iCategoryID
END

exec spGetProductByID 5


CREATE PROC spGetOrderDetailByOrderID @id int AS
BEGIN
	SELECT tblOrderDetail.iDetailID ,tblOrderDetail.iDetailOrderID,tblOrderDetail.iDetailProductID, 
		tblProduct.sProductName, tblOrderDetail.iDetailQuantity, tblOrderDetail.fDetailPrice
	FROM tblOrderDetail, tblProduct
	WHERE tblOrderDetail.iDetailOrderID = @id AND tblOrderDetail.iDetailProductID = tblProduct.iProductID
END

exec spGetOrderDetailByOrderID 2

Create PROC spGetRelatedProduct @categoryID int AS
BEGIN
	SELECT TOP 4 tblProduct.iProductID, tblProduct.sProductName, tblProduct.iProductCategoryId, tblProduct.fPrice, tblProduct.sImageUrl,tblProduct.Descreption
	FROM tblProduct
	WHERE tblProduct.iProductCategoryId = @categoryID
END

exec spGetRelatedProduct 2
