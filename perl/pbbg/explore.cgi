#!/usr/bin/perl -w
 
use strict;
use CGI qw(:cgi);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Data::Dumper;
use HTML::Template;
use DBI;
use config;
use weaponstats;
 
my $query = new CGI;
my %arguments = $query->Vars;

my $dbh = DBI->connect("DBI:mysql:$config{dbName}:$config{dbHost}",$config{dbUser},$config{dbPass},{RaiseError => 1});
my $sth;
my %parameters;

if($query->request_method() eq 'POST') {
	if($arguments{action} eq 'Attack') {
		# fighting the monster	
		use stats;
		use monsterstats;
		my $cookie = $query->cookie('username+password'); 
		my ($username) = split(/\+/,$cookie);
		$sth = $dbh->prepare("SELECT id FROM users WHERE UPPER(username) = UPPER(?)");
		$sth->execute($username);
		my $userID;
		$sth->bind_columns(\$userID);
		$sth->fetch;
		my %player = (
			name		=>	$username,
			attack		=>	stats::getStat('atk',$userID),
			defence		=>	stats::getStat('def',$userID),
			curhp		=>	stats::getStat('curhp',$userID)
		);
		my $phand = stats::getStat('phand',$userID);
		$player{attack} += weaponstats::getWeaponStat('atk',$phand);
		use armorstats;
		my @armor = qw(atorso ahead alegs aright aleft);
		foreach my $key(@armor) {
			my $id = stats::getStat($key,$userID);
			my $defence = armorstats::getArmorStat('defence',$id);
			$player{defence} += $defence;
		}		
		$sth = $dbh->prepare("SELECT id FROM monsters WHERE name = ?");
		$sth->execute($arguments{monster});
		my $monsterID;
		$sth->bind_columns(\$monsterID);
		$sth->fetch;
		my %monster = (
			name		=>	$arguments{monster},
			attack		=>	monsterstats::getMonsterStat('atk',$monsterID),
			defence		=>	monsterstats::getMonsterStat('def',$monsterID),
			curhp		=>	monsterstats::getMonsterStat('maxhp',$monsterID)
		);
		my @combat;
		my $turns = 0;
		my ($attacker,$defender);
		while($player{curhp} > 0 && $monster{curhp} > 0) {
			my %attack;
			if($turns % 2 != 0) {
				$attacker = \%monster;
				$defender = \%player;
			} else {
				$attacker = \%player;
				$defender = \%monster;
			}
			my $damage = 0;
			if($attacker->{attack} > $defender->{defence}) {
				$damage = $attacker->{attack} - $defender->{defence};	
			}
			my %attack = (
				attacker => $attacker->{name},
				defender => $defender->{name},
				damage => $damage
			);
			$defender->{curhp} -= $damage;
			push @combat, \%attack;
			$turns++;
		}
		stats::setStat('curhp',$userID,$player{curhp});
		if($player{curhp} > 0) {
			# player won
			stats::setStat('gc',$userID,stats::getStat('gc',$userID) + monsterstats::getMonsterStat('gc',$monsterID));
			$parameters{won} = 1;
			$parameters{gold} = monsterstats::getMonsterStat('gc',$monsterID);
			my $rand = int(rand(99))+1;
			$sth = $dbh->prepare("SELECT item_id FROM monster_items WHERE monster_id = ? AND rarity >= ? ORDER BY RAND() LIMIT 1");
			$sth->execute($monsterID,$rand);
			my $itemID;
			$sth->bind_columns(\$itemID);
			$sth->fetch;
			$sth = $dbh->prepare("SELECT count(id) FROM user_items WHERE user_id = ? AND item_id = ?");
			$sth->execute($userID,$itemID);
			my $count;
			$sth->bind_columns(\$count);
			$sth->fetch;
			if($count > 0) {
				# already has one of the item
				$sth = $dbh->prepare("UPDATE user_items SET quantity = quantity + 1 WHERE user_id = ? AND item_id = ?");
			} else {
				# has none of the item - new row
				$sth = $dbh->prepare("INSERT INTO user_items(quantity,user_id,item_id) VALUES (1,?,?)");
			}
			$sth->execute($userID,$itemID);
			$sth = $dbh->prepare("SELECT name FROM items WHERE id = ?");
			$sth->execute($itemID);
			$sth->bind_columns(\$parameters{item});
			$sth->fetch;

            my $monster_exp = monsterstats::getMonsterStat('exp',$monsterID);
            $parameters{exp} = $monster_exp;
            my $exp_rem = stats::getStat('exp_rem',$userID);
            $exp_rem -= $monster_exp;
            if($exp_rem <= 0) {
                $exp_rem = 100;
                $parameters{level_up} = 1;
            }
            stats::setStat('exp_rem',$userID,$exp_rem);   		
		} else {
			# monster won	
			$parameters{lost} = 1;
		}
		$parameters{combat} = \@combat;
	} else {
		# running away - back to the index page!
		print $query->redirect('index.cgi');
	}	
} else {
    my $area_id = $arguments{'area'};
    $sth = $dbh->prepare("SELECT monster FROM area_monsters WHERE area = ? ORDER BY RAND() LIMIT 1");
    $sth->execute($area_id);
    my $monster_id;
    $sth->bind_columns(\$monster_id);
    $sth->fetch;
    $sth = $dbh->prepare("SELECT name FROM monsters WHERE id = ?");
    $sth->execute($monster_id);
    $sth->bind_columns(\$parameters{monster});
    $sth->fetch;
}

my $area_id = $query->url_param('area');
$sth = $dbh->prepare("SELECT name FROM areas WHERE id = ?");
$sth->execute($area_id);
$sth->bind_columns(\$parameters{area_name});
$sth->fetch;

my $template = HTML::Template->new(
		filename	=>	'explore.tmpl',
		associate	=>	$query,
	);
$template->param(%parameters);
print $query->header(), $template->output;