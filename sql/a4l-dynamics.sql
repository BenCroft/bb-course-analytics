SELECT	dt.Description AS Term,
dc.CourseNumber,
dc.Section,
dc.UniqueDescription AS CourseDescription,
di.UniqueDescription AS Instructor,
ddot.DayOfTermKey,
ddot.WeekLevel,

dd.DayNameOfWeek,
dd.DateName,
dd.FullDate,

fca.TimeBandKey,
dtb.Description24Hour AS TimeDescription24,
dtb.RollupDescription AS TimeDescriptionRollup,
du.UniqueDescription AS StudentName,
/* Grades */
dgl.Description AS GradeLetter,
LearnGradePercentKey,
/* LMS Activity */
AssessmentAccesses, ContentAccesses, CourseAccesses, CourseAccessMinutes, CourseInteractions, CourseItemAccesses, ToolAccesses,

FROM	Final.FactCourseActivity fca

JOIN Final.DimCourse dc
ON fca.CourseKey = dc.CourseKey
JOIN Final.DimTerm dt
ON fca.TermKey = dt.TermKey
JOIN Final.DimCourseRole dcr
ON fca.CourseRoleKey = dcr.CourseRoleKey
JOIN Final.DimDayOfTerm ddot
ON fca.DayOfTermKey = ddot.DayOfTermKey
JOIN Final.DimDate dd
ON fca.DateKey = dd.DateKey
JOIN Final.DimUser du
ON fca.UserKey = du.UserKey
JOIN Final.DimGradeLetter dgl
ON fca.LearnGradeLetterKey = dgl.GradeLetterKey
JOIN Final.DimTimeBand dtb
ON fca.TimeBandKey = dtb.TimeBandKey
JOIN Final.DimInstructor di
ON fca.InstructorKey = di.InstructorKey

WHERE dt.Description in ('Summer 2020')

AND dcr.Description = 'Student'
AND   dc.BatchUID = '____________'

ORDER BY Term, CourseNumber, Section, WeekLevel, DayNameOfWeek
