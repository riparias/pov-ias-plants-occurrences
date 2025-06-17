/*
Created by Damiano Oldoni (INBO)
*/

SELECT
-- RECORD-LEVEL
  'Event'                               AS type,
  'en'                                  AS language,
  'https://creativecommons.org/licenses/by/4.0/legalcode' AS license,
  'POV'                                 AS rightsHolder,
  'https://doi.org/10.15468/29cggt'     AS datasetID,
  'POV'                                 AS institutionCode,
  'Monitoring of invasive alien species by the Province East Flanders, Belgium' AS datasetName,
  'HumanObservation'                    AS basisOfRecord,
  o."SamplingProtocol"                  AS samplingProtocol, -- casual observation
-- IDENTIFICATION
  CASE
    WHEN o."ValidationStatus" = 'approved by experts' THEN 'verified by experts'
    ELSE NULL
  END                                   AS identificationVerificationStatus,
-- OCCURRENCE
  o."ObservationIdentifier"             AS occurrenceID,
  'present'                             AS occurrenceStatus,
    CASE
    WHEN o."QuantificationOfInvasion" > 0 THEN o."QuantificationOfInvasion"
    ELSE NULL
  END                                   AS organismQuantity,
  CASE
    WHEN o."QuantificationOfInvasion" > 0 AND o."QuantificationUnit" = 'm²' THEN 'coverage in ' || o."QuantificationUnit"
    -- this is at the moment never the case
    WHEN o."QuantificationOfInvasion" > 0 AND o."QuantificationUnit" = 'Individuals' THEN 'individuals'
    ELSE NULL
  END                                   AS organismQuantityType,
/*
  CASE
    WHEN o."QuantificationOfInvasion" > 0 AND o."QuantificationUnit" = 'Individuals' THEN o."QuantificationOfInvasion"
    ELSE NULL
  END                                   AS individualCount, -- at the moment individualCount is never filled in
*/
  date(o."DateOfObservation")           AS eventDate,
  -- LOCATION
  'BE'                                  AS countryCode,
  printf('%.5f', ROUND(o."Y", 5))       AS decimalLatitude,
  printf('%.5f', ROUND(o."X", 5))       AS decimalLongitude,
  'WGS84'                               AS geodeticDatum,
  CASE
    WHEN o."CoordinateUncertainty" IS NULL THEN 30
    ELSE o."CoordinateUncertainty"
  END                                   AS coordinateUncertaintyInMeters,
  CAST(o."YLambert72" AS INT)           AS verbatimLatitude,
  CAST(o."XLambert72" AS INT)           AS verbatimLongitude,
  'Lambert coordinates'                 AS verbatimCoordinateSystem,
  'EPSG:31370'                          AS verbatimSRS,
-- TAXON
  CASE
    WHEN o."ScientificName" = 'Cabomba caroliniana' THEN 'Cabomba caroliniana'
    WHEN o."ScientificName" = 'Eichhornia crassipes' THEN 'Eichhornia crassipes'
    WHEN o."ScientificName" = 'Elodea nuttallii' THEN 'Elodea nuttallii'
    WHEN o."ScientificName" = 'Eriocheir sinensis' THEN 'Eriocheir sinensis'
    WHEN o."ScientificName" = 'Gunnera tinctoria' THEN 'Gunnera tinctoria'
    WHEN o."ScientificName" = 'Heracleum mantegazzianum' THEN 'Heracleum mantegazzianum'
    WHEN o."ScientificName" = 'Hydrocotyle ranunculoides' THEN 'Hydrocotyle ranunculoides'
    WHEN o."ScientificName" = 'Impatiens glandulifera' THEN 'Impatiens glandulifera'
    WHEN o."ScientificName" = 'Lagarosiphon major' THEN 'Lagarosiphon major'
    WHEN o."ScientificName" = 'Lithobates catesbeianus' THEN 'Lithobates catesbeianus'
    WHEN o."ScientificName" = 'Ludwigia grandiflora' THEN 'Ludwigia grandiflora'
    WHEN o."ScientificName" = 'Ludwigia peploides montevidensis' THEN 'Ludwigia peploides subsp. montevidensis'
    WHEN o."ScientificName" = 'Lysichiton americanus' THEN 'Lysichiton americanus'
    WHEN o."ScientificName" = 'Microstegium vimineum' THEN 'Microstegium vimineum'
    WHEN o."ScientificName" = 'Myriophyllum aquaticum' THEN 'Myriophyllum aquaticum'
    WHEN o."ScientificName" = 'Myriophyllum heterophyllum' THEN 'Myriophyllum heterophyllum'
    WHEN o."ScientificName" = 'Trachemys scripta' THEN 'Trachemys scripta'
    WHEN o."ScientificName" = 'Ailanthus altissima' THEN 'Ailanthus altissima'
    WHEN o."ScientificName" = 'Robinia spec.' THEN 'Robinia'
    WHEN o."ScientificName" = 'Lepomis gibbosus' THEN 'Lepomis gibbosus'
    WHEN o."ScientificName" = 'Fallopia / Reynoutria' THEN 'Reynoutria'
    WHEN o."ScientificName" = 'Crassula helmsii' THEN 'Crassula helmsii'
    WHEN o."ScientificName" = 'Prunus Serotina' THEN 'Prunus serotina'
    WHEN o."ScientificName" = 'Fargesia' THEN 'Fargesia'
    WHEN o."ScientificName" = 'Lamium galeobdolon subsp. argentatum' THEN 'Lamium galeobdolon subsp. argentatum'
    WHEN o."ScientificName" = 'Solidago canadensis' THEN 'Solidago canadensis'
    WHEN o."ScientificName" = 'Rhus typhina' THEN 'Rhus typhina'
    WHEN o."ScientificName" = 'Rosa rugosa' THEN 'Rosa rugosa'
    WHEN o."ScientificName" = 'Rosa multiflora' THEN 'Rosa multiflora'
    WHEN o."ScientificName" = 'Phytolacca americana' THEN 'Phytolacca americana'
    WHEN o."ScientificName" = 'Helianthus tuberosus' THEN 'Helianthus tuberosus'
    WHEN o."ScientificName" = 'Fallopia  baldschuanica' THEN 'Fallopia  baldschuanica'
    WHEN o."ScientificName" = 'Azolla filiculoides' THEN 'Azolla filiculoides'
    WHEN o."ScientificName" = 'Harmonia axyridis' THEN 'Harmonia axyridis'
    WHEN o."ScientificName" = 'Pistia statiotes' THEN 'Pistia statiotes'
    WHEN o."ScientificName" = 'Zizania latifolia' THEN 'Zizania latifolia'
    WHEN o."ScientificName" = 'Saururus cernuus' THEN 'Saururus cernuus'
    WHEN o."ScientificName" = 'Salvinia molesta' THEN 'Salvinia molesta'
    WHEN o."ScientificName" = 'Pistia stratiotes' THEN 'Pistia stratiotes'
    WHEN o."ScientificName" = 'Aponogeton distachyos' THEN 'Aponogeton distachyos'
    WHEN o."ScientificName" = 'Petasites japonicus' THEN 'Petasites japonicus'
    ELSE NULL
  END                                   AS scientificName,
  o."Kingdom"                           AS kingdom,
  CASE
    WHEN o."ScientificName" = 'Cabomba caroliniana' THEN 'species'
    WHEN o."ScientificName" = 'Eichhornia crassipes' THEN 'species'
    WHEN o."ScientificName" = 'Elodea nuttallii' THEN 'species'
    WHEN o."ScientificName" = 'Eriocheir sinensis' THEN 'species'
    WHEN o."ScientificName" = 'Gunnera tinctoria' THEN 'species'
    WHEN o."ScientificName" = 'Heracleum mantegazzianum' THEN 'species'
    WHEN o."ScientificName" = 'Hydrocotyle ranunculoides' THEN 'species'
    WHEN o."ScientificName" = 'Impatiens glandulifera' THEN 'species'
    WHEN o."ScientificName" = 'Lagarosiphon major' THEN 'species'
    WHEN o."ScientificName" = 'Lithobates catesbeianus' THEN 'species'
    WHEN o."ScientificName" = 'Ludwigia grandiflora' THEN 'species'
    WHEN o."ScientificName" = 'Ludwigia peploides montevidensis' THEN 'subspecies'
    WHEN o."ScientificName" = 'Lysichiton americanus' THEN 'species'
    WHEN o."ScientificName" = 'Microstegium vimineum' THEN 'species'
    WHEN o."ScientificName" = 'Myriophyllum aquaticum' THEN 'species'
    WHEN o."ScientificName" = 'Myriophyllum heterophyllum' THEN 'species'
    WHEN o."ScientificName" = 'Trachemys scripta' THEN 'species'
    WHEN o."ScientificName" = 'Ailanthus altissima' THEN 'species'
    WHEN o."ScientificName" = 'Robinia spec.' THEN 'genus'
    WHEN o."ScientificName" = 'Lepomis gibbosus' THEN 'species'
    WHEN o."ScientificName" = 'Fallopia / Reynoutria' THEN 'genus'
    WHEN o."ScientificName" = 'Crassula helmsii' THEN 'species'
    WHEN o."ScientificName" = 'Prunus Serotina' THEN 'species'
    WHEN o."ScientificName" = 'Fargesia' THEN 'genus'
    WHEN o."ScientificName" = 'Lamium galeobdolon subsp. argentatum' THEN 'subspecies'
    WHEN o."ScientificName" = 'Solidago canadensis' THEN 'species'
    WHEN o."ScientificName" = 'Rhus typhina' THEN 'species'
    WHEN o."ScientificName" = 'Rosa rugosa' THEN 'species'
    WHEN o."ScientificName" = 'Rosa multiflora' THEN 'species'
    WHEN o."ScientificName" = 'Phytolacca americana' THEN 'species'
    WHEN o."ScientificName" = 'Helianthus tuberosus' THEN 'species'
    WHEN o."ScientificName" = 'Fallopia  baldschuanica' THEN 'species'
    WHEN o."ScientificName" = 'Azolla filiculoides' THEN 'species'
    WHEN o."ScientificName" = 'Harmonia axyridis' THEN 'species'
    WHEN o."ScientificName" = 'Pistia statiotes' THEN 'species'
    WHEN o."ScientificName" = 'Zizania latifolia' THEN 'species'
    WHEN o."ScientificName" = 'Saururus cernuus' THEN 'species'
    WHEN o."ScientificName" = 'Salvinia molesta' THEN 'species'
    WHEN o."ScientificName" = 'Pistia stratiotes' THEN 'species'
    WHEN o."ScientificName" = 'Aponogeton distachyos' THEN 'species'
    WHEN o."ScientificName" = 'Petasites japonicus' THEN 'species'
    ELSE NULL
  END                                   AS taxonRank,
  CASE
    WHEN o."DutchName" = 'Waterwaaier' THEN 'waterwaaier'
    WHEN o."DutchName" = 'Waterhyacint' THEN 'waterhyacint'
    WHEN o."DutchName" = 'Smalle waterpest' THEN 'smalle waterpest'
    WHEN o."DutchName" = 'Chinese wolhandkrab' THEN 'Chinese wolhandkrab'
    WHEN o."DutchName" = 'Gewone gunnera (reuzenrabarber)' THEN 'gewone gunnera'
    WHEN o."DutchName" = 'Reuzenberenklauw' THEN 'reuzenberenklauw'
    WHEN o."DutchName" = 'Grote waternavel' THEN 'grote waternavel'
    WHEN o."DutchName" = 'Reuzenbalsemien' THEN 'reuzenbalsemien'
    WHEN o."DutchName" = 'Ruwe waterpest' THEN 'ruwe waterpest'
    WHEN o."DutchName" = 'Amerikaanse stierkikker' THEN 'Amerikaanse stierkikker'
    WHEN o."DutchName" = 'Waterteunisbloem' THEN 'waterteunisbloem'
    WHEN o."DutchName" = 'Postelein-waterlepeltje (Kleine waterteunisbloem-subsoort)' THEN 'postelein-waterlepeltje'
    WHEN o."DutchName" = 'Moerasaronskelk' THEN 'moerasaronskelk'
    WHEN o."DutchName" = 'Japans steltgras' THEN 'Japans steltgras'
    WHEN o."DutchName" = 'Parelvederkruid' THEN 'parelvederkruid'
    WHEN o."DutchName" = 'Ongelijkbladig vederkruid' THEN 'ongelijkbladig vederkruid'
    WHEN o."DutchName" = 'Lettersierschildpad' THEN 'lettersierschildpad'
    WHEN o."DutchName" = 'Hemelboom' THEN 'hemelboom'
    WHEN o."DutchName" = 'Robinia' THEN 'robinia'
    WHEN o."DutchName" = 'Zonnebaars' THEN 'zonnebaars'
    WHEN o."DutchName" = 'Japanse en andere invasieve duizendknopen' THEN NULL
    WHEN o."DutchName" = 'Watercrassula' THEN 'watercrassula'
    WHEN o."DutchName" = 'Amerikaanse vogelkers' THEN 'Amerikaanse vogelkers'
    WHEN o."DutchName" = 'Bamboe (soort)' THEN 'bamboe'
    WHEN o."DutchName" = 'Bonte gele dovenetel' THEN 'bonte gele dovenetel'
    WHEN o."DutchName" = 'Canadese guldenroede' THEN 'Canadese guldenroede'
    WHEN o."DutchName" = 'Fluweelboom' THEN 'fluweelboom'
    WHEN o."DutchName" = 'Rimpelroos' THEN 'rimpelroos'
    WHEN o."DutchName" = 'Veelbloemige roos' THEN 'veelbloemige roos'
    WHEN o."DutchName" = 'Westerse karmozijnbes' THEN 'westerse karmozijnbes'
    WHEN o."DutchName" = 'Aardpeer' THEN 'aardpeer'
    WHEN o."DutchName" = 'Chinese bruidssluier' THEN 'Chinese bruidssluier'
    WHEN o."DutchName" = 'Grote kroosvaren' THEN 'grote kroosvaren'
    WHEN o."DutchName" = 'Veelkleurig Aziatisch lieveheersbeestje' THEN  'veelkleurig Aziatisch lieveheersbeestje'
    WHEN o."DutchName" = 'Mantsjoerese wilde rijst' THEN 'Mantsjoerese wilde rijst'
    WHEN o."DutchName" = 'Leidse plant' THEN 'Leidse plant'
    WHEN o."DutchName" = 'Grote vlotvaren' THEN 'grote vlotvaren'
    WHEN o."DutchName" = 'Watersla' THEN 'watersla'
    WHEN o."DutchName" = 'Kaapse waterlelie' THEN 'Kaapse waterlelie'
    WHEN o."DutchName" = 'Japans hoefblad' THEN 'Japans hoefblad'
    ELSE NULL
  END                                   AS vernacularName
  FROM occurrences AS o
  WHERE
    -- Remove observations of multiple unidentified taxa
    o."ScientificName" != 'Meerdere soorten'

