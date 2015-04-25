---
title: "Codebook.md"
output: html_document
---

## Output Details
The tidyoutdata.txt has 14220 rows and 4 columns.

The output in tidyoutdata.txt has the following columns

### subject
Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30

### activity
This represents the activity that each person performed. The feature measurement was for that particular activity. The valid values in this column are

  * WALKING 
  * WALKING_UPSTAIRS
  * WALKING_DOWNSTAIRS 
  * SITTING 
  * STANDING 
  * LAYING

### feature

79 different selected features are listed in this column 

The feature are sensor signals measurements. 

If the column name has accelerometer or gyro, it means the measurement was captured using the accelerometer or gyro embedded in the smartphone. 

If there 'time' or 'freq' in the feature names, it means the variable is from time or frequency domain respectively.

'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.


  * timebodyaccelerometermean-x          
  * timebodyaccelerometermean-y                   
  * timebodyaccelerometermean-z         
  * timebodyaccelerometerstd-x            
  * timebodyaccelerometerstd-y            
  * timebodyaccelerometerstd-z         
  * timegravityaccelerometermean-x            
  * timegravityaccelerometermean-y             
  * timegravityaccelerometermean-z                 
  * timegravityaccelerometerstd-x            
  * timegravityaccelerometerstd-y             
  * timegravityaccelerometerstd-z               
  * timebodyaccelerometerjerkmean-x           
  * timebodyaccelerometerjerkmean-y          
  * timebodyaccelerometerjerkmean-z              
  * timebodyaccelerometerjerkstd-x           
  * timebodyaccelerometerjerkstd-y           
  * timebodyaccelerometerjerkstd-z                
  * timebodygyromean-x           
  * timebodygyromean-y           
  * timebodygyromean-z                             
  * timebodygyrostd-x           
  * timebodygyrostd-y           
  * timebodygyrostd-z                              
  * timebodygyrojerkmean-x           
  * timebodygyrojerkmean-y           
  * timebodygyrojerkmean-z                        
  * timebodygyrojerkstd-x           
  * timebodygyrojerkstd-y           
  * timebodygyrojerkstd-z           
  * timebodyaccelerometermagmean           
  * timebodyaccelerometermagstd           
  * timegravityaccelerometermagmean                
  * timegravityaccelerometermagstd           
  * timebodyaccelerometerjerkmagmean           
  * timebodyaccelerometerjerkmagstd              
  * timebodygyromagmean           
  * timebodygyromagstd           
  * timebodygyrojerkmagmean                        
  * timebodygyrojerkmagstd           
  * freqbodyaccelerometermean-x           
  * freqbodyaccelerometermean-y                    
  * freqbodyaccelerometermean-z           
  * freqbodyaccelerometerstd-x           
  * freqbodyaccelerometerstd-y                     
  * freqbodyaccelerometerstd-z                      
  * freqbodyaccelerometermeanfreq-x           
  * freqbodyaccelerometermeanfreq-y                
  * freqbodyaccelerometermeanfreq-z           
  * freqbodyaccelerometerjerkmean-x           
  * freqbodyaccelerometerjerkmean-y               
  * freqbodyaccelerometerjerkmean-z                           
  * freqbodyaccelerometerjerkstd-x           
  * freqbodyaccelerometerjerkstd-y                 
  * freqbodyaccelerometerjerkstd-z                  
  * freqbodyaccelerometerjerkmeanfreq-x             
  * freqbodyaccelerometerjerkmeanfreq-y            
  * freqbodyaccelerometerjerkmeanfreq-z             
  * freqbodygyromean-x                              
  * freqbodygyromean-y                             
  * freqbodygyromean-z                             
  * freqbodygyrostd-x                              
  * freqbodygyrostd-y                             
  * freqbodygyrostd-z                              
  * freqbodygyromeanfreq-x                         
  * freqbodygyromeanfreq-y                        
  * freqbodygyromeanfreq-z               
  * freqbodyaccelerometermagmean         
  * freqbodyaccelerometermagstd         
  * freqbodyaccelerometermagmeanfreq     
  * freqbodyaccelerometerjerkmagmean     
  * freqbodyaccelerometerjerkmagstd     
  * freqbodyaccelerometerjerkmagmeanfreq        
  * freqbodygyromagmean                  
  * freqbodygyromagstd                  
  * freqbodygyromagmeanfreq              
  * freqbodygyrojerkmagmean              
  * freqbodygyrojerkmagstd              
  * freqbodygyrojerkmagmeanfreq        
  
### calculatedmean
This column lists the average of each feature for each activity and each subject
          

## Data Transformations

1. There were 561 features that were input to this process. These are listed in the feature.txt in this repository. Only the features with the word 'mean' or 'std' were picked up from the 561 features. Thus 79 features were considered for this processing.

2. The following transformations were performed on the feature names before they were output to the tidy data so that the feature names were more readable.
    * the 'x','y', 'z' at the end of the feature name was replaced with '-x','-y','-z' respectively so that the axial direction was explicit 
    * '()' bracket symbol was removed from the feature name
    * Occurence of the word 'bodybody' was replaced with 'body'
    * 'acc' was made more readable by replacing it with 'accelerometer'
    * 't' indicates time and 'f' indicates 'frequency'. So 'tbody' was replaced with 'timebody' and similar changes were made for words - fbody, tgravity and fgravity
    * all feature names were changed to same case - lower case for more readability
