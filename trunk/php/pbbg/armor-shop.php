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

if($_POST) {
	require_once 'armor-stats.php';		// armor stats
	if($_POST['sell']) {
		$armorID = getStat($_POST['sell'],$userID);
		$query = sprintf("SELECT price FROM items WHERE id = %s",mysql_real_escape_string($armorID));
		$result = mysql_query($query);
		list($price) = mysql_fetch_row($result);
		$gold = getStat('gc',$userID);
		setStat('gc',$userID,($gold + $price));
		setStat($armorSlot,$userID,'');		
	} else {	
		$armorID = $_POST['armor-id'];
		$query = sprintf("SELECT price FROM items WHERE id = %s",mysql_real_escape_string($armorID));
		$result = mysql_query($query);
		list($cost) = mysql_fetch_row($result);
		$gold = getStat('gc',$userID);
		if ($gold > $cost) {
			$slot = getArmorStat('aslot',$armorID);
			$equipped = getStat($slot,$userID);
			if(!$equipped) {
				setStat($slot,$userID,$armorID);
				setStat('gc',$userID,($gold - $cost));
				$smarty->assign('message','You purchased and equipped the new armor.');
			} else {
				// they already have something equipped - display an error
				$smarty->assign('error','You are already wearing a piece of that kind of armor! You will need to sell your current armor before you can buy new armor.');
			}
		} else {
			$smarty->assign('error','You cannot afford that piece of armor.');
		}
	}
}
$query = "SELECT DISTINCT(id), name, price FROM items WHERE type = 'Armor' ORDER BY RAND() LIMIT 10;";
$result = mysql_query($query);
$armor = array();
while($row = mysql_fetch_assoc($result)) {
	array_push($armor,$row);
}
$stats = array('atorso','ahead','alegs','aright','aleft');
foreach ($stats as $key) {
	$id = getStat($key,$userID);
	$query = sprintf("SELECT name FROM items WHERE id = %s",
			mysql_real_escape_string($id));
	$result = mysql_query($query);
	if($result) {
		list($name) = mysql_fetch_row($result);
		$smarty->assign($key,$name);
	}
}

$smarty->assign('armor',$armor);
$smarty->display('armor-shop.tpl');
 
?>