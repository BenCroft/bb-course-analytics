SELECT	dt.Description AS Term,
		dc.CourseNumber,
		dc.Section,
		dc.UniqueDescription AS CourseDescription,
		dc.InstructionMethod,
		di.UniqueDescription As Instructor,

		ds.UniqueDescription AS StudentName,
		ds.SourceKey AS StudentID,

		dcit.Description AS ItemTypeDescription,
		dcit.CourseItemGroup AS ItemGroup,

		(SELECT Description FROM Final.DimCourseItem dci WHERE fgc.CourseItemKey = dci.CourseItemKey) AS CourseItem,
		fgc.CourseItemKey,

		ContentItemDescription, GradeCenterColumnCategory,

		GradedAttempts, HasMultipleGradedAttempts, HighestGrade, LowestGrade, GradeChange, DaysFromFirstToLastAttempt, DaysFromFirstToLastGraded, DaysToGradeFirstAttempt, FirstAttemptDate,
		FirstGradedDate, LastAttemptDate, LastGradedDate, GradeCenterColumnCategory,
		GradePercentKey, GradeLetterKey, Grade, AdjustedGrade, fgc.PossibleScore, fgc.Score,

		fscs.LearnGradeLetterKey, fscs.LearnGradePercentKey, fscs.NormalizedScore, fscs.Score, fscs.PossibleScore, fscs.AssessmentAccesses, fscs.CourseAccesses, fscs.CourseAccessMinutes,
		fscs.CourseItemAccesses, fscs.ForumPostCharacters, fscs.ForumPosts, fscs.Interactions

		/* Don't include these because it makes an entry for every single access*/
		/*fcia.CourseItemMinutes, fcia.CourseItemAccesses, fcia.CourseItemInteractions*/

FROM Final.FactGradeCenter fgc

JOIN	Final.DimTerm dt ON fgc.TermKey = dt.TermKey
JOIN	Final.DimCourse dc ON fgc.CourseKey = dc.CourseKey
JOIN	Final.DimStudent ds ON fgc.StudentKey = ds.StudentKey
JOIN	Final.FactStudentCourseSummary fscs ON fgc.StudentKey = fscs.StudentKey AND fgc.CourseKey = fscs.CourseKey AND fgc.TermKey = fscs.TermKey
/*JOIN	Final.FactCourseItemActivity fcia ON fgc.CourseItemKey = fcia.CourseItemKey AND fgc.CourseKey = fcia.CourseKey AND fgc.TermKey = fcia.TermKey */
JOIN	Final.DimCourseItemType dcit ON fgc.CourseItemTypeKey = dcit.CourseItemTypeKey
JOIN	Final.DimInstructor di ON fgc.InstructorKey = di.InstructorKey

WHERE	dt.Description in ('Summer 2020')
AND   dc.BatchUID = '____________'
