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

#ACTUAL DATA
data=read.csv("data.csv", header = TRUE)
data=na.omit(data)
summary(data)
class(data$Date)
data$Date=as.Date(data$Date,format="%d/%m/%y")
summary(data)
data2=data[,3:6] #All factors except for interest rates
summary(data2)


#MODEL BUILDING
#Specify each univariate GARCH(1,1) model
garch11.spec=ugarchspec(mean.model = list(armaOrder = c(0,0)), variance.model = list(garchOrder = c(1, 1), model = "sGARCH"), distribution.model = "norm")

#Specify the DCC-GARCH(1.1) model (this creates a DCCspec object)
#We replicate 4 times as we are considering 4 univariate time series. Change if we add more factors.
dcc.garch11.spec=dccspec(uspec = multispec(replicate(4,garch11.spec)), dccOrder = c(1, 1),distribution = "mvnorm")
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

#Manual plotting
#Inflation and GDP
plot(rcor(dcc.fit2)[1,2,], type = "l", col = "purple", main = "Conditional Correlation of Inflation and GDP", xlab = "Time", ylab = "Correlation")

#Inflation and Risk Free Rate
plot(rcor(dcc.fit2)[1,3,], type = "l", col = "purple", main = "Conditional Correlation of Inflation and Risk Free Rate", xlab = "Time", ylab = "Correlation")

#Inflation and Mortality
plot(rcor(dcc.fit2)[1,4,], type = "l", col = "purple", main = "Conditional Correlation of Inflation and Mortality", xlab = "Time", ylab = "Correlation")

#GDP and Risk Free Rate
plot(rcor(dcc.fit2)[2,3,], type = "l", col = "purple", main = "Conditional Correlation of GDP and Risk Free Rate", xlab = "Time", ylab = "Correlation")

#GDP and Mortality
plot(rcor(dcc.fit2)[2,4,], type = "l", col = "purple", main = "Conditional Correlation of GDP and Mortality", xlab = "Time", ylab = "Correlation")

#Risk Free Rate and Mortality
plot(rcor(dcc.fit2)[3,4,], type = "l", col = "purple", main = "Conditional Correlation of Risk Free Rate and Mortality", xlab = "Time", ylab = "Correlation")


#FORECASTS
#k-step ahead forecasts
dcc.fcst1=dccforecast(dcc.fit2, n.ahead=1) #1-step ahead forecast
rcor(dcc.fcst1)
rcor(dcc.fcst1,output = "matrix") #As a matrix
plot(dcc.fcst) #Can't plot conditional correlation forecast

#ROLLING FORECASTS
#dccroll arguments:
#spec - DCCspec object as created above
#data - full set of data (don't split into training or test)
#n.ahead - 1 (since we want to do 1-step ahead rolling forecasts; don't change this)
#n.start - data point at which we want to start refreshing the rolling window. Change this depending on the dataset. 
#refit.every - 1 (since we want to recompute the model after adding every single new data point; don't change this)
#refit.window - "recursive" (since we want to fit a model on ALL THE OBSERVATIONS FROM TIME 1 UNTIL THE END OF THE ROLLING WINDOW; don't change this)
#window.size = "NULL" (since we're not using a sliding window; don't change this)
dcc.roll=dccroll(spec=dcc.garch11.spec,data=data2, n.ahead = 1, n.start = 225, refit.every = 1, refit.window = "recursive", window.size = NULL)
dcc.roll #Forecasted models

#List of forecasted correlation matrices
rcor(dcc.roll)
forecasts=rcor(dcc.roll,output = "matrix") #As matrix
forecasts
