library(dplyr)
library(reshape2)
my_dir = './Multi_OBJ_Network_Quality/data/ghg_data'
file_names = list.files(my_dir)
# Read in data
df_list = lapply(file_names, function(f) read.csv(paste(my_dir,f,sep='/'),
                                                  header=F,sep = ' ') %>%
                   # Make the column names the time series of the times
                   setNames(seq(ISOdate(2010,05,10,0),by='6 hour',length.out=ncol(.))) %>%
                   # Add an id column that says what each of the rows are
                   mutate(RowID = c(paste('Region',1:15),'Synthetic Observations'))) %>%
  setNames(file_names)
# Melt Dataframes
df_long_list = lapply(names(df_list),function(df_name) melt(df_list[[df_name]],
                      id.vars='RowID',variable.name='MeasurementTime',
                      value.name='Measurement') %>%
                        # Add the site name as a column in the df
                        mutate(Site = !!df_name)) %>%
  setNames(names(df_list))

# Combine all into a  single dataframe
### SLOW!!!!! ###
# combined_df_longs = do.call(rbind,df_long_list)
### Faster ###
# combined_df_longs_dp = bind_rows(df_long_list)
### FASTEST ###
combined_df_longs = data.table::rbindlist(df_long_list)
