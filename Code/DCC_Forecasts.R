library(rugarch)
library(rmgarch)
library(xts)

#EXAMPLE DATA
data("dji30retw")
summary(dji30retw)
Dat = dji30retw[,1:3]
garch11.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 1), model = "sGARCH"), distribution.model = "std")
dcc.garch11.spec=dccspec(uspec = multispec(replicate(3,garch11.spec)), dccOrder = c(1, 1),distribution = "mvt")
dcc.garch11.spec
dcc.fit1=dccfit(dcc.garch11.spec, data=Dat)
dcc.fit1
rcor(dcc.fit1, type="R")[,,'1989-08-11']

#Preparing data (don't run this)
library(plyr)
data=read.csv("processed_data.csv", header = TRUE)
data=na.omit(data)
data=rename(data, c("Log.return_x"="FTSE","Log.return_y"="Yield","Log.return_x.1"="Inflation","Log.return_y.1"="GDP","Log.return"="RF_rate"))
summary(data)
write.csv(data, "processed_data_full.csv", row.names=FALSE) #Full data
training_data=data[1:237,] #Training data
write.csv(training_data, "processed_data_training.csv", row.names=FALSE) #Training data

#Loading final data
data2=read.csv("processed_data_full.csv", header = TRUE)
data2=data2[,2:6] #Removing the date column
summary(data2)

#MODEL BUILDING
#Specify each univariate GARCH model
FTSE.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 1), model = "sGARCH"), distribution.model = "norm")
Yield.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 2), model = "sGARCH"), distribution.model = "norm")
Inflation.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 2), model = "sGARCH"), distribution.model = "norm")
GDP.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 1), model = "sGARCH"), distribution.model = "norm")
RF_rate.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 2), model = "sGARCH"), distribution.model = "norm")

#Specify the DCC-GARCH(1.1) model (this creates a DCCspec object)
#We replicate 5 times as we are considering 5 univariate time series. Change if we add more factors.
dcc.garch11.spec=dccspec(uspec = multispec(c(FTSE.spec,Yield.spec,Inflation.spec,GDP.spec,RF_rate.spec)), dccOrder = c(1, 1),distribution = "mvnorm")
dcc.garch11.spec #This is the DCCspec object

#Fit the DCC model using the DCCspec object and the data
dcc.fit2=dccfit(dcc.garch11.spec, data=data2)
dcc.fit2 #Output

#Plotting the DCC model
plot(dcc.fit2) #Can't seem to plot the other conditional correlations.

#All conditional covariance matrices! 
rcor(dcc.fit2)[,,] #Note that the dates are wrong.
rcor(dcc.fit2)[,,1] #To see only the first matrix
rcor(dcc.fit2, output = "matrix") #Outputs as a matrix

#Manual plotting for FTSE vs other factors
#FTSE and Yield
plot(rcor(dcc.fit2)[1,2,], type = "l", col = "purple", main = "Conditional Correlation of FTSE and Yield", xlab = "Time", ylab = "Correlation")

#FTSE and Inflation
plot(rcor(dcc.fit2)[1,3,], type = "l", col = "purple", main = "Conditional Correlation of FTSE and Inflation", xlab = "Time", ylab = "Correlation")

#FTSE and GDP
plot(rcor(dcc.fit2)[1,4,], type = "l", col = "purple", main = "Conditional Correlation of FTSE and GDP", xlab = "Time", ylab = "Correlation")

#FTSE and Risk Free Rate
plot(rcor(dcc.fit2)[1,5,], type = "l", col = "purple", main = "Conditional Correlation of FTSE and Risk Free Rate", xlab = "Time", ylab = "Correlation")

#FORECASTS
#k-step ahead forecasts
dcc.fcst1=dccforecast(dcc.fit2, n.ahead=12) #1-step ahead forecast
rcor(dcc.fcst1)
rcor(dcc.fcst1,output = "matrix") #As a matrix
plot(dcc.fcst1) #Can't plot conditional correlation forecast

#ROLLING FORECASTS
#dccroll arguments:
#spec - DCCspec object as created above
#data - full set of data (don't split into training or test)
#n.ahead - 1 (since we want to do 1-step ahead rolling forecasts; don't change this)
#n.start - data point at which we want to start refreshing the rolling window. Change this depending on the dataset. 
#refit.every - 1 (since we want to recompute the model after adding every single new data point; don't change this)
#refit.window - "recursive" (since we want to fit a model on ALL THE OBSERVATIONS FROM TIME 1 UNTIL THE END OF THE ROLLING WINDOW; don't change this)
#window.size = "NULL" (since we're not using a sliding window; don't change this)
dcc.roll=dccroll(spec=dcc.garch11.spec,data=data2, n.ahead = 1, n.start = 237, refit.every = 1, refit.window = "recursive", window.size = NULL)
dcc.roll #Forecasted models

#List of forecasted correlation matrices
rcor(dcc.roll)
forecasts=rcor(dcc.roll,output = "matrix")
forecasts
forecasts_matrix=as.matrix(forecasts) #Format as a matrix object
forecasts_matrix
write.csv(forecasts_matrix, "forecasts.csv", row.names=FALSE)

