SELECT DISTINCT
		dt.Description AS Term,
		instmode.Description AS InstructionMode,
		dcn.SubjectSourceKey AS Subject,
		dcn.CatalogNumberSourceKey AS CourseNumber,
		dcn.ClassSectionSourceKey AS Section,
		dcn.ClassNumberSectionPaddedDescription AS TotalCourseDescription,
		(SELECT ds.UniqueDescription FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS StudentName,
		(SELECT ds.SourceKey FROM Final.DimStudent ds WHERE fr.StudentKey = ds.StudentKey) AS StudentID,
		vfspo.EmployeeID, vfspo.VersionKey, vfspo.PlanCount, vfspo.TermSourceKey, vfspo.AcademicPlan, vfspo.AcademicSubPlan,
		
		df.UniqueDescription As Instructor,

		fr.StudentAge,
		fr.BSUIPEDSEthnicity,
		(SELECT UniqueDescription FROM Final.DimGender g WHERE fr.GenderKey = g.GenderKey) AS Gender,
		fst.FirstTermAtInstitutionCount AS FirstTermAtInstution,
		fst.CumulativeGPA,
		(SELECT UniqueDescription FROM CustomFinal.DimFirstGeneration dfg WHERE fst.FirstGenerationKey = dfg.FirstGenerationKey) AS FirstGen,
		(SELECT UniqueDescription FROM CustomFinal.DimVeteranAffiliated vet WHERE fst.VeteranAffiliatedKey = vet.VeteranAffiliatedKey) AS VeteranAff,
		(SELECT UniqueDescription FROM Final.DimAcademicLevel al WHERE fst.AcademicLevelKey = al.AcademicLevelKey) AS AcademicLevel,
		fst.HasTransferCumGPA,

		dal.Description, daltk.FullTimePartTimeDescription, 
		
		EnrollStatus, RegistrationAddDate, RegistrationDropDate, dv.Description AS VersionDescription

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

WHERE	dt.Description in ('Summer 2020')
AND		dcn.ClassNumberKey IN ('106064', '106065') /*e.g. '106064', get from ClassNumber table*/
AND     dv.VersionKey = 1 /*Current snapshot*/


ORDER BY StudentName, Term, Subject, CourseNumber, StudentID, VersionKey, AcademicPlan