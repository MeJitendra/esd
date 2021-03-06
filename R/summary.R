# Updated script 
# A. Mezghani 
# met.no
# 6 mars 2013

# Original script from http://www.image.ucar.edu/~nychka/Fields/Source/R/summary.ncdf.R
# fields, Tools for spatial data
# Copyright 2004-2011, Institute for Mathematics Applied Geosciences
# University Corporation for Atmospheric Research
# Licensed under the GPL -- www.gpl.org/licenses/gpl.html

summary.ncdf4 <- function(ncfile=ncfile, verbose = TRUE) { # Begin
# check if file exists and type of ncfile object
if (is.character(ncfile)) {
   if (!file.exists(ncfile)) stop(paste("Sorry, the netcdf file '", ncfile, "' does not exist or the path has not been set correctly !",sep =""))
   ncid <- nc_open(ncfile)     
} else if (class(ncfile) == "ncdf4") ncid <- ncfile else stop("ncfile format should be a valid netcdf filename or a netcdf id of class 'ncdf4'")  

model <- ncatt_get(ncid,0)
if (verbose) print(" -------------------------------------------------------------------")
if (verbose) print(ncid$filename)
if (verbose) print(model$title)
# constant vectors
type <- c("Years","Seasons","Months","Days","Hours")
type.abb <- substr(tolower(type),1,3)
# Print summary from the netcdf
  for (i in 1:ncid$nvars) {
     vname = ncid$var[[i]]$name
     ndims = ncid$var[[i]]$ndims
     namedims  = names(ncid$dim)
     varstr = paste(vname, " (variable ", as.character(i),") has unit (",ncid$var[[i]]$units,") and dimension(s)", sep = "")
     for (j in 1:ndims) {
       varstr <- paste(varstr,ncid$var[[i]]$dim[[j]]$name,sep=" ")  
       varstr <- paste(varstr,"(",as.character(ncid$var[[i]]$dim[[j]]$len),")",sep="")}
       if (verbose) print(varstr, fill = TRUE)
     for (j in 1:ndims) {
           dimstr = paste(ncid$var[[i]]$dim[[j]]$name, " (dimension ", as.character(j),") Unit (", ncid$var[[i]]$dim[[j]]$units, ") First point (",as.character(min(ncid$var[[i]]$dim[[j]]$vals)),") Last point (",as.character(max(ncid$var[[i]]$dim[[j]]$vals)),") Step (",(ncid$var[[i]]$dim[[j]]$vals[2]-ncid$var[[i]]$dim[[j]]$vals[1]),")",sep = "")
           if (verbose) print(dimstr)
     }
     ifreq <- grep("freq",names(model))
     if (length(ifreq)>0) {  
        itype <- grep(tolower(eval(parse(text=paste("model$",names(model)[ifreq],sep="")))),tolower(type))
        if (length(itype)>0) {
        frequency <- model$frequency
        if (verbose) print(paste("Frequency has been found in data attributes: ",model$frequency,"(Values)",sep=" ")) 
        }
     } else if (verbose) {
        print(paste("Warning: Frequency has not been found in data attributes !",sep=" ")) 
        frequency <- NA
     }
     if ((!is.null(grepl("tim",ncid$var[[i]]$dim[[ndims]]$name))) & (length(grep("calend",names(ncid$var[[i]]$dim[[ndims]])))>0)) if (verbose) print(paste(ncid$var[[i]]$dim[[ndims]]$calendar,"calendar has been found",sep=" ")) 
  }
results <- list(title = model$title , name = vname , dims = namedims , frequency = frequency) 
invisible(results)
} # End of function

