SELECT	dt.TermKey, dt.SourceKey AS TermSourceKey, dt.Description, EmployeeID, AcademicPlan,
		dp.PlanTypeDescription, dp.CIPCode, dp.CIP4DigitCode, dp.CIP4DigitUniqueDescription, dp.FullyOnlineProgram,
		dp.PlanSourceKey, dp.PlanDescription
		
		

FROM Final.FactStudentPlan main

JOIN Final.DimPlan dp
ON dp.PlanKey = main.PlanKey

JOIN Final.DimTerm dt
ON dt.TermKey = main.TermKey

WHERE VersionKey = 3 AND
		TermSourceKey = 1206

ORDER BY TermKey, EmployeeID, AcademicPlan 