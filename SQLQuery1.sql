use heer_practice
use master

create table [User] (
	id int primary key identity(1,1),
	firstname varchar(50) not null,
	lastname varchar(50) not null,
	email varchar(20) unique,
	password VARCHAR(10) CHECK (LEN(password) >= 8 AND LEN(password) <= 10),
	usertypeid int,
	address varchar(100),
	mobileno bigint not null,
	countryid int,
	stateid int,
	cityid int
)

alter table [user] add foreign key (usertypeid) references usertype(id)
alter table [user] add foreign key (countryid) references country(id)
alter table [user] add foreign key (stateid) references states(id)
alter table [user] add foreign key (cityid) references city(id)

create table medicines (
	id int primary key identity(1,1),
	medicinename varchar(20) not null,
	diagnosisid int
)
alter table medicines add foreign key (diagnosisid) references diagnosis(id)

create table usertype (
	id int primary key identity(1,1),
	usertypename varchar(20) not null
)

create table diagnosis(
	id int primary key identity(1,1),
	diagnosisDetails varchar(50) not null 
)

create table treatmentdetails(
	id int primary key identity(1,1),
	patientid int,
	doctorid int,
	nurseid int,
	diagnosis int,
	prescription int,
	treatmentfee int not null,
	DOT date,
	instructions varchar(100)
)
alter table treatmentdetails add foreign key (patientid) references [user](id)
alter table treatmentdetails add foreign key (doctorid) references [user](id)
alter table treatmentdetails add foreign key (nurseid) references [user](id)
alter table treatmentdetails add foreign key (diagnosis) references diagnosis(id)
alter table treatmentdetails add foreign key (prescription) references medicines(id)

create table country (
	id int primary key identity(1,1),
	countryname varchar(30) not null
)

create table states(
	id int primary key identity(1,1),
	statename varchar(30) not null,
	countryid int 
)
alter table states add foreign key (countryid) references country(id)
create table city (
	id int primary key identity(1,1),
	cityname varchar(30) not null,
	countryid int,
	stateid int
)
alter table city add foreign key (countryid) references country(id)
alter table city add foreign key (stateid) references states(id)

-- Inserting data into [User] table
INSERT INTO [User] (firstname, lastname, email, password, usertypeid, address, mobileno, countryid, stateid, cityid)
VALUES 
('John', 'Doe', 'john@example.com', 'password1', 1, '123 Main St', 1234567890, 1, 1, 1),
('Alice', 'Smith', 'alice@example.com', 'password2', 1, '456 Elm St', 9876543210, 2, 2, 2),
('Bob', 'Johnson', 'bob@example.com', 'password3', 2, '789 Oak St', 5555555555, 3, 3, 3),
('Emily', 'Brown', 'emily@example.com', 'password4', 2, '101 Pine St', 4444444444, 4, 4, 4),
('Michael', 'Jones', 'michael@example.com', 'password5', 3, '202 Maple St', 3333333333, 5, 5, 5);

-- Inserting data into medicines table
INSERT INTO medicines (medicinename, diagnosisid)
VALUES 
('Medicine A', 1),
('Medicine B', 2),
('Medicine C', 3),
('Medicine D', 4),
('Medicine E', 5);

-- Inserting data into usertype table
INSERT INTO usertype (usertypename)
VALUES 
('Type A'),
('Type B'),
('Type C');
select * from usertype
-- Inserting data into diagnosis table
INSERT INTO diagnosis (diagnosisDetails)
VALUES 
('Diagnosis A'),
('Diagnosis B'),
('Diagnosis C'),
('Diagnosis D'),
('Diagnosis E');


-- Inserting data into treatmentdetails table
INSERT INTO treatmentdetails (patientid, doctorid, nurseid, diagnosis, prescription, treatmentfee, DOT, instructions)
VALUES 
(1, 2, 3, 1, 1, 100, '2023-01-01', 'Follow-up in two weeks'),
(2, 3, 4, 2, 2, 150, '2023-02-01', 'Take medicine with food'),
(3, 4, 5, 3, 3, 200, '2023-03-01', 'Rest and drink plenty of fluids'),
(4, 5, 1, 4, 4, 250, '2023-04-01', 'Avoid strenuous activities'),
(5, 1, 2, 5, 5, 300, '2023-05-01', 'Complete the full course of medication');

-- Inserting data into country table
INSERT INTO country (countryname)
VALUES 
('Country A'),
('Country B'),
('Country C'),
('Country D'),
('Country E');

-- Inserting data into states table
INSERT INTO states (statename, countryid)
VALUES 
('State A1', 1),
('State B1', 2),
('State C1', 3),
('State D1', 4),
('State E1', 5);

-- Inserting data into city table
INSERT INTO city (cityname, countryid, stateid)
VALUES 
('City A1', 1, 1),
('City B1', 2, 2),
('City C1', 3, 3),
('City D1', 4, 4),
('City E1', 5, 5);


create procedure for_user 
	@firstname varchar(50),
	@lastname varchar(50),
	@email varchar(20),
	@password VARCHAR(10),
	@usertypeid int,
	@address varchar(100),
	@mobileno int,
	@countryid int,
	@stateid int,
	@cityid int
as
begin
	insert into [user](firstname,lastname,email,password,usertypeid,address,mobileno,countryid,stateid,cityid) 
	values (@firstname,@lastname,@email,@password ,@usertypeid ,@address,@mobileno,@countryid ,@stateid ,@cityid )
	select * from [user]
end;

EXEC  for_user 
    @firstname = 'John',
    @lastname = 'Doe',
    @email = 'john12345@example.com',
    @password = 'password678999999',
    @usertypeid = 1,
    @address = '123 Main St',
    @mobileno = 1234567890,
    @countryid = 1,
    @stateid = 1,
    @cityid = 1;

create procedure doctor_type 
	@para int = null
	as
	begin
	if @para is null 
	begin
	select concat('Dr.',u.firstname,u.lastname) as Doctorname, concat(u.address,', ',c.cityname,', ',s.statename,', ',co.countryname) as Address, u.mobileno as mobileNo
	from [user] u join usertype ut on u.usertypeid = ut.id and ut.usertypename =  'type A' join city c on c.id = u.cityid join states s on s.id = u.stateid join country co on co.id = u.countryid;
	end
	else
	begin
	select concat('Dr.',u.firstname,u.lastname) as Doctorname, concat(u.address,', ',c.cityname,', ',s.statename,', ',co.countryname) as Address, u.mobileno as mobileNo
	from [user] u join usertype ut on u.usertypeid = ut.id and ut.usertypename =  'type A' join city c on c.id = u.cityid join states s on s.id = u.stateid join country co on co.id = u.countryid where u.id = @para;
	end
end;

exec doctor_type

create function d_madicicne 
	(@detail varchar(20))
returns varchar(20)
as
begin
 declare @mad varchar(20)
 select  @mad = m.medicinename from medicines m join diagnosis d on d.id = m.diagnosisid where d.diagnosisDetails = @detail;
 return @mad
 end
 select dbo.d_madicicne('Diagnosis E')


select * from [user]
select * from treatmentdetails
select * from usertype

