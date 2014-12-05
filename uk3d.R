## Thank you very much for answer, the data now is updated to: https://github.com/bwtian/uktest
# 1. Dear edzer, I think the Z is not the problem, because I use a regular 3d grid
# 2. With a nugget of 0.0001 as suggested by Jon Skoien have decreaed the max (15 -> 14)
# 3. nmax have a big affect to the predicted value (namx 6~100, max: 16~9)
# 4. Maybe the problem is the outliers, i.e. at shallow depth have high temperature, but no data in deeper

# So my questions
# 1. Is there a way to do auto fitting of Nested model in gstat?
# 2. If there is a outlier as a correct obervation, for example a volcano, could I remove it?
# 3. How to decide a suitable namx value?
# 4. Is it possilbe to use a log backtransfter method to decrease the max value?
setwd("uktest")
spdf  <- readRDS("spdf")
grid  <- readRDS("grid")
coordinates(grid) <- ~x+y+z
lccWgs84  <- "+proj=lcc +lat_1=32.8 +lat_2=43.2 +lat_0=38 +lon_0=137.5 +x_0=1000000 +y_0=1000000 +datum=WGS84 +units=m +no_defs"
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
