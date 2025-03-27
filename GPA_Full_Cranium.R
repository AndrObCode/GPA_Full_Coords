## load required packages
library(geomorph)  # [github::geomorphR/geomorph] v4.0.4 
library(plyr)      # CRAN v1.8.7 
library(abind)     # CRAN v1.4-5 
library(ape)       # CRAN v5.6-2

# Set the working directory to the correct one
setwd("C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/")  

# Define the absolute path to the Full_Coords directory
coords_dir <- "C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/Full_Coords"

# Read in coordinates
filelist <- list.files(path = coords_dir, pattern = "*.txt")  # Use absolute path here

# Remove the Museum IDs from the specimen names
names <- gsub(".txt", "", filelist)  # Extract names of specimens from the file names

# Construct the full file paths using file.path() to ensure proper file path handling
filelist <- file.path(coords_dir, filelist)  # Create full paths to each file

coords <- NULL  # Initialize empty object that will hold the 3D array of coordinates

for (i in 1:length(filelist)) {
  temp <- read.morphologika(filelist[i])  # Read each morphologika file
  k <- dim(temp)[1]  # Extract the dimension of the data
  coords <- rbind(coords, two.d.array(temp))  # Append the coordinates to the array
}

# Reshape the coordinates into a 3D array
Data <- arrayspecs(coords, k, 3) 

# Assign the specimen names as dimension names
dimnames(Data)[[3]] <- names

# Clean up environment
remove(i, filelist, k, coords, temp)

# Read the species classifier file (make sure the path is correct)
specimenList <- read.csv("C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/Species_classifier.csv", header = TRUE, row.names = 1)

# Check the dimensions of the Data array
length(Data[,,1])


#Importation of partition designations, ensure it's a factor; The landmark dataset will now be split into two partitions; basicranium and the rest of cranium 

### Import the  partition map, ensure it's a factor
part.gp=as.vector(read.csv("C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/Partitions.csv", header=FALSE))
part.gp=as.factor(part.gp$V1)

#Subset basicranial landmarks from raw data
Data_reskull=Data[which(part.gp==1),,]
Data_basi=Data[which(part.gp==2),,]


#Also read in landpair data: 

Landpairs_full <- read.csv("C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/Landpairs_All.csv", header=FALSE)
Landpairs_basi <- read.csv("C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/Landpairs_Basi.csv", header=FALSE)
Landpairs_rest <- read.csv("C:/Users/n11874368/OneDrive - Queensland University of Technology/Desktop/R/My_Project/Rate/Landpairs_Rest.csv", header=FALSE)



#GPA for all coordinates

#Run GPA
GPA_AllSpecimens <- gpagen(Data, Proj = TRUE, ProcD = FALSE)

Meanspec_rawdata <- findMeanSpec(GPA_AllSpecimens$coords)

#make sure dimnames of coords match with rownames of specdata file
rownames(specimenList) == dimnames(GPA_AllSpecimens$coords)[[3]]

# View the GPA results
summary(GPA_AllSpecimens)
str(GPA_AllSpecimens)
plot(GPA_AllSpecimens)