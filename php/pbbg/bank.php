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

$gold = getStat('gc',$userID);
if($_POST) {
	$amount = $_POST['amount'];	
	if($_POST['action'] == 'Deposit') {
		if($amount > $gold || $amount == '') {
			// the user input something weird - assume the maximum
			$amount = $gold;	
		}
		setStat('gc',$userID,getStat('gc',$userID) - $amount);
		setStat('bankgc',$userID,getStat('bankgc',$userID)+$amount);
		$smarty->assign('deposited',$amount);
	} else {
		$bankGold = getStat('bankgc',$userID);
		if($amount > $bankGold || $amount == '') {
			// the user input something weird again - again, assume the maximum
			$amount = $bankGold;
		}
		setStat('gc',$userID,getStat('gc',$userID) + $amount);
		setStat('bankgc',$userID,getStat('bankgc',$userID)-$amount);
		$smarty->assign('withdrawn',$amount);
	}
}

$smarty->assign('gold',getStat('gc',$userID));
$smarty->assign('inbank',getStat('bankgc',$userID));
$smarty->display('bank.tpl');

?>