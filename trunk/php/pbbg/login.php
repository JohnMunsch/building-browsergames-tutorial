<?php

// put full path to Smarty.class.php
require('/usr/share/php/smarty/Smarty.class.php');
$smarty = new Smarty();

$smarty->template_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/templates';
$smarty->compile_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/templates_compile';
$smarty->cache_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/cache';
$smarty->config_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/configs';

session_start();
if($_POST) {
	require_once 'config.php';
	$username = $_POST['username'];
	$password = $_POST['password'];		
	$conn = mysql_connect($dbhost,$dbuser,$dbpass)
		or die ('Error connecting to mysql');
	mysql_select_db($dbname);
	$query = sprintf("SELECT COUNT(id) FROM users WHERE UPPER(username) = UPPER('%s') AND password='%s'",
		mysql_real_escape_string($username),
		mysql_real_escape_string(md5($password)));
	$result = mysql_query($query);
	list($count) = mysql_fetch_row($result);
	if($count == 1) {
		$_SESSION['authenticated'] = true;
		$_SESSION['username'] = $username;
		header('Location:changepass.php');
	} else {
		$query = sprintf("SELECT COUNT(id) FROM users WHERE UPPER(username) = UPPER('%s') AND password='%s'",
			mysql_real_escape_string($username),
			mysql_real_escape_string(md5('saltgoeshere' . $password)));
		$result = mysql_query($query);
		list($count) = mysql_fetch_row($result);
		if($count == 1) {
			$_SESSION['authenticated'] = true;
			$_SESSION['username'] = $username;
			$query = sprintf("UPDATE users SET last_login = NOW() WHERE UPPER(username) = UPPER('%s') AND password = '%s'",
				mysql_real_escape_string($username),
				mysql_real_escape_string(md5('saltgoeshere' . $password)));
			mysql_query($query);
			$query = sprintf("SELECT is_admin FROM users WHERE UPPER(username) = UPPER('%s') AND password='%s'",
				mysql_real_escape_string($username),
				mysql_real_escape_string(md5('saltgoeshere' . $password)));
			$result = mysql_query($query);
			list($is_admin) = mysql_fetch_row($result);
			if($is_admin == 1) {
				header('Location:admin.php');			
			} else {
				header('Location:index.php');				
			}
		} else {	
			$error = 'There is no username/password combination like that in the database.';
		}
	}
}

$smarty->assign('error',$error);
$smarty->display('login.tpl');
?>