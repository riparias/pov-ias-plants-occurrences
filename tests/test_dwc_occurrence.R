# load libraries
library(testthat)
library(readr)
library(dplyr)

# read proposed new version of the DwC mapping
occs_path <- here::here("data", "processed", "occurrence.csv")
dwc_occurrence <- readr::read_csv(occs_path, guess_max = 10000)

# tests
testthat::test_that("Right columns in right order", {
  columns <- c(
    "type",
    "language",
    "license",
    "rightsHolder",
    "datasetID",
    "institutionCode",
    "datasetName",
    "basisOfRecord",
    "samplingProtocol",
    "identificationVerificationStatus",
    "occurrenceID",
    "occurrenceStatus",
    "organismQuantity",
    "organismQuantityType",
    "eventDate",
    "countryCode",
    "decimalLatitude",
    "decimalLongitude",
    "geodeticDatum",
    "coordinateUncertaintyInMeters",
    "verbatimLatitude",
    "verbatimLongitude",
    "verbatimCoordinateSystem",
    "verbatimSRS",
    "scientificName",
    "kingdom",
    "taxonRank",
    "vernacularName"
  )
  testthat::expect_equal(names(dwc_occurrence), columns)
})

testthat::test_that("datasetID is always present and is equal to DOI dataset", {
  testthat::expect_true(all(!is.na(dwc_occurrence$datasetID)))
  testthat::expect_equal(unique(dwc_occurrence$datasetID),
                         "https://doi.org/10.15468/29cggt")
})

testthat::test_that("occurrenceID is always present and is unique", {
  testthat::expect_true(all(!is.na(dwc_occurrence$occurrenceID)))
  testthat::expect_equal(length(unique(dwc_occurrence$occurrenceID)),
                         nrow(dwc_occurrence))
})

testthat::test_that("All data are verified by experts", {
  testthat::expect_true(all(!is.na(dwc_occurrence$identificationVerificationStatus)))
  testthat::expect_equal(length(unique(dwc_occurrence$identificationVerificationStatus)),
                         1)
  testthat::expect_equal(unique(dwc_occurrence$identificationVerificationStatus),
                         "verified by experts")
})

testthat::test_that("samplingProtocol is always Casual Observation", {
  testthat::expect_equal(
    dwc_occurrence %>%
      dplyr::distinct(samplingProtocol) %>%
      dplyr::pull(samplingProtocol),
    "casual observation"
  )
})

testthat::test_that(
  "organismQuantity is always an integer greater than 0 if present", {
    organismQuantity_values <-
      dwc_occurrence %>%
      dplyr::filter(!is.na(organismQuantity)) %>%
      dplyr::distinct(organismQuantity) %>%
      dplyr::pull(organismQuantity)
    testthat::expect_equal(
      as.numeric(organismQuantity_values), as.integer(organismQuantity_values)
    )
})

testthat::test_that(
  "an organismQuantity must have a corresponding organismQuantityType", {
    organismQuantityType_values <-
      dwc_occurrence %>%
      dplyr::filter(!is.na(organismQuantity)) %>%
      dplyr::distinct(organismQuantityType) %>%
      dplyr::pull(organismQuantityType)
    testthat::expect_true(all(!is.na(organismQuantityType_values)))
  })

testthat::test_that(
  "organismQuantityType is one of the predefined values if not NA", {
    values <- c("coverage in m²") # other value, individuals, doesn't occur yet
    organismQuantityType_values <-
      dwc_occurrence %>%
      dplyr::filter(!is.na(organismQuantityType)) %>%
      dplyr::distinct(organismQuantityType) %>%
      dplyr::pull(organismQuantityType)
    testthat::expect_true(all(organismQuantityType_values %in% values))
  })

testthat::test_that("coordinates and uncertainties are always filled in", {
  # decimalLatitude
  testthat::expect_true(
    all(!is.na(dwc_occurrence$decimalLatitude))
  )
  # decimalLongitude
  testthat::expect_true(
    all(!is.na(dwc_occurrence$decimalLongitude))
  )
  # verbatimLatitude
  testthat::expect_true(
    all(!is.na(dwc_occurrence$verbatimLatitude))
  )
  # verbatimLongitude
  testthat::expect_true(
    all(!is.na(dwc_occurrence$verbatimLongitude))
  )
  # coordinateUncertaintyInMeters
  testthat::expect_true(
    all(!is.na(dwc_occurrence$coordinateUncertaintyInMeters))
  )
})

testthat::test_that("decimalLatitude is within Flemish boundaries", {
  testthat::expect_true(all(dwc_occurrence$decimalLatitude < 51.65))
  testthat::expect_true(all(dwc_occurrence$decimalLatitude > 50.63))
})

testthat::test_that("decimalLongitude is within Flemish boundaries", {
  testthat::expect_true(all(dwc_occurrence$decimalLongitude < 5.95))
  testthat::expect_true(all(dwc_occurrence$decimalLongitude > 2.450))
})

testthat::test_that("verbatimLongitude is always a positive integer", {
  testthat::expect_true(
    all(dwc_occurrence$verbatimLongitude == as.integer(dwc_occurrence$verbatimLongitude))
  )
})

testthat::test_that("verbatimLatitude is always a positive integer", {
  testthat::expect_true(
    all(dwc_occurrence$verbatimLatitude == as.integer(dwc_occurrence$verbatimLatitude))
  )
})

testthat::test_that("eventDate is always filled in", {
  testthat::expect_true(all(!is.na(dwc_occurrence$eventDate)))
})

testthat::test_that("scientificName is never NA and one of the list", {
  species <- c(
    "Cabomba caroliniana",
    "Eichhornia crassipes",
    "Elodea nuttallii",
    "Eriocheir sinensis",
    "Gunnera tinctoria",
    "Heracleum mantegazzianum",
    "Hydrocotyle ranunculoides",
    "Impatiens glandulifera",
    "Lagarosiphon major",
    "Lithobates catesbeianus",
    "Ludwigia grandiflora",
    "Ludwigia peploides subsp. montevidensis",
    "Lysichiton americanus",
    "Microstegium vimineum",
    "Myriophyllum aquaticum",
    "Myriophyllum heterophyllum",
    "Trachemys scripta",
    "Ailanthus altissima",
    "Robinia",
    "Lepomis gibbosus",
    "Reynoutria",
    "Crassula helmsii",
    "Prunus serotina",
    "Fargesia",
    "Lamium galeobdolon subsp. argentatum",
    "Solidago canadensis",
    "Rhus typhina",
    "Rosa rugosa",
    "Rosa multiflora",
    "Phytolacca americana",
    "Helianthus tuberosus",
    "Fallopia  baldschuanica",
    "Azolla filiculoides",
    "Harmonia axyridis",
    "Pistia statiotes",
    "Zizania latifolia",
    "Saururus cernuus",
    "Salvinia molesta",
    "Pistia stratiotes",
    "Aponogeton distachyos",
    "Petasites japonicus"
  )
  testthat::expect_true(all(!is.na(dwc_occurrence$scientificName)))
  testthat::expect_true(all(dwc_occurrence$scientificName %in% species))
})

testthat::test_that("kingdom is always equal to Plantae or Animalia", {
  testthat::expect_true(all(!is.na(dwc_occurrence$kingdom)))
  testthat::expect_true(
    all(dwc_occurrence$kingdom %in% c("Plantae", "Animalia"))
  )
})

testthat::test_that("taxonRank is always filled in and one of the list", {
  taxon_ranks <- c("genus", "species", "subspecies")
  testthat::expect_true(all(!is.na(dwc_occurrence$taxonRank)))
  testthat::expect_true(
    all(dwc_occurrence$taxonRank %in% taxon_ranks)
  )
})

testthat::test_that(
  "vernacularName is one of the list and NA only for specific cases", {
    vernacular_names <- c(
      "waterwaaier",
      "waterhyacint",
      "smalle waterpest",
      "Chinese wolhandkrab",
      "gewone gunnera",
      "reuzenberenklauw",
      "grote waternavel",
      "reuzenbalsemien",
      "ruwe waterpest",
      "Amerikaanse stierkikker",
      "waterteunisbloem",
      "postelein-waterlepeltje",
      "moerasaronskelk",
      "Japans steltgras",
      "parelvederkruid",
      "ongelijkbladig vederkruid",
      "lettersierschildpad",
      "hemelboom",
      "robinia",
      "zonnebaars",
      "watercrassula",
      "Amerikaanse vogelkers",
      "bonte gele dovenetel",
      "Canadese guldenroede",
      "fluweelboom",
      "rimpelroos",
      "veelbloemige roos",
      "westerse karmozijnbes",
      "aardpeer",
      "Chinese bruidssluier",
      "grote kroosvaren",
      "veelkleurig Aziatisch lieveheersbeestje",
      "Mantsjoerese wilde rijst",
      "Leidse plant",
      "grote vlotvaren",
      "watersla",
      "Kaapse waterlelie",
      "Japans hoefblad"
    )
    species_to_exclude <- c("Fargesia", "Reynoutria")
    occs_with_valid_vernacular_names <-
      dwc_occurrence %>%
      dplyr::filter(!scientificName %in% species_to_exclude)
    testthat::expect_true(
      all(!is.na(occs_with_valid_vernacular_names$vernacularName))
    )
    testthat::expect_true(
      all(occs_with_valid_vernacular_names$vernacularName %in% vernacular_names)
    )
})
