/* STEP 1: Get CourseSourceKeys, Course descriptions, BatchUIDs, etc. */

SELECT DISTINCT dc.SourceKey AS CourseSourceKey, vcm.COURSE_NAME, vcm.COURSE_ID,
				CourseKey, TermSourceKey, 
				dc.Description, SubjectCode, CourseNumber, Section, 
				di.UniqueDescription, InstructionMethod, SectionStatus, CourseType, BatchUID
FROM	Final.DimCourse dc
JOIN	Final.DimInstructor di ON dc.InstructorSourceKey = di.SourceKey
JOIN	CustomSource.ViewCOURSE_MAIN vcm ON dc.SourceKey = vcm.PK1
WHERE	TermSourceKey = '1199'
	AND	CourseNumber = 'BIOL 227'
	AND	CourseType = 'Lecture'
	AND InstructionMethod = 'Online'
	AND	(di.UniqueDescription LIKE '%Koob%' OR di.UniqueDescription LIKE '%Sherburne%' OR di.UniqueDescription LIKE '%Hanley%')
ORDER BY CourseSourceKey
	  
/* STEP 2: Run queries */
SELECT * 
 FROM Final.ReportViewCourseActivity
 WHERE Term = 'Fall 2019' 
 AND CourseSourceKey IN ('93516', '95085')

SELECT * 
 FROM Final.ReportViewCourseItemActivity
 WHERE Term = 'Fall 2019' 
 AND CourseSourceKey IN ('93516', '95085')

SELECT * 
 FROM Final.ReportViewCourseSummary
 WHERE Term = 'Fall 2019' 
 AND CourseSourceKey IN ('93516', '95085')

SELECT * 
 FROM Final.ReportViewForumSubmissions
 WHERE Term = 'Fall 2019' 
 AND CourseSourceKey IN ('93516', '95085')
 
SELECT * 
 FROM Final.ReportViewGradeCenter
 WHERE Term = 'Fall 2019' 
 AND Course IN ('F19 - BIOL 227 - ONLINE Human Anatomy & Physiology I',
'Fa19 - BIOL 227 - Human Anatomy & Physiology I ONLINE')

SELECT * 
 FROM Final.ReportViewStudentCourseSummary
 WHERE Term = 'Fall 2019' 
 AND CourseSourceKey IN ('93516', '95085')