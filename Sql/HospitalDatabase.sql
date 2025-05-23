USE [master]
GO
/****** Object:  Database [HealthCareSystem]    Script Date: 3/27/2025 2:38:34 AM ******/
CREATE DATABASE [HealthCareSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HealthCareSystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\HealthCareSystem.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HealthCareSystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\HealthCareSystem_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [HealthCareSystem] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HealthCareSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HealthCareSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HealthCareSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HealthCareSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HealthCareSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HealthCareSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [HealthCareSystem] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [HealthCareSystem] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [HealthCareSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HealthCareSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HealthCareSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HealthCareSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HealthCareSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HealthCareSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HealthCareSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HealthCareSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HealthCareSystem] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HealthCareSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HealthCareSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HealthCareSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HealthCareSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HealthCareSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HealthCareSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HealthCareSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HealthCareSystem] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HealthCareSystem] SET  MULTI_USER 
GO
ALTER DATABASE [HealthCareSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HealthCareSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HealthCareSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HealthCareSystem] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [HealthCareSystem]
GO
/****** Object:  StoredProcedure [dbo].[AddDoctor]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddDoctor]
@Name VARCHAR(100),
@Specialty VARCHAR(100),
@Contact_Info VARCHAR(20),
@Department_ID INT,
@Years_of_Experience INT
AS
BEGIN
    INSERT INTO Doctor (Name, Specialty, Contact_Info, Department_ID, Years_of_Experience)
    VALUES (@Name, @Specialty, @Contact_Info, @Department_ID, @Years_of_Experience);
END;

GO
/****** Object:  StoredProcedure [dbo].[AddPrescription]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddPrescription]
@Patient_ID INT,
@Doctor_ID INT,
@Medication VARCHAR(255),
@Dosage VARCHAR(50),
@Duration VARCHAR(50),
@Refill_Allowed BIT
AS
BEGIN
    INSERT INTO Prescription (Patient_ID, Doctor_ID, Prescription_Date, Medication, Dosage, Duration, Refill_Allowed)
    VALUES (@Patient_ID, @Doctor_ID, GETDATE(), @Medication, @Dosage, @Duration, @Refill_Allowed);
END;

GO
/****** Object:  StoredProcedure [dbo].[AssignRoom]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AssignRoom]
@Patient_ID INT,
@Room_ID INT,
@Reason_for_Admission VARCHAR(255)
AS
BEGIN
    INSERT INTO Admission (Patient_ID, Room_ID, Admission_Date, Reason_for_Admission)
    VALUES (@Patient_ID, @Room_ID, GETDATE(), @Reason_for_Admission);
    
    UPDATE Room SET Availability_Status = 0 WHERE Room_ID = @Room_ID;
END;

GO
/****** Object:  StoredProcedure [dbo].[BookAppointment]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BookAppointment]
@Patient_ID INT,
@Doctor_ID INT,
@Appointment_Date DATE,
@Appointment_Time TIME,
@Reason_for_Visit VARCHAR(255)
AS
BEGIN
    INSERT INTO Appointment (Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Status, Reason_for_Visit)
    VALUES (@Patient_ID, @Doctor_ID, @Appointment_Date, @Appointment_Time, 'Scheduled', @Reason_for_Visit);
END;

GO
/****** Object:  StoredProcedure [dbo].[CancelAppointment]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CancelAppointment]
@Appointment_ID INT
AS
BEGIN
    UPDATE Appointment SET Status = 'Cancelled' WHERE Appointment_ID = @Appointment_ID;
END;

GO
/****** Object:  StoredProcedure [dbo].[GetDoctorAppointments]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetDoctorAppointments]
@Doctor_ID INT
AS
BEGIN
    SELECT * FROM Appointment WHERE Doctor_ID = @Doctor_ID AND Status = 'Scheduled';
END;

GO
/****** Object:  StoredProcedure [dbo].[GetPatientMedicalRecords]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetPatientMedicalRecords]
@Patient_ID INT
AS
BEGIN
    SELECT * FROM Medical_Record WHERE Patient_ID = @Patient_ID;
END;

GO
/****** Object:  StoredProcedure [dbo].[ProcessPayment]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcessPayment]
@Patient_ID INT,
@Amount DECIMAL(10,2),
@Payment_Method VARCHAR(50),
@Insurance_Provider_ID INT = NULL
AS
BEGIN
    INSERT INTO Billing (Patient_ID, Billing_Date, Amount, Status, Insurance_Provider_ID, Payment_Method)
    VALUES (@Patient_ID, GETDATE(), @Amount, 'Paid', @Insurance_Provider_ID, @Payment_Method);
END;

GO
/****** Object:  StoredProcedure [dbo].[RegisterPatient]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegisterPatient]
@Name VARCHAR(100),
@Date_of_Birth DATE,
@Contact_Info VARCHAR(20),
@Address VARCHAR(255),
@Insurance_Details VARCHAR(255),
@Emergency_Contact VARCHAR(20)
AS
BEGIN
    INSERT INTO Patient (Name, Date_of_Birth, Contact_Info, Address, Insurance_Details, Emergency_Contact)
    VALUES (@Name, @Date_of_Birth, @Contact_Info, @Address, @Insurance_Details, @Emergency_Contact);
END;

GO
/****** Object:  StoredProcedure [dbo].[UpdateDoctorProfile]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateDoctorProfile]
@Doctor_ID INT,
@Specialty VARCHAR(100),
@Contact_Info VARCHAR(20),
@Years_of_Experience INT
AS
BEGIN
    UPDATE Doctor 
    SET Specialty = @Specialty, Contact_Info = @Contact_Info, Years_of_Experience = @Years_of_Experience
    WHERE Doctor_ID = @Doctor_ID;
END;

GO
/****** Object:  Table [dbo].[Admission]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Admission](
	[Admission_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Room_ID] [int] NULL,
	[Admission_Date] [date] NULL,
	[Discharge_Date] [date] NULL,
	[Reason_for_Admission] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Admission_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Appointment]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Appointment](
	[Appointment_ID] [int] NOT NULL,
	[Appointment_Date] [date] NULL,
	[Appointment_Time] [time](7) NULL,
	[Patient_ID] [int] NULL,
	[Doctor_ID] [int] NULL,
	[Status] [varchar](50) NULL,
	[Reason_for_Visit] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Appointment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Billing]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Billing](
	[Billing_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Billing_Date] [date] NULL,
	[Amount] [decimal](10, 2) NULL,
	[Status] [varchar](50) NULL,
	[Insurance_Provider_ID] [int] NULL,
	[Payment_Method] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Billing_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Department]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Department](
	[Department_ID] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Location] [varchar](100) NULL,
	[Head_of_Department] [int] NULL,
	[Number_of_Staff] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Department_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Doctor](
	[Doctor_ID] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Specialty] [varchar](100) NULL,
	[Contact_Info] [varchar](20) NULL,
	[Department_ID] [int] NULL,
	[Years_of_Experience] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Doctor_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Insurance_Provider]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Insurance_Provider](
	[Provider_ID] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Contact_Info] [varchar](20) NULL,
	[Policy_Details] [varchar](255) NULL,
	[Coverage_Limit] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Provider_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lab_Result]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lab_Result](
	[Result_ID] [int] NOT NULL,
	[Test_ID] [int] NULL,
	[Patient_ID] [int] NULL,
	[Result_Date] [date] NULL,
	[Result] [varchar](255) NULL,
	[Doctor_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Result_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lab_Test]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lab_Test](
	[Test_ID] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Description] [varchar](255) NULL,
	[Cost] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Test_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Medical_Record]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Medical_Record](
	[Record_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Doctor_ID] [int] NULL,
	[Record_Date] [date] NULL,
	[Diagnosis] [varchar](255) NULL,
	[Treatment] [varchar](255) NULL,
	[Notes] [varchar](255) NULL,
	[Follow_Up_Date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Record_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Nurse]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Nurse](
	[Nurse_ID] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Contact_Info] [varchar](20) NULL,
	[Department_ID] [int] NULL,
	[Shift_Timings] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Nurse_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Patient](
	[Patient_ID] [int] NOT NULL,
	[Name] [varchar](100) NULL,
	[Date_of_Birth] [date] NULL,
	[Contact_Info] [varchar](20) NULL,
	[Address] [varchar](255) NULL,
	[Insurance_Details] [varchar](255) NULL,
	[Emergency_Contact] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Patient_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Prescription](
	[Prescription_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Doctor_ID] [int] NULL,
	[Prescription_Date] [date] NULL,
	[Medication] [varchar](255) NULL,
	[Dosage] [varchar](50) NULL,
	[Duration] [varchar](50) NULL,
	[Refill_Allowed] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Prescription_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Room]    Script Date: 3/27/2025 2:38:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Room](
	[Room_ID] [int] NOT NULL,
	[Room_Number] [varchar](10) NULL,
	[Room_Type] [varchar](50) NULL,
	[Availability_Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Room_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Admission]  WITH CHECK ADD FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Admission]  WITH CHECK ADD FOREIGN KEY([Room_ID])
REFERENCES [dbo].[Room] ([Room_ID])
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Billing]  WITH CHECK ADD FOREIGN KEY([Insurance_Provider_ID])
REFERENCES [dbo].[Insurance_Provider] ([Provider_ID])
GO
ALTER TABLE [dbo].[Billing]  WITH CHECK ADD FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO
ALTER TABLE [dbo].[Lab_Result]  WITH CHECK ADD FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Lab_Result]  WITH CHECK ADD FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Lab_Result]  WITH CHECK ADD FOREIGN KEY([Test_ID])
REFERENCES [dbo].[Lab_Test] ([Test_ID])
GO
ALTER TABLE [dbo].[Medical_Record]  WITH CHECK ADD FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Medical_Record]  WITH CHECK ADD FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
USE [master]
GO
ALTER DATABASE [HealthCareSystem] SET  READ_WRITE 
GO
