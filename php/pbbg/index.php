<?php

require_once 'smarty.php';

require_once 'login-check.php';
require_once 'stats.php';
$smarty->assign('attack',getStat('atk',$userID));
$smarty->assign('magic',getStat('mag',$userID));
$smarty->assign('defence',getStat('def',$userID));
$smarty->assign('gold',getStat('gc',$userID));
$setHP = getStat('sethp',$userID);
if($setHP == 0) {
	// haven't set up the user's HP values yet - let's set those!
	setStat('curhp',$userID,10);
	setStat('maxhp',$userID,10);
	setStat('sethp',$userID,1);	
}
$smarty->assign('currentHP',getStat('curhp',$userID));
$smarty->assign('maximumHP',getStat('maxhp',$userID));
$smarty->assign('name',$_SESSION['username']);
$smarty->display('index.tpl');

?>