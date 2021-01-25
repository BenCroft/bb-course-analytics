SELECT	dt.Description AS Term,
		dc.CourseNumber,
		dc.Section,
		dc.UniqueDescription,
		di.UniqueDescription AS Instructor,
		dc.InstructionMethod,

		(SELECT Description FROM Final.DimCourseItem dci WHERE fs.CourseItemKey = dci.CourseItemKey) AS CourseItem,
		fs.CourseItemKey,

		(SELECT Description FROM Final.DimCourseItemType dcit WHERE fs.CourseItemTypeKey = dcit.CourseItemTypeKey) AS CourseItemType,

		fs.UserKey,
		fs.UserCourse,

		ddot.DayOfTermKey,
		ddot.WeekLevel,

		fs.TimeBandKey,
		dtb.Description AS TimeDescription,
		dtb.Description24Hour AS TimeDescription24,
		dtb.RollupDescription,

		SubmissionDate,
		SubmissionSize,
		SubmissionCount

FROM Final.FactSubmission fs

JOIN	Final.DimTerm dt ON fs.TermKey = dt.TermKey
JOIN	Final.DimCourse dc ON fs.CourseKey = dc.CourseKey
JOIN	Final.DimUser du ON fs.UserKey = du.UserKey
JOIN	Final.DimTimeBand dtb ON fs.TimeBandKey = dtb.TimeBandKey
JOIN	Final.DimDayOfTerm ddot ON fs.DayOfTermKey = ddot.DayOfTermKey
JOIN	Final.DimCourseRole dcr ON fs.CourseRoleKey = dcr.CourseRoleKey
JOIN	Final.DimInstructor di ON fs.InstructorKey = di.InstructorKey

WHERE	dt.Description in ('Summer 2020')
AND		du.InstitutionRoleDescription = 'Student'
AND   dc.BatchUID = '____________'

ORDER BY Term, CourseNumber, CourseItem
