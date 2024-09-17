BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "notices" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notices" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "text" text NOT NULL,
    "path" text NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notices"
    ADD CONSTRAINT "notices_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR talking_noticeboard
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('talking_noticeboard', '20240917123901203', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240917123901203', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
