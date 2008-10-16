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

$actions = array('potion' => 'use_potion','crystal_ball' => 'use_crystal_ball');

if($_POST) {
	if($_POST['item-id']) {
		$query = sprintf("SELECT item_id FROM user_items WHERE user_id = '%s' AND id = '%s'",
			mysql_real_escape_string($userID),
			mysql_real_escape_string($_POST['item-id']));
		$result = mysql_query($query);
		list($itemID) = mysql_fetch_row($result);
		require_once 'items.php';
		$token = getItemStat('token',$itemID);
		call_user_func($actions[$token]);
	}
}

$inventory = array();
$query = sprintf("SELECT id, item_id, quantity FROM user_items WHERE user_id = '%s'",
		mysql_real_escape_string($userID));
$result = mysql_query($query);
while($row = mysql_fetch_assoc($result)) {
	 $item_query = sprintf("SELECT name FROM items WHERE id = '%s'",
		mysql_real_escape_string($row['item_id']));
	$item_result = mysql_query($item_query);
	list($row['name']) = mysql_fetch_row($item_result);
	array_push($inventory,$row);
}
$smarty->assign('inventory',$inventory);
$smarty->display('inventory.tpl');
 
function use_potion() {
	echo 'This is code that would run when the user used a potion.';
}
function use_crystal_ball() {
	echo 'This is code that would run when the user used a crystal ball.';
}
?>