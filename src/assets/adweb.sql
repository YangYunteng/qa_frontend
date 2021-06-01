/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80021
 Source Host           : localhost:3306
 Source Schema         : adweb

 Target Server Type    : MySQL
 Target Server Version : 80021
 File Encoding         : 65001

 Date: 25/05/2021 20:27:09
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for answer_likes
-- ----------------------------
DROP TABLE IF EXISTS `answer_likes`;
CREATE TABLE `answer_likes`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `answer_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_answer_idx`(`answer_id`, `user_id`) USING BTREE,
  INDEX `idx_answer_likes_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_answer_likes_user`(`user_id`) USING BTREE,
  CONSTRAINT `fk_answer_likes_answer` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_answer_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for answers
-- ----------------------------
DROP TABLE IF EXISTS `answers`;
CREATE TABLE `answers`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `question_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `answerer_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_answers_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_answers_question`(`question_id`) USING BTREE,
  INDEX `fk_answers_answerer`(`answerer_id`) USING BTREE,
  CONSTRAINT `fk_answers_answerer` FOREIGN KEY (`answerer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_answers_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comment_likes
-- ----------------------------
DROP TABLE IF EXISTS `comment_likes`;
CREATE TABLE `comment_likes`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `comment_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_comment_idx`(`comment_id`, `user_id`) USING BTREE,
  INDEX `idx_comment_likes_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_comment_likes_user`(`user_id`) USING BTREE,
  CONSTRAINT `fk_comment_likes_answer` FOREIGN KEY (`comment_id`) REFERENCES `answers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_comment_likes_comment` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_comment_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `from_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `to_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `answer_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_comments_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_comments_from`(`from_id`) USING BTREE,
  INDEX `fk_comments_to`(`to_id`) USING BTREE,
  INDEX `fk_comments_answer`(`answer_id`) USING BTREE,
  CONSTRAINT `fk_comments_answer` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_comments_from` FOREIGN KEY (`from_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_comments_to` FOREIGN KEY (`to_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for question_follows
-- ----------------------------
DROP TABLE IF EXISTS `question_follows`;
CREATE TABLE `question_follows`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `question_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_question_idx`(`question_id`, `user_id`) USING BTREE,
  INDEX `idx_question_follows_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_question_follows_user`(`user_id`) USING BTREE,
  CONSTRAINT `fk_question_follows_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_question_follows_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `questioner_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_questions_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_questions_questioner`(`questioner_id`) USING BTREE,
  FULLTEXT INDEX `idx_questions_title`(`title`) WITH PARSER `ngram`,
  CONSTRAINT `fk_questions_questioner` FOREIGN KEY (`questioner_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `user_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `granter_id` bigint(0) UNSIGNED NULL DEFAULT NULL,
  `type` tinyint(0) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_roles_deleted_at`(`deleted_at`) USING BTREE,
  INDEX `fk_roles_user`(`user_id`) USING BTREE,
  INDEX `fk_roles_granter`(`granter_id`) USING BTREE,
  CONSTRAINT `fk_roles_granter` FOREIGN KEY (`granter_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) NULL DEFAULT NULL,
  `updated_at` datetime(3) NULL DEFAULT NULL,
  `deleted_at` datetime(3) NULL DEFAULT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `password` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `nickname` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `gender` tinyint(0) UNSIGNED NULL DEFAULT NULL,
  `email` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `idx_users_username`(`username`) USING BTREE,
  INDEX `idx_users_deleted_at`(`deleted_at`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
