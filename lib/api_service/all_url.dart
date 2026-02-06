class AllUrl {
  static final String baseUrl='http://35.73.30.144:2005/api/v1';
  static final String registrationUrl="$baseUrl/Registration";
  static final String loginUrl="$baseUrl/Login";
  static final String createNewTaskUrl='$baseUrl/createTask';

  static final String newTaskListUrl='$baseUrl//listTaskByStatus/New';
  static final String completedTaskListUrl='$baseUrl/listTaskByStatus/Completed';
  static final String cancelTaskListUrl='$baseUrl/listTaskByStatus/Canceled';
  static final String progressTaskListUrl='$baseUrl/listTaskByStatus/Progressed';

  static final String taskCountListUrl='$baseUrl/taskStatusCount';
  static String taskUpdateStatus(String id,String status)=>"$baseUrl/updateTaskStatus/$id/$status";
  static final String updateUrl='$baseUrl/ProfileUpdate';

  static String emailVerifyUrl(String email)=>'$baseUrl/RecoverVerifyEmail/$email';
  static String pinOtpUrl(String email,String otp)=>'$baseUrl/RecoverVerifyOtp/$email/$otp';
  static final String setPasswordUrl='$baseUrl/RecoverResetPassword';
  static String deleteTaskUrl(String id)=>"$baseUrl/deleteTask/$id";
}