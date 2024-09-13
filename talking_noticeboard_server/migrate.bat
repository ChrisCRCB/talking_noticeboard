@echo off
cls & serverpod create-migration & dart bin\main.dart --apply-migrations --role=maintenance & title Server