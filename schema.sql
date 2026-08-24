-- MCU Tracker schema
-- Run with: npm run db:migrate:local (or :remote)
-- Edit/add/remove rows below to customize your own "selected" MCU list.
-- chronological_order = position in in-universe story timeline (not release order)
-- phase = official MCU phase 1-6, used purely for color-coding (Infinity Stone theme)
--   1 = space (blue) · 2 = mind (yellow) · 3 = reality (red)
--   4 = power (purple) · 5 = time (green) · 6 = soul (orange)

DROP TABLE IF EXISTS items;

CREATE TABLE items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  chronological_order INTEGER NOT NULL,
  title TEXT NOT NULL,
  image_url TEXT NOT NULL DEFAULT '',
  type TEXT NOT NULL,           -- 'movie' | 'show'
  franchise TEXT NOT NULL DEFAULT 'MCU',
  phase INTEGER NOT NULL,       -- 1-6
  era TEXT NOT NULL,            -- in-story setting, shown on the card
  -- 0 = not started, 1 = currently watching, 2 = watched
  watched INTEGER NOT NULL DEFAULT 0 CHECK (watched BETWEEN 0 AND 2)
);

-- Add a direct image URL for a title, for example:
-- UPDATE items SET image_url = 'https://example.com/poster.jpg' WHERE title = 'Blade';

INSERT INTO items (chronological_order, title, type, phase, era, watched) VALUES
(1,  'Captain America: First Avenger', 'movie', 1, '1943-1945', 2),
(2,  'Captain Marvel', 'movie', 1, '1995', 2),
(3,  'Blade', 'movie', 1, '1998', 0),
(4,  'X-Men', 'movie', 1, '2000', 0),
(5,  'Spiderman 1', 'movie', 1, '2001', 2),
(6,  'X2: X-Men United', 'movie', 1, '2003', 0),
(7,  'Spiderman 2', 'movie', 1, '2004', 2),
(8,  'Spiderman 3', 'movie', 1, '2005', 2),
(9,  'X-Men: The Last Stand', 'movie', 1, '2006', 0),
(10, 'Iron Man 1', 'movie', 1, '2008', 2),
(11, 'The Incredible Hulk', 'movie', 1, '2010', 2),
(12, 'Iron Man 2', 'movie', 1, '2010', 2),
(13, 'Thor', 'movie', 1, '2011', 2),
(14, 'The Amazing Spiderman', 'movie', 1, '2012', 2),
(15, 'The Avengers', 'movie', 1, '2012', 2),
(16, 'The Wolverine', 'movie', 1, '2013', 0),
(17, 'X-Men: Days of Future Past', 'movie', 1, '1973 / 2023', 0),
(18, 'Iron Man 3', 'movie', 2, '2012', 2),
(19, 'Thor: The Dark Kingdom', 'movie', 2, '2013', 2),
(20, 'Captain America: Winter Soldier (= The Return of the First Avenger)', 'movie', 2, '2014', 2),
(21, 'The Amazing Spiderman 2: Rise of Electro', 'movie', 2, '2014', 2),
(22, 'Guardians of the Galaxy 1', 'movie', 2, '2014', 2),
(23, 'Guardians of the Galaxy 2', 'movie', 2, '2014', 2),
(24, 'Avengers: Age of Ultron', 'movie', 2, '2015', 2),
(25, 'Ant Man', 'movie', 2, '2015', 2),
(26, 'Captain America: Civil War', 'movie', 3, '2016', 2),
(27, 'Black Widow', 'movie', 3, '2016', 2),
(28, 'Spiderman: Homecoming', 'movie', 3, '2016', 2),
(29, 'Black Panther', 'movie', 3, '2016', 2),
(30, 'Doctor Strange', 'movie', 3, '2016', 2),
(31, 'Deadpool 1', 'movie', 3, '2016', 2),
(32, 'Thor: Ragnarok', 'movie', 3, '2017', 2),
(33, 'Deadpool 2', 'movie', 3, '2018', 2),
(34, 'Venom', 'movie', 3, '2018', 2),
(35, 'Avengers: Infinity War', 'movie', 3, '2018', 2),
(36, 'Ant-Man and the Wasp', 'movie', 3, '2018', 2),
(37, 'Venom: Let There Be Carnage', 'movie', 3, '2020', 2),
(38, 'Avengers: Endgame', 'movie', 3, '2023', 2),
(39, 'Loki (Season 1)', 'show', 3, '2023', 2),
(40, 'WandaVision', 'show', 3, '2023', 2),
(41, 'The Falcon and the Winter Soldier', 'show', 3, '2023', 2),
(42, 'Venom: The Last Dance', 'movie', 3, '2024', 1),
(43, 'Spiderman: Far From Home', 'movie', 3, '2024', 0),
(44, 'Shang-Chi and the Legend of the Ten Rings', 'movie', 4, '2024', 0),
(45, 'Eternals', 'movie', 4, '2024', 0),
(46, 'Spiderman: No Way Home', 'movie', 4, '2024', 0),
(47, 'Doctor Strange in the Multiverse of Madness', 'movie', 4, '2024', 0),
(48, 'Hawkeye', 'show', 4, '2024', 0),
(49, 'Moon Knight', 'show', 4, '2024', 0),
(50, 'Black Panther: Wakanda Forever', 'movie', 4, '2024', 0),
(51, 'Thor: Love and Thunder', 'movie', 4, '2024', 0),
(52, 'The Guardians of the Galaxy Holiday Special', 'show', 4, '2024', 2),
(53, 'Ant-Man and the Wasp: Quantumania', 'movie', 5, '2025', 0),
(54, 'Guardians of the Galaxy 3', 'movie', 5, '2025', 0),
(55, 'Secret Invasion', 'show', 5, '2025', 0),
(56, 'The Marvels', 'movie', 5, '2025', 0),
(57, 'Loki (Season 2)', 'show', 5, '2025', 0),
(58, 'Deadpool & Wolverine', 'movie', 5, '2025', 0),
(59, 'Captain America: Brave New World', 'movie', 5, '2026', 0),
(60, 'Thunderbolts', 'movie', 5, '2027', 0),
(61, 'Spider-Man: Brand New Day', 'movie', 6, '2028', 0),
(62, 'Avengers: Doomsday', 'movie', 6, '2028', 0),
(63, 'Avengers: Secret Wars', 'movie', 6, '...', 0);

UPDATE items SET franchise = CASE
  WHEN title = 'Blade' THEN 'Blade'
  WHEN title LIKE 'X-Men%' OR title = 'The Wolverine' THEN 'X-Men'
  WHEN title LIKE 'Spiderman%' OR title LIKE 'Spider-Man%' OR title LIKE 'Venom%' THEN 'Spiderman'
  WHEN title LIKE 'Deadpool%' THEN 'Deadpool'
  ELSE 'MCU'
END;
