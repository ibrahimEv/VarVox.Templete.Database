IF OBJECT_ID('tempdb..#QuestionTypeTemplate') Is NOT NULL
 DROP TABLE #QuestionTypeTemplate

 CREATE TABLE #QuestionTypeTemplate
 (
	[Id] INT NOT NULL PRIMARY KEY,
	[QuestionType] VARCHAR(50) NOT NULL,
	[QuestionJsonTemp] VARCHAR(MAX) NOT NULL
 )

 INSERT INTO #QuestionTypeTemplate(Id, QuestionType, QuestionJsonTemp)

