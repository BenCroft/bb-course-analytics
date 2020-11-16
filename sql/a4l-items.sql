SELECT	dt.Description AS Term,
		dc.CourseNumber,
		dc.Section,
		dc.UniqueDescription AS CourseDescription,
		di.UniqueDescription AS Instructor,
		dc.InstructionMethod,

		ddot.DayOfTermKey,
		ddot.WeekLevel,
		dd.DayNameOfWeek,
		/*dd.DateName, */

		(SELECT GradableIndicator FROM Final.DimCourseItemIndicators dcii WHERE fcia.CourseItemIndicatorsKey = dcii.CourseItemIndicatorsKey) AS Gradable,
		(SELECT Description FROM Final.DimCourseItem dci WHERE fcia.CourseItemKey = dci.CourseItemKey) AS CourseItem,
		dcit.Description AS ItemTypeDescription,
		dcit.CourseItemGroup AS ItemGroup,

		fcia.CourseItemKey,

		fcia.UserKey,
		ds.StudentKey,
		ds.UniqueDescription AS StudentName,

		fcia.LearnGradeLetterKey,
		fcia.LearnGradePercentKey,

		CourseItemAccesses,
		CourseItemMinutes,
		CourseItemInteractions,
		MobileCourseItemAccesses,

		fcia.TimeBandKey,
		dtb.Description AS TimeDescription,
		dtb.Description24Hour AS TimeDescription24,
		dtb.RollupDescription

FROM	Final.FactCourseItemActivity fcia

JOIN	Final.DimTerm dt ON fcia.TermKey = dt.TermKey
JOIN	Final.DimCourse dc ON fcia.CourseKey = dc.CourseKey
JOIN	Final.DimUser du ON fcia.UserKey = du.UserKey
JOIN	Final.DimTimeBand dtb ON fcia.TimeBandKey = dtb.TimeBandKey
JOIN	Final.DimDayOfTerm ddot ON fcia.DayOfTermKey = ddot.DayOfTermKey
JOIN	Final.DimDate dd ON fcia.DateKey = dd.DateKey
JOIN	Final.DimCourseItemType dcit ON fcia.CourseItemTypeKey = dcit.CourseItemTypeKey
JOIN	Final.DimStudent ds ON ds.UniqueDescription = du.UniqueDescription
JOIN	Final.DimInstructor di ON di.InstructorKey = fcia.InstructorKey



WHERE	dt.Description in ('Summer 2020')
AND		du.InstitutionRoleDescription = 'Student'
AND   dc.BatchUID = '____________'

ORDER BY Term, CourseNumber, Section
