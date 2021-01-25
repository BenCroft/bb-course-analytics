/* STEP 1: Get CourseSourceKeys, Course descriptions, BatchUIDs, etc. */

SELECT DISTINCT dc.SourceKey AS CourseSourceKey, vcm.COURSE_NAME, vcm.COURSE_ID,
				CourseKey, TermSourceKey, 
				dc.Description, SubjectCode, CourseNumber, Section, 
				di.UniqueDescription, InstructionMethod, SectionStatus, CourseType, BatchUID
FROM	Final.DimCourse dc
JOIN	Final.DimInstructor di ON dc.InstructorSourceKey = di.SourceKey
JOIN	CustomSource.ViewCOURSE_MAIN vcm ON dc.SourceKey = vcm.PK1
WHERE	TermSourceKey = '1209' /* Ex: '1199' */
	AND	CourseNumber = 'BIOL 227' /* Ex: 'BIOL 227' */
	AND	CourseType = 'Lecture' /* Ex: 'Lecture' */
	AND InstructionMethod IN ('Online', 'Remote') /* Ex: 'Online' */
	AND	(di.UniqueDescription LIKE '%Koob%' OR di.UniqueDescription LIKE '%Hanley%' OR di.UniqueDescription LIKE '%Sherburne%') /* Ex: 'Hanley' */
ORDER BY CourseSourceKey

/* Save this as a4l_main.csv */
/* Jot down CourseSourceKeys for the next step here */
/* AND CourseSourceKey IN ('___', '____', '____')




/* *********************************************************************** 
/* STEP 2: Find and replace blank values with results found above. For example:
STEP 2.1
WHERE Term = 'Fall 2019'

STEP 2.2
CourseSourceKey IN ('93516', '95085')

STEP 2.3
AND Course IN ('F19 - BIOL 227 - ONLINE Human Anatomy & Physiology I', 'Fa19 - BIOL 227 - Human Anatomy & Physiology I ONLINE')
*/
	  
/* STEP 2: Run queries */

/* course_activity.csv */
SELECT * 
 FROM Final.ReportViewCourseActivity
 WHERE Term = '___' 
 AND CourseSourceKey IN ('_____', '_____')

/* course_item_activity.csv  ---> NOTE! Edit the date format in Excel to be only the date! */
SELECT * 
 FROM Final.ReportViewCourseItemActivity
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')

/* course_summary */
SELECT * 
 FROM Final.ReportViewCourseSummary
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')

/* forum_submissions.csv */
SELECT * 
 FROM Final.ReportViewForumSubmissions
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')
 
 /* grade_center.csv */
SELECT * 
 FROM Final.ReportViewGradeCenter
 WHERE Term = '___'
 AND CourseSourceKey IN ('_____', '_____')

/* student_course_summary.csv */
SELECT * 
 FROM Final.ReportViewStudentCourseSummary
 WHERE Term = '___' 
 AND CourseSourceKey IN ('_____', '_____')