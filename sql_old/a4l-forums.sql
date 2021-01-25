SELECT	dt.Description AS Term,
		dc.CourseNumber,
		dc.Section,
		dc.UniqueDescription AS CourseDescription,
		di.UniqueDescription AS Instructor,
		dc.InstructionMethod,

		forum.SubmissionDate AS DateTime,
		ddot.Description AS DayOfTerm,
		ddot.WeekLevel AS WeekOfTerm,

		forum.CourseItemKey,
		(SELECT Description FROM Final.DimCourseItem dci WHERE forum.CourseItemKey = dci.CourseItemKey) AS CourseItem,

		du.UniqueDescription AS StudentName,
		forum.OriginalPostAuthor,

		forum.SubmissionTypeSource,
		forum.IsOriginalPost,
		forum.Characters AS Characters,
		forum.DateModified

FROM	Final.FactForumSubmissions_CustomizedView forum

JOIN	Final.DimTerm dt
ON		forum.TermKey = dt.TermKey
JOIN	Final.DimCourse dc
ON		forum.CourseKey = dc.CourseKey
JOIN	Final.DimUser du
ON		forum.UserKey = du.UserKey
JOIN	Final.DimDayOfTerm ddot
ON		forum.DayOfTermKey = ddot.DayOfTermKey
JOIN	Final.FactCourseItems fci
ON		fci.CourseItemKey = forum.CourseItemKey
JOIN	Final.DimInstructor di
ON		di.InstructorKey = forum.InstructorKey

WHERE	dt.Description IN ('Summer 2020')
AND		du.InstitutionRoleDescription = 'Student'
AND   dc.BatchUID = '____________'
