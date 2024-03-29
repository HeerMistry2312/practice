CREATE DATABASE CP356ChiragPatel;
USE CP356ChiragPatel;


									--- Create Table User ---

CREATE TABLE [User](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[FirstName] VARCHAR(255) NOT NULL,
	[LastName] VARCHAR(255) NOT NULL,
	[Email] VARCHAR(100) UNIQUE,
	[Password] VARCHAR(10) NOT NULL,
	[UserTypeId] INT,
	[Address] VARCHAR(MAX),
	[MobileNo] VARCHAR(20) NOT NULL,
	[CountryId] INT,
	[State] INT,
	[CityId] INT,
	CONSTRAINT check_cs CHECK (LEN([Password])>= 8 AND LEN([Password])<=10) 
);
									--- Create Table UserType ---

CREATE TABLE [UserType](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[UserTypeName] VARCHAR(255) NOT NULL
);

									--- Create Table Country ---

CREATE TABLE [Country](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[CountryName] VARCHAR(255) NOT NULL,
);

									--- Create Table States ---

CREATE TABLE [States](
	[Id] INT PRIMARY KEY IDENTITY (1,1),
	[StateName] VARCHAR(255) NOT NULL,
	[CountryId] INT
);

									--- Create Table City ---

CREATE TABLE [City](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[CityName] VARCHAR(255) NOT NULL,
	[CountryId] INT,
	[StateId] INT
);

									--- Create Table TreatmentDetails ---

CREATE TABLE [TreatmentDetails](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[PatientId] INT,
	[DoctorId] INT,
	[NurseId] INT,
	[Diagnosis] INT,
	[Prescription] INT,
	[TreatmentFee] DECIMAL(18,2) NOT NULL,
	[DOT] DATE,
	[Instructions] VARCHAR(255)
);
									--- Create Table Diagnosis ---

CREATE TABLE [Diagnosis](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[DiagnosisDetails] VARCHAR(255) NOT NULL,
);

									--- Create Table Medicine ---

CREATE TABLE [Medicine](
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[MedicineName] VARCHAR(255),
	[DiagnosisId] INT
);


ALTER TABLE [States] ADD CONSTRAINT Fk_SCID FOREIGN KEY ([CountryId]) REFERENCES [Country]([Id]);
ALTER TABLE [City] ADD CONSTRAINT Fk_CCID FOREIGN KEY ([CountryId]) REFERENCES [Country]([Id]);
ALTER TABLE [City] ADD CONSTRAINT Fk_CSID FOREIGN KEY ([StateId]) REFERENCES [States]([Id]);

ALTER TABLE [Medicine] ADD CONSTRAINT Fk_MDID FOREIGN KEY ([DiagnosisId]) REFERENCES [Diagnosis]([Id]);

ALTER TABLE [User] ADD CONSTRAINT Fk_UUTID FOREIGN KEY ([UserTypeId]) REFERENCES [UserType]([Id]);
ALTER TABLE [User] ADD CONSTRAINT Fk_UCID FOREIGN KEY ([CountryId]) REFERENCES [Country]([Id]);
ALTER TABLE [User] ADD CONSTRAINT Fk_USID FOREIGN KEY ([State]) REFERENCES [States]([Id]);
ALTER TABLE [User] ADD CONSTRAINT Fk_UCityID FOREIGN KEY ([CityId]) REFERENCES [City]([Id]);

ALTER TABLE [TreatmentDetails] ADD CONSTRAINT Fk_TDPID FOREIGN KEY ([PatientId]) REFERENCES [User]([Id]);
ALTER TABLE [TreatmentDetails] ADD CONSTRAINT Fk_TDDID FOREIGN KEY ([DoctorId]) REFERENCES [User]([Id]);
ALTER TABLE [TreatmentDetails] ADD CONSTRAINT Fk_TDNID FOREIGN KEY ([NurseId]) REFERENCES [User]([Id]);
ALTER TABLE [TreatmentDetails] ADD CONSTRAINT Fk_TDDIID FOREIGN KEY ([Diagnosis]) REFERENCES [Diagnosis]([Id]);
ALTER TABLE [TreatmentDetails] ADD CONSTRAINT Fk_TDPRID FOREIGN KEY ([Prescription]) REFERENCES [Medicine]([Id]);

									--Insert or Update Data In UserType Table--

CREATE OR ALTER PROC Insert_Update_Data_UserTpye(
	@Id INT,
	@UserTypeName VARCHAR(255)
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [UserType]([UserTypeName]) VALUES (@UserTypeName);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [UserType] SET [UserTypeName] = @UserTypeName WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC Insert_Update_Data_UserTpye null,'Doctor'
EXEC Insert_Update_Data_UserTpye null,'Patient'
EXEC Insert_Update_Data_UserTpye null,'Nurse'

SELECT * FROM UserType


									--Insert or Update Data In Country Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_Country(
	@Id INT,
	@CountryName VARCHAR(255)
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [Country]([CountryName]) VALUES (@CountryName);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [Country] SET [CountryName] = @CountryName WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_Country null,'India'
EXEC sp_Insert_Update_Data_Country null,'USA'

SELECT * FROM Country

									--Insert or Update Data In Diagnosis Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_Diagnosis(
	@Id INT,
	@DiagnosisDetails VARCHAR(255)
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [Diagnosis]([DiagnosisDetails]) VALUES (@DiagnosisDetails);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [Diagnosis] SET [DiagnosisDetails] = @DiagnosisDetails WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_Diagnosis null,'Fever'
EXEC sp_Insert_Update_Data_Diagnosis null,'Cold'
EXEC sp_Insert_Update_Data_Diagnosis null,'Headache'
EXEC sp_Insert_Update_Data_Diagnosis null,'Stomachache'
EXEC sp_Insert_Update_Data_Diagnosis null,'Vomit'

SELECT * FROM Diagnosis

									--Insert or Update Data In Medicine Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_Medicine(
	@Id INT,
	@MedicineName VARCHAR(255),
	@DiagnosisId INT
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [Medicine]([MedicineName],[DiagnosisId]) VALUES (@MedicineName,@DiagnosisId);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [Medicine] SET [MedicineName] = @MedicineName , [DiagnosisId] = @DiagnosisId WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_Medicine null ,'Dolo600',1
EXEC sp_Insert_Update_Data_Medicine null ,'Levocetirizine',2
EXEC sp_Insert_Update_Data_Medicine null ,'Panadol',3
EXEC sp_Insert_Update_Data_Medicine null ,'Liquiprin',4
EXEC sp_Insert_Update_Data_Medicine null ,'Paracetamol',5

SELECT * FROM Medicine

									--Insert or Update Data In State Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_State(
	@Id INT,
	@Statename VARCHAR(255),
	@CountryId INT
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [States]([StateName],[CountryId]) VALUES (@Statename,@CountryId);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [States] SET [StateName] = @Statename , [CountryId] = @CountryId WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_State null,'Gujarat',1
EXEC sp_Insert_Update_Data_State null,'Paris',2

SELECT * FROM States


									--Insert or Update Data In City Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_City(
	@Id INT,
	@CityName VARCHAR(255),
	@CountryId INT,
	@StateId INT
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [City]([CityName],[CountryId],[StateId]) VALUES (@CityName,@CountryId,@StateId);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [City] SET [CityName] = @CityName , [CountryId] = @CountryId , [StateId] = @StateId WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_City null,'siddhpur',1,1
EXEC sp_Insert_Update_Data_City null , 'Paris',2,2

SELECT * FROM City

									--Insert or Update Data In User Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_User(
	@Id INT,
	@FirstName VARCHAR(255),
	@LastName VARCHAR(255),
	@Email VARCHAR(100),
	@Password VARCHAR(10),
	@UserTypeId INT,
	@Address VARCHAR(MAX),
	@MobileNo VARCHAR(20),
	@CountryId INT,
	@StateId INT,
	@CityId INT
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [User]([FirstName],[LastName],[Email],[Password],[UserTypeId],[Address],[MobileNo],[CountryId],[State],[CityId]) 
			VALUES (@FirstName,@LastName,@Email,@Password,@UserTypeId,@Address,@MobileNo,@CountryId,@StateId,@CityId);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [User] SET [FirstName] = @FirstName , [LastName] = @LastName ,[Email] = @Email, [Password] = @Password , [UserTypeId] = @UserTypeId ,[Address] = @Address, [MobileNo] = @MobileNo , [CountryId] = @CountryId ,[State] = @StateId , [CityId] = @CityId WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_User null , 'Chirag','Patel','chirag@gmail.com','chirag123',1,'3 street paris','123-123-1234',2,2,2
EXEC sp_Insert_Update_Data_User null , 'Parth','Patel','Parth@gmail.com','Parth123',2,'3 street siddhpur','999-999-9999',1,1,1
EXEC sp_Insert_Update_Data_User null , 'Jay','Patel','Jay@gmail.com','Jayp1234',3,'3 street siddhpur','888-888-8888',1,1,1

SELECT * FROM [User]

									--Insert or Update Data In TreatmentDetails Table--

CREATE OR ALTER PROC sp_Insert_Update_Data_TreatmentDetails(
	@Id INT,
	@PatientId INT,
	@DoctorId INT,
	@NurseId INT,
	@Diagnosis INT,
	@Prescripation INT,
	@TreatmentFee DECIMAL(18,2),
	@DOT DATE,
	@Instructions VARCHAR(MAX)
)
AS
BEGIN
	BEGIN TRY
		IF (@Id IS NULL)
		BEGIN
			INSERT INTO [TreatmentDetails]([PatientId],[DoctorId],[NurseId],[Diagnosis],[Prescription],[TreatmentFee],[DOT],[Instructions]) VALUES (@PatientId,@DoctorId,@NurseId,@Diagnosis,@Prescripation,@TreatmentFee,@DOT,@Instructions);
		END
		IF (@Id IS NOT NULL)
		BEGIN
			BEGIN TRY
				BEGIN TRAN 
					UPDATE [TreatmentDetails] SET [PatientId] = @PatientId , [DoctorId] = @DoctorId , [NurseId] = @NurseId,[Diagnosis] = @Diagnosis,[Prescription]=@Prescripation,[TreatmentFee]=@TreatmentFee,[DOT]=@DOT,[Instructions]= @Instructions WHERE [Id] = @Id; 
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				PRINT ERROR_MESSAGE();
			END CATCH
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH
END

EXEC sp_Insert_Update_Data_TreatmentDetails null ,2,1,3,1,1,500,'2020-12-12','Every Night After Dinner'

SELECT * FROM TreatmentDetails



---[Q2]------

									--Retrive Doctors UserType--

CREATE OR ALTER PROC sp_Retrive_Doctors_UserType(
	@UserId INT
)
AS
BEGIN 
	BEGIN TRY 
		IF(@UserId IS NOT NULL)
		BEGIN
			SELECT ([U].[FirstName] + ' ' + U.LastName) AS [DoctorName],[Address],[MobileNo] FROM [UserType][UT] INNER JOIN [User][U] ON [UT].[Id] = [U].[UserTypeId] INNER JOIN [City][CT] ON [U].[CityId] = [CT].[Id] INNER JOIN [States][S] ON [CT].[StateId] = [S].[Id] INNER JOIN [Country][C] ON [S].[CountryId] = [C].[Id] WHERE [U].[Id] = @UserId AND [UT].[Id] = 1;
		END
		IF(@UserId IS NUll)
		BEGIN
			SELECT ([U].[FirstName] + ' ' + U.LastName) AS [DoctorName],[Address],[MobileNo] FROM [UserType][UT] INNER JOIN [User][U] ON [UT].[Id] = [U].[UserTypeId] INNER JOIN [City][CT] ON [U].[CityId] = [CT].[Id] INNER JOIN [States][S] ON [CT].[StateId] = [S].[Id] INNER JOIN [Country][C] ON [S].[CountryId] = [C].[Id] WHERE [UT].[Id] = 1;
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH
END

EXEC sp_Retrive_Doctors_UserType null

----[Q3]

								--FUNCTION Retrive Doctors UserType--

CREATE OR ALTER FUNCTION fun_Medicine_per_Diagnosis(
	@DiagnosisDetails varchar(255)
)
RETURNS VARCHAR(255)
AS
BEGIN
	declare @var varchar(255);
	select @var = stuff(
(select  ',' + MedicineName  from Medicine where DiagnosisId in (
select Id from Diagnosis D where DiagnosisDetails in (select [value] from string_split(@DiagnosisDetails,',')) ) for xml path(''))
,1,1,'')
	
	RETURN @var
	
END
	--while(i <= len())
	--Return (SELECT M.MedicineName from Diagnosis D INNER JOIN Medicine M On D.Id = M.DiagnosisId WHERE D.DiagnosisDetails = @DiagnosisDetails) 


PRINT dbo.fun_Medicine_per_Diagnosis('vomit','Fever')



--[Q4]

									--Retrive Doctors UserType--

CREATE OR ALTER PROC sp_Assign_Doc_Treatment(
	@FirstName VARCHAR(255),
	@LastName VARCHAR(255),
	@Email VARCHAR(100),
	@Password VARCHAR(10),
	@UserType VARCHAR(50),
	@Address VARCHAR(max),
	@MobileNo VARCHAR(20),
	@CityName Varchar(100),
	@DoctorName VARCHAR(255),
	@NurseName VARCHAR(255),
	@DesasesName VARCHAR(MAX),
	@TreatmentFee DECIMAL(18,2),
	@DOT DATE,
	@Instruction VARCHAR(MAX)
)
AS
BEGIN
	BEGIN TRY
	BEGIN TRAN
		DECLARE @i int
		Declare @UTId INT,@contId Int,@statid int,@cityid int,@PatientId int,@doctorId int,@NurseId int,@pric int,@DiagnoesId Int

		
			
			SET @UTId = (SELECT Id FROM UserType WHERE UserTypeName = @UserType)
			SET @cityId = (SELECT id from City WHERE CityName = @CityName)
			SET @statid = (select s.Id FROM city ct inner join States s on ct.StateId = s.Id WHERE ct.Id = @cityid)
			SET @contId = (select c.Id from city ct inner join States s on ct.StateId = s.Id inner join Country c on s.CountryId = c.Id WHERE s.Id = @statid)

			EXEC sp_Insert_Update_Data_User null,@FirstName,@LastName,@Email,@Password,@UTId,@Address,@MobileNo,@contId,@statid,@cityid
			
			--INSERT INTO [User]([FirstName],[LastName],[Email],[Password],[UserTypeId],[Address],[MobileNo],[CountryId],[State],[CityId])	VALUES (@FirstName,@LastName,@Email,@Password,@UTId,@Address,@MobileNo,@contId,@statid,@cityid)
		
			
			SET @PatientId = (SELECT MAX(Id) AS [ID] FROM [User])
			--(SELECT(SELECT SCOPE_IDENTITY() AS [Last-Inserted Identity Value])FROM(SELECT id FROM [USER]))
			SET @doctorId = (SELECT ut.Id FROM UserType ut INNER JOIN [User] u ON ut.Id = u.UserTypeId WHERE ut.UserTypeName = 'Doctor' AND		u.FirstName = @DoctorName)
			SET @NurseId = (SELECT ut.Id FROM UserType ut INNER JOIN [User] u ON ut.Id = u.UserTypeId WHERE ut.UserTypeName = 'Nurse' AND	u.FirstName = @NurseName)
			SET @DiagnoesId = (SELECT ID FROM Diagnosis WHERE DiagnosisDetails = @DesasesName )
			SET @pric = (SELECT id FROM Medicine WHERE DiagnosisId = @DiagnoesId )
			

			EXEC sp_Insert_Update_Data_TreatmentDetails null,@PatientId,@doctorId,@NurseId,@DiagnoesId,@pric,@TreatmentFee,@DOT,@Instruction
			--INSERT INTO [TreatmentDetails]([PatientId],[DoctorId],[NurseId],[Diagnosis],[Prescription],[TreatmentFee],[DOT],[Instructions]) VALUES (@PatientId,@doctorId,@NurseId,@DiagnoesId,@pric,@TreatmentFee,@DOT,@Instruction)
			


			
			SELECT (U.FirstName + ' ' + U.LastName) AS PatientName,@DoctorName AS [DoctorName],@NurseName AS [NurseName],(dbo.fun_Medicine_per_Diagnosis(@DesasesName)) AS [MEDICINE],[TD].[DOT],([U].[Address]+ ' ' + [CT].[CityName] + ' ' + [S].[StateName] + ' ' + [C].[CountryName]) AS [Address],[U].[MobileNo],[TD].[TreatmentFee] FROM [USER][U] INNER JOIN [UserType][UT] ON [U].[UserTypeId] = [UT].[Id] INNER JOIN  TreatmentDetails TD ON U.Id = TD.PatientId   INNER JOIN [City] [CT] ON [U].[CityId] = [CT].[Id] INNER JOIN [States][S] ON
			[U].[State] = [S].[Id] INNER JOIN [Country][C] ON [U].[CountryId] = [C].[Id] WHERE U.FirstName = @FirstName
		
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		PRINT ERROR_MESSAGE()
	END CATCH
END


EXEC sp_Assign_Doc_Treatment 'hemang','dholu','dholu@gmail.com','vgfdfggff','Patient','3-street','333-333-3333','Paris','Chirag','Jay','Fever,Cold,vomit','500','2022-08-08','every Day'

select * from UserType
SELECT * FROM [User]
SELECT * FROM TreatmentDetails

DELETE FROM [USER] WHERE ID = 16
