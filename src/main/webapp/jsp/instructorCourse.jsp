<%@ page import="teammates.common.Common"%>
<%@ page import="teammates.common.datatransfer.CourseData"%>
<%@ page import="teammates.ui.controller.InstructorCourseHelper"%>
<%
	InstructorCourseHelper helper = (InstructorCourseHelper)request.getAttribute("helper");
%>
<!DOCTYPE html>
<html>
<head>
	<link rel="shortcut icon" href="/favicon.png">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Teammates - Instructor</title>
	<link rel="stylesheet" href="/stylesheets/common.css" type="text/css">
	<link rel="stylesheet" href="/stylesheets/instructorCourse.css" type="text/css">
	
	<script type="text/javascript" src="/js/jquery-minified.js"></script>
	<script type="text/javascript" src="/js/tooltip.js"></script>
	<script type="text/javascript" src="/js/date.js"></script>
	<script type="text/javascript" src="/js/CalendarPopup.js"></script>
	<script type="text/javascript" src="/js/AnchorPosition.js"></script>
	<script type="text/javascript" src="/js/common.js"></script>
	
	<script type="text/javascript" src="/js/instructor.js"></script>
	<script type="text/javascript" src="/js/instructorCourse.js"></script>
    <jsp:include page="../enableJS.jsp"></jsp:include>
</head>

<body>
	<div id="dhtmltooltip"></div>
	<div id="frameTop">
		<jsp:include page="<%= Common.JSP_INSTRUCTOR_HEADER %>" />
	</div>

	<div id="frameBody">
		<div id="frameBodyWrapper">
			<div id="topOfPage"></div>
			<div id="headerOperation">
				<h1>Add New Course</h1>
			</div>

			<form method="get" action="<%= Common.PAGE_INSTRUCTOR_COURSE %>" name="form_addcourse">
				<input type="hidden" id="<%= Common.PARAM_INSTRUCTOR_ID %>" name="<%= Common.PARAM_INSTRUCTOR_ID %>" value="<%= helper.account.googleId%>">
				<table id="addform" class="inputTable">
					<tr>
						<td class="label bold" width="20%">Course ID:</td>
						<td><input class="addinput" type="text"
							name="<%= Common.PARAM_COURSE_ID %>" id="<%= Common.PARAM_COURSE_ID %>"
							value="<%= (helper.courseID==null ? "" : helper.courseID) %>"
							onmouseover="ddrivetip('Enter the identifier of the course, e.g.CS3215-Sem1.')"
							onmouseout="hideddrivetip()"
							maxlength=<%= Common.COURSE_ID_MAX_LENGTH %> tabindex="1"></td>
					</tr>
					<tr>
						<td class="label bold">Course Name:</td>
						<td><input class="addinput" type="text"
							name="<%= Common.PARAM_COURSE_NAME %>" id="<%= Common.PARAM_COURSE_NAME %>"
							value="<%=(helper.courseName==null ? "" : InstructorCourseHelper.escapeForHTML(helper.courseName))%>"
							onmouseover="ddrivetip('Enter the name of the course, e.g. Software Engineering.')"
							onmouseout="hideddrivetip()"
							maxlength=<%=CourseData.COURSE_NAME_MAX_LENGTH%> tabindex=2 /></td>
					</tr>
					<tr>
						<td colspan=2 class="label bold">Instructors:</td>
					</tr>
					<tr>
						<td colspan=2>
							<span id="instructorformat" class="bold">Format: Google ID | Instructor Name | Instructor Email</span>
							<textarea rows="6" cols="110" class ="textvalue" name="<%= Common.PARAM_COURSE_INSTRUCTOR_LIST %>" id="<%= Common.PARAM_COURSE_INSTRUCTOR_LIST %>"><%=helper.account.googleId + "|" + helper.account.name + "|" + helper.account.email %></textarea>
						</td>
					</tr>
					<tr>
						<td colspan=2 class="centeralign"><input id="btnAddCourse" type="submit" class="button"
							onclick="return verifyCourseData();" value="Add Course" tabindex="3"></td>
					</tr>
				</table>
				<%
					if(helper.isMasqueradeMode()){
				%>
					<input type="hidden" name="<%=Common.PARAM_USER_ID%>" value="<%=helper.requestedUser%>">
				<%
					}
				%>
			</form>
			<br>
			<jsp:include page="<%=Common.JSP_STATUS_MESSAGE%>" />
			<br>
			<table class="dataTable">
				<tr>
					<th class="color_white bold"><input class="buttonSortAscending" type="button"
						id="button_sortcourseid"
						onclick="toggleSort(this,1);">
						Course ID</th>
					<th class="color_white bold"><input class="buttonSortNone" type="button"
						id="button_sortcoursename"
						onclick="toggleSort(this,2);">
						Course Name</th>
					<th class="centeralign color_white bold">Teams</th>
					<th class="centeralign color_white bold">Total Students</th>
					<th class="centeralign color_white bold">Total Unregistered</th>
					<th class="centeralign color_white bold">Action(s)</th>
				</tr>
				<%
					int idx = -1;
								for(CourseData course: helper.courses){ idx++;
				%>
					<tr class="courses_row">
						<td id="courseid<%=idx%>"><%=course.id%></td>
						<td id="coursename<%=idx%>"><%=InstructorCourseHelper.escapeForHTML(course.name)%></td>
						<td class="t_course_teams centeralign"><%= course.teamsTotal %></td>
						<td class="centeralign"><%= course.studentsTotal %></td>
						<td class="centeralign"><%= course.unregisteredTotal %></td>
						<td class="centeralign">
							<a class="color_black t_course_enroll<%= idx %>"
								href="<%= helper.getInstructorCourseEnrollLink(course.id) %>"
								onmouseover="ddrivetip('<%= Common.HOVER_MESSAGE_COURSE_ENROLL %>')"
								onmouseout="hideddrivetip()">Enroll</a>
							<a class="color_black t_course_view<%= idx %>"
								href="<%=helper.getInstructorCourseDetailsLink(course.id)%>"
								onmouseover="ddrivetip('<%= Common.HOVER_MESSAGE_COURSE_DETAILS %>')"
								onmouseout="hideddrivetip()">View</a>
							<a class="color_black t_course_edit<%= idx %>"
								href="<%=helper.getInstructorCourseEditLink(course.id)%>"
								onmouseover="ddrivetip('<%= Common.HOVER_MESSAGE_COURSE_EDIT %>')"
								onmouseout="hideddrivetip()">Edit</a>
							<a class="color_black t_course_delete<%= idx %>"
								href="<%=helper.getInstructorCourseDeleteLink(course.id,false)%>"
								onclick="hideddrivetip(); return toggleDeleteCourseConfirmation('<%= course.id %>');"
								onmouseover="ddrivetip('<%= Common.HOVER_MESSAGE_COURSE_DELETE %>')"
								onmouseout="hideddrivetip()">Delete</a>
						</td>
					</tr>
				<%	}
					if(idx==-1){ // Print empty row
				%>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				<%	} %>
			</table>
			<br>
			<br>
			<br>
			<% if(idx==-1){ %>
				No records found. <br>
				<br>
				<br>
				<br>
			<% } %>
		</div>
	</div>

	<div id="frameBottom">
		<jsp:include page="<%= Common.JSP_FOOTER %>" />
	</div>
</body>
</html>