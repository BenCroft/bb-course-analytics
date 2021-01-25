/* STEP 1: Get CourseSourceKeys, Course descriptions, BatchUIDs, etc. */

SELECT DISTINCT dc.SourceKey AS CourseSourceKey, vcm.COURSE_NAME, vcm.COURSE_ID,
				CourseKey, TermSourceKey, 
				dc.Description, SubjectCode, CourseNumber, Section, 
				di.UniqueDescription, InstructionMethod, SectionStatus, CourseType, BatchUID
FROM	Final.DimCourse dc
JOIN	Final.DimInstructor di ON dc.InstructorSourceKey = di.SourceKey
JOIN	CustomSource.ViewCOURSE_MAIN vcm ON dc.SourceKey = vcm.PK1
WHERE	TermSourceKey = '___' /* Ex: '1199' */
	AND	CourseNumber = '___' /* Ex: 'BIOL 227' */
	AND	CourseType = '___' /* Ex: 'Lecture' */
	AND InstructionMethod = '___' /* Ex: 'Online' */
	AND	(di.UniqueDescription LIKE '%___%' OR di.UniqueDescription LIKE '%___%' OR di.UniqueDescription LIKE '%___%') /* Ex: 'Hanley' */
ORDER BY CourseSourceKey

/* STEP 2: Find and replace blank values with results found above. For example:
STEP 2.1
WHERE Term = 'Fall 2019'

STEP 2.2
CourseSourceKey IN ('93516', '95085')

STEP 2.3
AND Course IN ('F19 - BIOL 227 - ONLINE Human Anatomy & Physiology I', 'Fa19 - BIOL 227 - Human Anatomy & Physiology I ONLINE')
*/
	  
/* STEP 2: Run queries */
SELECT * 
 FROM Final.ReportViewCourseActivity
 WHERE Term = '___' 
 AND CourseSourceKey IN ('_____', '_____')

SELECT * 
 FROM Final.ReportViewCourseItemActivity
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')

SELECT * 
 FROM Final.ReportViewCourseSummary
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')

SELECT * 
 FROM Final.ReportViewForumSubmissions
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')
 
SELECT * 
 FROM Final.ReportViewGradeCenter
 WHERE Term = '___'
 AND Course IN ('____', '___')

SELECT * 
 FROM Final.ReportViewStudentCourseSummary
 WHERE Term = '___' 
 AND CourseSourceKey IN ('_____', '_____')