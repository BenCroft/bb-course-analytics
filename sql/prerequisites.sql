DECLARE
	@PrerequisiteA VARCHAR(4000) = '%BIOL 227%',
	@PrerequisiteB VARCHAR(4000) = '%HLTH 101%',
	@PrerequisiteC VARCHAR(4000) = '%CHEM 101%'

SELECT
	/*Term*/
	fr.TermKey, fr.TermSourceKey, SessionCode,
	/*Course*/
	dcn.ClassNumberSectionUniqueDescription, dcn.ClassNumberUniqueDescription, dc.PrimarySubject, dc.PrimaryCatalogNumber, ClassSection, PrimaryComponent,
	/*Course Attribute*/
	fca.CourseAttribute, fca.CourseAttributeValue, dca.ValueFormalDescription,
	/*Student Enrollment and Grade*/
	ds.SourceKey AS StudentID, EnrolledClassCount, DropCount, WithdrawCount, CreditsAttempted, CreditsEarned, dg.EarnCreditIndicator, dg.SuccessIndicator,
	HasClassGrade, ClassGrade, dg.GradeKey, dg.SourceKey AS GradeLetter, dg.GradeDescription, dg.GradeSubgroup, dg.GradeGroup, dg.GradingBasisDescription

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
	OR ClassNumberUniqueDescription LIKE @PrerequisiteC)
	AND dc.PrimaryComponent = 'LEC'
	AND fca.VersionKey = 5 /*Census Date*/

ORDER BY ClassNumber, TermKey, SessionCode, CourseAttribute, StudentID
