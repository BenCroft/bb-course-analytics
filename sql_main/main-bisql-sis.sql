

WITH main AS	
(	

	SELECT DISTINCT	
			fr.VersionKey AS VersionKeyRegistration,	
			vfspo.VersionKey AS VersionKeyStudentPlanOwner,	
			fr.TermKey,	
			dt.SourceKey AS TermSourceKey,	
			dt.Description AS Term,	
			instmode.Description AS InstructionMode,	
			dcn.SubjectSourceKey AS Subject,	
			dcn.CatalogNumberSourceKey AS CourseNumber,	
			dcn.ClassSectionSourceKey AS Section,	
			dcn.ClassNumberUniqueDescription,	
			dcn.ClassNumberSectionPaddedDescription AS TotalCourseDescription,	
			(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS StudentID,	
			vfspo.EmployeeID,  vfspo.PlanCount, vfspo.AcademicPlan, vfspo.AcademicSubPlan,	
			df.UniqueDescription As Instructor,	
			fr.StudentAge,	
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
			AND		fr.VersionKey = fst.VersionKey	

			JOIN	Final.DimInstructionMode instmode	
			ON		fr.InstructionModeKey = instmode.InstructionModeKey	

			JOIN	Final.DimFaculty df	
			ON		fr.FacultyKey = df.FacultyKey	

			JOIN	Final.DimAcademicLevel dal	
			ON		fr.AcademicLevelKey = dal.AcademicLevelKey	

			JOIN	Final.DimAcademicLoadTuition daltk	
			ON		fr.AcademicLoadTuitionKey = daltk.AcademicLoadTuitionKey	

			JOIN	CustomFinal.ViewFactStudentPlanOwner vfspo	
			ON		fr.StudentKey = vfspo.StudentKey 	
			AND		fr.TermKey = vfspo.TermKey	
			AND		fr.VersionKey = vfspo.VersionKey	

			JOIN	Final.DimVersion dv	
			ON		vfspo.VersionKey = dv.VersionKey	

			JOIN 	Final.DimRepeatCode drc 	
			ON 		fr.RepeatCodeKey = drc.RepeatCodeKey	

			JOIN	Final.DimGrade dg	
			ON		fr.GradeKey = dg.GradeKey			

	WHERE	dt.SourceKey in ('1209')	
	AND		dcn.ClassNumberUniqueDescription IN ('BIOL 227')	
	AND 	instmode.Description = 'Online'	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'		
),	

P1 AS	
	(SELECT DISTINCT	
		fr.VersionKey AS P1_VersionKeyRegistration,	
		dt.SourceKey AS P1_TermSourceKey,	
		instmode.Description AS P1_InstructionMode,	
		dcn.ClassNumberUniqueDescription as P1_ClassNumber,	
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS P1_StudentID,	
		fr.StudentKey as P1_StudentKey,	
		CreditsEarned as P1_CreditsEarned, dg.EarnCreditIndicator as P1_EarnCreditIndicator, 	
		dg.SuccessIndicator as P1_SuccessIndicator,	
		ClassGrade as P1_ClassGrade, dg.SourceKey as P1_GradeLetter, dg.GradePoints as P1_GradePoints, 	
		dg.GradeDescription as P1_GradeDescription, dg.GradeSubgroup as P1_GradeSubgroup, 	
		dg.GradeGroup as P1_GradeGroup, dg.GradingBasisDescription as P1_GradingBasisDescription,	
		EnrollStatus as P1_EnrollStatus, RegistrationAddDate as P1_RegistrationDate, 	
		RegistrationDropDate as P1_RegistrationDropDate, drc.UniqueDescription as P1_UniqueDescription,	

		ROW_NUMBER() OVER (PARTITION BY fr.StudentKey ORDER BY fr.TermSourceKey DESC) AS P1_rn	


	FROM	Final.FactRegistration fr	

		JOIN	Final.DimTerm dt	
		ON		fr.Termkey = dt.TermKey	

		JOIN	Final.DimClassNumber dcn	
		ON		fr.ClassNumberKey = dcn.ClassNumberKey	

		JOIN	Final.FactStudentTerm fst	
		ON		fr.StudentKey = fst.StudentKey 	
		AND		fr.TermKey = fst.TermKey	
		AND		fr.VersionKey = fst.VersionKey	

		JOIN	Final.DimInstructionMode instmode	
		ON		fr.InstructionModeKey = instmode.InstructionModeKey	

		JOIN	Final.DimFaculty df	
		ON		fr.FacultyKey = df.FacultyKey	

		JOIN	Final.DimAcademicLevel dal	
		ON		fr.AcademicLevelKey = dal.AcademicLevelKey	

		JOIN	Final.DimAcademicLoadTuition daltk	
		ON		fr.AcademicLoadTuitionKey = daltk.AcademicLoadTuitionKey	

		JOIN	CustomFinal.ViewFactStudentPlanOwner vfspo	
		ON		fr.StudentKey = vfspo.StudentKey 	
		AND		fr.TermKey = vfspo.TermKey	
		AND		fr.VersionKey = vfspo.VersionKey	

		JOIN	Final.DimVersion dv	
		ON		vfspo.VersionKey = dv.VersionKey	

		JOIN 	Final.DimRepeatCode drc 	
		ON 		fr.RepeatCodeKey = drc.RepeatCodeKey	

		JOIN	Final.DimGrade dg	
		ON		fr.GradeKey = dg.GradeKey	

	WHERE		dcn.ClassNumberUniqueDescription IN ('CHEM 111')	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'	
),	

P2 AS	
	(SELECT DISTINCT	
		fr.VersionKey AS P2_VersionKeyRegistration,	
		dt.SourceKey AS P2_TermSourceKey,	
		instmode.Description AS P2_InstructionMode,	
		dcn.ClassNumberUniqueDescription as P2_ClassNumber,	
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS P2_StudentID,	
		fr.StudentKey as P2_StudentKey,	
		CreditsEarned as P2_CreditsEarned, dg.EarnCreditIndicator as P2_EarnCreditIndicator, 	
		dg.SuccessIndicator as P2_SuccessIndicator,	
		ClassGrade as P2_ClassGrade, dg.SourceKey as P2_GradeLetter, dg.GradePoints as P2_GradePoints, 	
		dg.GradeDescription as P2_GradeDescription, dg.GradeSubgroup as P2_GradeSubgroup, 	
		dg.GradeGroup as P2_GradeGroup, dg.GradingBasisDescription as P2_GradingBasisDescription,	
		EnrollStatus as P2_EnrollStatus, RegistrationAddDate as P2_RegistrationDate, 	
		RegistrationDropDate as P2_RegistrationDropDate, drc.UniqueDescription as P2_UniqueDescription,	

		ROW_NUMBER() OVER (PARTITION BY fr.StudentKey ORDER BY fr.TermSourceKey DESC) AS P2_rn	


	FROM	Final.FactRegistration fr	

		JOIN	Final.DimTerm dt	
		ON		fr.Termkey = dt.TermKey	

		JOIN	Final.DimClassNumber dcn	
		ON		fr.ClassNumberKey = dcn.ClassNumberKey	

		JOIN	Final.FactStudentTerm fst	
		ON		fr.StudentKey = fst.StudentKey 	
		AND		fr.TermKey = fst.TermKey	
		AND		fr.VersionKey = fst.VersionKey	

		JOIN	Final.DimInstructionMode instmode	
		ON		fr.InstructionModeKey = instmode.InstructionModeKey	

		JOIN	Final.DimFaculty df	
		ON		fr.FacultyKey = df.FacultyKey	

		JOIN	Final.DimAcademicLevel dal	
		ON		fr.AcademicLevelKey = dal.AcademicLevelKey	

		JOIN	Final.DimAcademicLoadTuition daltk	
		ON		fr.AcademicLoadTuitionKey = daltk.AcademicLoadTuitionKey	

		JOIN	CustomFinal.ViewFactStudentPlanOwner vfspo	
		ON		fr.StudentKey = vfspo.StudentKey 	
		AND		fr.TermKey = vfspo.TermKey	
		AND		fr.VersionKey = vfspo.VersionKey	

		JOIN	Final.DimVersion dv	
		ON		vfspo.VersionKey = dv.VersionKey	

		JOIN 	Final.DimRepeatCode drc 	
		ON 		fr.RepeatCodeKey = drc.RepeatCodeKey	

		JOIN	Final.DimGrade dg	
		ON		fr.GradeKey = dg.GradeKey	

	WHERE		dcn.ClassNumberUniqueDescription IN ('HLTH 101')	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'	
),	

P3 AS	
	(SELECT DISTINCT	
		fr.VersionKey AS P3_VersionKeyRegistration,	
		dt.SourceKey AS P3_TermSourceKey,	
		instmode.Description AS P3_InstructionMode,	
		dcn.ClassNumberUniqueDescription as P3_ClassNumber,	
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS P3_StudentID,	
		fr.StudentKey as P3_StudentKey,	
		CreditsEarned as P3_CreditsEarned, dg.EarnCreditIndicator as P3_EarnCreditIndicator, 	
		dg.SuccessIndicator as P3_SuccessIndicator,	
		ClassGrade as P3_ClassGrade, dg.SourceKey as P3_GradeLetter, dg.GradePoints as P3_GradePoints, 	
		dg.GradeDescription as P3_GradeDescription, dg.GradeSubgroup as P3_GradeSubgroup, 	
		dg.GradeGroup as P3_GradeGroup, dg.GradingBasisDescription as P3_GradingBasisDescription,	
		EnrollStatus as P3_EnrollStatus, RegistrationAddDate as P3_RegistrationDate, 	
		RegistrationDropDate as P3_RegistrationDropDate, drc.UniqueDescription as P3_UniqueDescription,	

		ROW_NUMBER() OVER (PARTITION BY fr.StudentKey ORDER BY fr.TermSourceKey DESC) AS P3_rn	


	FROM	Final.FactRegistration fr	

		JOIN	Final.DimTerm dt	
		ON		fr.Termkey = dt.TermKey	

		JOIN	Final.DimClassNumber dcn	
		ON		fr.ClassNumberKey = dcn.ClassNumberKey	

		JOIN	Final.FactStudentTerm fst	
		ON		fr.StudentKey = fst.StudentKey 	
		AND		fr.TermKey = fst.TermKey	
		AND		fr.VersionKey = fst.VersionKey	

		JOIN	Final.DimInstructionMode instmode	
		ON		fr.InstructionModeKey = instmode.InstructionModeKey	

		JOIN	Final.DimFaculty df	
		ON		fr.FacultyKey = df.FacultyKey	

		JOIN	Final.DimAcademicLevel dal	
		ON		fr.AcademicLevelKey = dal.AcademicLevelKey	

		JOIN	Final.DimAcademicLoadTuition daltk	
		ON		fr.AcademicLoadTuitionKey = daltk.AcademicLoadTuitionKey	

		JOIN	CustomFinal.ViewFactStudentPlanOwner vfspo	
		ON		fr.StudentKey = vfspo.StudentKey 	
		AND		fr.TermKey = vfspo.TermKey	
		AND		fr.VersionKey = vfspo.VersionKey	

		JOIN	Final.DimVersion dv	
		ON		vfspo.VersionKey = dv.VersionKey	

		JOIN 	Final.DimRepeatCode drc 	
		ON 		fr.RepeatCodeKey = drc.RepeatCodeKey	

		JOIN	Final.DimGrade dg	
		ON		fr.GradeKey = dg.GradeKey	

	WHERE		dcn.ClassNumberUniqueDescription IN ('HLTH 300')	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'	
)	

SELECT	DISTINCT *	

	FROM main	
	LEFT JOIN P1 ON main.StudentID = P1_StudentID 	
	LEFT JOIN P2 ON main.StudentID = P2_StudentID	
	LEFT JOIN P3 ON main.StudentID = P3_StudentID	

	WHERE (P1_rn IS NULL OR P1_rn = '1') /* NULLs are for students without prereq. 1 is the most recent grade for prereq. */	
	AND (P2_rn IS NULL OR P2_rn = '1')	
	AND (P3_rn IS NULL OR P3_rn = '1')	

ORDER BY main.StudentID
















 /* ******************************************************************* */

/* Below is obselete, but keeping for development purposes




/*






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



/* STEP 2: */
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
AND     fr.VersionKey = 4 /*End of term snapshot*/


ORDER BY StudentName, Term, Subject, CourseNumber, StudentID, VersionKey, AcademicPlan

*/