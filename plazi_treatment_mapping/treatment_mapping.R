xml = xml2::read_xml(filename)
for (r in 1:length(result$data)){
  plazi_treat_id = result$data[[r]]$TreatId

  xpath = paste0("//tp:taxon-treatment/tp:nomenclature/tp:taxon-name/tp:taxon-name-part[@taxon-name-part-type='species'][.='", result$data[[r]]$TreatSpeciesEpithet, "']")
  pensoft_treat_node = xml2::xml_find_all(xml, xpath)
  xml2::xml_set_attrs(xml2::xml_parent(xml2::xml_parent(xml2::xml_parent(pensoft_treat_node))), c("plazi-id" = plazi_treat_id), ns = character())
  }

xml2::write_xml(xml, file = "~/plazi-tryout.xml")
