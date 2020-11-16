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
        ToolAccesses,

FROM Final.FactStudentCourseSummary fscs

JOIN Final.DimTerm dt
  ON fscs.TermKey = dt.TermKey
JOIN Final.DimCourse dc
  ON fscs.CourseKey = dc.CourseKey
JOIN Final.DimStudent ds
  ON fscs.StudentKey = ds.StudentKey
JOIN Final.DimInstructor di
  ON fscs.InstructorKey = di.InstructorKey

WHERE   dt.Description in ('______') /*E.g. 'Summer 2020' */
  AND   SISGradeLetter IS NOT NULL
  AND   dc.BatchUID = '____________'

ORDER BY  Term,
          dc.CourseNumber,
          dc.Section,
          ds.UniqueDescription
