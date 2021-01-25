

/* NOTE: Step 1 is now already bundled within Step 2. We can skip this small Step 1 now. */

/*
/* STEP 1: Get ClassNumberKeys - Do this for main course and prerequisite courses in one query */ 
SELECT DISTINCT dcn.ClassNumberKey, dt.SourceKey AS TermSourceKey, dt.Description, 
dc.PrimarySubject, dc.PrimaryCatalogNumber, dcn.ClassNumberUniqueDescription, ClassSection, 
ds.Description AS Session, CombinedSection, df.UniqueDescription AS Instructor, 
ClassEnrolledCount, dim.Description AS InstructionMode, ds.WeeksOfInstruction

FROM Final.FactClassSchedule main

JOIN Final.DimClassNumber dcn
ON dcn.ClassNumberKey = main.ClassNumberKey

JOIN Final.DimInstructionMode dim
ON main.InstructionModeKey = dim.InstructionModeKey

JOIN Final.DimCourse dc
ON main.CourseKey = dc.CourseKey

JOIN Final.DimTerm dt
ON main.TermKey = dt.TermKey

JOIN Final.DimSession ds
ON main.SessionKey = ds.SessionKey

JOIN Final.DimFaculty df
ON main.FacultyKey = df.FacultyKey

WHERE dcn.ClassNumberUniqueDescription IN ('BIOL 227')
AND dim.Description = 'Online'
AND dt.SourceKey IN ('1209')

ORDER BY TermSourceKey, dc.PrimarySubject, dc.PrimaryCatalogNumber, ClassSection

/* Jot down the ClassNumberKeys here for Step 2*/
/*AND		dcn.ClassNumberKey IN ('106064', '106065', '112015')*/ 
*/


/* STEP 2: Use previous values to do this query */
SELECT DISTINCT
		fr.TermKey,
		dt.SourceKey AS TermSourceKey,
		dt.Description AS Term,
		instmode.Description AS InstructionMode,
		dcn.SubjectSourceKey AS Subject,
		dcn.CatalogNumberSourceKey AS CourseNumber,
		dcn.ClassSectionSourceKey AS Section,
		dcn.ClassNumberUniqueDescription,
		dcn.ClassNumberSectionPaddedDescription AS TotalCourseDescription,
		(SELECT ds.UniqueDescription FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS StudentName,
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS StudentID,
		vfspo.EmployeeID, vfspo.VersionKey, vfspo.PlanCount, vfspo.TermSourceKey, vfspo.AcademicPlan, vfspo.AcademicSubPlan,
		
		df.UniqueDescription As Instructor,

		fr.StudentAge,
		fr.BSUIPEDSEthnicity,
		(SELECT UniqueDescription FROM Final.DimGender g WHERE fr.GenderKey = g.GenderKey) AS Gender,
		fst.FirstTermAtInstitutionCount AS FirstTermAtInstitution,
		fst.CumulativeGPA,
		(SELECT UniqueDescription FROM CustomFinal.DimFirstGeneration dfg WHERE fst.FirstGenerationKey = dfg.FirstGenerationKey) AS FirstGen,
		(SELECT UniqueDescription FROM CustomFinal.DimVeteranAffiliated vet WHERE fst.VeteranAffiliatedKey = vet.VeteranAffiliatedKey) AS VeteranAff,
		(SELECT UniqueDescription FROM Final.DimAcademicLevel al WHERE fst.AcademicLevelKey = al.AcademicLevelKey) AS AcademicLevel,
		fst.HasTransferCumGPA,

		dal.Description, daltk.FullTimePartTimeDescription, 

		EnrolledClassCount, DropCount, fr.WithdrawCount, CreditsAttempted, CreditsEarned, dg.EarnCreditIndicator, dg.SuccessIndicator,
	HasClassGrade, ClassGrade, dg.GradeKey, dg.SourceKey AS GradeLetter, dg.GradePoints, dg.GradeDescription, dg.GradeSubgroup, dg.GradeGroup, dg.GradingBasisDescription,
		
		EnrollStatus, RegistrationAddDate, RegistrationDropDate, drc.UniqueDescription, dv.Description AS VersionDescription

FROM	Final.FactRegistration fr

		JOIN	Final.DimTerm dt
		ON		fr.Termkey = dt.TermKey

		JOIN	Final.DimClassNumber dcn
		ON		fr.ClassNumberKey = dcn.ClassNumberKey

		JOIN	Final.FactStudentTerm fst
		ON		fr.StudentKey = fst.StudentKey 
		AND		fr.TermKey = fst.TermKey

		JOIN	Final.DimInstructionMode instmode
		ON		fr.InstructionModeKey = instmode.InstructionModeKey

		JOIN	Final.DimFaculty df
		ON		fr.FacultyKey = df.FacultyKey

		JOIN	Final.DimAcademicLevel dal
		ON		fr.AcademicLevelKey = dal.AcademicLevelKey

		JOIN	Final.DimAcademicLoadTuition daltk
		ON		fr.AcademicLoadTuitionKey = daltk.AcademicLoadTuitionKey

		JOIN	CustomFinal.ViewFactStudentPlanOwner vfspo
		ON		(fr.StudentKey = vfspo.StudentKey) AND (fr.TermKey = vfspo.TermKey) 

		JOIN	Final.DimVersion dv
		ON		vfspo.VersionKey = dv.VersionKey

		JOIN 	Final.DimRepeatCode drc 
		ON 		fr.RepeatCodeKey = drc.RepeatCodeKey

		JOIN	Final.DimGrade dg
		ON		fr.GradeKey = dg.GradeKey

WHERE	dt.SourceKey in ('1209')
AND		dcn.ClassNumberUniqueDescription IN ('BIOL 227')
AND 	instmode.Description = 'Online'
AND     dv.VersionKey = 1 /*Current snapshot*/


ORDER BY StudentName, Term, Subject, CourseNumber, StudentID, VersionKey, AcademicPlan