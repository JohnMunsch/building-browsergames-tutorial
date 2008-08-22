<?php

include 'smarty.php';

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
		$query = sprintf("SELECT COUNT(id) FROM users WHERE UPPER(username) = UPPER('%s')",
			mysql_real_escape_string($_POST['username']));
		$result = mysql_query($query);
		list($count) = mysql_fetch_row($result);
		if($count >= 1) { 
			$error = 'that username is taken.';
		} else {
			$query = sprintf("INSERT INTO users(username,password) VALUES ('%s','%s')",
				mysql_real_escape_string($_POST['username']),
				mysql_real_escape_string(md5('saltgoeshere' . $password)));
			$result = mysql_query($query);			
			$userID = mysql_insert_id($conn);
			require_once 'stats.php';
			setStat('atk',$userID,'5');
			setStat('def',$userID,'5');			
			setStat('mag',$userID,'5');
			$message = 'Congratulations, you registered successfully!';
		}
	}	
}
$smarty->assign('error',$error);
$smarty->assign('message',$message);
$smarty->display('/home/buildingbrowsergames/public_html/game/php/smarty/templates/register.tpl');

?>