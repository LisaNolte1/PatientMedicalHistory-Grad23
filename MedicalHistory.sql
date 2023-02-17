USE [master]
GO
/****** Object:  Database [MedicalHistory]    Script Date: 2023/02/17 10:24:18 ******/
CREATE DATABASE [MedicalHistory]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MedicalHistory', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MedicalHistory.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MedicalHistory_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\MedicalHistory_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [MedicalHistory] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MedicalHistory].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MedicalHistory] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MedicalHistory] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MedicalHistory] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MedicalHistory] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MedicalHistory] SET ARITHABORT OFF 
GO
ALTER DATABASE [MedicalHistory] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [MedicalHistory] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MedicalHistory] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MedicalHistory] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MedicalHistory] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MedicalHistory] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MedicalHistory] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MedicalHistory] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MedicalHistory] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MedicalHistory] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MedicalHistory] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MedicalHistory] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MedicalHistory] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MedicalHistory] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MedicalHistory] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MedicalHistory] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MedicalHistory] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MedicalHistory] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MedicalHistory] SET  MULTI_USER 
GO
ALTER DATABASE [MedicalHistory] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MedicalHistory] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MedicalHistory] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MedicalHistory] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MedicalHistory] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MedicalHistory] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MedicalHistory] SET QUERY_STORE = ON
GO
ALTER DATABASE [MedicalHistory] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MedicalHistory]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[id] [uniqueidentifier] NOT NULL,
	[phone] [varchar](10) NULL,
	[email] [nvarchar](255) NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dose]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dose](
	[id] [uniqueidentifier] NOT NULL,
	[description] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Dose] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medication]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medication](
	[id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__Medication] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[id] [uniqueidentifier] NOT NULL,
	[contactId] [uniqueidentifier] NULL,
 CONSTRAINT [PK__Patient] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[id] [uniqueidentifier] NOT NULL,
	[idNumber] [varchar](13) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[surname] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__Person] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[id] [uniqueidentifier] NOT NULL,
	[medicationId] [uniqueidentifier] NOT NULL,
	[doseId] [uniqueidentifier] NOT NULL,
	[patientId] [uniqueidentifier] NOT NULL,
	[professionalId] [uniqueidentifier] NOT NULL,
	[startdate] [datetime] NOT NULL,
	[endate] [datetime] NOT NULL,
	[cancelledDate] [datetime] NULL,
 CONSTRAINT [PK__Prescription] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Procedure]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Procedure](
	[id] [uniqueidentifier] NOT NULL,
	[patientId] [uniqueidentifier] NOT NULL,
	[professionalId] [uniqueidentifier] NOT NULL,
	[typeId] [uniqueidentifier] NOT NULL,
	[date] [datetime] NULL,
 CONSTRAINT [PK_Procedure] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcedureType]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcedureType](
	[id] [uniqueidentifier] NOT NULL,
	[description] [varchar](255) NOT NULL,
 CONSTRAINT [PK_ProcedureType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Professional]    Script Date: 2023/02/17 10:24:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professional](
	[id] [uniqueidentifier] NOT NULL,
	[contactId] [uniqueidentifier] NULL,
 CONSTRAINT [PK__Doctor] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF__Contact__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Dose] ADD  CONSTRAINT [DF__Dose__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Medication] ADD  CONSTRAINT [DF__Medication__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Patient] ADD  CONSTRAINT [DF__Patient__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [DF__Person__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Prescription] ADD  CONSTRAINT [DF__Prescription__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Procedure] ADD  CONSTRAINT [DF__Procedure__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[ProcedureType] ADD  CONSTRAINT [DF__ProcedureType__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Professional] ADD  CONSTRAINT [DF__Doctor__id]  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Contact] FOREIGN KEY([contactId])
REFERENCES [dbo].[Contact] ([id])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Contact]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Person] FOREIGN KEY([id])
REFERENCES [dbo].[Person] ([id])
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [FK_Patient_Person]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_Professional] FOREIGN KEY([id])
REFERENCES [dbo].[Professional] ([id])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_Professional]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Dose] FOREIGN KEY([doseId])
REFERENCES [dbo].[Dose] ([id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Dose]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Medication] FOREIGN KEY([medicationId])
REFERENCES [dbo].[Medication] ([id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Medication]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Patient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Patient]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Professional] FOREIGN KEY([professionalId])
REFERENCES [dbo].[Professional] ([id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Professional]
GO
ALTER TABLE [dbo].[Procedure]  WITH CHECK ADD  CONSTRAINT [FK_Procedure_Patient] FOREIGN KEY([patientId])
REFERENCES [dbo].[Patient] ([id])
GO
ALTER TABLE [dbo].[Procedure] CHECK CONSTRAINT [FK_Procedure_Patient]
GO
ALTER TABLE [dbo].[Procedure]  WITH CHECK ADD  CONSTRAINT [FK_Procedure_ProcedureType] FOREIGN KEY([typeId])
REFERENCES [dbo].[ProcedureType] ([id])
GO
ALTER TABLE [dbo].[Procedure] CHECK CONSTRAINT [FK_Procedure_ProcedureType]
GO
ALTER TABLE [dbo].[Procedure]  WITH CHECK ADD  CONSTRAINT [FK_Procedure_Professional] FOREIGN KEY([professionalId])
REFERENCES [dbo].[Professional] ([id])
GO
ALTER TABLE [dbo].[Procedure] CHECK CONSTRAINT [FK_Procedure_Professional]
GO
ALTER TABLE [dbo].[Professional]  WITH CHECK ADD  CONSTRAINT [FK_Professional_Contact] FOREIGN KEY([contactId])
REFERENCES [dbo].[Contact] ([id])
GO
ALTER TABLE [dbo].[Professional] CHECK CONSTRAINT [FK_Professional_Contact]
GO
USE [master]
GO
ALTER DATABASE [MedicalHistory] SET  READ_WRITE 
GO
