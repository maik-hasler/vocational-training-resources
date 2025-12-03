-- =========================
-- TABLES
-- =========================
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
    username TEXT NOT NULL UNIQUE,
    gold INTEGER NOT NULL DEFAULT 0,
    class_id INTEGER NOT NULL,
    race_id INTEGER NOT NULL,
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

-- =========================
-- GUILD_ROLE
-- =========================
INSERT INTO GUILD_ROLE (id, name, description) VALUES
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
-- PLAYER
-- =========================
INSERT OR IGNORE INTO PLAYER (id, username, gold, class_id, race_id) VALUES
(1, 'Arion', 723, 2, 5),
(2, 'Brynn', 1023, 3, 7),
(3, 'Kael', 154, 1, 2),
(4, 'Lyra', 895, 4, 9),
(5, 'Toren', 432, 5, 1),
(6, 'Selene', 1199, 6, 6),
(7, 'Darius', 8, 7, 3),
(8, 'Elara', 147, 8, 8),
(9, 'Fenric', 1001, 9, 4),
(10, 'Mira', 678, 10, 10),
(11, 'Rogan', 501, 11, 11),
(12, 'Vexa', 0, 12, 12),
(13, 'Zyric', 132, 1, 1),
(14, 'Lyric', 1475, 2, 2),
(15, 'Thane', 777, 3, 3),
(16, 'Kiera', 290, 4, 4),
(17, 'Oren', 1111, 5, 5),
(18, 'Selar', 623, 6, 6),
(19, 'Riven', 50, 7, 7),
(20, 'Alara', 1469, 8, 8),
(21, 'Draven', 404, 9, 9),
(22, 'Nyssa', 88, 10, 10),
(23, 'Talon', 999, 11, 11),
(24, 'Eris', 35, 12, 12),
(25, 'Kaida', 447, 1, 3);

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
INSERT OR IGNORE INTO PLAYER_GUILD (player_id, guild_id, joined_date) VALUES
(1, 1, '2025-01-15'),
(2, 2, '2025-02-20'),
(3, 1, '2025-03-05'),
(4, 3, '2025-01-25'),
(5, 2, '2025-02-10'),
(6, 3, '2025-03-18'),
(7, 4, '2025-01-30'),
(8, 5, '2025-02-14'),
(9, 6, '2025-03-12'),
(10, 1, '2025-01-20'),
(12, 3, '2025-03-22'),
(14, 5, '2025-02-05'),
(15, 6, '2025-03-01'),
(17, 2, '2025-02-08'),
(18, 3, '2025-03-15'),
(21, 6, '2025-03-25'),
(24, 3, '2025-03-05');

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
INSERT OR IGNORE INTO PLAYER_STAT (player_id, stat_id, value) VALUES
(1, 1, 120), (1, 2, 80), (1, 3, 25), (1, 4, 20), (1, 5, 15), (1, 6, 5), (1, 7, 10), (1, 8, 7),
(2, 1, 100), (2, 2, 120), (2, 3, 30), (2, 4, 15), (2, 5, 20), (2, 6, 10), (2, 7, 12), (2, 8, 8),
(3, 1, 150), (3, 2, 50), (3, 3, 35), (3, 4, 25), (3, 5, 10), (3, 6, 4), (3, 7, 8), (3, 8, 5),
(4, 1, 110), (4, 2, 90), (4, 3, 28), (4, 4, 18), (4, 5, 17), (4, 6, 6), (4, 7, 11), (4, 8, 7),
(5, 1, 130), (5, 2, 70), (5, 3, 32), (5, 4, 22), (5, 5, 14), (5, 6, 5), (5, 7, 9), (5, 8, 6),
(6, 1, 105), (6, 2, 110), (6, 3, 27), (6, 4, 16), (6, 5, 19), (6, 6, 7), (6, 7, 13), (6, 8, 9),
(7, 1, 140), (7, 2, 60), (7, 3, 34), (7, 4, 24), (7, 5, 12), (7, 6, 5), (7, 7, 10), (7, 8, 6),
(8, 1, 115), (8, 2, 95), (8, 3, 29), (8, 4, 19), (8, 5, 18), (8, 6, 6), (8, 7, 11), (8, 8, 7),
(9, 1, 125), (9, 2, 85), (9, 3, 31), (9, 4, 21), (9, 5, 15), (9, 6, 5), (9, 7, 10), (9, 8, 6),
(10, 1, 110), (10, 2, 100), (10, 3, 28), (10, 4, 18), (10, 5, 17), (10, 6, 6), (10, 7, 12), (10, 8, 8),
(11, 1, 135), (11, 2, 65), (11, 3, 33), (11, 4, 23), (11, 5, 13), (11, 6, 5), (11, 7, 9), (11, 8, 6),
(12, 1, 120), (12, 2, 90), (12, 3, 30), (12, 4, 20), (12, 5, 15), (12, 6, 6), (12, 7, 11), (12, 8, 7),
(13, 1, 145), (13, 2, 55), (13, 3, 36), (13, 4, 26), (13, 5, 12), (13, 6, 4), (13, 7, 8), (13, 8, 5),
(14, 1, 110), (14, 2, 100), (14, 3, 29), (14, 4, 18), (14, 5, 16), (14, 6, 5), (14, 7, 11), (14, 8, 7),
(15, 1, 130), (15, 2, 70), (15, 3, 32), (15, 4, 22), (15, 5, 14), (15, 6, 5), (15, 7, 10), (15, 8, 6),
(16, 1, 115), (16, 2, 95), (16, 3, 30), (16, 4, 19), (16, 5, 17), (16, 6, 6), (16, 7, 11), (16, 8, 7),
(17, 1, 125), (17, 2, 85), (17, 3, 31), (17, 4, 21), (17, 5, 15), (17, 6, 5), (17, 7, 10), (17, 8, 6),
(18, 1, 105), (18, 2, 110), (18, 3, 27), (18, 4, 16), (18, 5, 19), (18, 6, 7), (18, 7, 12), (18, 8, 8),
(19, 1, 140), (19, 2, 60), (19, 3, 34), (19, 4, 24), (19, 5, 13), (19, 6, 5), (19, 7, 9), (19, 8, 6),
(20, 1, 115), (20, 2, 95), (20, 3, 29), (20, 4, 19), (20, 5, 18), (20, 6, 6), (20, 7, 11), (20, 8, 7),
(21, 1, 125), (21, 2, 85), (21, 3, 31), (21, 4, 21), (21, 5, 15), (21, 6, 5), (21, 7, 10), (21, 8, 6),
(22, 1, 110), (22, 2, 100), (22, 3, 28), (22, 4, 18), (22, 5, 17), (22, 6, 6), (22, 7, 11), (22, 8, 7),
(23, 1, 135), (23, 2, 65), (23, 3, 33), (23, 4, 23), (23, 5, 13), (23, 6, 5), (23, 7, 9), (23, 8, 6),
(24, 1, 120), (24, 2, 90), (24, 3, 30), (24, 4, 20), (24, 5, 15), (24, 6, 6), (24, 7, 11), (24, 8, 7),
(25, 1, 140), (25, 2, 75), (25, 3, 35), (25, 4, 25), (25, 5, 14), (25, 6, 5), (25, 7, 10), (25, 8, 6);
