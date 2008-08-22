<?php
 
require_once 'smarty.php';
 
session_start();
 
require_once 'config.php';		// our database settings
require_once 'stats.php';
$conn = mysql_connect($dbhost,$dbuser,$dbpass)
	or die('Error connecting to mysql');
mysql_select_db($dbname);
// retrieve user ID
$query = sprintf("SELECT id FROM users WHERE UPPER(username) = UPPER('%s')",
			mysql_real_escape_string($_SESSION['username']));
$result = mysql_query($query);
list($userID) = mysql_fetch_row($result);

if($_POST) {
	$amount = $_POST['amount'];
	$gold = getStat('gc',$userID);
	$needed = getStat('maxhp',$userID) - getStat('curhp',$userID);
	if($amount > $needed || $amount == '') {
		$amount = $needed;	
	}
	if($amount > $gold) {
		$amount = $gold;	
	}
	setStat('gc',$userID,getStat('gc',$userID) - $amount);
	setStat('curhp',$userID,getStat('curhp',$userID) + $amount);
	$smarty->assign('healed',$amount);
}

$smarty->assign('curhp',getStat('curhp',$userID));
$smarty->assign('maxhp',getStat('maxhp',$userID));
$smarty->assign('gold',getStat('gc',$userID));

$smarty->display('healer.tpl');

?>