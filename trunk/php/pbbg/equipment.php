<?php
 
require_once 'smarty.php';
 
session_start();
 
require_once 'config.php';		// our database settings
$conn = mysql_connect($dbhost,$dbuser,$dbpass)
	or die('Error connecting to mysql');
mysql_select_db($dbname);
// retrieve player's ID
$query = sprintf("SELECT id FROM users WHERE UPPER(username) = UPPER('%s')",
			mysql_real_escape_string($_SESSION['username']));
$result = mysql_query($query);
list($userID) = mysql_fetch_row($result);

require_once 'stats.php';	// player stats
$phand = getStat('phand',$userID);
$shand = getStat('shand',$userID);
if($_POST) {
	setStat('phand',$userID,$shand);
	setStat('shand',$userID,$phand);
	$temp = $shand;
	$shand = $phand;	
	$phand = $temp;
}
$phand_query = sprintf("SELECT name FROM items WHERE id = %s",
				mysql_real_escape_string($phand));
$result = mysql_query($phand_query);
if($result) {
	list($phand_name) = mysql_fetch_row($result);
	$smarty->assign('phand',$phand_name);
}
$shand_query = sprintf("SELECT name FROM items WHERE id = %s",
				mysql_real_escape_string($shand));
$result = mysql_query($shand_query);
if($result) {
	list($shand_name) = mysql_fetch_row($result);
	$smarty->assign('shand',$shand_name);
}
$smarty->display('equipment.tpl');
 
?>