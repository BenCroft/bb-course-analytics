SELECT CourseKey, Description, SubjectCode, CourseNumber, Section, 
InstructionMethod, SectionStatus, CourseType, BatchUID 

FROM Final.DimCourse

WHERE BatchUID LIKE '%1203%' and BatchUID LIKE '%BIOL%' AND BatchUID LIKE '%228%'
AND InstructionMethod = 'Online' 
AND CourseType = 'Lecture'