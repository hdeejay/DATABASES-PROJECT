<?php
// Database connection
$servername = "mariadb";  // e.g., "localhost"
$username = "cs332g4";      // your MySQL username
$password = "iBZAZmn5";      // your MySQL password
$dbname = "cs332g4";          // your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Assuming you receive inputs through POST method from a form
$professorSSN = isset($_POST['prof_ssn']) ? $_POST['prof_ssn'] : null;
$courseNumber = isset($_POST['course_num']) ? $_POST['course_num'] : null;
$sectionNumber = isset($_POST['section_num']) ? $_POST['section_num'] : null;
$studentCWID = isset($_POST['student_cwid']) ? $_POST['student_cwid'] : null;

// 1. For the Professor: Given SSN
if (!empty($professorSSN)) {
    $query = "SELECT Course.Title, Section.meeting_days, Section.start_time, Section.end_time 
              FROM Professor 
              JOIN Section ON Professor.SSN = Section.PSSN 
              JOIN Course ON Section.CNO = Course.course_number 
              WHERE Professor.SSN = ?";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $professorSSN);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        echo "Title: " . $row["Title"]. " - Days: " . $row["meeting_days"]. " - Start Time: " . $row["start_time"]. " - End Time: " . $row["end_time"]. "<br>";
    }
    $stmt->close();
}

// 2. For the Professor: Given Course and Section Number
if (!empty($courseNumber) && !empty($sectionNumber)) {
    $query = "SELECT Enrollment_record.Grade, COUNT(*) as count
              FROM Enrollment_record
              WHERE Enrollment_record.CNO = ? AND Enrollment_record.SNO = ?
              GROUP BY Enrollment_record.Grade";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("si", $courseNumber, $sectionNumber);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        echo "Grade: " . $row["Grade"]. " - Count: " . $row["count"]. "<br>";
    }
    $stmt->close();
}

// 3. For the Student: Given Course Number
if (!empty($courseNumber)) {
    $query = "SELECT Section.section_number, Section.meeting_days, Section.start_time, Section.end_time, COUNT(Enrollment_record.CWID) AS enrolled_students
              FROM Section
              JOIN Course ON Section.CNO = Course.course_number
              LEFT JOIN Enrollment_record ON Section.section_number = Enrollment_record.SNO
              WHERE Course.course_number = ?
              GROUP BY Section.section_number";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $courseNumber);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        echo "Section Number: " . $row["section_number"]. " - Days: " . $row["meeting_days"]. " - Start Time: " . $row["start_time"]. " - End Time: " . $row["end_time"]. " - Enrolled Students: " . $row["enrolled_students"]. "<br>";
    }
    $stmt->close();
}

// 4. For the Student: Given CWID
if (!empty($studentCWID)) {
    $query = "SELECT Course.Title, Enrollment_record.Grade
              FROM Student
              JOIN Enrollment_record ON Student.CWID = Enrollment_record.CWID
              JOIN Section ON Enrollment_record.SNO = Section.section_number
              JOIN Course ON Section.CNO = Course.course_number
              WHERE Student.CWID = ?";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $studentCWID);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        echo "Course: " . $row["Title"]. " - Grade: " . $row["Grade"]. "<br>";
    }
    $stmt->close();
}

$conn->close();
?>



