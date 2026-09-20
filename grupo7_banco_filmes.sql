-- Banco de dados do Projeto Grupo 7
-- MySQL 8.0+
CREATE DATABASE IF NOT EXISTS filmae
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE filmae;

CREATE TABLE usuario (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  email VARCHAR(254) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE filmes (
  tconst VARCHAR(20) PRIMARY KEY,
  title_type VARCHAR(30) NOT NULL,
  primary_title TEXT NOT NULL,
  original_title TEXT NOT NULL,
  is_adult BOOLEAN NOT NULL,
  start_year SMALLINT NULL,
  end_year SMALLINT NULL,
  runtime_minutes SMALLINT NULL,
  genres JSON NULL
);

CREATE TABLE pessoas (
  nconst VARCHAR(20) PRIMARY KEY,
  primary_name VARCHAR(255) NOT NULL,
  birth_year SMALLINT NULL,
  death_year SMALLINT NULL,
  primary_profession JSON NULL,
  known_for_titles JSON NULL
);

CREATE TABLE avaliacoes_filmes (
  tconst VARCHAR(20) PRIMARY KEY,
  average_rating DECIMAL(3,1) NOT NULL,
  num_votes INT UNSIGNED NOT NULL,
  CONSTRAINT fk_avaliacoes_filme
    FOREIGN KEY (tconst) REFERENCES filmes(tconst)
);

CREATE TABLE titulos_alternativos (
  title_id VARCHAR(20) NOT NULL,
  ordering SMALLINT UNSIGNED NOT NULL,
  title TEXT NOT NULL,
  region VARCHAR(10) NULL,
  language VARCHAR(10) NULL,
  types JSON NULL,
  attributes JSON NULL,
  is_original_title BOOLEAN NOT NULL,
  PRIMARY KEY (title_id, ordering),
  CONSTRAINT fk_akas_filme
    FOREIGN KEY (title_id) REFERENCES filmes(tconst)
);

CREATE TABLE equipe_filme (
  tconst VARCHAR(20) PRIMARY KEY,
  directors JSON NULL,
  writers JSON NULL,
  CONSTRAINT fk_crew_filme
    FOREIGN KEY (tconst) REFERENCES filmes(tconst)
);

CREATE TABLE episodios (
  tconst VARCHAR(20) PRIMARY KEY,
  parent_tconst VARCHAR(20) NOT NULL,
  season_number SMALLINT UNSIGNED NULL,
  episode_number SMALLINT UNSIGNED NULL,
  CONSTRAINT fk_episode_filme
    FOREIGN KEY (tconst) REFERENCES filmes(tconst),
  CONSTRAINT fk_episode_parent
    FOREIGN KEY (parent_tconst) REFERENCES filmes(tconst)
);

CREATE TABLE principais_filme (
  tconst VARCHAR(20) NOT NULL,
  ordering SMALLINT UNSIGNED NOT NULL,
  nconst VARCHAR(20) NOT NULL,
  category VARCHAR(50) NOT NULL,
  job VARCHAR(255) NULL,
  characters JSON NULL,
  PRIMARY KEY (tconst, ordering),
  CONSTRAINT fk_principals_filme
    FOREIGN KEY (tconst) REFERENCES filmes(tconst),
  CONSTRAINT fk_principals_pessoa
    FOREIGN KEY (nconst) REFERENCES pessoas(nconst)
);

CREATE TABLE usuario_filmes_assistidos (
  usuario_id BIGINT UNSIGNED NOT NULL,
  tconst VARCHAR(20) NOT NULL,
  watched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usuario_id, tconst),
  CONSTRAINT fk_assistidos_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
  CONSTRAINT fk_assistidos_filme
    FOREIGN KEY (tconst) REFERENCES filmes(tconst) ON DELETE CASCADE
);

CREATE TABLE usuario_filmes_espera (
  usuario_id BIGINT UNSIGNED NOT NULL,
  tconst VARCHAR(20) NOT NULL,
  added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usuario_id, tconst),
  CONSTRAINT fk_espera_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
  CONSTRAINT fk_espera_filme
    FOREIGN KEY (tconst) REFERENCES filmes(tconst) ON DELETE CASCADE
);

CREATE INDEX idx_filmes_primary_title ON filmes(primary_title(100));
CREATE INDEX idx_filmes_start_year ON filmes(start_year);
CREATE INDEX idx_pessoas_primary_name ON pessoas(primary_name(100));
CREATE INDEX idx_principals_nconst ON principais_filme(nconst);
CREATE INDEX idx_episode_parent ON episodios(parent_tconst);
