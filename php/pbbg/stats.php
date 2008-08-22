<?php

require_once 'stats-dry.php';
define('TYPE','user');

function getStat($statName,$userID) {
	return getStatDRY(TYPE,$statName,$userID);
}
function setStat($statName,$userID,$value) {
	setStatDRY(TYPE,$statName,$userID,$value);
}

?>