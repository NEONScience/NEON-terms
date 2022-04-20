
##############################################################################################
#' @title Read Terms Database Script

#' @author 
#' Kaelin M. Cawley \email{kcawley@battelleecology.org} \cr

#' @description This script loads an R workspace of the units tables from the NEON terms 
#' database and converts them to rdf triples to create an ontology.

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

#' @keywords ontology, terms, units

#' @examples
#' #TBD

# changelog and author contributions / copyrights
#   Kaelin M. Cawley (2021-01-07)
#     original creation
##############################################################################################

if(file.exists("C:/Users/kcawley")){
  wdir <- "~/GitHub/NEON-terms/sandbox/"
}

setwd(wdir)

load(paste0(wdir,"shinyUnitTables.RData"))

# # From https://cran.r-project.org/web/packages/rdflib/vignettes/rdf_intro.html
library(rdflib)
library(dplyr)
library(tidyr)
library(tibble)
library(jsonld)

# # Write out a table of triples
unit_triples <-
  unitType %>%
  gather(attribute, measurement, -unitTypeID)

# Initialize the rdf object
rdf <- rdflib::rdf()

#Add a triple to the rdf object
prefix <- "NEON:" #Use this to create a unique URI

rdf %>% rdf_add(subject = paste0(prefix,unit_triples$unitTypeID[1]),
                predicate = paste0(prefix,unit_triples$attribute[1]),
                object = paste0(prefix,unit_triples$measurement[1]))

rdf

# From https://docs.ropensci.org/rdflib/articles/articles/data-lake.html

# ## Data 
# library(nycflights13)
# library(repurrrsive)
# 
## for comparison approaches
library(dplyr)
library(purrr)
library(jsonlite)

## Our focal package:
library(rdflib)
## experimental functions for rdflib package
#source(system.file("examples/tidy_schema.R", package="rdflib"))

rdf <- rdf(storage = "BDB", new_db = TRUE)

# df <- flights %>% 
#   left_join(airlines) %>%
#   left_join(planes, by="tailnum") %>% 
#   select(carrier, name, manufacturer, model) %>% 
#   distinct()
# head(df)

uri_unit <- unit %>%
  mutate()

uri_unitType <- unitType %>%
  mutate()

uri_unitTypeBase <- unitTypeBase %>%
  mutate()

system.time({
  write_nquads(uri_unit,  "unit.nq", key = "unitType", prefix = "unit:")
  write_nquads(uri_unitType,  "unitType.nq", key = "unitTypeID", prefix = "unitType:")
  write_nquads(uri_unitTypeBase,  "unitTypeBase.nq", prefix = "unitTypeBase:")
})

system.time({
  read_nquads("unit.nq", rdf = rdf)
  read_nquads("unitType.nq", rdf = rdf)
  read_nquads("unitTypeBase.nq", rdf = rdf)
})

rdf_serialize(rdf, "test_units.rdf", format = "rdfxml")

# s <- 
#   'SELECT  ?carrier ?name ?manufacturer ?model ?dep_delay
# WHERE {
# ?flight <flights:tailnum>  ?tailnum .
# ?flight <flights:carrier>  ?carrier .
# ?flight <flights:dep_delay>  ?dep_delay .
# ?tailnum <planes:manufacturer> ?manufacturer .
# ?tailnum <planes:model> ?model .
# ?carrier <airlines:name> ?name
# }'
# 
# system.time(
#   df <- rdf_query(rdf, s)
# )
# 
# head(df)
# 
# uri_flights <- flights %>% 
#   mutate(tailnum = paste0("planes:", tailnum),
#          carrier = paste0("airlines:", carrier))
# 
# system.time({
#   write_nquads(airlines,  "airlines.nq", key = "carrier", prefix = "airlines:")
#   write_nquads(planes,  "planes.nq", key = "tailnum", prefix = "planes:")
#   write_nquads(uri_flights,  "flights.nq", prefix = "flights:")
# })
# 
# system.time({
#   read_nquads("airlines.nq", rdf = rdf)
#   read_nquads("flights.nq", rdf = rdf)
#   read_nquads("planes.nq", rdf = rdf)
#   
# })
# 
# s <- 
#   'SELECT  ?carrier ?name ?manufacturer ?model ?dep_delay
# WHERE {
# ?flight <flights:tailnum>  ?tailnum .
# ?flight <flights:carrier>  ?carrier .
# ?flight <flights:dep_delay>  ?dep_delay .
# ?tailnum <planes:manufacturer> ?manufacturer .
# ?tailnum <planes:model> ?model .
# ?carrier <airlines:name> ?name
# }'
# 
# system.time(
#   df <- rdf_query(rdf, s)
# )
# 
# head(df)
# 
# rdf_serialize(rdf, "test_planes.rdf", format = "rdfxml")
# 
# 
