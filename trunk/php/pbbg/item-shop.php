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
	if($_POST['item-id']) {
		$itemID = $_POST['item-id'];
		$query = sprintf("SELECT price FROM items WHERE id = '%s'",mysql_real_escape_string($itemID));
		$result = mysql_query($query);
		list($cost) = mysql_fetch_row($result);
		$gold = getStat('gc',$userID);
		if($gold >= $cost) {
			setStat('gc',$userID,($gold - $cost));
			$query = sprintf("SELECT count(id) FROM user_items WHERE user_id = '%s' AND item_id = '%s'",
				mysql_real_escape_string($userID),mysql_real_escape_string($itemID));
			$result = mysql_query($query);
			list($count) = mysql_fetch_row($result);
			if ($count > 0) {
				# already has one of the item
				$query = sprintf("UPDATE user_items SET quantity = quantity + 1 WHERE user_id = '%s' AND item_id = '%s'",
					mysql_real_escape_string($userID),
					mysql_real_escape_string($itemID));
			} else {
				# has none - new row
				$query = sprintf("INSERT INTO user_items(quantity,user_id,item_id) VALUES (1,'%s','%s')",
					mysql_real_escape_string($userID),
					mysql_real_escape_string($itemID));
			}
			mysql_query($query);
			$smarty->assign('message','You purchased the item.');
		} else {
			$smarty->assign('error','You cannot afford that item!');
		}
	} else if($_POST['sell-id']) {
		$itemID = $_POST['sell-id'];
		$query = sprintf("SELECT price FROM items WHERE id = '%s'",mysql_real_escape_string($itemID));
		$result = mysql_query($query);
		list($cost) = mysql_fetch_row($result);
		$gold = getStat('gc',$userID);
		setStat('gc',$userID,($gold + $cost));		
		$query = sprintf("SELECT quantity FROM user_items WHERE user_id = '%s' AND item_id = '%s'",
			mysql_real_escape_string($userID),mysql_real_escape_string($itemID));
		$result = mysql_query($query);
		list($quantity) = mysql_fetch_row($result);
		if ($quantity > 1) {
			$query = sprintf("UPDATE user_items SET quantity = quantity - 1 WHERE user_id = '%s' AND item_id = '%s'",
				mysql_real_escape_string($userID),
				mysql_real_escape_string($itemID));
		} else {
			$query = sprintf("DELETE FROM user_items WHERE user_id = '%s' AND item_id = '%s'",
				mysql_real_escape_string($userID),
				mysql_real_escape_string($itemID));
		}
		mysql_query($query);		
		$smarty->assign('message','You sold the item.');
	}
}
$query = "SELECT DISTINCT(id), name, price FROM items WHERE type = 'Usable' ORDER BY RAND() LIMIT 5;";
$result = mysql_query($query);
$items = array();
while($row = mysql_fetch_assoc($result)) {
	array_push($items,$row);
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
$smarty->assign('items',$items);
$smarty->display('item-shop.tpl');
 
?>