<?php
require('/usr/share/php/smarty/Smarty.class.php');
$smarty = new Smarty();

$smarty->template_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/templates';
$smarty->compile_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/templates_compile';
$smarty->cache_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/cache';
$smarty->config_dir = '/home/buildingbrowsergames/public_html/game/php/smarty/configs';
?>