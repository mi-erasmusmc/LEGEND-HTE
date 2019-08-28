library(shiny)
library(DT)
library(tidyverse)

source("helper.R")

exposures <- readRDS("data/exposures.rds")
databases <- readRDS("data/databases.rds")
outcomes <- readRDS("data/map.rds")
analyses <- readRDS("data/analyses.rds")
indications <- readRDS("data/indications.rds")

