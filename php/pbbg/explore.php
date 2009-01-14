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
		$phand = getStat('phand',$userID);
		$atk = getWeaponStat('atk',$phand);
		$player['attack'] += $atk;
		require_once 'armor-stats.php';		// armor stats
		$armor = array('atorso','ahead','alegs','aright','aleft');
		foreach ($armor as $key) {
			$id = getStat($key,$userID);
			$defence = getArmorStat('defence',$id);
			$player['defence'] += $defence;
		}		
		
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
			$rand = rand(0,100);
			$query = sprintf("SELECT item_id FROM monster_items WHERE monster_id = %s AND rarity >= %s ORDER BY RAND() LIMIT 1",
				mysql_real_escape_string($monsterID),
				mysql_real_escape_string($rand));
			$result = mysql_query($query);
			list($itemID) = mysql_fetch_row($result);
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
			# retrieve the item name, so that we can display it
			$query = sprintf("SELECT name FROM items WHERE id = %s",
				mysql_real_escape_string($itemID));
			$result = mysql_query($query);
			list($itemName) = mysql_fetch_row($result);
			$smarty->assign('item',$itemName);
			
			$monster_exp = getMonsterStat('exp',$monsterID);
			$smarty->assign('exp',$monster_exp);
			$exp_rem = getStat('exp_rem',$userID);
			$exp_rem -= $monster_exp;
			$level_up = 0;
			if($exp_rem <= 0) {
			    // level up!
			    $exp_rem = 100;
			    $level_up = 1;
			}
		    $smarty->assign('level_up',$level_up);
			setStat('exp_rem',$userID,$exp_rem);
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
    $area_id = $_GET['area'];
    $query = sprintf("SELECT monster FROM area_monsters WHERE area = %s ORDER BY RAND() LIMIT 1",
        mysql_real_escape_string($area_id));
    $result = mysql_query($query);
    list($monster_id) = mysql_fetch_row($result);
    $query = sprintf("SELECT name FROM monsters WHERE id = %s",
        mysql_real_escape_string($monster_id));
    $result = mysql_query($query);
    list($monster) = mysql_fetch_row($result);
    $smarty->assign('monster',$monster);
}

$query = sprintf("SELECT name FROM areas WHERE id = %s",
    mysql_real_escape_string($_GET['area']));
$result = mysql_query($query);
list($area_name) = mysql_fetch_row($result);
$smarty->assign('area',$area_name);
$smarty->assign('area_id',$_GET['area']);

$smarty->display('explore.tpl');
 
?>