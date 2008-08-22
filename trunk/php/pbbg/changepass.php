<?php

include 'smarty.php';
require_once 'login-check.php';

if($_POST) {
	$password = $_POST['password'];
	$confirm = $_POST['confirm'];
	if($password != $confirm) {
		$error = 'Passwords do not match!';	
	} else {
		require_once 'config.php';		// our database settings
		$conn = mysql_connect($dbhost,$dbuser,$dbpass)
			or die('Error connecting to mysql');
		mysql_select_db($dbname);
		$query = sprintf("UPDATE users SET password = '%s' WHERE username = '%s'",
					mysql_real_escape_string(md5('saltgoeshere' . $_POST['password'])),
					mysql_real_escape_string($_SESSION['username']));
		mysql_query($query);
		$message = 'Password updated successfully.';
	}	
}
$smarty->assign('error',$error);
$smarty->assign('message',$message);
$smarty->display('change_pass.tpl');

?>