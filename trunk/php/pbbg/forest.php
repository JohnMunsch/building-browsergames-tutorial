<?php
 
require_once 'smarty.php';
require_once 'weapon-stats.php';
require_once 'login-check.php';
 
session_start();
 
require_once 'config.php';		// our database settings
$conn = mysql_connect($dbhost,$dbuser,$dbpass)
	or die('Error connecting to mysql');
mysql_select_db($dbname);
 
if($_POST) {
	if($_POST['action'] == 'Attack') {
		require_once 'stats.php';			// player stats
		require_once 'monster-stats.php';	// monster stats
		// to begin with, we'll retrieve our player and our monster stats 
		$query = sprintf("SELECT id FROM users WHERE UPPER(username) = UPPER('%s')",
					mysql_real_escape_string($_SESSION['username']));
		$result = mysql_query($query);
		list($userID) = mysql_fetch_row($result);
		$player = array (
			name		=>	$_SESSION['username'],
			attack 		=>	getStat('atk',$userID),
			defence		=>	getStat('def',$userID),
			curhp		=>	getStat('curhp',$userID)
		);
		// $phand = getStat('phand',$userID);
		// $atk = getWeaponStat('atk',$phand);
		// $player['attack'] += $atk;
		$query = sprintf("SELECT id FROM monsters WHERE name = '%s'",
					mysql_real_escape_string($_POST['monster']));
		$result = mysql_query($query);
		list($monsterID) = mysql_fetch_row($result);
		$monster = array (
			name		=>	$_POST['monster'],
			attack		=>	getMonsterStat('atk',$monsterID),
			defence		=>	getMonsterStat('def',$monsterID),
			curhp		=>	getMonsterStat('maxhp',$monsterID)
		);
		$combat = array();
		$turns = 0;		
		while($player['curhp'] > 0 && $monster['curhp'] > 0 && $turns <= 100) {
			if($turns % 2 != 0) {
				$attacker = &$monster;
				$defender = &$player;	
			} else {
				$attacker = &$player;
				$defender = &$monster;
			}
			$damage = 0;
			if($attacker['attack'] > $defender['defence']) {
				$damage = $attacker['attack'] - $defender['defence'];	
			}
			$defender['curhp'] -= $damage;
			$combat[$turns] = array(
				attacker	=>	$attacker['name'],
				defender	=>	$defender['name'],
				damage		=>	$damage
			);
			$turns++;
		}
		setStat('curhp',$userID,$player['curhp']);
		if($player['curhp'] > 0) {
			// player won
			setStat('gc',$userID,getStat('gc',$userID)+getMonsterStat('gc',$monsterID));	
			$smarty->assign('won',1);
			$smarty->assign('gold',getMonsterStat('gc',$monsterID));
		} else {
			// monster won
			$smarty->assign('lost',1);	
		}
		$smarty->assign('combat',$combat);
	} else {
		// Running away! Send them back to the main page
		header('Location: index.php');	
	}
} else {
	$query = sprintf("SELECT name FROM monsters ORDER BY RAND() LIMIT 1");
	$result = mysql_query($query);
	list($monster) = mysql_fetch_row($result);
	$smarty->assign('monster',$monster);
}
 
$smarty->display('forest.tpl');
 
?>