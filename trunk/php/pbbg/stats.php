<?php

require_once 'stats-dry.php';

function getStat($statName,$userID) {
	return getStatDRY('user',$statName,$userID);
}
function setStat($statName,$userID,$value) {
	setStatDRY('user',$statName,$userID,$value);
}

?>