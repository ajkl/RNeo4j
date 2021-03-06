getConstraint = function(graph, label = character()) UseMethod("getConstraint")

getConstraint.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

getConstraint.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  url = attr(graph, "constraints")
  
  # If label is not given, get constraints for entire graph.
  if(length(label) == 0) {
    result = http_request(url, "GET", graph)
    
    if(length(result) == 0) {
      message("No constraints in the graph.")
      return(invisible())
    }
    
  # Else, if label is given, only get constraint on label.  
  } else if(length(label) == 1) {
    if(!(label %in% getLabel(graph))) {
      message("Label '", label, "' does not exist.")
      return(invisible())
    }
    
    url = url = paste(url, label, "uniqueness", sep = "/")
    result = http_request(url, "GET", graph)
    
    if(length(result) == 0) {
      message(paste0("No constraints for label '", label, "'."))
      return(invisible())
    }
    
  # Else, user supplied an invalid combination of arguments.  
  } else {
    stop("Arguments supplied are invalid.")
  }
  
  for(i in 1:length(result)) {
    result[[i]]['property_keys'] = result[[i]]['property_keys'][[1]][[1]]
  }
  
  df = do.call(rbind.data.frame, result)
  rownames(df) = NULL
  return(df)
}