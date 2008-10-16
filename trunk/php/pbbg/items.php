<?php

require_once 'stats-dry.php';

function getItemStat($statName,$ItemID) {
	return getStatDRY('Item',$statName,$ItemID);
}
function setItemStat($statName,$ItemID,$value) {
	setStatDRY('Item',$statName,$ItemID,$value);
}

?>