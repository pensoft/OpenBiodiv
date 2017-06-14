#' Convert an XML Document to RDF
#'
#' The function ought to work on different types of XML documents. It tackes
#' care of error checking and calling the correct top-level extractor.
#'
#' This function is exported and can be called from the user.
#'
#' @author Viktor Senderov
#' @param resource_locator
#'        locator, e.g. file path or URL, of the XML resource
#' @param locator_type
#'        type of the locator; one of c("FILE", "URL"); default is "FILE"
#' @param resource_format
#'        XML schema of the XML resource; one of c( "TAXPUB", "PLAZI" );
#'        default is "TAXPUB"
#' @param serialization_format
#'        output serialization format for the RDF; one of c( "TURTLE" );
#'        default is "TURTLE"
#'
#' @export
#'
xml2rdf = function( resource_locator,
                    resource_type = "FILE",
                    resource_format = "TAXPUB",
                    serialization_format = "Turtle")
{
  # checks, if not FILE, cannot write back
  stopifnot ( is.character(resource_type), resource_type == "FILE" )
  stopifnot ( is.character(resource_format), resource_format %in%
                c( "TAXPUB", "REFBANK_XML" ) )
  stopifnot (
    is.character(serialization_format), serialization_format == "Turtle" )

  # load the XML document
  xml = xml2::read_xml( resource_locator , options = c()) # both a document and a node
  # fetch or set the id for the XML document
  context = qname(  get_or_set_obkms_id( xml , fullname = TRUE ) )

  # Call the top-level extractors depending on the type
  if ( resource_format == "TAXPUB" ) {
    triples = taxpub_extractor( xml ) # will return a triples object (TODO S3 or S4??)
    # serialize
    serialization = c()
    if (serialization_format == "Turtle") {
      serialization = turtle_prepend_prefixes()
      serialization = c ( serialization, triples2turtle2 ( context, triples ), "\n\n" )
      #serialization = c ( serialization, triples2turtle2 ( context, triples$article ), "\n\n" )
     # serialization = c( serialization, triples2turtle2( "pensoft:Nomenclature", triples$nomenclature))
    }
    # context need to be cleared
    clear_context( context )
    # return the return string as a string
    xml2::write_xml( xml, resource_locator )
  }
  return ( do.call(paste, as.list( serialization )))
}

#' Top Level Extractor from TaxPub to Triples
#'
#' @param xml an XML document (as parsed by the `xml2` package)
#' @param xlit XPATH locations of atoms (literals) of a TaxPub document
#' @param xdoco XPATH locations of document entities, parts of the document that are not atoms and are identifiers
#' @return TODO write what is returned
#'
#' @export
#'
taxpub_extractor = function( xml, xlit = yaml::yaml.load_file( obkms$config$literals_db_xpath ),
                             xdoco = yaml::yaml.load_file( obkms$config$non_literals_db_xpath ) )
{
                          ## Atom Processing ##

  literals = as.list( find_literals( xml, xlit ) ) # literals is a vector of strings (the individual atoms)

  # Document component entities (sub-article level entities )
  doco = find_document_component_entities ( xml, xdoco )

  # There are two types of identifiers:
  # - identifiers for document entities (previously known as local entities), e.g. figure
  # - identifiers for abstract entities (external, or non-local), e.g. scientific name
  # For document entities we use `get_or_set_obkms_id` that only works on the XML, and does not require any lookup

  identifier = list()
  identifier[['article']] = qname( get_or_set_obkms_id( xml , fullname = TRUE ) )
  identifier[['paper']] = qname ( get_or_set_obkms_id( fullname = TRUE ) ) # the paper is the "work" of an article
  identifier[['publisher']] = qname ( lookup_id( literals$publisher_name ) ) # looks up the publishers by its label
  #identifier[['publisher_role']] = qname( lookup_id () ) # creates a new identifier for the publisher role
  identifier[['journal']] = qname ( lookup_id( literals$journal_title)) # looks up the journal by its name

  #local[['article']] = qname ( get_nodeid ( literals$doi ) )
  #local[['front_matter']] = qname ( get_nodeid(  ) )
  #local[['title']] = qname ( get_nodeid() )
  #local[['abstract']] = qname ( get_nodeid() )

  # For abstract entities, we need to do a look-up in the database.
  # We used to use the function get_nodeit, but now we use `lookup_id` that
  # works roughly in the same way but is more flexible. It first looks
  # in OBKMS for an identifier of a (labeled) entity, and if it finds one
  # (or many depending on the usage options), returns it (them). If nothing
  # is found, and an option is set, a new one is generated.

  triples = list (
    # first : what can we tell about the journal
    # note the publisher of the journal need not be fixed, therefore it should
    # be expressed as a roleintime. however the publisher of a given article
    # is fixed. so the relationships (roles) between journals and publishers can be
    # inferred based on the articles they have published TODO

    triple( identifier$journal,    qname( obkms$properties$type$uri ),                qname ( obkms$classes$Journal$uri ) ),
    triple( identifier$journal,    qname( obkms$properties$preferred_label$uri ),     squote ( literals$journal_title, lang = "English" ) ),
    triple( identifier$journal,    qname( obkms$properties$alternate_label$uri ),     squote ( literals$abbrev_journal_title, lang = "English" ) ),
    triple( identifier$journal,    qname( obkms$properties$issn$uri ),                squote ( literals$issn ) ),
    triple( identifier$journal,    qname( obkms$properties$eissn$uri ),               squote ( literals$eissn ) ),
    triple( identifier$journal,    qname( obkms$properties$sub_endeavour_id$uri ),    identifier$article),

    triple( identifier$article,    qname( obkms$properties$type$uri ),                qname( obkms$classes$Article$uri ) ),
    triple( identifier$article,    qname( obkms$properties$preferred_label$uri ),     squote( literals$doi ) ) ,
    triple( identifier$article,    qname( obkms$properties$title$uri ),               squote( literals$article_title, lang = "English" ) ) ,
    triple( identifier$article,    qname( obkms$properties$doi$uri ),                 squote( literals$doi ) ) ,
    triple( identifier$article,    qname( obkms$properties$publisher$uri ),           squote( literals$publisher_name , lang = "English" ) ), # the publisher of an article is clear
    triple( identifier$article,    qname( obkms$properties$publication_year$uri ),         squote( literals$pub_year, type = "Year" ) ),
    triple( identifier$article,    qname( obkms$properties$publication_date$uri ),         squote( paste( literals$pub_year, literals$pub_month, literals$pub_day, sep = "-") , type = "Date" ) ),
    triple( identifier$article,    qname( obkms$properties$publisher_id$uri ),              identifier$publisher ) ,
    triple( identifier$article,    qname( obkms$properties$realization_of$uri ),            identifier$paper ) , # TODO check whether the inverse is being materialized by the ontology

    triple ( identifier$paper,     qname( obkms$properties$type$uri) ,        qname( obkms$classes$Paper$uri ) ) ,

    triple( identifier$publisher,  qname( obkms$properties$type$uri ),                     qname( obkms$classes$Publisher$uri ) ),
    triple( identifier$publisher,  qname( obkms$properties$preferred_label$uri ),          squote( literals$publisher_name, lang = "English" ) ) )

  # now go thru the sub-component level things that can repeat, e.g. authors
  # TODO first author, second author and so on
  # before we do author processing, we need to update the authors database in
  # memory
  update_authors_db()
  for ( a in doco$authors ) {
    triples = c ( triples,  author_extractor( identifier$paper , a$xml, document = xml) )
  }

  # keyword processing
  for ( taxon_keyword in literals$taxon_classification ) {
    dbpedia_id = qname ( dbpedia_lookup( t, lang = "English" , concept_type = "Taxon" ) )
    subject_term_id = qname( lookup_id ( taxon_keyword, concept_type = "Taxon Classification" ) )

    triples = c ( triples, list (
        triple( subject_term_id, qname( obkms$properties$type$uri ), obkms$classes$Subject_Term$uri  ),
        triple( subject_term_id, qname( obkms$properties$label$uri ), squote( taxon_keyword, lang = obkms$parameters$Language$English$label ) ) ,
        triple( subject_term_id, qname( obkms$properties$belongs_to_scheme$uri ), qname ( obkms$parameters$Vocabularies$Taxon_Classification_Terms$uri ) ),
        triple( subject_term_id, qname ( obkms$properties$exact_match$uri), dbpedia_id ) ,

        triple( identifier$article, qname ( obkms$properties$keywords$uri ), squote ( t, lang = obkms$parameters$Language$English$label ) ),
        triple( identifier$article, qname ( obkms$properties$subject_term$uri ), subject_term_id  ) ) )
  }

  # subjects processing

  for ( t in literals$subject_classification ) {
    subject_term_id =
      qname ( dbpedia_lookup( t, lang = "English"  ) )
    triples = c ( triples, list (
      triple( identifier$article, qname ( obkms$properties$keywords$uri ), squote ( t, lang = "English" ) ),
      triple( identifier$article, qname ( obkms$properties$subject_term$uri ), subject_term_id  ) ) )
  }

  # subjects processing

  for ( t in literals$geographical_classification ) {
    subject_term_id =
      qname ( dbpedia_lookup( t, lang = "English"  ) )
    triples = c ( triples, list (
      triple( identifier$article, qname ( obkms$properties$keywords$uri ), squote ( t, lang = "English" ) ),
      triple( identifier$article, qname ( obkms$properties$subject_term$uri ), subject_term_id  ) ) )
  }


  return ( triples )

  # TODO: YAML nesting is not making things easier. better create functions to extract domainsincludings and comments from the ontology

  # TODO commented everything from here on, needs reworking

#   local_xml = list()
#
#   # Triples
#   # we have several contexts: article related triples
#   # and nomenclature_triples
#   #nomenclature_triples = list()
#   attach(obkms, warn.conflicts = FALSE)
#   triples = list(
#     #publisher
#     triple( local$publisher,      entities$a,                   entities$agent ),
#     triple( local$publisher,      entities$pref_label,          squote ( literals$publisher_name ) ) ,
#     triple( local$publisher,      entities$holds_role_in_time,  local$publisher_role ),
#     triple( local$publisher_role, entities$a,                   entities$role_in_time ),
#     triple( local$publisher_role, entities$with_role,           entities$publisher ),
#     triple( local$publisher_role, entities$relates_to_document, local$journal ),
# 	#journal
#     triple( local$journal,        entities$a,                   entities$journal ),
#     triple( local$journal,        entities$pref_label,          squote ( literals$journal_title ) ),
#     triple( local$journal,        entities$alt_label,           squote ( literals$abbrev_journal_title ) ),
#     triple( local$journal,        entities$issn,                squote ( literals$issn ) ),
#     triple( local$journal,        entities$eissn,               squote ( literals$eissn ) ),
#     triple( local$journal,        entities$dcpublisher,         squote ( literals$publisher_name ) ),
#     triple( local$journal,        entities$frbr_haspart,        local$article ),
#     #TODO fabio:hasSubjectTerm
#     #TODO fabio:hasDiscipline
#     #TODO dcterms:creator
# 	# article
#     triple( local$article,        entities$a,                   entities$journal_article ),
#     triple( local$article,        entities$pref_label,          squote( literals$doi ) ),
#     triple( local$article,        entities$prism_doi,           squote( literals$doi ) ),
#     triple( local$article,        entities$has_publication_year, squote( literals$pub_date, "^^xsd:gYear" ) ) ,
#     triple( local$article,        entities$title,               squote(literals$article_title, "@en-us")),
#     triple( local$article,           entities$contains, doco$front_matter[[1]]$id),
# 	triple( local$article,           entities$contains, doco$body[[1]]$id),
# 	triple( local$article,           entities$contains, doco$back_matter[[1]]$id),
# 	# front matter
#     triple( doco$front_matter[[1]]$id,      entities$a,        entities$front_matter ),
#     triple( doco$front_matter[[1]]$id,      entities$contains, doco$title[[1]]$id),
#     triple( doco$front_matter[[1]]$id,      entities$contains, doco$abstract[1][[1]]$id),
#     triple( doco$front_matter[[1]]$id,      entities$first_item,
#                                       list( triple("", entities$item_content, doco$title[[1]]$id),
#                                             triple("", entities$next_item,
#                                                 list( triple( "", entities$item_content, doco$front_matter[[1]]$id))))),
#     triple( doco$title[[1]]$id,         entities$a,                      entities$doco_title),
#     triple( doco$title[[1]]$id,         entities$has_content,            squote(literals$article_title, "@en-us"   )),
#     triple( doco$abstract[1][[1]]$id,    entities$a,               entities$sro_abstract),
#   ## all of the following things are in the back matter
#   # a document should have one back matter
#   # back-matter
# 	  triple( doco$body[[1]]$id,          entities$a,              entities$body),
# 	  triple( doco$back_matter[[1]]$id, entities$a, 				entities$back_matter ),
#     triple( doco$back_matter[[1]]$id, entities$contains, 		doco$acknowledgement[1][[1]]$id ),
#   # all of the next ones are contained in the back matter
#   # TODO load the ontology to materialize transitive property of journal->backmaterr->stuff
#   # describe afterword (acknolwedgement)
#   # TODO check whether it is OK to use afterword = acknowledgement
#   # acknoledgement trick needed to avoid empty values [1]
#     triple( doco$acknowledgement[1][[1]]$id, entities$a, 			entities$acknowledgement ))
#   # figures
#   for ( fig in doco$figures ) {
#     triples = c( triples, list(
# 	triple( fig$id, 					 entities$a, 			entities$figure ),
#     triple( doco$back_matter[[1]]$id,    entities$contains, 	fig$id ) ) )
#   }
#   # how should captions be processed? During the first pass they should be
#   # extracted in the doco structure. Then during the second pass they should be
#   # connected to their parent object via the parent identifier
#   for ( caption in doco$captions ) {
#     parent = xml2::xml_parent( caption$xml )
#     id = xml2::xml_attr(parent, "id")
#     # TODO do not hardcode the pensoft prefix anywhere!!!
#     obkms_node = qname( paste0( "<http://id.pensoft.net/", id, ">") )
#     triples.new = list(
#       triple( caption$id , entities$a,        entities$caption ),
#       triple( caption$id , entities$has_content, squote( xml2::xml_text( caption$xml, trim = TRUE ) ) ),
#       triple( obkms_node, entities$contains,  caption$id )
#     )
#     triples = c( triples, triples.new )
#   }
#
#   # describe plates, a special kind of figure consisting of multiple figures
#   # it is not part of doco, that's why we've created an object for it in pensoft
#   # TODO Ontology define plate class and derive it from figure
#   # plates
#   for ( plate in doco$plates ) {
#     triples = c( triples, list(
# 	triple( plate$id, 					entities$a,				 entities$figure ),
#     triple( plate$id, 					entities$a, 			 entities$plate ) ,
#     triple( doco$back_matter[1][[1]]$id, 	entities$contains, 		 plate$id ) ) )
#     # TODO add figure-plate relationships!
#   }
#   # describe tables
#   for ( table in doco$tables ) {
#     triples = c( triples, list(
# 	triple( table$id, 					entities$a, 			entities$table ),
#     triple( doco$back_matter[1][[1]]$id,   entities$contains,      table$id ) ) )
#   }
#   # describe reference list
#   for ( ref_list in doco$reference_list) {
#     triples = c( triples, list(
# 	triple( ref_list$id,                entities$a,             entities$reference_list ),
#     triple( doco$back_matter[1][[1]]$id,   entities$contains,      ref_list$id ) ) )
#   }
#   # describe individual references
#   # TODO there is no reference class in Doco, need to extend it
#   for ( reference in doco$reference) {
#     triples = c( triples, list(
# 	triple( reference$id,               entities$a,            entities$reference ),
#     triple( doco$back_matter[1][[1]]$id,    entities$contains,    reference$id ) ) )
#   }
#   # describe individual nomenclature sections
#
#   # Process taxa in different parts of the manuscript
#   # we need to do two things
#   # 1 create bibliographic (attachment) entities for the things
#   # 2 look for the TNU's in the XML that correspond to these entities
#   # submit if needed new names to OBKMS
#   # 3 connect attachment entities to names via TNU's
#   # look for taxa in the title and attach them
#   # in the case of the title, we have already defined the attachment entity
#   # and we have only one xml node where to look
#   # idea: for all local entities, we will store the xml node of the entity in a list
#   # the keys will be the nodeids found in the local list
#   # the xpath for the corresponding entity is usually found in the non-literal
#   # xml path file
#   # there are two cases: when the local entity is a single entity and when the
#   # this function finds the xml nodes of the local entities/// better
#   # document component entities
#   # every paper contains certain document component such as titles, abstract, etc
#   # every document component can have an id which is given by the id attribute
#   # in the XML
#   # we want to do the following thing: we want to list the document components
#   # in a yaml file. then we want to open the yaml file, iterate over the
#   # document components and generate semantic entities for them.
#    # now we want to iterate over the local entit
#   for (entity_list in doco) {
#     for (document_entity in entity_list) {
#       names_used = extract_scientific_names_used( document_entity$xml )
#       new_triples = construct_tnu_triples( document_entity$id, names_used )
#       triples = c( triples, new_triples )
#     }
#   }
#
#   # extract nomenclaute
#   for (nomen in doco$nomenclature) {
#     # TODO do them as parts of treatments in the future
#     doco_triples = list(
#     triple( doco$body[[1]]$id,          entities$contains,       nomen$id),
#     triple( nomen$id, entities$a,            entities$nomenclature) )
#     #triple( nomen$id, entities$has_content,  xml2::xml_text(nomen$xml)))
#     valid_name = extract_valid_name( nomen$xml )
#     nomen_citations = extract_nomen_citations ( nomen$xml )
#     new_triples = construct_nomen_triples( nomen$id, valid_name, nomen_citations)
#     triples = c( triples, doco_triples, new_triples )
#   }
#
#
#
#   # # local entity is list
#   # local_xml[[ local$title ]] = xml2::xml_find_all( xml, xnonlit$title )[[1]]
#   # names_used = extract_scientific_names_used( local_xml[[ local$title ]] )
#   # new_triples = construct_tnu_triples( local$title, names_used )
#   # triples = c( triples, new_triples )
#   # # look for taxa in the abstract
#   # local_xml[[ local$abstract ]] = xml2::xml_find_all( xml, xnonlit$abstract )[[1]]
#   # names_used = extract_scientific_names_used( local_xml[[ local$abstract ]] )
#   # new_triples = construct_tnu_triples( local$abstract , names_used )
#   # triples = c( triples, new_triples )
#
#
#
#     #look for taxa in figures
#   # this includes figs in captions
#   #a figure is something tagged by <fig></fig>
#   #it may or may not be wrapped in a figure group
#   #xpath expressions must be stored in another group (non-literal)
#   #non-literals ideally already have an id in the XML
#   #start with free standing figs
#   #local_figs is a list of the new fig entitites
#   #fig_tnus are the Taxon Name Usages (taxa and rdf) per fig
#   # local[['figures']] = list()
#   #   free_standing_figs_ns = xml2::xml_find_all( xml, xnonlit$free_standing_figs)
#   # j = 1
#   # for ( figure_node in free_standing_figs_ns ) {
#   #   id = xml2::xml_text( xml2::xml_find_all ( figure_node, xnonlit$rel_figid ) )
#   #   local$figures[[j]] = qname( get_nodeid( "", id ) )
#   #   triples = c(triples,
#   #              list( triple ( local$article, entities$contains, local$figures[[j]] )))
#   #   triples = c(triples,
#   #                  list(  triple( local$figures[[j]], entities$a, entities$figure) ))
#   #   new_triples =
#   #               construct_tnu_triples( figure_node, local$figures[[j]] )
#   #   triples = c( triples, new_triples$article)
#   #   nomenclature_triples = c(nomenclature_triples, new_triples$nomenclature)
#   # }
#   # look for taxa in plates captions
#   # ...
#
#   detach( obkms )
#   # prep return values
#   triples = list(article = triples )
#
#   return(  triples )
}

#' Extract author information from the XML
#' Note: extracts the information for _one_ author
#'
#' @param paper URI of the research paper
#' @param author_xml part of the XML where the author information is found
#' @export

author_extractor = function ( paper , author_xml, authors_xpath =  yaml::yaml.load_file( obkms$config$authors_db_xpath ), document ) {
  literals = as.list( find_literals( author_xml, authors_xpath ) )
  # also get the references, a little bit tricky
  # TODO MULTIPLE AFFILIATIONS DO EXISI!!!
  literals$affiliation = list()
  for ( r in literals$reference ) {
    current_affiliation = trim_label( xml2::xml_text(
        xml2::xml_find_first(document, paste0( "/article/front/article-meta/aff[@id='", r, "']" ) ) ,
                                    trim = TRUE), removeLeadingDigits = TRUE )
    parsed_affiliation = parse_affiliation ( current_affiliation )
    literals$affiliation[[r]] =
      list( country = trim_label ( parsed_affiliation$country, removeLeadingDigits = TRUE),
            city = trim_label ( parsed_affiliation$city, removeLeadingDigits = TRUE ),
            street_address = trim_label( parsed_affiliation$address, removeLeadingDigits = FALSE ),
            institution  = trim_label ( parsed_affiliation$institution, removeLeadingDigits = FALSE ),
            full_affiliation_string = current_affiliation)
  }

  # at this point, we have all the literal information and we're ready try to
  # lookup the author based on the literals
  identifier = list()

  identifier[['author']] = qname( lookup_author ( literals ) ) # what happens if multiple matches are returned??
  #identifier[['affiliation']] = lookup_id ()

  if ( !is.null ( literals$collab ) ) {
    triples = list (
      triple( paper,                qname( obkms$properties$creator$uri ),         identifier$author ) ,
      triple( identifier$author,    qname( obkms$properties$type$uri ),            qname ( obkms$classes$Agent$uri ) ),
      triple( identifier$author,    qname( obkms$properties$preferred_label$uri ), squote ( literals$collab ) ),
      triple( identifier$author,    qname( obkms$properties$email$uri ),           squote ( literals$email ) ) )
  }
  else {
    triples = list (
      triple( paper,                qname( obkms$properties$creator$uri ),         identifier$author ) ,
      triple( identifier$author,    qname( obkms$properties$type$uri ),            qname ( obkms$classes$Person$uri ) ),
      triple( identifier$author,    qname( obkms$properties$preferred_label$uri ), squote ( paste(literals$given_name, literals$surname, sep = " " ) ) ),
      triple( identifier$author,    qname( obkms$properties$first_name$uri ),      squote ( literals$given_name ) ),
      triple( identifier$author,    qname( obkms$properties$surname$uri ),         squote ( literals$surname ) ),
      triple( identifier$author,    qname( obkms$properties$email$uri ),           squote ( literals$email ) ) )
  }

  # add the org/affiliation information
  for ( org in literals$affiliation ) {
    triples = c( triples,
                 list(
        triple( identifier$author,    qname( obkms$properties$has_affiliation_string$uri ),
                                                        squote( org$full_affiliation_string, lang = "English") ) ,
        triple( identifier$author,    qname( obkms$properties$is_member_of_organization$uri ), list (
        triple( "", qname( obkms$properties$type$uri),      qname ( obkms$classes$Organization$uri ) ),
        triple( "", qname( obkms$properties$organization_has_name$uri ), squote( org$institution, lang = "English" ) ),
        triple( "", qname( obkms$properties$has_address$uri ), list(
        triple( "", qname( obkms$properties$type$uri),      qname ( obkms$classes$Address$uri ) ),
        triple( "", qname( obkms$properties$country$uri ),  squote( org$country, lang = "English" ) ) ,
        triple( "", qname( obkms$properties$city$uri),      squote( org$city, lang = "English" ) ),
        triple( "", qname( obkms$properties$street$uri),    squote( org$street_address, lang = "English" ) ) ) ) ) ) ) )

  }
  return ( triples )
}

#' Connects one local entity, to a list of the names that have been used
#' via an intermediate class TNU
#' @param local_entity the local entity which has used the names
#' @param names_used list of names that have been used
#' @return triples
construct_tnu_triples = function ( local_entity, names_used ) {
  triples = list()
  i = 1
  attach(obkms, warn.conflicts = FALSE)
  for ( t in names_used ) {
    new_tnu = qname ( get_nodeid() )
    triples[[i ]] = triple( local_entity, entities$realization_of, new_tnu)
    i = i + 1
    triples[[i ]] = triple( new_tnu, entities$a, entities$tnu)
    i = i + 1
    triples[[i ]] = triple( new_tnu, entities$dwciri_scientific_name, t)
    i = i + 1
  }
  detach(obkms)
  return(  triples  )
}

#' Construct the nomen triples by creating a NomenclaturalAct
#' @param nomen_section_id the id of the nomen section to attach the act to
#' @param valid_name the single valid name
#' @param nomen_citations a vector of citations (synonyms, etc)
#' @return triples
#' @export
construct_nomen_triples = function ( nomen_section_id, valid_name, nomen_citations) {
  triples = list()
  i = 1
  attach(obkms, warn.conflicts = FALSE)
  new_act = qname ( get_nodeid() )
  triples[[i ]] = triple( nomen_section_id, entities$realization_of, new_act)
  i = i + 1
  triples[[i ]] = triple( new_act, entities$a, entities$act)
  i = i + 1
  triples[[i ]] = triple( new_act, entities$valid_name, valid_name)
  i = i + 1
  for ( cito in nomen_citations ) {
    triples[[i ]] = triple( new_act, entities$nomenclatural_citation, cito)
    i = i + 1
  }
  detach(obkms)
  return(  triples  )
}

#' Extract taxonomic name usages from an XML nodeset
#' It also looks into descendant nodes thanks to the // in Xpath
#' Actually we want to submit nomenclature right away to OBKMS
#' so as not have duplicates.
#' TODO : this function should be rewritten to use the single name case DRY
#' @param nodeset \emph{xml_nodeset} to check for TNU's
#' @return \emph{list} of scientific name id's and triples with information
#' TODO BUG extracts the label when processing bodies twice!!!
#' @export
extract_scientific_names_used = function ( xml_ns ) {
  ret_value = list() # triples and names
  # look for the TNU tag
  x = list()
  x[['tnu']] = ".//tp:taxon-name"
  x[['taxon_name_part']] = ".//tp:taxon-name-part" # counting from taxon-name
  x[['dwc_rank']] = "./tp:taxon-name-part/@taxon-name-part-type" # counting from taxon-name
  # entities
  tnu_xml = xml2::xml_find_all( xml_ns, x$tnu )
  # triples
  triples = list()
  tnu = list()

  # for each of the scientific names we will get or create a node a network
  i = 1
  for( t in tnu_xml ) {
    # there are two kinds: binomial and monomial
    # construct the label of the scientific name with which to query OBKMS
    scientific_name = extract_single_scientific_name ( t )
    tnu = c( tnu, scientific_name )
  }
  return ( tnu )
}

#' Extract the valid name (first citation) from a nomenclatural section in the XML
#' @param nomen_xml the nomenclatural node in the taxpub file
#' @return the OBKMS node of the valid (first name)
#' @export
extract_valid_name  = function ( nomen_xml ) {
  # we start with the xpath of where everything is found
  x = list()
  x[['valid_name']] = "./tp:taxon-name" # by avoiding the // double slash we only match the valid name
  valid_name_xml = xml2::xml_find_all(nomen_xml, x[['valid_name']])[1][[1]]
  valid_name = extract_single_scientific_name( valid_name_xml )
  return ( valid_name )
}

#' Extract nomenclature citations (next citations) from a nomenclatural section in the XML
#' #' @param nomen_xml the nomenclatural node in the taxpub file
#' @return the OBKMS node of the valid (first name)
#' @export
extract_nomen_citations = function ( nomen_xml ) {
  nomen_citations = c()
  # we start with the xpath of where everything is found
  x = list()
  # TODO : we might actually want to process the comments to extract the meaning of the citation
  x[['nomen_cito']] = "./tp:nomenclature-citation-list//tp:taxon-name" # by ensuring we first dive into the citation list we do it
  nomen_cito_xml = xml2::xml_find_all(nomen_xml, x[['nomen_cito']])
  for ( nomen_citation in nomen_cito_xml ) {
    nomen_citations =c(nomen_citations, extract_single_scientific_name( nomen_citation ))
  }
  return( nomen_citations )
}

#' Extracts only one scientific name from an XML node
#' @param t the tp:taxon-name node
#' @return the id of the name in OBKMS
#' TODO serialize this function as turtle
#' TODO after lookup, this function should be able to UPDATE the rank
#' of a name, if uncertain "insertae"
#' TODO also do authorship, etc.
#' @export
extract_single_scientific_name = function ( t ) {
  x = list()
  x[['tnu']] = ".//tp:taxon-name"
  x[['taxon_name_part']] = ".//tp:taxon-name-part" # counting from taxon-name
  x[['dwc_rank']] = "./tp:taxon-name-part/@taxon-name-part-type" # counting from taxon-name
  triples = list()
  i = 1
  # there are two kinds: binomial and monomial
  # construct the label of the scientific name with which to query OBKMS
  label = xml2::xml_text( t , trim = TRUE)
  # trim takes care of traling and leading spaces, but what about in the middle?
  # the next should take care of it
  label = gsub("[\t]+", " ", label)
  label = gsub("[\n]+", " ", label)
  label = gsub("[ ]+", " ", label)
  scientific_name = qname( get_nodeid( label ) )
  triples[[ i ]] = triple( scientific_name, entities$a, entities$scientific_name )
  i = i + 1
  triples[[ i ]] = triple( scientific_name, entities$pref_label, squote( label ) )
  i = i + 1
  # rank
  rank = xml2::xml_text( xml2::xml_find_all( t, x$dwc_rank) )
  if ( length (rank ) == 0 ) rank = "incertae"
  if ( length( rank ) > 1 ) rank = "species"
  triples[[i]] = triple( scientific_name, entities$rank, squote( rank ) )
  i = i + 1
  # literal scientifc name
  literal_scientific_name = xml2::xml_text( xml2::xml_find_all( t, x$taxon_name_part ) )
  # depending on the rank, we do different things with the literal
  # species, binomial case, xml_text has returned two things
  if ( rank == "species" ) {
    triples[[i]] = triple(scientific_name, entities$species, squote( literal_scientific_name[2] ) )
    i = i + 1
    triples[[i]] = triple(scientific_name, entities$genus, squote( literal_scientific_name[1] ) )
    i = i + 1
  }
  else {
    triples[[i]] =
      triple(scientific_name, entities[[rank]], squote( literal_scientific_name ) )
    i = i + 1
  }
  # now triple for this scientific name are complete and can be submitted to
  # obkms
  serialization = c()
  serialization = turtle_prepend_prefixes()
  ttl = triples2turtle2( "pensoft:Nomenclature", triples )
  connex = file ("Nomenclature.ttl", open = "a")
  writeLines(ttl, connex)
  close(connex)
  serialization = c( serialization, ttl )
  r = rdf4jr::add_data(server_access_options, server_access_options$repository,
                       do.call(paste, as.list( serialization )))

  cat(httr::content(r))
  return ( scientific_name )
}


#' Find literals
#' @export

find_literals = function( xml, x  ) {
  r =
    sapply( names(x), function( l ) {
      ns = xml2::xml_find_all( xml, x[[l]] )
      # ns is a list
      if ( length( ns ) == 0) return ( NULL )
      else return ( trim_label ( xml2::xml_text( ns , trim = TRUE) ) )
    })
}

#' Finds the XML nodes corresponding to semantic entities
#' @param xml \emph{XML2} resource to look at
#' @param local_entities \emph{list} of semantic id's of entities
#' @param local_entities_xpath xpath
#' @return \emph{list} of XML nodes corresponding to the entities
find_local_xml = function ( xml, local_entities, local_entities_xpath ) {
  local_xml = list()
  local_entity_labels = names(local_entities)
  for (l in local_entity_labels) {
    local_xml[[ local_entities[[l]] ]] =
      xml2::xml_find_all( xml, local_entities_xpath[[l]] )[[1]]
  }
}

#' Finds document components id and xml nodes
#' @param xml the xml resource
#' @param document_component_xpath datapase of xpaths where the document components
#' are found in the corresponding XML schema
find_document_component_entities = function ( xml, document_component_xpath ) {
  doco = list()
  for ( name in names( document_component_xpath ) ) {
    xml_nodeset = xml2::xml_find_all( xml, document_component_xpath[[ name ]] )
    doco[[name]] = list()
    j = 1
    for ( xml_node in xml_nodeset ) {
      obkms_id = get_or_set_obkms_id( xml_node )
      doco[[name]][[j]] = list( id = obkms_id, xml = xml_node )
      j = j + 1
    }
  }
  return ( doco )
}

#' Ensure correctness of a triple
#' @param S \emph{character} subject
#' @param P \emph{character} predicate
#' @param O \emph{character OR list} object
#' @return NULL, if one of the values is missing, a character of length 3 otherwise
#' unless blank is TRUE, then S = ""
#' @export
triple = function(S, P, O, blank = FALSE) {
  # this has not been tested yet, probably needs a list around the return anyway
  if ( blank == TRUE ) {
    S = c("")
    if ( is.null(P) || is.null(O) ) return ( NULL )
    if ( is.list (O) ) return ( list( S, P, O ) )
    else return ( c( S,P,O))
  }
  if ( is.null(S) || is.null(P) || is.null(O) ) return ( NULL )
  if ( is.list (O) ) return( list(S, P, O) )
  else return ( c(S,P,O))
}

#' do a little bit more
#' @export
triple2 = function(S, P, O, blank = FALSE) {
  # this has not been tested yet, probably needs a list around the return anyway
  if ( blank == TRUE ) {
    S = c("")
    if ( is.null(P) || is.null(O) ) return ( NULL )
    if ( is.list (O) ) return ( list( S, P, O ) )
    else return ( c( S,P,O))
  }
  if ( is.null(S) || is.null(P) || is.null(O) || S == "" || P == "" || O == "" || is.na(S) || is.na(P) || is.na(O) ) return ( NULL )
  if ( is.list (O) ) return( list(S, P, O) )
  else return ( c(S,P,O))
}

#      _ _   _ _   _ _  __
#   | | | | | \ | | |/ /
#  _  | | | | |  \| | ' /
# | |_| | |_| | |\  | . \
#  \___/ \___/|_| \_|_|\_\

#
#' Extract info from the front-matter, data frame based
#'
extract_metadata = function( xml, xlit ) {
  # all the entity generating functions can return NULL
  # in this case the triple constructing function will return an empty triple
  # literals
  literals = as.list( find_literals( xml, xlit ) )

  # local entities
  local = list()
  local[['publisher']] = qname ( get_nodeid( literals$publisher_name ) )
  local[['publisher_role']] = qname( get_nodeid () )
  local[['journal']] = qname ( get_nodeid( literals$journal_title))
  local[['article']] = qname ( get_nodeid ( literals$doi ) )

  # triples
  attach(obkms, warn.conflicts = FALSE)
  triples = matrix (nrow= 0, ncol = 3, byrow = TRUE,
                    dimnames =  list(c(), c("subject", "predicate", "object")))
  triples = rbind(triples,
                  triple( local$publisher,      entities$a,                   entities$agent ),
                  triple( local$publisher,      entities$pref_label,          squote ( literals$publisher_name ) ) ,
                  triple( local$publisher,      entities$holds_role_in_time,  local$publisher_role ),
                  triple( local$publisher_role, entities$a,                   entities$role_in_time ),
                  triple( local$publisher_role, entities$with_role,           entities$publisher ),
                  triple( local$publisher_role, entities$relates_to_document, local$journal ),
                  triple( local$journal,        entities$a,                   entities$journal ),
                  triple( local$journal,        entities$pref_label,          squote ( literals$journal_title ) ),
                  triple( local$journal,        entities$alt_label,           squote ( literals$abbrev_journal_title ) ),
                  triple( local$journal,        entities$issn,                squote ( literals$issn ) ),
                  triple( local$journal,        entities$eissn,               squote ( literals$eissn ) ),
                  triple( local$journal,        entities$dcpublisher,         squote ( literals$publisher_name ) ),
                  triple( local$journal,        entities$frbr_haspart,        local$article ),
                  triple( local$article,        entities$a,                   entities$journal_article ),
                  triple( local$article,        entities$pref_label,          squote( literals$doi ) ),
                  triple( local$article,        entities$prism_doi,           squote( literals$doi ) ),
                  triple( local$article,        entities$has_publication_year, squote( literals$pub_date, "^^xsd:gYear" ) ) ,
                  triple( local$article,        entities$title,               squote(literals$article_title, "@en-us")))
  #TODO fabio:hasSubjectTerm
  #TODO fabio:hasDiscipline
  #TODO dcterms:creator
  detach(obkms)

  return( as.data.frame( triples ) )
}

#===============================================================================

#
#' Extract metadata from an XML document but return value is a list
#' @inheritParams extract.front_matter
#' @return \emph{list} of triples
extract.metadata = function( xml, xlit ) {
  # all the entity generating functions can return NULL
  # in this case the triple constructing function will return an empty triple
  # literals
  literals = as.list( find_literals( xml, xlit ) )
  # local entities
  local = list()
  local[['publisher']] = qname ( get_nodeid( literals$publisher_name ) )
  local[['publisher_role']] = qname( get_nodeid () )
  local[['journal']] = qname ( get_nodeid( literals$journal_title))
  local[['article']] = qname ( get_nodeid ( literals$doi ) )
  # triples
  attach(obkms, warn.conflicts = FALSE)
  triples = list(
    triple( local$publisher,      entities$a,                   entities$agent ),
    triple( local$publisher,      entities$pref_label,          squote ( literals$publisher_name ) ) ,
    triple( local$publisher,      entities$holds_role_in_time,  local$publisher_role ),
    triple( local$publisher_role, entities$a,                   entities$role_in_time ),
    triple( local$publisher_role, entities$with_role,           entities$publisher ),
    triple( local$publisher_role, entities$relates_to_document, local$journal ),
    triple( local$journal,        entities$a,                   entities$journal ),
    triple( local$journal,        entities$pref_label,          squote ( literals$journal_title ) ),
    triple( local$journal,        entities$alt_label,           squote ( literals$abbrev_journal_title ) ),
    triple( local$journal,        entities$issn,                squote ( literals$issn ) ),
    triple( local$journal,        entities$eissn,               squote ( literals$eissn ) ),
    triple( local$journal,        entities$dcpublisher,         squote ( literals$publisher_name ) ),
    triple( local$journal,        entities$frbr_haspart,        local$article ),
    triple( local$article,        entities$a,                   entities$journal_article ),
    triple( local$article,        entities$pref_label,          squote( literals$doi ) ),
    triple( local$article,        entities$prism_doi,           squote( literals$doi ) ),
    triple( local$article,        entities$has_publication_year, squote( literals$pub_date, "^^xsd:gYear" ) ) ,
    triple( local$article,        entities$title,               squote(literals$article_title, "@en-us")))
  #TODO fabio:hasSubjectTerm
  #TODO fabio:hasDiscipline
  #TODO dcterms:creator
  detach(obkms)
  return(  triples  )
}



#' Get the OBKMS Id of an XML node, if not set, set it
#'
#' Does not do any database lookups. Is exported.
#'
#' @param node the XML node from which to take the ID
#' @param fullname if TRUE, returns a URI with the OBKMS base prefix
#'
#' @export
#'
#'
get_or_set_obkms_id = function ( node, fullname = FALSE )
{
  # if no node, just generate an ID
  if ( missing( node ) ) {
    obkms_id =  uuid::UUIDgenerate()
  }
  else {
    if ( is.na( xml2::xml_attr( node, "obkms_id" ) ) )
    {
      xml2::xml_attr( node, "obkms_id" ) = uuid::UUIDgenerate()
    }
    obkms_id = xml2::xml_attr( node, "obkms_id" )
  }

  if ( fullname )
  {
    return (  paste0( strip_angle( obkms$prefixes$`_base`) , obkms_id ) )
  }

  else return ( obkms_id )
}
