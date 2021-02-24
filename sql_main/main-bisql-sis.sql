/* This query pulls information regarding a student term enrollment (with student attributes and outcomes) as the main table. */
/* It then joins this main table with a temporary table that shows terms/outcomes of a prereqs/coreqs ("P1") */
/* To add or remove prerequsities, duplicate the P1 table, change the prereq, and append it to the join list. */
/* Be sure to update aliases for each P table (e.g. P1_StudentID, P4_StudentID) */


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

			dv.Description AS VersionDescription,
			EnrolledClassCount, DropCount, fr.WithdrawCount, CreditsAttempted, CreditsEarned, dg.EarnCreditIndicator, dg.SuccessIndicator,	
			HasClassGrade, ClassGrade, dg.GradeKey, dg.SourceKey AS GradeLetter, dg.GradePoints, dg.GradeDescription, dg.GradeSubgroup, dg.GradeGroup, dg.GradingBasisDescription,	

			EnrollStatus, RegistrationAddDate, RegistrationDropDate, 
			dri.Description AS RepeatDescripton, dri.ShortDescription AS RepeatDescriptionShort, dri.SummaryIndicator AS RepeatSummaryIndicator

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

			JOIN 	CustomFinal.DimBSURepeatIndicator dri
			ON 		fr.BSURepeatIndicatorKey = dri.BSURepeatIndicatorKey

			JOIN	Final.DimGrade dg	
			ON		fr.GradeKey = dg.GradeKey			

	WHERE	dt.SourceKey in ('1159', '1163', '1169', '1173', '1179', '1183', '1189', '1193', '1199', '1203', '1209')	
	AND		dcn.ClassNumberUniqueDescription IN ('BIOL 227')	
	AND 	instmode.Description = 'Online'	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'		
),	

/* Repeat the P1 table set up for each prerequisite/corequisite of interest, making a P2, P3, P4.... */
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
),

P4 AS	
	(SELECT DISTINCT	
		fr.VersionKey AS P4_VersionKeyRegistration,	
		dt.SourceKey AS P4_TermSourceKey,	
		instmode.Description AS P4_InstructionMode,	
		dcn.ClassNumberUniqueDescription as P4_ClassNumber,	
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS P4_StudentID,	
		fr.StudentKey as P4_StudentKey,	
		CreditsEarned as P4_CreditsEarned, 
		dg.EarnCreditIndicator as P4_EarnCreditIndicator, 	
		dg.SuccessIndicator as P4_SuccessIndicator,	
		ClassGrade as P4_ClassGrade, 
		dg.SourceKey as P4_GradeLetter, 
		dg.GradePoints as P4_GradePoints, 	
		dg.GradeDescription as P4_GradeDescription, dg.GradeSubgroup as P4_GradeSubgroup, 	
		dg.GradeGroup as P4_GradeGroup, dg.GradingBasisDescription as P4_GradingBasisDescription,	
		EnrollStatus as P4_EnrollStatus, RegistrationAddDate as P4_RegistrationDate, 	
		RegistrationDropDate as P4_RegistrationDropDate, drc.UniqueDescription as P4_UniqueDescription,	

		ROW_NUMBER() OVER (PARTITION BY fr.StudentKey ORDER BY fr.TermSourceKey DESC) AS P4_rn	


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

	WHERE		dcn.ClassNumberUniqueDescription IN ('BIOL 100')	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'	
),		

P5 AS	
	(SELECT DISTINCT	
		fr.VersionKey AS P5_VersionKeyRegistration,	
		dt.SourceKey AS P5_TermSourceKey,	
		instmode.Description AS P5_InstructionMode,	
		dcn.ClassNumberUniqueDescription as P5_ClassNumber,	
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS P5_StudentID,	
		fr.StudentKey as P5_StudentKey,	
		CreditsEarned as P5_CreditsEarned, 
		dg.EarnCreditIndicator as P5_EarnCreditIndicator, 	
		dg.SuccessIndicator as P5_SuccessIndicator,	
		ClassGrade as P5_ClassGrade, 
		dg.SourceKey as P5_GradeLetter, 
		dg.GradePoints as P5_GradePoints, 	
		dg.GradeDescription as P5_GradeDescription, dg.GradeSubgroup as P5_GradeSubgroup, 	
		dg.GradeGroup as P5_GradeGroup, dg.GradingBasisDescription as P5_GradingBasisDescription,	
		EnrollStatus as P5_EnrollStatus, RegistrationAddDate as P5_RegistrationDate, 	
		RegistrationDropDate as P5_RegistrationDropDate, drc.UniqueDescription as P5_UniqueDescription,	

		ROW_NUMBER() OVER (PARTITION BY fr.StudentKey ORDER BY fr.TermSourceKey DESC) AS P5_rn	


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

	WHERE		dcn.ClassNumberUniqueDescription IN ('CHEM 100')	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'	
),

P6 AS	
	(SELECT DISTINCT	
		fr.VersionKey AS P6_VersionKeyRegistration,	
		dt.SourceKey AS P6_TermSourceKey,	
		instmode.Description AS P6_InstructionMode,	
		dcn.ClassNumberUniqueDescription as P6_ClassNumber,	
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS P6_StudentID,	
		fr.StudentKey as P6_StudentKey,	
		CreditsEarned as P6_CreditsEarned, 
		dg.EarnCreditIndicator as P6_EarnCreditIndicator, 	
		dg.SuccessIndicator as P6_SuccessIndicator,	
		ClassGrade as P6_ClassGrade, 
		dg.SourceKey as P6_GradeLetter, 
		dg.GradePoints as P6_GradePoints, 	
		dg.GradeDescription as P6_GradeDescription, dg.GradeSubgroup as P6_GradeSubgroup, 	
		dg.GradeGroup as P6_GradeGroup, dg.GradingBasisDescription as P6_GradingBasisDescription,	
		EnrollStatus as P6_EnrollStatus, RegistrationAddDate as P6_RegistrationDate, 	
		RegistrationDropDate as P6_RegistrationDropDate, drc.UniqueDescription as P6_UniqueDescription,	

		ROW_NUMBER() OVER (PARTITION BY fr.StudentKey ORDER BY fr.TermSourceKey DESC) AS P6_rn	


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

	WHERE		dcn.ClassNumberUniqueDescription IN ('CHEM 101')	
	AND     fr.VersionKey = 3 /*End of term snapshot*/	
	AND		dg.GradeDescription != 'No Grade'	
)

SELECT	DISTINCT *	

	FROM main	
	LEFT JOIN P1 ON main.StudentID = P1.P1_StudentID 	
	LEFT JOIN P2 ON main.StudentID = P2.P2_StudentID	
	LEFT JOIN P3 ON main.StudentID = P3.P3_StudentID
	LEFT JOIN P4 ON main.StudentID = P4.P4_StudentID	
	LEFT JOIN P5 ON main.StudentID = P5.P5_StudentID
	LEFT JOIN P6 ON main.StudentID = P6.P6_StudentID

	WHERE (P1_rn IS NULL OR P1_rn = '1') /* NULLs are for students without prereq. 1 is the most recent grade for prereq. */	
	AND (P2_rn IS NULL OR P2_rn = '1')	
	AND (P3_rn IS NULL OR P3_rn = '1')	
	AND (P4_rn IS NULL OR P4_rn = '1')
	AND (P5_rn IS NULL OR P5_rn = '1')
	AND (P6_rn IS NULL OR P6_rn = '1')


ORDER BY main.StudentID






