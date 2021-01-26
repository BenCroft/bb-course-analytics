DECLARE
	@PrerequisiteA VARCHAR(4000) = '%BIOL 101%',
	@PrerequisiteB VARCHAR(4000) = '%HLTH 101%',
	@PrerequisiteC VARCHAR(4000) = '%CHEM 111%',
	@PrerequisiteD VARCHAR(4000) = '%HLTH 300%'

SELECT DISTINCT
	/*Term*/
	fr.TermKey, fr.TermSourceKey,
	/*Course*/
	dcn.ClassNumberUniqueDescription, dc.PrimarySubject, dc.PrimaryCatalogNumber, PrimaryComponent,
	/*Student Enrollment and Grade*/
	ds.SourceKey AS StudentID, EnrolledClassCount, DropCount, WithdrawCount, CreditsAttempted, CreditsEarned, dg.EarnCreditIndicator, dg.SuccessIndicator,
	HasClassGrade, ClassGrade, dg.GradeKey, dg.SourceKey AS GradeLetter, dg.GradePoints, dg.GradeDescription, dg.GradeSubgroup, dg.GradeGroup, dg.GradingBasisDescription

FROM Final.FactRegistration fr
	JOIN Final.DimClassNumber dcn
		ON fr.ClassNumberKey = dcn.ClassNumberKey
	JOIN Final.DimGrade dg
		ON fr.GradeKey = dg.GradeKey
	INNER JOIN Final.FactCourseAttributes fca
		ON fr.CourseKey = fca.CourseKey
		AND fr.TermKey = fca.TermKey
	JOIN Final.DimCourseAttribute dca
		ON fca.CourseAttributeKey = dca.CourseAttributeKey
	INNER JOIN Final.DimStudent ds
		ON fr.StudentKey = ds.StudentKey
	INNER JOIN Final.DimCourse dc
		ON fr.CourseKey = dc.CourseKey

WHERE (ClassNumberUniqueDescription LIKE @PrerequisiteA
	OR ClassNumberUniqueDescription LIKE @PrerequisiteB
	OR ClassNumberUniqueDescription LIKE @PrerequisiteC
	OR ClassNumberUniqueDescription LIKE @PrerequisiteD)
	AND dc.PrimaryComponent = 'LEC'
	AND fca.VersionKey = 1 /*Current Snapshot*/
	AND EarnCreditIndicator = 'Credit Earned'

ORDER BY ClassNumberUniqueDescription, TermKey, StudentID