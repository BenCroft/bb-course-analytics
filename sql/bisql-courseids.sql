SELECT DISTINCT dt.SourceKey, dt.Description, dc.PrimarySubject, dc.PrimaryCatalogNumber, ClassSection, dcn.ClassNumberKey, ds.Description, CombinedSection, df.UniqueDescription, 
ClassEnrolledCount, dim.Description, ds.WeeksOfInstruction

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

WHERE dc.PrimarySubject = 'BIOL'
AND dt.Description in ('Fall 2020')
/*AND		dcn.ClassNumberKey IN ('106064', '106065')*/

ORDER BY SourceKey, dc.PrimarySubject, dc.PrimaryCatalogNumber, ClassSection
