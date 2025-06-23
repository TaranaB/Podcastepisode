
-- ========================================================
-- PODCAST EPISODE CMS PROJECT (Database: podcast_episode_cms1)
-- Developed for DevifyX MySQL Assignment | Author: [Tarana Bagotia]
-- ========================================================

-- Step 1: Create Database
CREATE DATABASE podcast_episode_cms1;
USE podcast_episode_cms1;

-- Step 2: Create Table - Podcast Shows
CREATE TABLE podcast_shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    host_name VARCHAR(200) NOT NULL
);

-- Step 3: Create Table - Episodes
CREATE TABLE episodes (
    episode_id INT AUTO_INCREMENT PRIMARY KEY,
    show_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    release_date DATE,
    duration_minutes INT,
    audio_file_url VARCHAR(500),
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    transcript TEXT,
    play_count INT DEFAULT 0,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (show_id) REFERENCES podcast_shows(show_id)
);

-- Step 4: Create Table - Categories
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE episode_categories (
    episode_id INT,
    category_id INT,
    PRIMARY KEY (episode_id, category_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Step 5: Create Table - Tags
CREATE TABLE tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE episode_tags (
    episode_id INT,
    tag_id INT,
    PRIMARY KEY (episode_id, tag_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

-- Step 6: Create Table - Guests
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT
);

CREATE TABLE episode_guests (
    episode_id INT,
    guest_id INT,
    PRIMARY KEY (episode_id, guest_id),
    FOREIGN KEY (episode_id) REFERENCES episodes(episode_id),
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
);

-- Step 7: Create Table - Users 
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin', 'editor', 'viewer') DEFAULT 'viewer',
    can_edit BOOLEAN DEFAULT FALSE
);

-- DATA INSERTS


-- Insert Podcast Shows
INSERT INTO podcast_shows (title, description, host_name) VALUES
('Tech Pulse', 'Weekly tech industry updates', 'Arjun Mehta'),
('Daily Zen', 'Mindfulness and meditation podcast', 'Tara Singh');

-- Insert Episodes with audio URLs
INSERT INTO episodes (show_id, title, description, release_date, duration_minutes, audio_file_url, status, transcript, play_count)
VALUES
(1, 'AI Trends 2025', 'Predictions and analysis', '2025-06-01', 40, 'http://audio.com/ai2025.mp3', 'published', 'Transcript content here...', 320),
(2, 'Morning Meditation', '5 min guided breathing', '2025-06-02', 5, 'http://audio.com/morning.mp3', 'published', 'Breathing and silence...', 880);

-- Insert Categories
INSERT INTO categories (name) VALUES ('Technology'), ('Health'), ('Mindfulness');

-- Insert Tags
INSERT INTO tags (name) VALUES ('AI'), ('Startup'), ('Relax'), ('Calm');

-- Insert Guests
INSERT INTO guests (name, bio) VALUES 
('Dr. Anita Rao', 'AI researcher at Stanford'),
('Lama Tenzin', 'Buddhist monk and speaker');

-- Insert Episode-Category Mapping
INSERT INTO episode_categories VALUES 
(1, 1), (2, 2), (2, 3);

-- Insert Episode-Tag Mapping
INSERT INTO episode_tags VALUES 
(1, 1), (1, 2), (2, 3), (2, 4);

-- Insert Episode-Guest Mapping
INSERT INTO episode_guests VALUES 
(1, 1), (2, 2);

-- Insert Users
INSERT INTO users (username, role, can_edit) VALUES
('admin_user', 'admin', TRUE),
('editor_user', 'editor', TRUE),
('viewer_user', 'viewer', FALSE);

-- SAMPLE SELECT & UPDATE QUERIES 


-- 1. Get all episodes with "AI" in the title
SELECT * FROM episodes WHERE title LIKE '%AI%';

-- 2. List all published episodes that are not soft deleted
SELECT * FROM episodes WHERE status = 'published' AND is_deleted = FALSE;

-- 3. Retrieve the multilingual metadata for episode 1
SELECT * FROM episode_languages WHERE episode_id = 1;

-- 4. Get all episodes under the 'Mindfulness' category
SELECT e.title
FROM episodes e
JOIN episode_categories ec ON e.episode_id = ec.episode_id
JOIN categories c ON c.category_id = ec.category_id
WHERE c.name = 'Mindfulness';

-- 5. Get all episodes tagged with 'AI'
SELECT e.title
FROM episodes e
JOIN episode_tags et ON e.episode_id = et.episode_id
JOIN tags t ON t.tag_id = et.tag_id
WHERE t.name = 'AI';

-- 6. Show all guests and their corresponding episode titles
SELECT g.name AS guest, e.title AS episode
FROM guests g
JOIN episode_guests eg ON g.guest_id = eg.guest_id
JOIN episodes e ON e.episode_id = eg.episode_id;

-- 7. View all users who can edit content
SELECT username, role FROM users WHERE can_edit = TRUE;

-- 8. Simulate a new play (download) for episode 1
UPDATE episodes SET play_count = play_count + 1 WHERE episode_id = 1;

-- 9. Soft delete an episode (mark as deleted, do not remove from DB)
UPDATE episodes SET is_deleted = TRUE WHERE episode_id = 2;

-- 10. Retrieve all soft-deleted episodes
SELECT * FROM episodes WHERE is_deleted = TRUE;


-- INDEXING FOR PERFORMANCE


CREATE INDEX idx_episode_title ON episodes(title);
CREATE INDEX idx_category_name ON categories(name);
CREATE INDEX idx_tag_name ON tags(name);
CREATE INDEX idx_guest_name ON guests(name);
CREATE INDEX idx_username ON users(username);
