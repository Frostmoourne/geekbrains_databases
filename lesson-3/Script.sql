
DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(150),
	
	INDEX video_names(name)
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS music;
CREATE TABLE music (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	artist_name VARCHAR(255),
	track_name VARCHAR(255),

	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS flagged_media;
CREATE TABLE flagged_media (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW()

	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);