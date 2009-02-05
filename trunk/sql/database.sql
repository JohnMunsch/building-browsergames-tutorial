SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

CREATE TABLE IF NOT EXISTS `areas` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `areas` (`id`, `name`) VALUES 
(1, 'Forest'),
(2, 'Woods');

CREATE TABLE IF NOT EXISTS `area_monsters` (
  `id` int(11) NOT NULL auto_increment,
  `area` int(11) default NULL,
  `monster` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `area_monsters` (`id`, `area`, `monster`) VALUES 
(1, 1, 1),
(2, 1, 2),
(3, 1, 3);

CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  `type` enum('Weapon','Armor','Usable','Foo') default NULL,
  `price` int(11) NOT NULL default '10',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `items` (`id`, `name`, `type`, `price`) VALUES 
(1, 'Wooden Sword', 'Weapon', 10),
(2, 'Flail', 'Weapon', 15),
(3, 'Mace', 'Weapon', 10),
(4, 'Pizza Slicer', 'Weapon', 10),
(5, 'Bow and Arrows', 'Weapon', 10),
(6, 'Rolling Pin', 'Weapon', 10),
(7, 'Dagger', 'Weapon', 10),
(16, 'Sample Right Arm', 'Armor', 10),
(15, 'Sample Legs', 'Armor', 10),
(14, 'Sample Torso', 'Armor', 10),
(13, 'Sample Helmet', 'Armor', 10),
(17, 'Sample Left Arm', 'Armor', 10),
(21, 'Crystal Ball', 'Usable', 10),
(20, 'Red Potion', 'Usable', 10);

CREATE TABLE IF NOT EXISTS `monsters` (
  `id` int(11) NOT NULL auto_increment,
  `name` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `monsters` (`id`, `name`) VALUES 
(1, 'Crazy Eric'),
(2, 'Lazy Russell'),
(3, 'Hard Hitting Louis');

CREATE TABLE IF NOT EXISTS `monster_items` (
  `id` int(11) NOT NULL auto_increment,
  `monster_id` int(11) default NULL,
  `item_id` int(11) default NULL,
  `rarity` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `monster_items` (`id`, `monster_id`, `item_id`, `rarity`) VALUES 
(1, 1, 1, 100),
(2, 2, 2, 100),
(3, 3, 4, 100),
(4, 4, 5, 100);

CREATE TABLE IF NOT EXISTS `stats` (
  `id` int(11) NOT NULL auto_increment,
  `display_name` text,
  `short_name` varchar(10) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `stats` (`id`, `display_name`, `short_name`) VALUES 
(1, 'Magic', 'mag'),
(2, 'Attack', 'atk'),
(3, 'Defence', 'def'),
(4, 'Gold', 'gc'),
(5, 'Maximum HP', 'maxhp'),
(6, 'Current HP', 'curhp'),
(7, 'Set Default HP Values', 'sethp'),
(8, 'Gold In Bank', 'bankgc'),
(9, 'Password Reset - hash vulnerability', 'pwrd'),
(10, 'Primary Hand Weapon', 'phand'),
(11, 'Secondary Hand Weapon', 'shand'),
(12, 'Armor - Head', 'ahead'),
(13, 'Armor - Torso', 'atorso'),
(14, 'Armor - Legs', 'alegs'),
(15, 'Armor - Right Arm', 'aright'),
(16, 'Armor - Left Arm', 'aleft'),
(17, 'Item Armor Slot', 'aslot'),
(18, 'Item Use Token', 'token'),
(19, 'Experience', 'exp'),
(20, 'Experience Remaining', 'exp_rem');

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(250) default NULL,
  `password` varchar(50) default NULL,
  `is_admin` tinyint(1) NOT NULL default '0',
  `last_login` timestamp NULL default NULL,
  `email` text NOT NULL,
  `confirmed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `user_items` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `entity_stats` (
  `id` int(11) NOT NULL auto_increment,
  `stat_id` int(11) default NULL,
  `entity_id` int(11) default NULL,
  `value` text,
  `entity_type` enum('User','Monster','Item') default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `entity_stats` (`stat_id`, `entity_id`, `value`, `entity_type`) VALUES 
(2, 1, '2', 'Monster'),
(3, 1, '2', 'Monster'),
(5, 1, '8', 'Monster'),
(2, 2, '1', 'Monster'),
(3, 2, '0', 'Monster'),
(5, 2, '4', 'Monster'),
(2, 3, '4', 'Monster'),
(3, 3, '3', 'Monster'),
(5, 3, '10', 'Monster'),
(4, 1, '5', 'Monster'),
(4, 2, '20', 'Monster'),
(4, 3, '5', 'Monster'),
(2, 1, '2', 'Item'),
(19, 3, '15', 'Monster'),
(19, 2, '10', 'Monster'),
(19, 1, '5', 'Monster'),
(17, 13, 'ahead', 'Item'),
(17, 14, 'atorso', 'Item'),
(17, 15, 'alegs', 'Item'),
(17, 16, 'aright', 'Item'),
(17, 17, 'aleft', 'Item'),
(17, 0, '0', 'Item'),
(2, 7, '0', 'Item'),
(2, 0, '0', 'Item'),
(2, 3, '0', 'Item'),
(2, 6, '0', 'Item'),
(18, 20, 'potion', 'Item'),
(18, 11, '0', 'Item'),
(18, 12, '0', 'Item'),
(18, 13, '0', 'Item'),
(18, 21, 'crystal_ball', 'Item'),
(3, 0, '0', 'Item'),
(18, 1, '0', 'Item'),
(18, 4, '0', 'Item'),
(18, 2, '0', 'Item'),
(2, 4, '0', 'Item'),
(2, 2, '0', 'Item'),
(2, 5, '0', 'Item');

-- quests, 2009-02-16
CREATE TABLE quests(
    id int not null auto_increment,
    title varchar(250),
    description text,
    PRIMARY KEY(id)
);
CREATE TABLE player_quests(
    id int not null auto_increment,
    quest_id int,
    player_id int,
    completed tinyint(1) default 0,
    PRIMARY KEY(id)
);