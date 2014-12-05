## Thank you very much for answer
# 1. Dear, edzer, I think the Z is not the problem, because I use a regular grid
# 2. With a nugget of 0.0001 as suggested by Jon Skoien have decreaed the value a little
## from 16 to 14 but still quite large
# 3. nmax have a big affect to the predicted value
# 4. Maybe the problem is the outliers, i.e. at shallow depth have high temperature of t~z
setwd("uktest")
spdf  <- readRDS("spdf")
grid  <- readRDS("grid")
coordinates(grid) <- ~x+y+z
proj4string(grid)  <- CRS(lccWgs84)
gridded(grid) <- TRUE

uk.vgm <- variogram(logt ~ z, spdf,
                    boundaries = c(seq(100,1000,100), seq(2000,45000,5000)))
plot(uk.vgm)

##
uk.eye1  <- vgm(psill = 0.155,  model = "Gau",  range=700,  nugget=0.0001)
uk.eye   <- vgm(psill = 0.125,  model = "Sph",  range=35000,  nugget=0,  add.to=uk.eye1)
plot(uk.vgm, model = uk.eye, plot.numbers = TRUE)

summary(spdf)
summary(grid)
logt.uk <- krige(log(t)~z, spdf, grid, model = uk.eye, nmax = 10)
## predicedt and ovserved should be same, max should aroud 6
summary((logt.uk$var1.pred))
summary((spdf$logt))
