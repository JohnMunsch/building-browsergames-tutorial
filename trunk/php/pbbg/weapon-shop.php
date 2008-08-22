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
	if($_POST['sell']) {
		$weaponID = getStat($_POST['sell'],$userID);
		$query = sprintf("SELECT price FROM items WHERE id = %s",mysql_real_escape_string($weaponID));
		$result = mysql_query($query);
		list($price) = mysql_fetch_row($result);
		$gold = getStat('gc',$userID);
		setStat('gc',$userID,($gold + $price));
		setStat($_POST['sell'],$userID,'');
		$phand = getStat('phand',$userID);
		$shand = getStat('shand',$userID);
	} else {
		$weaponID = $_POST['weapon-id'];
		$query = sprintf("SELECT price FROM items WHERE id = %s",mysql_real_escape_string($weaponID));
		$result = mysql_query($query);
		list($cost) = mysql_fetch_row($result);
		$gold = getStat('gc',$userID);
		if($gold >= $cost) {
			// subtract gold, equip weapon, go from there.
			if(!$phand) {
				setStat('phand',$userID,$weaponID);
				setStat('gc',$userID,($gold - $cost));
				$phand = $weaponID;
				$smarty->assign('message','You equipped the weapon in your primary hand.');
			} else {
				if(!$shand) {
					setStat('shand',$userID,$weaponID);
					setStat('gc',$userID,($gold - $cost));
					$shand = $weaponID;
					$smarty->assign('message','You equipped the weapon in your secondary hand.');
				} else {
					$smarty->assign('error','You already have two weapons! You must sell one before equipping another one.');
				}
			}
		} else {
			$smarty->assign('error','You cannot afford that weapon!');
		}
	}
}
$query = "SELECT DISTINCT(id), name, price FROM items WHERE type = 'Weapon' ORDER BY RAND() LIMIT 5;";
$result = mysql_query($query);
$weapons = array();
while($row = mysql_fetch_assoc($result)) {
	array_push($weapons,$row);
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
$smarty->assign('weapons',$weapons); 
$smarty->display('weapon-shop.tpl');
 
?>