-- =========================
-- TABLES
-- =========================
CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at DATETIME NOT NULL,
    last_login DATETIME NOT NULL);

CREATE TABLE IF NOT EXISTS CLASS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS RACE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS PLAYER (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    class_id INTEGER NOT NULL,
    race_id INTEGER NOT NULL,
    username TEXT NOT NULL UNIQUE,
    gold INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (account_id) REFERENCES account(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES KLASSE(id),
    FOREIGN KEY (race_id) REFERENCES RACE(id)
);

CREATE TABLE IF NOT EXISTS GUILD (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS PLAYER_GUILD (
    player_id INTEGER NOT NULL,
    guild_id INTEGER NOT NULL,
    joined_date DATE NOT NULL,
    PRIMARY KEY (player_id, guild_id),
    FOREIGN KEY (player_id) REFERENCES PLAYER(id),
    FOREIGN KEY (guild_id) REFERENCES GUILD(id)
);

CREATE TABLE IF NOT EXISTS GUILD_ROLE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS PLAYER_GUILD_ROLE (
    player_id INTEGER NOT NULL,
    guild_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (player_id, guild_id),
    
    FOREIGN KEY (player_id, guild_id)
        REFERENCES PLAYER_GUILD(player_id, guild_id)
        ON DELETE CASCADE,
        
    FOREIGN KEY (role_id)
        REFERENCES GUILD_ROLE(id)
);

CREATE TABLE IF NOT EXISTS STAT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    acronym TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS PLAYER_STAT (
    player_id INTEGER NOT NULL,
    stat_id INTEGER NOT NULL,
    value INTEGER NOT NULL,
    PRIMARY KEY (player_id, stat_id),
    FOREIGN KEY (player_id) REFERENCES PLAYER(id),
    FOREIGN KEY (stat_id) REFERENCES STAT(id)
);

CREATE TABLE IF NOT EXISTS LEVEL (
    id INTEGER PRIMARY KEY,
    experience_required INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS PLAYER_LEVEL (
    player_id INTEGER PRIMARY KEY,
    current_level INTEGER NOT NULL DEFAULT 1,
    current_experience INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES PLAYER(id) ON DELETE CASCADE,
    FOREIGN KEY (current_level) REFERENCES LEVEL(id)
);

-- =========================
-- account
-- =========================
WITH RECURSIVE nums(id) AS (
    SELECT 1
    UNION ALL
    SELECT id + 1 FROM nums WHERE id < 5000)
INSERT INTO account (id, created_at, last_login)
SELECT
    id,
    -- created_at: random time within last 5 years
    datetime(
            strftime('%s','now')       -- current unix time
                - abs(random()) % (5 * 365 * 24 * 60 * 60), -- subtract up to 5 years in seconds
            'unixepoch'
    ) AS created_at,
    -- last_login: random time within last 180 days
    datetime(
            strftime('%s','now')
                - abs(random()) % (180 * 24 * 60 * 60), -- subtract up to 180 days
            'unixepoch'
    ) AS last_login
FROM nums;

-- =========================
-- PLAYER
-- =========================
CREATE TEMP TABLE medieval_first (name TEXT);
INSERT INTO medieval_first (name) VALUES
('Aldric'),('Beorn'),('Cuthbert'),('Godric'),('Hereward'),('Leofric'),('Osric'),('Wynstan'),
('Ivar'),('Torvald'),('Sigurd'),('Ragnar'),('Bjorn'),('Hakon'),('Eirik'),('Ulfr'),
('Aedan'),('Cian'),('Fionn'),('Niall'),('Taran'),('Ronan'),('Oisin'),('Bran'),
('Roderick'),('Baldric'),('Cedric'),('Theobald'),('Gerhardt'),('Berengar'),
('Cassian'),('Lucian'),('Octavian'),('Hadrian'),('Marcellus'),('Dorian'),
('Tiberius'),('Alaric'),('Wulfram'),('Siegfried');

CREATE TEMP TABLE medieval_last (name TEXT);
INSERT INTO medieval_last (name) VALUES
('Blackwood'),('Ironshield'),('Stormcloak'),('Ravenspear'),('Oakenshield'),
('Wolfborn'),('Stonehelm'),('Hawkridge'),('Frostward'),('Firebrand'),
('Silverkeep'),('Darkwater'),('Drakebane'),('Stormwatch'),('Redwyne'),
('Longspear'),('Wintermere'),('Darkwater'),('Falconcrest'),('Grimward'),
('Shadowmoor'),('Ravencrest'),('Thornfield'),('Brightmore'),('Highridge');

CREATE TEMP TABLE medieval_epithet (epithet TEXT);
INSERT INTO medieval_epithet (epithet) VALUES
('the Bold'),('the Cunning'),('the Elder'),('the Younger'),('the Fearless'),
('the Black'),('the Wanderer'),('the Vigilant'),('the Ironhand'),('the Stormborn'),
('of Stormhold'),('of Wolfswood'),('of Dragonspire'),('of Highcrest'),
('of Winterhall'),('of the North'),('of Westvale'),('of the Lowlands'),
('the Just'),('the Swift'),('the Pale'),('the Red'),('the White'),('the Reaver'),
('the Dragonslayer');

-- Generate all 15,000 players in one go
-- 95% of accounts (4,750) get at least one player, 5% (250) remain empty (randomly selected)
WITH RECURSIVE nums(id) AS (
    SELECT 1
    UNION ALL
    SELECT id + 1 FROM nums WHERE id < 15000
),
-- Select 4,750 random accounts (95%) that will have players
               active_accounts AS (
                   SELECT id FROM account ORDER BY RANDOM() LIMIT 4750
    ),
-- Number them sequentially for the guaranteed assignment
    numbered_accounts AS (
SELECT id, ROW_NUMBER() OVER (ORDER BY id) as rn
FROM active_accounts
    )
INSERT INTO player (id, account_id, username, gold, class_id, race_id)
SELECT
    nums.id AS id,

    -- First 4,750 players: one guaranteed player per active account
    -- Remaining 10,250 players: randomly assigned to active accounts
    CASE
        WHEN nums.id <= 4750 THEN (SELECT id FROM numbered_accounts WHERE rn = nums.id)
        ELSE (SELECT id FROM active_accounts ORDER BY RANDOM() LIMIT 1)
END AS account_id,

    -- username generation
    LOWER(
        REPLACE(
            (
                (SELECT name FROM medieval_first ORDER BY random() LIMIT 1) || '_' ||
                (SELECT name FROM medieval_last ORDER BY random() LIMIT 1) || '_' ||
                (SELECT epithet FROM medieval_epithet ORDER BY random() LIMIT 1) || '_' ||
                nums.id
            ),
            ' ', '_'
        )
    ) AS username,

    (abs(random()) % 9001) + 100 AS gold,  -- 100–9100
    (abs(random()) % 20) + 1 AS class_id,   -- 1–20
    (abs(random()) % 18) + 1 AS race_id     -- 1–18
FROM nums;

-- =========================
-- GUILD_ROLE
-- =========================
INSERT OR IGNORE INTO GUILD_ROLE (id, name, description) VALUES
(1, 'Guildwarden', 'Leader of the guild'),
(2, 'Councilor', 'Second in command, sits on the ruling council'),
(3, 'Captain', 'Senior officer overseeing members'),
(4, 'Member', 'Standard guild member'),
(5, 'Initiate', 'New member / recruit');

-- =========================
-- STAT
-- =========================
INSERT OR IGNORE INTO STAT (id, name, acronym) VALUES
(1, 'Health', 'HP'),
(2, 'Mana', 'MP'),
(3, 'Attack', 'ATK'),
(4, 'Defense', 'DEF'),
(5, 'Speed', 'SPD'),
(6, 'Critical Chance', 'CRIT'),
(7, 'Evasion', 'EVA'),
(8, 'Luck', 'LUCK');

-- =========================
-- CLASS
-- =========================
INSERT OR IGNORE INTO CLASS (id, name, description) VALUES
(1, 'Paladin', 'Holy warrior using shield, light magic, and defensive auras.'),
(2, 'Warrior', 'Heavily armored melee fighter with strong physical damage.'),
(3, 'Knight', 'Defensive fighter focused on shields and protection skills.'),
(4, 'Dark Knight', 'Wields dark magic and heavy weapons, using self-sacrifice abilities.'),
(5, 'Rogue', 'Stealth-based melee assassin using daggers and poisons.'),
(6, 'Assassin', 'High burst damage dealer with shadow abilities.'),
(7, 'Monk', 'Martial artist using fast combos and chi techniques.'),
(8, 'Berserker', 'Two-handed fighter driven by rage mechanics.'),
(9, 'Ranger', 'Ranged bow user with animal companions.'),
(10, 'Gunner', 'Uses firearms, traps, and mechanical gadgets.'),
(11, 'Mage', 'Casts elemental spells such as fire, frost, and arcane magic.'),
(12, 'Warlock', 'Uses shadow magic and summons demonic entities.'),
(13, 'Cleric', 'Holy magic healer focused on restoration and protection.'),
(14, 'Druid', 'Shapeshifter using nature magic and healing abilities.'),
(15, 'Bard', 'Support class using music-based buffs and magical melodies.'),
(16, 'Shaman', 'Controls the elements and uses totems for support.'),
(17, 'Templar', 'Hybrid tank-healer combining defense and holy magic.'),
(18, 'Battlemage', 'Melee mage combining martial combat with spellcasting.'),
(19, 'Witchmaster', 'Crowd control specialist using curses and enchantments.'),
(20, 'Engineer', 'Uses gadgets, bombs, and mechanical constructs.');

-- =========================
-- RACE
-- =========================
INSERT OR IGNORE INTO RACE (id, name, description) VALUES
(1, 'Human', 'Balanced race with versatile traits and adaptable abilities.'),
(2, 'High Elf', 'Graceful and agile race focused on arcane magic.'),
(3, 'Dark Elf', 'Masters of shadow magic with swift and lethal attacks.'),
(4, 'Dwarf', 'Sturdy race with high defense and master craftsmanship.'),
(5, 'Orc', 'Strong, aggressive warriors built for melee combat.'),
(6, 'Troll', 'Regenerative race skilled in shamanism and spiritual magic.'),
(7, 'Beastkin', 'Physically powerful animal-like race such as leonine or lupine clans.'),
(8, 'Tigerkin', 'Agile feline scouts excelling in speed and precision.'),
(9, 'Demonborn', 'Dark-magic infused beings with high resistance and demonic traits.'),
(10, 'Elementalborn', 'Born of fire, ice, earth, or wind with strong elemental heritage.'),
(11, 'Undead', 'Reanimated beings with immunities and lifesteal abilities.'),
(12, 'Fae', 'Magical, nimble race with high mobility and illusion skills.'),
(13, 'Android', 'Technological lifeforms with built-in enhancements and resistances.'),
(14, 'Mechanoid', 'Armored mechanical beings using energy-based capabilities.'),
(15, 'Gnome', 'Small inventive race specializing in engineering and alchemy.'),
(16, 'Goblin', 'Clever tricksters skilled with explosives, traps, and tinkering.'),
(17, 'Halfling', 'Lucky, evasive race known for agility and stealth.'),
(18, 'Plushkin', 'Cute soft-creature race with charm-based abilities.');

-- =========================
-- GUILD
-- =========================
INSERT OR IGNORE INTO GUILD (id, name, description) VALUES
(1, 'Order of the Dawn', 'A holy knight order sworn to protect the realm from darkness.'),
(2, 'Shadow Veil', 'A secretive guild of rogues and assassins working from the shadows.'),
(3, 'Arcane Concord', 'A circle of mages dedicated to studying and controlling raw magic.'),
(4, 'Iron Vanguard', 'A battle-hardened mercenary guild known for its fearless warriors.'),
(5, 'Emerald Circle', 'A druidic guild protecting nature and ancient forest spirits.'),
(6, 'Stormborn Clans', 'A loose alliance of shamans and elemental warriors from the north.');

-- =========================
-- PLAYER_GUILD
-- =========================
-- Assign 70% of players to random guilds with random join dates
INSERT INTO PLAYER_GUILD (player_id, guild_id, joined_date)
SELECT
    id AS player_id,

    -- Random guild (1-6)
    (abs(random()) % 6) + 1 AS guild_id,

    -- Random join date within the last year
    date(
    strftime('%s', 'now') - abs(random()) % (365 * 24 * 60 * 60),
    'unixepoch'
    ) AS joined_date

FROM player
WHERE abs(random()) % 100 < 70;  -- 70% probability

-- =========================
-- PLAYER_GUILD_ROLE
-- =========================
-- Assign Guildwarden role to the longest-standing guild member
INSERT INTO PLAYER_GUILD_ROLE (player_id, guild_id, role_id)
SELECT player_id, guild_id, 1 -- Guildwarden
FROM (
    SELECT 
        player_id, 
        guild_id,
        ROW_NUMBER() OVER (PARTITION BY guild_id ORDER BY joined_date ASC) AS rn
    FROM PLAYER_GUILD
)
WHERE rn = 1;

-- Assign random roles to all other members
INSERT INTO PLAYER_GUILD_ROLE (player_id, guild_id, role_id)
SELECT pg.player_id,
       pg.guild_id,
       (
           CASE ABS(RANDOM()) % 4
               WHEN 0 THEN 2  -- Councilor
               WHEN 1 THEN 3  -- Captain
               WHEN 2 THEN 4  -- Member
               WHEN 3 THEN 5  -- Initiate
           END
       ) AS random_role
FROM PLAYER_GUILD pg
LEFT JOIN PLAYER_GUILD_ROLE pgr
       ON pgr.player_id = pg.player_id
      AND pgr.guild_id = pg.guild_id
WHERE pgr.player_id IS NULL;   -- exclude Guildwardens already assigned

-- =========================
-- PLAYER_STAT
-- =========================
-- Generate random stats for all players (8 stats each)
INSERT INTO PLAYER_STAT (player_id, stat_id, value)
SELECT
    p.id AS player_id,
    s.id AS stat_id,

    -- Generate random stat values based on stat type
    CASE s.id
        WHEN 1 THEN (abs(random()) % 51) + 100  -- Health: 100-150
        WHEN 2 THEN (abs(random()) % 71) + 50   -- Mana: 50-120
        WHEN 3 THEN (abs(random()) % 13) + 25   -- Attack: 25-37
        WHEN 4 THEN (abs(random()) % 12) + 15   -- Defense: 15-26
        WHEN 5 THEN (abs(random()) % 11) + 10   -- Speed: 10-20
        WHEN 6 THEN (abs(random()) % 7) + 4     -- Critical Chance: 4-10
        WHEN 7 THEN (abs(random()) % 6) + 8     -- Evasion: 8-13
        WHEN 8 THEN (abs(random()) % 5) + 5     -- Luck: 5-9
        END AS value

FROM player p
    CROSS JOIN stat s;

-- =========================
-- LEVEL
-- =========================
INSERT OR IGNORE INTO LEVEL (id, experience_required) VALUES
(1, 0),
(2, 100),
(3, 300),
(4, 600),
(5, 1000);

-- =========================
-- PLAYER_LEVEL
-- =========================
-- Assign each level to at least one player, then random levels to the rest
INSERT OR IGNORE INTO PLAYER_LEVEL (player_id, current_level, current_experience)
SELECT
    id,
    CASE
        -- Ensure each level is used at least once (first 5 players get levels 1-5)
        WHEN id <= 5 THEN id
        -- Remaining players get random levels between 1 and 5
        ELSE (ABS(RANDOM()) % 5) + 1
        END AS level,
    CASE
        -- Random experience progress within current level
        WHEN id <= 5 AND id = 1 THEN 0
        WHEN id <= 5 AND id = 2 THEN 45
        WHEN id <= 5 AND id = 3 THEN 150
        WHEN id <= 5 AND id = 4 THEN 280
        WHEN id <= 5 AND id = 5 THEN 520
        ELSE ABS(RANDOM()) % 50
        END AS exp
FROM PLAYER;