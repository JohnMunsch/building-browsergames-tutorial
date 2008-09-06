<?php

require_once 'stats-dry.php';

function getWeaponStat($statName,$weaponID) {
	return getStatDRY('Weapon',$statName,$weaponID);
}

?>