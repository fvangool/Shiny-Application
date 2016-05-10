# READ NBB codes - XBRL Mapping file

# Clear all environment variables
rm(list = ls(all.names = TRUE))
#set working directory
setwd("/Users/fvangool/Dropbox (Personal)/R projects/data/")
# monitor performance
ptm <- proc.time()
#for cbind
#output <- df <- data.frame(matrix(ncol = 0, nrow = 37))
#for rbind
output <- df <- data.frame(matrix(ncol = 6, nrow = 0))

## MAPPING Retrieval

#read NBB codes formula in dataframe

formulaNBB <- read.table("finance_formulascodes.csv", stringsAsFactors=FALSE,
                         header=TRUE,
                         sep=";", na.strings = c("NA", "")         
)[ ,c("formula_name", "NBB_code")]

# remove NA entries
formulaNBB <- na.omit(formulaNBB)

# READ NBB codes - XBRL Mapping file

data <- read.table("160310-XBRL Mapping NBB codes comma.csv", stringsAsFactors=FALSE,
                   header=TRUE,
                   sep=";"         
)
# function to retrieve all Xlink labels based on NBB code
retrieveXlink <- function(nbbcode){
        xlink <- data[data$NBB_Code==as.character(nbbcode)  &  data$Publisher=="NBB", ]
        xlink
}
# lookup matching Xlink Label

# xlinklist <- lapply(formulaNBB$NBB_code, function (x) retrieveXlink(x))
xlinklist <- lapply(unique(formulaNBB$NBB_code), function (x) retrieveXlink(x))
# merge list of dataframes in 1 dataframe
xlinks <- do.call("rbind", xlinklist)

#look up all xbrl files directory
#read all the filenames with XBRL extension from a directory
filenames <- list.files(, pattern="*.xbrl", full.names=FALSE)
#start looping trough files
for (i in 1:length(filenames)) {
        
        ## XPATH part
        # install.packages("xml2")
        
        
        library(xml2)
        #x <- read_xml("virtus.xbrl")
        
        x <- read_xml(filenames[i])
        
        # xlinks$Xlink_label
        getXBRLvalue <- function( nbb, xbrl){
                
                b  <- nbb
                a <- xbrl
                xp <- sprintf(".//pfs:%s[@contextRef='CurrentInstant'or @contextRef='CurrentDuration']",a)
                tt <- xml_find_all(x,xp, xml_ns(x))
                out <- c(b,a,xml_text(tt))
        }
        
        #res <- lapply(xlinks, function (x) getXBRLvalue(x),simplify = FALSE, USE.NAMES = TRUE)
        #res <- mapply(xlinks$NBB_Code, function (x) getXBRLvalue(x), MoreArgs = xlinks$Xlink_label)
        #res <- sapply(xlinks$NBB_Code, function (x) getXBRLvalue(x),xbrl =xlinks$Xlink_label)
        qq <- mapply(getXBRLvalue, xlinks$NBB_Code, xlinks$Xlink_label)
        result <- data.frame( nbb_code = sapply( qq, "[", 1), xbrl_name = sapply( qq, "[", 2), 
                              xbrl_value =as.numeric( sapply( qq, "[", 3) ) )
        
        # GET General info company and annual report period start end
        #start data annual report period
        xp <- sprintf(".//xbrli:startDate")
        tt <- xml_find_all(x,xp, xml_ns(x))
        out <- xml_text(tt)
        periodStartDate <- out[1]
        #result$start_date <- periodStartDate
        #WARNING: store the char input as date
        result$start_date <- as.POSIXlt(periodStartDate, "%Y-%m-%d", tz = "CET")
        #end data annaul report period
        xp <- sprintf(".//xbrli:endDate")
        tt <- xml_find_all(x,xp, xml_ns(x))
        out <- xml_text(tt)
        periodEndDate <- out[1]
        result$end_date <- periodEndDate
        # EntityCurrentLegalName
        xp <- sprintf(".//pfs-gcd:EntityCurrentLegalName[@contextRef='CurrentDuration']")
        tt <- xml_find_all(x,xp, xml_ns(x))
        entityCurrentLegalName <- xml_text(tt)
        result$entity_name <- entityCurrentLegalName
        #VAT Number
        xp <- sprintf(".//pfs-gcd:IdentifierValue[@contextRef='CurrentDuration']")
        tt <- xml_find_all(x,xp, xml_ns(x))
        VATnumber <- xml_text(tt)
        
        #result$vat <- VATnumber
        # construct filename based on general info
        #filename <- paste(entityCurrentLegalName, VATnumber, periodStartDate, periodEndDate,".xlsx", sep="_")
        #print(filename[1])
        # library(xlsx)
        # 
        # write.xlsx(result, filename[1])
        
        #cbind output
        #print(head(result))
        #cbind data
        #output <- cbind(output,result)
        #rbind data
        output <- rbind(output,result)
        #end for loop
}
#library(xlsx)

#head(output)
#str(output)
#write.xlsx(output, "Gert_results binded by column.xlsx")
#write.xlsx(output, "160414-Concurrentieanlayse-Virtus Shop in Shape_cbind.xlsx")
# # Print performance result
#print(proc.time() - ptm)

#add year column based on start_date of output variable
require(lubridate)
output$year <- year(output$start_date)
#remove the start and end date
output$start_date <- NULL
output$end_date <- NULL
#reorder output columns
output <-output[,c(4,2,1,3,5)]
# sort by entity name then by year
output <- output[ order(output[,1], output[,3], output[,5]),]
## testing transpose wiht reshape
#test <- head(output,200)
test <-output
test$xbrl_name <- NULL
library(reshape2)
#nn<-reshape(test,timevar="year",idvar="entity_name",direction="wide")
#molten = melt(test, id = c("xbrl_value"))
molten = melt(test, id.vars = c("entity_name","year","nbb_code")  , measure.vars = c("xbrl_value"))
molten
pret <- molten
pret$variable <- NULL
nn<-reshape(pret,timevar="year",idvar=c("entity_name", "nbb_code"),direction="wide")
#write.xlsx(nn, "testy.xlsx")
#sort by nbbcode
#l <-nn[,c(2,1)]
#l <- nn[,c(ncol(nn),1:(ncol(nn)-1))]
l <- nn[,c(2,1,1:(ncol(nn)-2))]
#nn <-nn[,c(4,2,1,3,5)]
# sort by nbb code then by entity name
nn <- nn[ order(l[,1], l[,2]),]
head(nn)
nn[nn == "#N/A"] <- NA
nn[is.na(nn)] <- 0
print(proc.time() - ptm)
library(xlsx)
write.xlsx(nn, "160502-VIRTUS Concurrentieanalyse.xlsx")
# my_func <- function(x) {
#         paste0(deparse(x), collapse="")
# }
# nn<-reshape(molten,timevar="cat",idvar="sample",direction="wide")
# happy <- dcast(molten, formula = entity_name + year ~ variable,value.var="value",
#                fun.aggregate=my_func)
# happy
# require(reshape2)
# x = data.frame(subject = c("John", "Mary"), 
#                time = c(1,1),
#                age = c(33,NA),
#                weight = c(90, NA),
#                height = c(2,2))
# x
# molten = melt(x, id = c("subject", "time"))
# molten
# dcast(molten, formula = time + subject ~ variable, value.var="value",
#       fun.aggregate=my_func)
# 
# 
# # Melt French Fries dataset
# data(french_fries)
# ffm <- melt(french_fries, id = 1:4, na.rm = TRUE)
# 
# # Aggregate examples - all 3 yield the same result
# dcast(ffm, treatment ~ .)
# dcast(ffm, treatment ~ ., function(x) length(x))
# dcast(ffm, treatment ~ ., length) 
# 
# # Passing further arguments through ...
# dcast(ffm, treatment ~ ., sum)
# dcast(ffm, treatment ~ ., sum, trim = 0.1)
# 
# data(airquality)
# names(airquality) <- tolower(names(airquality))
# 
# df <- data.frame(
#         V1=rep(1:3, 14), 
#         V2=rep(paste0("A", 0:6), 6), 
#         V3=sample(1:100, 42), 
#         V4=paste0(sample(letters, 42, replace=TRUE), sample(letters, 42, replace=TRUE))  
# )    
print(proc.time() - ptm)

#split the dataframes
# nn$entity_name <- as.factor(nn$entity_name)
# spli <- split( nn,nn$entity_name)
# #get the third data.frame from list
# xx <-as.data.frame(spli[3])
# ebit1 <- xx[xx$Bossuyt.Winkelinrichting.nbb_code == "9903" ,]
# ebit2 <- xx[xx$Bossuyt.Winkelinrichting.nbb_code == "751" ,]
# ebit3 <- xx[xx$Bossuyt.Winkelinrichting.nbb_code == "752/9" ,]
# ebit4 <- xx[xx$Bossuyt.Winkelinrichting.nbb_code == "650" ,]
# ebit5 <- xx[xx$Bossuyt.Winkelinrichting.nbb_code == "652/9" ,]
# 
# 
# ebit2011 <- ebit1$Bossuyt.Winkelinrichting.value.2011 - ebit2$Bossuyt.Winkelinrichting.value.2011 - ebit3$Bossuyt.Winkelinrichting.value.2011 + ebit4$Bossuyt.Winkelinrichting.value.2011 + ebit5$Bossuyt.Winkelinrichting.value.2011
# 
# EBIT calculation
# 9903-751-752/9+  650+ 652/9
# "Winst (verlies) van het boekjaar voor belasting   9903
# 
# –     Opbrengsten uit vlottende activa 751
# –     Andere financiële opbrengsten  752/9
# +    Kosten van schulden     650
# +    Andere financiële kosten 652/9"
wvvbel <- subset(output, nbb_code == "9903")
wvvbel[is.na(wvvbel)] <- 0
ova <- subset(output, nbb_code == "751")
ova[is.na(ova)] <- 0
afo <- subset(output, nbb_code == "752/9")
afo[is.na(afo)] <- 0
ks <- subset(output, nbb_code == "650")
ks[is.na(ks)] <- 0
afk <- subset(output, nbb_code == "652/9")
afk[is.na(afk)] <- 0
# 9903-751-752/9+  650+ 652/9
#calculate EBIT
EBIT <- cbind(wvvbel$xbrl_value - ova$xbrl_value - afo$xbrl_value + ks$xbrl_value + afk$xbrl_value)
EBIT <- cbind(wvvbel, wvvbel$xbrl_value - ova$xbrl_value - afo$xbrl_value + ks$xbrl_value + afk$xbrl_value)
colnames(EBIT)[6] <- "EBIT"
EBIT$nbb_code <- NULL
EBIT$xbrl_value <- NULL
EBIT$xbrl_name <- NULL
library(xlsx)
write.xlsx(EBIT, "EBIT.xlsx")
write.xlsx(output, "ouput.xlsx")
# Acid test (liquiditeit enge zin)	
# (29/58-29-3):(42/48+492/3)
t1 <- subset(output, nbb_code == "29/58")
t1[is.na(t1)] <- 0
t2 <- subset(output, nbb_code == "29")
t2[is.na(t2)] <- 0
t3 <- subset(output, nbb_code == "3")
t3[is.na(t3)] <- 0
t4 <- subset(output, nbb_code == "42/48")
t4[is.na(t4)] <- 0
t5 <- subset(output, nbb_code == "492/3")
t5[is.na(t5)] <- 0
# (29/58-29-3):(42/48+492/3)
acid <- EBIT <- cbind(t1,(t1$xbrl_value - t2$xbrl_value - t3$xbrl_value)/(t4$xbrl_value + t5$xbrl_value) )
colnames(EBIT)[6] <- "EBIT"
#### test
library(ggplot2)
ggplot(data = omzet, aes(x = year, y = xbrl_value/1000, color = entity_name)) +       
        geom_line(aes(group = entity_name)) + geom_point()
test <- as.Date(as.character(omzet$year), format="%Y")
mydate = strptime(omzet$year,format='%Y')
years(test)
write.csv(omzet, file = "omzet.csv")
nonsense <- read.csv("omzet.csv")
