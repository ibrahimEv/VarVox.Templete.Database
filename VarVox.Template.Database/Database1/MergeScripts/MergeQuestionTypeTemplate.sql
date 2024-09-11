IF OBJECT_ID('tempdb..#QuestionTypeTemplate') IS NOT NULL
    DROP TABLE #QuestionTypeTemplate

CREATE TABLE #QuestionTypeTemplate
(
    [Id] INT NOT NULL PRIMARY KEY,
    [QuestionType] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [QuestionJsonTemp] VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsActive] BIT NOT NULL
)

INSERT INTO #QuestionTypeTemplate (Id, QuestionType, QuestionJsonTemp, IsActive)
SELECT 1 AS Id, 'RADIO' AS QuestionType, 'Test' AS QuestionJsonTemp, 1 AS IsActive UNION ALL
SELECT 2 AS Id, 'CHECK-BOX' AS QuestionType, 'Test' AS QuestionJsonTemp, 1 AS IsActive UNION ALL
SELECT 3 AS Id, 'TEXT' AS QuestionType, 'Test' AS QuestionJsonTemp, 1 AS IsActive UNION ALL
SELECT 4 AS Id, 'RATING' AS QuestionType, 'Test' AS QuestionJsonTemp, 1 AS IsActive

BEGIN TRY
    BEGIN TRANSACTION

    MERGE TemplateDatabase.Ref.QuestionTypeTemplate AS TARGET
    USING #QuestionTypeTemplate AS SOURCE
        ON TARGET.Id = SOURCE.Id

    WHEN MATCHED AND (
        TARGET.QuestionType COLLATE SQL_Latin1_General_CP1_CI_AS <> SOURCE.QuestionType COLLATE SQL_Latin1_General_CP1_CI_AS
        OR TARGET.QuestionJsonTemp COLLATE SQL_Latin1_General_CP1_CI_AS <> SOURCE.QuestionJsonTemp COLLATE SQL_Latin1_General_CP1_CI_AS
        OR TARGET.IsActive <> SOURCE.IsActive)
    THEN
        UPDATE
        SET TARGET.QuestionType = SOURCE.QuestionType,
            TARGET.QuestionJsonTemp = SOURCE.QuestionJsonTemp,
            TARGET.IsActive = SOURCE.IsActive

    WHEN NOT MATCHED BY TARGET
    THEN
        INSERT (Id, QuestionType, QuestionJsonTemp, IsActive)
        VALUES (SOURCE.Id, SOURCE.QuestionType, SOURCE.QuestionJsonTemp, SOURCE.IsActive);

    COMMIT TRANSACTION
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION
    THROW;
END CATCH
GO
