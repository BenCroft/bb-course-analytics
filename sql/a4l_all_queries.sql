/* Query 1: Get CourseIDs */
SELECT CourseKey, Description, SubjectCode, CourseNumber, Section, 
InstructionMethod, SectionStatus, CourseType, BatchUID 
FROM Final.DimCourse
WHERE BatchUID LIKE '%1199%' and BatchUID LIKE '%BIOL%' AND BatchUID LIKE '%227%'
AND InstructionMethod = 'Online' 
AND CourseType = 'Lecture'



/* Set global environment variables */
DECLARE
	@myTermDescription VARCHAR(4000) = 'Fall 2019',
	@myTermSourceKey VARCHAR(4000) = '1199',
	@BatchUID1 VARCHAR(4000) = '1199-70663BIOL2274002',
	@BatchUID2 VARCHAR(4000) = '1199-70615BIOL227DEI176536BIOL227DE0176535BI716982'

/*Find and replace 
'BatchUID_List' with ('1199-70663BIOL2274002', '1199-70615BIOL227DEI176536BIOL227DE0176535BI716982')
*/




/* ***************************************** */
/* Query 2: Dynamics*/
SELECT	dt.Description AS Term, dc.CourseNumber, dc.Section, dc.UniqueDescription AS CourseDescription, di.UniqueDescription AS Instructor, ddot.DayOfTermKey,
		ddot.WeekLevel, dd.DayNameOfWeek, dd.DateName, dd.FullDate, fca.TimeBandKey, dtb.Description24Hour AS TimeDescription24, dtb.RollupDescription AS TimeDescriptionRollup,
		du.UniqueDescription AS StudentName, 
		/* Grades */ 
		dgl.Description AS GradeLetter, LearnGradePercentKey, 
		/* LMS Activity */ 
		AssessmentAccesses, ContentAccesses, CourseAccesses, CourseAccessMinutes, CourseInteractions, CourseItemAccesses, ToolAccesses
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

WHERE dt.Description in (@myTermDescription)
AND dcr.Description = 'Student'
AND   dc.BatchUID IN 'BatchUID_List'

ORDER BY Term, CourseNumber, Section, WeekLevel, DayNameOfWeek


/* Query 3: Forums */
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

WHERE	dt.Description IN (@myTermDescription)
AND		du.InstitutionRoleDescription = 'Student'
AND   dc.BatchUID IN 'BatchUID_List'


/* Query 4: Grades */
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

WHERE	dt.Description in (@myTermDescription)
AND   dc.BatchUID IN 'BatchUID_List'



/* Query 5: Items */
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

WHERE	dt.Description in (@myTermDescription)
AND		du.InstitutionRoleDescription = 'Student'
AND   dc.BatchUID IN 'BatchUID_List'

ORDER BY Term, CourseNumber, Section



/* Query 6: Statics */
SELECT  dt.Description AS Term,
        dc.CourseNumber,
        dc.Section,
        dc.UniqueDescription AS CourseDescription,
		    di.UniqueDescription AS Instructor,
		    ds.UniqueDescription AS StudentName,
        ds.SourceKey,
        SISGradeLetter,
        Score,
        NormalizedScore,
        PossibleScore,

        /* LMS Activity */
        AssessmentAccesses,
        ContentAccesses,
        CourseAccesses,
        CourseAccessMinutes,
        ForumPosts,
        ForumPostCharacters,
        Interactions,
        Submissions,
        ToolAccesses

FROM Final.FactStudentCourseSummary fscs

JOIN Final.DimTerm dt
  ON fscs.TermKey = dt.TermKey
JOIN Final.DimCourse dc
  ON fscs.CourseKey = dc.CourseKey
JOIN Final.DimStudent ds
  ON fscs.StudentKey = ds.StudentKey
JOIN Final.DimInstructor di
  ON fscs.InstructorKey = di.InstructorKey

WHERE   dt.Description in (@myTermDescription) /*E.g. 'Summer 2020' */
  AND   SISGradeLetter IS NOT NULL
  AND   dc.BatchUID IN 'BatchUID_List'

ORDER BY  Term,
          dc.CourseNumber,
          dc.Section,
          ds.UniqueDescription




/* Query 7: Submissions */
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

WHERE	dt.Description in (@myTermDescription)
AND		du.InstitutionRoleDescription = 'Student'
AND		dc.BatchUID IN 'BatchUID_List'

ORDER BY Term, CourseNumber, CourseItem
